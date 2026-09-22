part of 'cart_cubit.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = _Initial;
  const factory CartState.loading() = _Loading;
  const factory CartState.loaded({
    required CartEntity cart,
    @Default({}) Set<String> updatingProductIds,
    @Default(false) bool isAdding,
    String? actionError,
  }) = _Loaded;
  const factory CartState.empty() = _Empty;
  const factory CartState.error(String message) = _Error;
}
