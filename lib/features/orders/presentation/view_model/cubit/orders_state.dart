part of 'orders_cubit.dart';

enum WaiterRequestStatus { idle, submitting, success, failure }

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState.initial({
    @Default(WaiterRequestStatus.idle) WaiterRequestStatus waiterRequestStatus,
    @Default('') String waiterRequestMessage,
  }) = _Initial;
  const factory OrdersState.loading({
    @Default(WaiterRequestStatus.idle) WaiterRequestStatus waiterRequestStatus,
    @Default('') String waiterRequestMessage,
  }) = _Loading;
  const factory OrdersState.loaded({
    required List<OrderEntity> allOrders,
    required List<OrderEntity> filteredOrders,
    OrderStatus? selectedStatus,
    @Default(WaiterRequestStatus.idle) WaiterRequestStatus waiterRequestStatus,
    @Default('') String waiterRequestMessage,
  }) = _Loaded;
  const factory OrdersState.empty({
    @Default([]) List<OrderEntity> allOrders,
    OrderStatus? selectedStatus,
    @Default('No orders found') String message,
    @Default(WaiterRequestStatus.idle) WaiterRequestStatus waiterRequestStatus,
    @Default('') String waiterRequestMessage,
  }) = _Empty;
  const factory OrdersState.error(
    String message, {
    @Default(WaiterRequestStatus.idle) WaiterRequestStatus waiterRequestStatus,
    @Default('') String waiterRequestMessage,
  }) = _Error;
}

extension OrdersStateWaiterRequest on OrdersState {
  OrdersState withWaiterRequest(
    WaiterRequestStatus status, [
    String message = '',
  ]) => map(
    initial: (state) => state.copyWith(
      waiterRequestStatus: status,
      waiterRequestMessage: message,
    ),
    loading: (state) => state.copyWith(
      waiterRequestStatus: status,
      waiterRequestMessage: message,
    ),
    loaded: (state) => state.copyWith(
      waiterRequestStatus: status,
      waiterRequestMessage: message,
    ),
    empty: (state) => state.copyWith(
      waiterRequestStatus: status,
      waiterRequestMessage: message,
    ),
    error: (state) => state.copyWith(
      waiterRequestStatus: status,
      waiterRequestMessage: message,
    ),
  );
}
