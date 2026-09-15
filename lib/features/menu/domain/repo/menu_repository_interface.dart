import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';

abstract interface class MenuRepositoryInterface {
  Future<Result<List<CategoryEntity>>> getCategories();

  Future<Result<List<ProductEntity>>> getProducts({String? categoryId});

  Future<Result<ProductEntity>> getProductById(String id);

  Future<Result<List<ProductEntity>>> searchProducts(String query);
}
