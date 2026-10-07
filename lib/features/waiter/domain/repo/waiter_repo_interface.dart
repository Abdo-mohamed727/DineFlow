import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';

abstract interface class WaiterRepository {
  Future<Result<WaiterRequestsPageEntity>> getPendingRequests();

  Future<Result<WaiterRequestEntity>> acceptRequest(
    String requestId,
  );

  Future<Result<WaiterRequestEntity>> completeRequest(
    String requestId,
  );
}