 enum OrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  readyForPickup,
  served,
  pickedUp,
  paymentPending,
  paid,
  completed,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  bool get isDineInOnly =>
      this == OrderStatus.served || this == OrderStatus.paymentPending;

  bool get isTakeawayOnly =>
      this == OrderStatus.readyForPickup || this == OrderStatus.pickedUp;
}
