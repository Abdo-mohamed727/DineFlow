import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/features/menu/data/data_source/menu_remote_data_source_interface.dart';
import 'package:dineflow/features/menu/data/models/category_model.dart';
import 'package:dineflow/features/menu/data/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: MenuRemoteDataSource)
class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio _dio;

  MenuRemoteDataSourceImpl(this._dio);

  @override
  Future<CategoriesResponseModel> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categories);

      if (response.data is Map<String, dynamic>) {
        return CategoriesResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.data is List) {
        return CategoriesResponseModel(
          data: CategoriesDataModel(
            categories: (response.data as List<dynamic>)
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
      }
      return const CategoriesResponseModel();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<ProductsModel> getProducts({String? categoryId}) async {
    try {
      final response = await _dio.get(
        ApiConstants.products,
        queryParameters: categoryId != null && categoryId.isNotEmpty
            ? {'category_id': categoryId}
            : null,
      );

      if (response.data is Map<String, dynamic>) {
        return ProductsModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.data is List) {
        return ProductsModel(
          data: Data(
            items: (response.data as List<dynamic>)
                .map((e) => Items.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
      }
      return ProductsModel();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<Items> getProductById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.products}/$id');

      if (response.data == null) {
        throw const NotFoundException('Product not found.');
      }

      final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
          ? response.data['data']
          : (response.data['product'] ?? response.data);

      return Items.fromJson(data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<ProductsModel> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        ApiConstants.products,
        queryParameters: {'search': query},
      );

      if (response.data is Map<String, dynamic>) {
        return ProductsModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.data is List) {
        return ProductsModel(
          data: Data(
            items: (response.data as List<dynamic>)
                .map((e) => Items.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
      }
      return ProductsModel();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search products: ${e.toString()}');
    }
  }
}
