import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/services/real_time/real_time_service.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
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
  List<OrderEntity> _allOrders = [];
  OrderStatus? _selectedStatus;

  OrdersCubit(this._getOrdersUseCase,this._realTimeService) : super(const OrdersState.initial());

  List<OrderEntity> get allOrders => List.unmodifiable(_allOrders);
  OrderStatus? get selectedStatus => _selectedStatus;

  Future<void> start()async {
    await fetchOrders();
    _listenToRealTime();
  }
   void _listenToRealTime() {
    _realTimeService.onOrderCreated((data) {
      if (isClosed) return;
      final newOrder = OrderModel.fromJson(data).toEntity();
      if (!_allOrders.any((o) => o.id == newOrder.id)) {
        _allOrders = [newOrder, ..._allOrders];
        _applyFilter();
      }
    });

    _realTimeService.onOrderUpdate((data) {
      if (isClosed) return;
      final orderId = data['orderId'] as String;
      final newStatusStr = data['newStatus'] as String;
      
      final index = _allOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final parsedStatus = OrderModel(status: newStatusStr).parsedStatus;
        final existing = _allOrders[index];
        _allOrders = List.from(_allOrders)
          ..[index] = existing.copyWith(status: parsedStatus);
        _applyFilter();
      }
    });
  }

  Future<void> fetchOrders({bool silent = false}) async {
    if (!silent) {
      emit(const OrdersState.loading());
    }

    final result = await _getOrdersUseCase(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Success(data: final orders):
        _allOrders = orders;
        _applyFilter();
      case FailureResult(failure: final failure):
      if(!silent)
      {
        emit(OrdersState.error(failure.message));
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
   @override
  Future<void> close() {
    _realTimeService.disconnect();
    return super.close();
  }
}
