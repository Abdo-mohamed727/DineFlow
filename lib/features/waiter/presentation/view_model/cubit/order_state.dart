part of 'order_cubit.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.orderLoaded(OrderWaiterEntity order) = _OrderLoaded;
  const factory OrderState.ordersLoaded(OrdersPageEntity orders) =
      _OrdersLoaded;
  const factory OrderState.orderStatusUpdated(OrderWaiterEntity order) =
      _OrderStatusUpdated;
  const factory OrderState.orderCreated(CreateOrderEntity order) =
      _OrderCreated;
  const factory OrderState.error(String message) = _Error;
}
