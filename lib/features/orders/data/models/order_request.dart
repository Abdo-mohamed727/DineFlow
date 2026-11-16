import 'package:dineflow/core/enums/order_type.dart';

class CreateOrderRequest {
  final OrderType orderType;
  final String? diningSessionId;
  final String? tableId;
  final String? clientOrderId;

  const CreateOrderRequest({
    required this.orderType,
    this.diningSessionId,
    this.tableId,
    this.clientOrderId,
  });

  const CreateOrderRequest.dineIn({
    required this.diningSessionId,
    this.tableId,
    this.clientOrderId,
  }) : orderType = OrderType.dineIn;

  const CreateOrderRequest.takeaway({this.tableId, this.clientOrderId})
    : orderType = OrderType.takeaway,
      diningSessionId = null;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    final orderType = OrderTypeX.fromApi(json['orderType']?.toString());
    return CreateOrderRequest(
      orderType: orderType,
      diningSessionId: json['diningSessionId']?.toString(),
      tableId: json['tableId']?.toString(),
      clientOrderId: json['clientOrderId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'orderType': orderType.apiValue};
    if (diningSessionId != null && diningSessionId!.isNotEmpty) {
      map['diningSessionId'] = diningSessionId;
    }
    if (tableId != null && tableId!.isNotEmpty) {
      map['tableId'] = tableId;
    }
    if (clientOrderId != null && clientOrderId!.isNotEmpty) {
      map['clientOrderId'] = clientOrderId;
    }
    return map;
  }
}
