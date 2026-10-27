import 'package:dineflow/features/menu/domain/entity/product_entity.dart';

class CartItemEntity {
  final String productId;
  final int quantity;
  final ProductEntity product;
  final int lineTotal;

  const CartItemEntity({
    required this.productId,
    required this.quantity,
    required this.product,
    required this.lineTotal,
  });
}

class CartEntity {
  final String id;
  final List<CartItemEntity> items;
  final int subtotal;
  final int tax;
  final int total;

  const CartEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  bool get isEmpty => items.isEmpty;

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);
}
