import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';

abstract interface class CartRepositoryInterface {
  Future<Result<CartEntity>> getCart();

  Future<Result<CartEntity>> addItem({
    required String productId,
    required int quantity,
  });

  Future<Result<CartEntity>> updateItem({
    required String productId,
    required int quantity,
  });

  Future<Result<CartEntity>> removeItem(String productId);

  Future<Result<CartEntity>> clearCart();
}
