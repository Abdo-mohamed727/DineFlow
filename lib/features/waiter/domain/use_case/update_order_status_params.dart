class UpdateOrderStatusParams {
  final String orderId;
  final String status;

  const UpdateOrderStatusParams({
    required this.orderId,
    required this.status,
  });
}