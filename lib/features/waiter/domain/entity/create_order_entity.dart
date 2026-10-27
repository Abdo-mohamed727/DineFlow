class CreateOrderEntity {
  final String orderId;
  final String orderNumber;
  final String orderType;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;
  final String status;
  final String? notes;
  final DateTime createdAt;

  const CreateOrderEntity({
    required this.orderId,
    required this.orderNumber,
    required this.orderType,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    this.notes,
    required this.createdAt,
  });
}

class OrderItemEntity {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}