part of 'orders_cubit.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState.initial() = _Initial;
  const factory OrdersState.loading() = _Loading;
  const factory OrdersState.loaded({
    required List<OrderEntity> allOrders,
    required List<OrderEntity> filteredOrders,
    OrderStatus? selectedStatus,
  }) = _Loaded;
  const factory OrdersState.empty({
    @Default([]) List<OrderEntity> allOrders,
    OrderStatus? selectedStatus,
    @Default('No orders found') String message,
  }) = _Empty;
  const factory OrdersState.error(String message) = _Error;
}
