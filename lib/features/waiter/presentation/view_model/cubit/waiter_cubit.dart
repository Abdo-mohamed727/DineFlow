import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/tables_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';
import 'package:dineflow/features/waiter/domain/use_case/accept_request_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/complete_request_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/create_dine_order_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/create_takeaway_order_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_avaliable_table_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_order_by_id_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_by_status_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_by_status_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_pending_requests_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_table_by_id_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_tables_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/order_id_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/request_id_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/table_id_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_order_status_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_order_status_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_table_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_table_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:injectable/injectable.dart';
part 'waiter_cubit.freezed.dart';
part 'waiter_state.dart';

@injectable
class WaiterCubit extends Cubit<WaiterState> {
  final GetPendingRequestsUseCase _getPendingRequestsUseCase;
  final AcceptRequestUseCase _acceptRequestUseCase;
  final CompleteRequestUseCase _completeRequestUseCase;
  final CreateDineOrderUseCase _createDineOrderUseCase;
  final CreateTakeAwayOrderUseCase _createTakeawayOrderUseCase;
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrdersByStatusUseCase _getOrdersByStatusUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final GetTablesUseCase _getTablesUseCase;
  final GetAvailableWaiterTablesUseCase _getAvailableTablesUseCase;
  final GetTableByIdUseCase _getTableByIdUseCase;
  final UpdateTableUseCase _updateTableUseCase;
  WaiterCubit(
    this._getPendingRequestsUseCase,
    this._acceptRequestUseCase,
    this._completeRequestUseCase,
    this._createDineOrderUseCase,
    this._createTakeawayOrderUseCase,
    this._getOrdersUseCase,
    this._getOrdersByStatusUseCase,
    this._getOrderByIdUseCase,
    this._updateOrderStatusUseCase,
    this._getTablesUseCase,
    this._getAvailableTablesUseCase,
    this._getTableByIdUseCase,
    this._updateTableUseCase,
  ) : super(const WaiterState.initial());
  Future<void> getPendingRequests() async {
    emit(const WaiterState.loading());
    final result = await _getPendingRequestsUseCase(const NoParams());
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.requestsLoaded(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> acceptRequest(String requestId) async {
    emit(const WaiterState.loading());
    final result = await _acceptRequestUseCase(
      RequestIdParams(requestId: requestId),
    );
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.requestUpdated(data));
        await getPendingRequests();
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> completeRequest(String requestId) async {
    emit(const WaiterState.loading());
    final result = await _completeRequestUseCase(
      RequestIdParams(requestId: requestId),
    );
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.requestUpdated(data));
        await getPendingRequests();
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> createDineOrder(CreateDineOrderParams params) async {
    emit(const WaiterState.loading());
    final result = await _createDineOrderUseCase(params);
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.orderCreated(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> createTakeawayOrder(CreateTakeAwayOrderParams params) async {
    emit(const WaiterState.loading());
    final result = await _createTakeawayOrderUseCase(params);
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.orderCreated(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> getOrders() async {
    emit(const WaiterState.loading());
    final result = await _getOrdersUseCase(const NoParams());
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.ordersLoaded(data as OrdersPageEntity));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> getOrdersByStatus(String status) async {
    emit(const WaiterState.loading());
    final result = await _getOrdersByStatusUseCase(
      GetOrdersByStatusParams(status: status),
    );
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.ordersLoaded(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> getOrderById(String orderId) async {
    emit(const WaiterState.loading());
    final result = await _getOrderByIdUseCase(OrderIdParams(orderId: orderId));
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.orderLoaded(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    emit(const WaiterState.loading());
    final result = await _updateOrderStatusUseCase(
      UpdateOrderStatusParams(orderId: orderId, status: status),
    );
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.orderStatusUpdated(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> getTables() async {
    emit(const WaiterState.loading());
    final result = await _getTablesUseCase(const NoParams());
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.tablesLoaded(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> getAvailableTables() async {
    emit(const WaiterState.loading());

    final result = await _getAvailableTablesUseCase(const NoParams());

    switch (result) {
      case Success(data: final data):
        emit(WaiterState.tablesLoaded(data));

      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> getTableById(String tableId) async {
    emit(const WaiterState.loading());
    final result = await _getTableByIdUseCase(TableIdParams(tableId: tableId));
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.tableLoaded(data));
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }

  Future<void> updateTable(
    String tableId,
    String status, {
    bool availableOnly = false,
  }) async {
    emit(const WaiterState.loading());
    final result = await _updateTableUseCase(
      UpdateTableParams(tableId: tableId, status: status),
    );
    switch (result) {
      case Success(data: final data):
        emit(WaiterState.tableUpdated(data));
        if (availableOnly) {
          await getAvailableTables();
        } else {
          await getTables();
        }
      case FailureResult(failure: final failure):
        emit(WaiterState.error(failure.message));
    }
  }
}
