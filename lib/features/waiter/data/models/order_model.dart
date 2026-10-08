import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';

import 'customer_model.dart';
import 'table_model.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final CustomerModel customer;
  final String? diningSessionId;
  final TableModel? table;
  final String type;
  final List<OrderItemWaiterModel> items;
  final String status;
  final double subtotal;
  final double tax;
  final double total;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final customerData = json['customerId'];
    final tableData = json['tableId'];

    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      customer: CustomerModel.fromJson(
        customerData as Map<String, dynamic>,
      ),
      diningSessionId: json['diningSessionId'],
      table: tableData is Map<String, dynamic>
          ? TableModel.fromJson(tableData)
          : null,
      type: json['type'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderItemWaiterModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      status: json['status'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  OrderWaiterEntity toEntity() {
    return OrderWaiterEntity(
      id: id,
      orderNumber: orderNumber,
      customer: customer.toEntity(),
      diningSessionId: diningSessionId,
      table: table?.toEntity(),
      type: type,
      items: items.map((item) => item.toEntity()).toList(),
      status: status,
      subtotal: subtotal,
      tax: tax,
      total: total,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class OrderItemWaiterModel {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItemWaiterModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemWaiterModel.fromJson(Map<String, dynamic> json) {
    return OrderItemWaiterModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  OrderItemWaiterEntity toEntity() {
    return OrderItemWaiterEntity(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
    );
  }
}