import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_outcome.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class CreateOrderUseCase {
  CreateOrderUseCase(this._repository, this._uuid);

  final OrderRepositoryInterface _repository;
  final Uuid _uuid;

  Future<Result<CreateOrderOutcome>> call(CreateOrderParams params) async {
    final clientOrderId = params.clientOrderId ?? _uuid.v4();
    final payload = <String, dynamic>{'orderType': params.orderType.apiValue};
    if (params.diningSessionId case final sessionId?
        when sessionId.isNotEmpty) {
      payload['diningSessionId'] = sessionId;
    }
    if (params.tableId case final tableId? when tableId.isNotEmpty) {
      payload['tableId'] = tableId;
    }

    try {
      final existingOrders = params.clientOrderId == null
          ? const <PendingOrder>[]
          : await _repository.getPendingOrders();
      final matchingOrders = existingOrders
          .where((order) => order.clientOrderId == clientOrderId)
          .toList();
      final existing = matchingOrders.isEmpty ? null : matchingOrders.first;
      final pendingOrder =
          existing ??
          PendingOrder(
            clientOrderId: clientOrderId,
            payload: payload,
            createdAt: DateTime.now(),
          );
      if (existing == null) {
        await _repository.addPendingOrder(pendingOrder);
      } else {
        await _repository.updatePendingOrderStatus(
          clientOrderId,
          PendingOrderStatus.pending,
          clearLastError: true,
        );
      }

      final result = await _repository.sendPendingOrder(pendingOrder);
      if (result case Success(data: final order)) {
        await _repository.deletePendingOrder(clientOrderId);
        return Success(
          CreateOrderOutcome(
            clientOrderId: clientOrderId,
            disposition: CreateOrderDisposition.synced,
            order: order,
          ),
        );
      }

      final failure = (result as FailureResult).failure;
      final retryable =
          failure is NetworkFailure ||
          failure.statusCode == 429 ||
          (failure.statusCode != null && failure.statusCode! >= 500);
      await _repository.updatePendingOrderStatus(
        clientOrderId,
        retryable ? PendingOrderStatus.pending : PendingOrderStatus.failed,
        lastError: retryable ? null : failure.message,
        clearLastError: retryable,
      );
      return Success(
        CreateOrderOutcome(
          clientOrderId: clientOrderId,
          disposition: retryable
              ? CreateOrderDisposition.pending
              : CreateOrderDisposition.failed,
          message: failure.message,
        ),
      );
    } on Exception catch (error) {
      return FailureResult(
        CacheFailure('Could not save or update the order locally: $error'),
      );
    }
  }
}
