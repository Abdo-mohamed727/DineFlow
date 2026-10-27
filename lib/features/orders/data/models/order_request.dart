import 'package:dineflow/core/enums/order_type.dart';

class CreateOrderRequest {
  final OrderType orderType;
  final String? diningSessionId;
  final String? tableId;

  const CreateOrderRequest({
    required this.orderType,
    this.diningSessionId,
    this.tableId,
  });

  const CreateOrderRequest.dineIn({required this.diningSessionId, this.tableId})
    : orderType = OrderType.dineIn;

  const CreateOrderRequest.takeaway({this.tableId})
    : orderType = OrderType.takeaway,
      diningSessionId = null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'orderType': orderType.apiValue};
    if (diningSessionId != null && diningSessionId!.isNotEmpty) {
      map['diningSessionId'] = diningSessionId;
    }
    if (tableId != null && tableId!.isNotEmpty) {
      map['tableId'] = tableId;
    }
    return map;
  }
}
