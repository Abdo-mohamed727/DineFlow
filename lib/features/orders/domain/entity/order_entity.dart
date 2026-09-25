import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';

class OrderEntity {
  final String id;
  final String? orderNumber;
  final OrderType orderType;
  final String? tableId;
  final OrderStatus status;
  final int subtotal;
  final int tax;
  final int total;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    required this.id,
    this.orderNumber,
    required this.orderType,
    this.tableId,
    required this.status,
    this.subtotal = 0,
    this.tax = 0,
    this.total = 0,
    this.createdAt,
    this.updatedAt,
  });
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
