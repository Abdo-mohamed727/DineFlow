
import 'order_waiter_entity.dart';

sealed class OrderRealtimeEvent {
  const OrderRealtimeEvent();
}

final class OrderCreatedRealtimeEvent extends OrderRealtimeEvent {
  final OrderWaiterEntity order;

  const OrderCreatedRealtimeEvent(this.order);
}

final class OrderStatusChangedRealtimeEvent extends OrderRealtimeEvent {
  final String orderId;
  final String newStatus;

  const OrderStatusChangedRealtimeEvent({
    required this.orderId,
    required this.newStatus,
  });
}
