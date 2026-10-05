import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';

class OrderItemEntity {
  final String id;
  final String name;
  final int quantity;
  final String? notes;

  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    this.notes,
  });
}

class OrderEntity {
  final String id;
  final String? orderNumber;
  final OrderType orderType;
  final String? tableId;
  final String? tableNumber;
  final OrderStatus status;
  final int subtotal;
  final int tax;
  final int total;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    this.orderNumber,
    required this.orderType,
    this.tableId,
    this.tableNumber,
    required this.status,
    this.subtotal = 0,
    this.tax = 0,
    this.total = 0,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  OrderEntity copyWith({
    String? id,
    String? orderNumber,
    OrderType? orderType,
    String? tableId,
    String? tableNumber,
    OrderStatus? status,
    int? subtotal,
    int? tax,
    int? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemEntity>? items,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderType: orderType ?? this.orderType,
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }
}

class RestaurantTableEntity {
  final String id;
  final String tableNumber;
  final String status;
  final String capacity;
  final String? location;

  const RestaurantTableEntity({
    required this.id,
    required this.tableNumber,
    required this.status,
    required this.capacity,
    this.location,
  });

  String get displayName {
    if (tableNumber.isEmpty) return 'Table';
    if (tableNumber.toLowerCase().startsWith('table')) return tableNumber;
    return 'Table $tableNumber';
  }

  String get name => displayName;

  bool get isAvailable {
    final normalized = status.toUpperCase();
    return normalized.isEmpty ||
        normalized == 'AVAILABLE' ||
        normalized == 'FREE' ||
        normalized == 'VACANT' ||
        normalized == 'ACTIVE' ||
        normalized == 'OPEN';
  }
}
