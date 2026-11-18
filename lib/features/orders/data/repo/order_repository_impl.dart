import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_interface.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/data/models/request_waiter_model.dart';
import 'package:dineflow/features/orders/data/data_source/pending_order_local_data_source_interface.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepositoryInterface)
class OrderRepositoryImpl implements OrderRepositoryInterface {
  final OrderRemoteDataSource _remoteDataSource;
  final PendingOrderLocalDataSource _pendingOrders;

  OrderRepositoryImpl(this._remoteDataSource, this._pendingOrders);

  @override
  Future<Result<List<OrderEntity>>> getOrders() async {
    try {
      final models = await _remoteDataSource.getOrders();
      final orders = models.map((e) => e.toEntity()).toList();
      return Success(orders);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderEntity>> createTakeAwayOrder(
    CreateOrderParams params,
  ) async {
    try {
      final clientOrderId = params.clientOrderId;

      if (clientOrderId == null || clientOrderId.isEmpty) {
        return FailureResult(
          ServerFailure('Client order ID is required for idempotency.'),
        );
      }
      final request = CreateOrderRequest.takeaway(tableId: params.tableId);
      final model = await _remoteDataSource.createTakeAwayOrder(
        request,
        idempotencyKey: clientOrderId,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(
        NotFoundFailure(e.message, statusCode: e.statusCode),
      );
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderEntity>> createDineInOrder(
    CreateOrderParams params,
  ) async {
    try {
      final sessionId = params.diningSessionId;
      if (sessionId == null || sessionId.isEmpty) {
        return FailureResult(
          ServerFailure('Dining session is required for dine-in orders.'),
        );
      }
      final request = CreateOrderRequest.dineIn(
        diningSessionId: sessionId,
        tableId: params.tableId,
      );
      final clientOrderId = params.clientOrderId;

      if (clientOrderId == null || clientOrderId.isEmpty) {
        return FailureResult(
          ServerFailure('Client order ID is required for idempotency.'),
        );
      }
      final model = await _remoteDataSource.createDineInOrder(
        request,
        diningSessionId: sessionId,
        idempotencyKey: clientOrderId,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(
        NotFoundFailure(e.message, statusCode: e.statusCode),
      );
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderEntity>> sendPendingOrder(PendingOrder order) async {
    final payload = Map<String, dynamic>.from(order.payload);

    final nestedRequest = payload.remove('request');

    final requestPayload = nestedRequest is Map
        ? Map<String, dynamic>.from(nestedRequest)
        : payload;

    final request = CreateOrderRequest.fromJson(requestPayload);

    final result = request.orderType == OrderType.dineIn
        ? await _sendDineInRequest(request, idempotencyKey: order.clientOrderId)
        : await _sendTakeAwayRequest(
            request,
            idempotencyKey: order.clientOrderId,
          );

    if (result case Success(data: final remoteOrder)) {
      await _pendingOrders.recordServerOrderId(
        order.clientOrderId,
        remoteOrder.id,
      );
    }

    return result;
  }

  Future<Result<OrderEntity>> _sendTakeAwayRequest(
    CreateOrderRequest request, {
    required String idempotencyKey,
  }) async {
    try {
      final model = await _remoteDataSource.createTakeAwayOrder(
        request,
        idempotencyKey: idempotencyKey,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(
        NotFoundFailure(e.message, statusCode: e.statusCode),
      );
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  Future<Result<OrderEntity>> _sendDineInRequest(
    CreateOrderRequest request, {
    required String idempotencyKey,
  }) async {
    try {
      final sessionId = request.diningSessionId;
      if (sessionId == null || sessionId.isEmpty) {
        return FailureResult(
          ServerFailure('Dining session is required for dine-in orders.'),
        );
      }
      final model = await _remoteDataSource.createDineInOrder(
        request,
        diningSessionId: sessionId,
        idempotencyKey: idempotencyKey,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(
        NotFoundFailure(e.message, statusCode: e.statusCode),
      );
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<PendingOrder>> getPendingOrders() => _pendingOrders.getAll();

  @override
  Future<void> addPendingOrder(PendingOrder order) => _pendingOrders.add(order);

  @override
  Future<void> updatePendingOrderStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  }) {
    return _pendingOrders.updateStatus(
      clientOrderId,
      status,
      retryCount: retryCount,
      lastError: lastError,
      clearLastError: clearLastError,
    );
  }

  @override
  Future<void> deletePendingOrder(String clientOrderId) =>
      _pendingOrders.delete(clientOrderId);

  @override
  Future<Result<List<RestaurantTableEntity>>> getAvailableTables() async {
    try {
      final models = await _remoteDataSource.getTables();
      final tables = models
          .map((e) => e.toEntity())
          .where((table) => table.isAvailable)
          .toList();
      return Success(tables);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<SessionId>> startDining(String tableId) async {
    try {
      return Success(await _remoteDataSource.startDining(tableId));
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<DiningSessionEntity>>> getActiveDiningSessions() async {
    try {
      final models = await _remoteDataSource.getActiveDiningSessions();
      return Success(models.map((model) => model.toEntity()).toList());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<DiningSessionEntity>> closeDiningSession(
    String sessionId,
  ) async {
    try {
      final model = await _remoteDataSource.closeDiningSession(sessionId);
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<RequestWaiterEntity>> requestWaiter(
    RequestWaiterEntity request, {
    required String diningSessionId,
  }) async {
    try {
      final requestModel = RequestModel(
        data: Data(
          request: RequestData(
            customerId: request.customerId,
            tableId: request.tableId,
            diningSessionId: diningSessionId,
            type: request.type,
            status: request.status,
            message: request.message,
            id: request.id,
            createdAt: request.createdAt,
            updatedAt: request.updatedAt,
          ),
        ),
      );
      final model = await _remoteDataSource.requestWaiter(
        requestModel,
        diningSessionId: diningSessionId,
      );
      final requestData = model.data?.request;
      if (requestData == null) {
        return FailureResult(
          ServerFailure('Request data is missing in the response.'),
        );
      }
      return Success(requestData.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return FailureResult(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return FailureResult(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
