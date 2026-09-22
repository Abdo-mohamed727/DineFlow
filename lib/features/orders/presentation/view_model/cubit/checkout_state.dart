part of 'checkout_cubit.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial({
    OrderType? orderType,
    String? selectedTableId,
    @Default([]) List<RestaurantTableEntity> tables,
    @Default(false) bool isLoadingTables,
    @Default(false) bool isPlacingOrder,
    String? errorMessage,
  }) = _CheckoutInitial;
  const factory CheckoutState.success(OrderEntity order) = _CheckoutSuccess;
}
