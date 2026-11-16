import 'package:dineflow/core/enums/order_type.dart';

class CreateOrderParams {
  const CreateOrderParams({
    required this.orderType,
    this.diningSessionId,
    this.tableId,
    this.clientOrderId,
  });

  final OrderType orderType;
  final String? diningSessionId;
  final String? tableId;
  final String? clientOrderId;
}
