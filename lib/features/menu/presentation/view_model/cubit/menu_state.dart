part of 'menu_cubit.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState.initial() = _Initial;
  const factory MenuState.loading() = _Loading;
  const factory MenuState.loaded({
    required List<CategoryEntity> categories,
    required List<ProductEntity> products,
    String? selectedCategoryId,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory MenuState.empty({
    required List<CategoryEntity> categories,
    String? selectedCategoryId,
    @Default('') String searchQuery,
    @Default('No products found') String message,
  }) = _Empty;
  const factory MenuState.error(String message) = _Error;
}
