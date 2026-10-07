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
}