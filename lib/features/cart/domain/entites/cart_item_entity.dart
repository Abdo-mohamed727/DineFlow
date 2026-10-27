class CartEntity {
  final String id;
  final List<CartItemEntity> items;
  final int subtotal;
  final double taxRate;
  final double tax;
  final double total;
  final int itemCount;

  const CartEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.tax,
    required this.total,
    required this.itemCount,
  });

  static const empty = CartEntity(
    id: '',
    items: [],
    subtotal: 0,
    taxRate: 0,
    tax: 0,
    total: 0,
    itemCount: 1,
  );
}

class CartItemEntity {
  final String productId;
  final String name;
  final int price;
  final String image;
  final bool isAvailable;
  final int quantity;
  final int subtotal;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.isAvailable,
    required this.quantity,
    required this.subtotal,
  });
}
