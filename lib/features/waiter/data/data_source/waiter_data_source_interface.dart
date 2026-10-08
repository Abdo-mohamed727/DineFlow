import 'package:dineflow/features/waiter/data/models/create_order_model.dart';
import 'package:dineflow/features/waiter/data/models/orders_page_model.dart';

import '../models/waiter_request_model.dart';
import '../models/waiter_request_page_model.dart';

abstract interface class WaiterDataSource {
  Future<WaiterRequestsPageModel> getPendingRequests();

  Future<WaiterRequestModel> acceptRequest(
    String requestId,
  );

  Future<WaiterRequestModel> completeRequest(
    String requestId,
  );

  Future<CreateOrderModel> createDineOrder(
    String diningSessionId,
    List<Map<String, dynamic>> items,
    String? notes,
  );
  Future<CreateOrderModel> createTakeAwayOrder(
  List<Map<String, dynamic>> items,
);
Future<OrdersPageModel> getOrders();
Future<OrdersPageModel> getOrdersByStatus(String status);

}