import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/features/orders/data/models/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateOrderRequest', () {
    test('serializes a takeaway order without a dining session', () {
      final request = CreateOrderRequest.takeaway();

      expect(request.toJson(), {'orderType': OrderType.takeaway.apiValue});
    });

    test('serializes a dine-in order with its dining session', () {
      final request = CreateOrderRequest.dineIn(diningSessionId: 'session_123');

      expect(request.toJson(), {
        'orderType': OrderType.dineIn.apiValue,
        'diningSessionId': 'session_123',
      });
    });

    test('serializes the optional client order id', () {
      final request = CreateOrderRequest.takeaway(
        clientOrderId: '0d69fcb5-b792-48c6-a2fc-bbc6e6f4a8f3',
      );

      expect(request.toJson(), {
        'orderType': OrderType.takeaway.apiValue,
        'clientOrderId': '0d69fcb5-b792-48c6-a2fc-bbc6e6f4a8f3',
      });
    });
  });

  group('OrderModel', () {
    test('extracts the ID from a populated tableId object', () {
      const tableId = '6aabb9dd0bc9e678caf651b8';
      final order = OrderModel.fromJson({
        'id': 'order_123',
        'orderType': 'DINE_IN',
        'status': 'PENDING',
        'tableId': {'id': tableId, 'tableNumber': 5},
      });

      expect(order.tableId, tableId);
      expect(order.tableNumber, '5');
      expect(order.toEntity().tableId, tableId);
    });
  });
}
