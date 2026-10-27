import 'order_waiter_entity.dart';

class OrdersPageEntity {
  final List<OrderWaiterEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const OrdersPageEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}