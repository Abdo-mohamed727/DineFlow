import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';

class CreateOrderModel {
  final String orderId;
  final String orderNumber;
  final String orderType;
  final List<OrderItemModel> items;
  final double subtotal;
  final double tax;
  final double total;
  final String status;
  final String? notes;
  final DateTime createdAt;

  const CreateOrderModel({
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

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderModel(
      orderId: json['orderId'] ?? '',
      orderNumber: json['order']?['orderNumber'] ?? '',
      orderType: json['orderType'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderItemModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      notes: json['order']?['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  CreateOrderEntity toEntity() {
    return CreateOrderEntity(
      orderId: orderId,
      orderNumber: orderNumber,
      orderType: orderType,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      tax: tax,
      total: total,
      status: status,
      notes: notes,
      createdAt: createdAt,
    );
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
    );
  }
}