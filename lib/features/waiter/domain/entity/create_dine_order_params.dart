class CreateDineOrderParams {
  final String diningSessionId;
  final List<OrderItemParams> items;
  final String? notes;

  const CreateDineOrderParams({
    required this.diningSessionId,
    required this.items,
    this.notes,
  });
}

class OrderItemParams {
  final String productId;
  final int quantity;

  const OrderItemParams({
    required this.productId,
    required this.quantity,
  });
}