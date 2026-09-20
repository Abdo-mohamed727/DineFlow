import 'package:dineflow/features/menu/data/models/category_model.dart';
import 'package:dineflow/features/menu/data/models/product_model.dart';

abstract interface class MenuRemoteDataSource {
  Future<CategoriesResponseModel> getCategories();

  Future<ProductsModel> getProducts({String? categoryId});

  Future<Items> getProductById(String id);

  Future<ProductsModel> searchProducts(String query);
}
