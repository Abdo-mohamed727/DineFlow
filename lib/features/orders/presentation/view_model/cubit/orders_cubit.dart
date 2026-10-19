import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/services/real_time/real_time_service.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/request_waiter_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/request_waiter_usecase.dart';
import 'package:dineflow/features/orders/data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'orders_state.dart';
part 'orders_cubit.freezed.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final RealTimeService _realTimeService;
  final RequestWaiterUseCase _requestWaiterUseCase;
  List<OrderEntity> _allOrders = [];
  OrderStatus? _selectedStatus;

  OrdersCubit(
    this._getOrdersUseCase,
    this._realTimeService,
    this._requestWaiterUseCase,
  ) : super(const OrdersState.initial());

  List<OrderEntity> get allOrders => List.unmodifiable(_allOrders);
  OrderStatus? get selectedStatus => _selectedStatus;

  Future<void> start() async {
    _listenToRealTime();
    await fetchOrders();
  }

  void _listenToRealTime() {
    _realTimeService.onOrderCreated(_handleOrderCreated);
    _realTimeService.onOrderUpdate(_handleOrderUpdate);
  }

  void _handleOrderCreated(Map<String, dynamic> data) {
    if (isClosed) return;
    final newOrder = OrderModel.fromJson(data).toEntity();
    if (!_allOrders.any((o) => o.id == newOrder.id)) {
      _allOrders = [newOrder, ..._allOrders];
      _applyFilter();
    }
  }

  void _handleOrderUpdate(Map<String, dynamic> data) {
    if (isClosed) return;
    final orderId = data['orderId']?.toString();
    final newStatusStr = data['newStatus']?.toString();
    if (orderId == null || newStatusStr == null) return;

    final index = _allOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final parsedStatus = OrderModel(status: newStatusStr).parsedStatus;
      final existing = _allOrders[index];
      _allOrders = List.from(_allOrders)
        ..[index] = existing.copyWith(status: parsedStatus);
      _applyFilter();
    }
  }

  Future<void> fetchOrders({bool silent = false}) async {
    if (!silent) {
      emit(
        OrdersState.loading(
          waiterRequestStatus: state.waiterRequestStatus,
          waiterRequestMessage: state.waiterRequestMessage,
        ),
      );
    }

    final result = await _getOrdersUseCase(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Success(data: final orders):
        _allOrders = orders;
        _applyFilter();
      case FailureResult(failure: final failure):
        if (!silent) {
          emit(
            OrdersState.error(
              failure.message,
              waiterRequestStatus: state.waiterRequestStatus,
              waiterRequestMessage: state.waiterRequestMessage,
            ),
          );
        }
    }
  }

  void filterByStatus(OrderStatus? status) {
    _selectedStatus = status;
    _applyFilter();
  }

  Future<void> refreshOrders() async {
    await fetchOrders(silent: false);
  }

  Future<void> submitWaiterRequest({
    required String diningSessionId,
    required String tableId,
    required WaiterRequestKind kind,
  }) async {
    if (state.waiterRequestStatus == WaiterRequestStatus.submitting) return;

    if (diningSessionId.trim().isEmpty) {
      emit(
        state.withWaiterRequest(
          WaiterRequestStatus.failure,
          'A dining session is required to request assistance.',
        ),
      );
      return;
    }
    if (tableId.trim().isEmpty) {
      emit(
        state.withWaiterRequest(
          WaiterRequestStatus.failure,
          'A table is required to request assistance.',
        ),
      );
      return;
    }

    emit(state.withWaiterRequest(WaiterRequestStatus.submitting));
    final result = await _requestWaiterUseCase(
      RequestWaiterParams(
        diningSessionId: diningSessionId,
        request: RequestWaiterEntity(
          diningSessionId: diningSessionId,
          tableId: tableId,
          type: kind.apiValue,
          message: kind.message,
        ),
      ),
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(state.withWaiterRequest(WaiterRequestStatus.success));
      case FailureResult(failure: final failure):
        emit(
          state.withWaiterRequest(WaiterRequestStatus.failure, failure.message),
        );
    }
  }

  void resetWaiterRequest() {
    emit(state.withWaiterRequest(WaiterRequestStatus.idle));
  }

  List<OrderEntity> getOrdersByStatus(OrderStatus? status) {
    if (status == null) {
      return List.unmodifiable(_allOrders);
    }
    return List.unmodifiable(
      _allOrders.where((order) => order.status == status).toList(),
    );
  }

  void _applyFilter() {
    final filtered = getOrdersByStatus(_selectedStatus);
    if (_allOrders.isEmpty) {
      emit(
        OrdersState.empty(
          selectedStatus: _selectedStatus,
          waiterRequestStatus: state.waiterRequestStatus,
          waiterRequestMessage: state.waiterRequestMessage,
        ),
      );
    } else {
      emit(
        OrdersState.loaded(
          allOrders: List.unmodifiable(_allOrders),
          filteredOrders: filtered,
          selectedStatus: _selectedStatus,
          waiterRequestStatus: state.waiterRequestStatus,
          waiterRequestMessage: state.waiterRequestMessage,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _realTimeService.offOrderCreated(_handleOrderCreated);
    _realTimeService.offOrderUpdate(_handleOrderUpdate);
    return super.close();
  }
}

enum WaiterRequestKind {
  callWaiter,
  requestBill,
  otherHelp;

  String get apiValue => switch (this) {
    WaiterRequestKind.callWaiter => 'CALL_WAITER',
    WaiterRequestKind.requestBill => 'REQUEST_BILL',
    WaiterRequestKind.otherHelp => 'REQUEST_HELP',
  };

  String? get message => switch (this) {
    WaiterRequestKind.callWaiter => 'Please send a waiter to our table.',
    WaiterRequestKind.requestBill => 'Please bring the bill when ready.',
    WaiterRequestKind.otherHelp => 'I need help with something else.',
  };
}
