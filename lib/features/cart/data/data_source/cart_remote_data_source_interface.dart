import 'package:dineflow/features/cart/data/models/cart_model.dart';

abstract interface class CartRemoteDataSource {
  Future<CartModel> getCart();

  Future<CartModel> addItem({
    required String productId,
    required int quantity,
  });

  Future<CartModel> updateItem({
    required String productId,
    required int quantity,
  });

  Future<CartModel> removeItem(String productId);

  Future<CartModel> clearCart();
}
