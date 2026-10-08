import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';

class OrderItemWaiterEntity {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItemWaiterEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}

class OrderWaiterEntity {
  final String id;
  final String orderNumber;
  final CustomerEntity customer;
  final String? diningSessionId;
  final TableEntity? table;
  final String type;
  final List<OrderItemWaiterEntity> items;
  final String status;
  final double subtotal;
  final double tax;
  final double total;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderWaiterEntity({
    required this.id,
    required this.orderNumber,
    required this.customer,
    this.diningSessionId,
    this.table,
    required this.type,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}