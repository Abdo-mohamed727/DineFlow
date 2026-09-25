import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'orders_state.dart';
part 'orders_cubit.freezed.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;

  List<OrderEntity> _allOrders = [];
  OrderStatus? _selectedStatus;

  OrdersCubit(this._getOrdersUseCase) : super(const OrdersState.initial());

  List<OrderEntity> get allOrders => List.unmodifiable(_allOrders);
  OrderStatus? get selectedStatus => _selectedStatus;

  /// Fetches customer orders from backend (GET /api/orders) and keeps complete list in state.
  Future<void> fetchOrders({bool silent = false}) async {
    if (!silent) {
      emit(const OrdersState.loading());
    }

    final result = await _getOrdersUseCase(const NoParams());

    switch (result) {
      case Success(data: final orders):
        _allOrders = orders;
        _applyFilter();
      case FailureResult(failure: final failure):
        emit(OrdersState.error(failure.message));
    }
  }

  /// Sets selected status filter locally and updates state without making an API call.
  /// Pass [status] = null to show "All" orders.
  void filterByStatus(OrderStatus? status) {
    _selectedStatus = status;
    _applyFilter();
  }

  /// Refreshes orders from backend (GET /api/orders) and re-applies current local status filter.
  Future<void> refreshOrders() async {
    await fetchOrders(silent: false);
  }

  /// Filters already-loaded orders in memory by [status] without making an API call.
  /// When [status] is null, returns all orders.
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
      emit(OrdersState.empty(selectedStatus: _selectedStatus));
    } else {
      emit(
        OrdersState.loaded(
          allOrders: List.unmodifiable(_allOrders),
          filteredOrders: filtered,
          selectedStatus: _selectedStatus,
        ),
      );
    }
  }
}
