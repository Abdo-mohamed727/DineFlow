part of 'kitchen_cubit.dart';

@freezed
class KitchenState with _$KitchenState {
  const factory KitchenState.initial() = _Initial;
  const factory KitchenState.loading() = _Loading;
  const factory KitchenState.loaded(List<OrderEntity> orders) = _Loaded;
  const factory KitchenState.error(Failure failure) = _Error;
}
