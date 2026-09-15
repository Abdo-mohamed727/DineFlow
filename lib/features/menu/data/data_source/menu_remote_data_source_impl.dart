import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/features/menu/data/data_source/menu_remote_data_source_interface.dart';
import 'package:dineflow/features/menu/data/models/category_model.dart';
import 'package:dineflow/features/menu/data/models/product_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: MenuRemoteDataSource)
class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final SupabaseClient _supabaseClient;

  MenuRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabaseClient.from('categories').select();

      final list = response as List<dynamic>;
      return list
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    try {
      final response = categoryId != null && categoryId.isNotEmpty
          ? await _supabaseClient
              .from('products')
              .select()
              .eq('category_id', categoryId)
          : await _supabaseClient.from('products').select();

      final list = response as List<dynamic>;
      return list
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        throw const NotFoundException('Product not found.');
      }

      return ProductModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .ilike('name', '%$query%');

      final list = response as List<dynamic>;
      return list
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search products: ${e.toString()}');
    }
  }
}
