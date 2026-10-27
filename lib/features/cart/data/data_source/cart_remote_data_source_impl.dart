import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/core/networking/api_error_handler.dart';
import 'package:dineflow/features/cart/data/data_source/cart_remote_data_source_interface.dart';
import 'package:dineflow/features/cart/data/models/cart_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;

  CartRemoteDataSourceImpl(this._dio);

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await _dio.get(ApiConstants.cart);
      return _parseCart(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Failed to load cart. Please try again.',
      );
    }
  }

  @override
  Future<CartModel> addItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.cartItems,
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );
      return await _parseCartOrRefetch(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not add this item to your cart.',
      );
    }
  }

  @override
  Future<CartModel> updateItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiConstants.cartItems}/$productId',
        data: {'quantity': quantity},
      );
      return await _parseCartOrRefetch(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not update item quantity.',
      );
    }
  }

  @override
  Future<CartModel> removeItem(String productId) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.cartItems}/$productId',
      );
      return await _parseCartOrRefetch(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not remove this item.',
      );
    }
  }

  @override
  Future<CartModel> clearCart() async {
    try {
      final response = await _dio.delete(ApiConstants.cart);
      if (CartModel.looksLikeCart(response.data)) {
        return CartModel.fromJson(_asMap(response.data));
      }
      return CartModel(items: const []);
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not clear the cart.',
      );
    }
  }

  Future<CartModel> _parseCartOrRefetch(dynamic data) async {
    if (CartModel.looksLikeCart(data)) {
      final cart = CartModel.fromJson(_asMap(data));
      final items = cart.items;
      if (items != null &&
          items.isNotEmpty &&
          items.any((item) =>
              item.product == null ||
              item.product?.name == null ||
              item.product!.name!.isEmpty)) {
        return await getCart();
      }
      return cart;
    }
    return await getCart();
  }

  CartModel _parseCart(dynamic data) {
    if (data == null) {
      return CartModel(items: const []);
    }
    if (data is List) {
      return CartModel.fromJson({'items': data});
    }
    return CartModel.fromJson(_asMap(data));
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ServerException('Unexpected cart response.');
  }
}
