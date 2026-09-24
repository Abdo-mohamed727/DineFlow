import 'package:dineflow/core/enums/order_type.dart';

typedef SessionId = String;

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
