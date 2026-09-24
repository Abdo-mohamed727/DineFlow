import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';

export 'order_request.dart';

class OrderModel {
  String? id;
  String? orderType;
  String? tableId;
  String? status;
  int? subtotal;
  int? tax;
  int? total;

  OrderModel({
    this.id,
    this.orderType,
    this.tableId,
    this.status,
    this.subtotal,
    this.tax,
    this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrap(json);
    return OrderModel(
      id: payload['id']?.toString() ?? payload['_id']?.toString(),
      orderType: payload['orderType']?.toString(),
      tableId:
          payload['tableId']?.toString() ?? payload['table']?['id']?.toString(),
      status: payload['status']?.toString(),
      subtotal: _asInt(payload['subtotal']),
      tax: _asInt(payload['tax']),
      total: _asInt(payload['total']),
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? '',
      orderType: OrderTypeX.fromApi(orderType),
      tableId: tableId,
      status: _parseStatus(status),
      subtotal: subtotal ?? 0,
      tax: tax ?? 0,
      total: total ?? 0,
    );
  }
}

class RestaurantTableModel {
  String? id;

  String? tableNumber;
  String? capacity;
  String? status;
  String? location;
  int? seats;

  RestaurantTableModel({
    this.id,
    this.capacity,
    this.tableNumber,
    this.status,
    this.location,
    this.seats,
  });

  factory RestaurantTableModel.fromJson(Map<String, dynamic> json) {
    return RestaurantTableModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      tableNumber:
          json['tableNumber']?.toString() ??
          json['tablenumber']?.toString() ??
          json['number']?.toString() ??
          json['name']?.toString(),
      capacity: json['capacity']?.toString() ?? json['seats']?.toString(),
      status: json['status']?.toString(),
      location: json['location']?.toString() ?? json['area']?.toString(),
      seats: _asInt(json['seats'] ?? json['capacity']),
    );
  }

  RestaurantTableEntity toEntity() {
    final number = (tableNumber != null && tableNumber!.isNotEmpty)
        ? tableNumber!
        : (seats != null ? '$seats' : '');
    final cap = (capacity != null && capacity!.isNotEmpty)
        ? capacity!
        : (seats != null ? '$seats seats' : '');

    return RestaurantTableEntity(
      id: id ?? '',
      tableNumber: number,
      status: status ?? 'AVAILABLE',
      capacity: cap,
      location: location,
    );
  }
}

Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is Map<String, dynamic>) {
    if (data['order'] is Map<String, dynamic>) {
      return data['order'] as Map<String, dynamic>;
    }
    return data;
  }
  if (json['order'] is Map<String, dynamic>) {
    return json['order'] as Map<String, dynamic>;
  }
  return json;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.round();
}

OrderStatus _parseStatus(String? value) {
  switch (value?.toUpperCase()) {
    case 'ACCEPTED':
      return OrderStatus.accepted;
    case 'PREPARING':
      return OrderStatus.preparing;
    case 'READY':
      return OrderStatus.ready;
    case 'READY_FOR_PICKUP':
    case 'READYFORPICKUP':
      return OrderStatus.readyForPickup;
    case 'SERVED':
      return OrderStatus.served;
    case 'PICKED_UP':
    case 'PICKEDUP':
      return OrderStatus.pickedUp;
    case 'PAYMENT_PENDING':
    case 'PAYMENTPENDING':
      return OrderStatus.paymentPending;
    case 'PAID':
      return OrderStatus.paid;
    case 'COMPLETED':
      return OrderStatus.completed;
    case 'CANCELLED':
    case 'CANCELED':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.pending;
  }
}
