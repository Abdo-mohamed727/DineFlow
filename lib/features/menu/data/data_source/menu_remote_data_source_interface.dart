import 'package:dineflow/features/menu/data/models/category_model.dart';
import 'package:dineflow/features/menu/data/models/product_model.dart';

abstract interface class MenuRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getProducts({String? categoryId});

  Future<ProductModel> getProductById(String id);

  Future<List<ProductModel>> searchProducts(String query);
}
