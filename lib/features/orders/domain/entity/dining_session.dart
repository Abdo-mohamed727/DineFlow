import 'package:dineflow/core/enums/order_type.dart';

typedef SessionId = String;

class DiningSessionEntity {
  final SessionId id;
  final String tableId;
  final String status;

  const DiningSessionEntity({
    required this.id,
    required this.tableId,
    required this.status,
  });
}

class OrderNavigationArguments {
  final SessionId? sessionId;
  final OrderType orderType;
  final String? tableId;

  final String? tableName;

  const OrderNavigationArguments({
    required this.sessionId,
    required this.orderType,
    this.tableId,
    this.tableName,
  });
}
