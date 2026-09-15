import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/domain/usecase/get_categories_usecase.dart';
import 'package:dineflow/features/menu/domain/usecase/get_products_usecase.dart';
import 'package:dineflow/features/menu/domain/usecase/search_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'menu_state.dart';
part 'menu_cubit.freezed.dart';

@injectable
class MenuCubit extends Cubit<MenuState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;

  List<CategoryEntity> _allCategories = [];
  List<ProductEntity> _allProducts = [];
  String? _selectedCategoryId;
  String _searchQuery = '';

  MenuCubit(
    this._getCategoriesUseCase,
    this._getProductsUseCase,
    this._searchProductsUseCase,
  ) : super(const MenuState.initial());

  Future<void> loadMenu() async {
    emit(const MenuState.loading());

    final categoriesResult = await _getCategoriesUseCase(const NoParams());
    final productsResult =
        await _getProductsUseCase(const GetProductsParams());

    if (categoriesResult is FailureResult) {
      emit(MenuState.error(
          (categoriesResult as FailureResult).failure.message));
      return;
    }

    if (productsResult is FailureResult) {
      emit(MenuState.error((productsResult as FailureResult).failure.message));
      return;
    }

    _allCategories =
        (categoriesResult as Success<List<CategoryEntity>>).data;
    _allProducts = (productsResult as Success<List<ProductEntity>>).data;
    _selectedCategoryId = null;
    _searchQuery = '';

    await _applyFilters();
  }

  Future<void> selectCategory(String? categoryId) async {
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null;
    } else {
      _selectedCategoryId = categoryId;
    }
    await _applyFilters();
  }

  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    await _applyFilters();
  }

  Future<void> clearFilters() async {
    _selectedCategoryId = null;
    _searchQuery = '';
    await _applyFilters();
  }

  Future<void> _applyFilters() async {
    List<ProductEntity> categoryFiltered = _allProducts;
    if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
      categoryFiltered = _allProducts
          .where((product) => product.categoryId == _selectedCategoryId)
          .toList();
    }

    final searchResult = await _searchProductsUseCase(
      SearchProductsParams(
        query: _searchQuery,
        products: categoryFiltered,
      ),
    );

    List<ProductEntity> finalProducts = categoryFiltered;
    if (searchResult is Success<List<ProductEntity>>) {
      finalProducts = (searchResult as Success<List<ProductEntity>>).data;
    }

    if (finalProducts.isEmpty) {
      emit(
        MenuState.empty(
          categories: _allCategories,
          selectedCategoryId: _selectedCategoryId,
          searchQuery: _searchQuery,
          message: _searchQuery.isNotEmpty
              ? 'No products match "$_searchQuery"'
              : 'No products available in this category',
        ),
      );
    } else {
      emit(
        MenuState.loaded(
          categories: _allCategories,
          products: finalProducts,
          selectedCategoryId: _selectedCategoryId,
          searchQuery: _searchQuery,
        ),
      );
    }
  }
}
