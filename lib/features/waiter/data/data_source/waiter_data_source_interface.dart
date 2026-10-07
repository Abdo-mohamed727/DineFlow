import 'package:dineflow/features/waiter/data/models/create_order_model.dart';

import '../models/waiter_request_model.dart';
import '../models/waiter_request_page_model.dart';

abstract interface class WaiterDataSource {
   Future<CreateOrderModel> createDineOrder(
    String diningSessionId,
    List<Map<String, dynamic>> items,
    String? notes,
  );
  Future<WaiterRequestsPageModel> getPendingRequests();

  Future<WaiterRequestModel> acceptRequest(
    String requestId,
  );

  Future<WaiterRequestModel> completeRequest(
    String requestId,
  );
}