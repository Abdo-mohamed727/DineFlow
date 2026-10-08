import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';

abstract interface class WaiterRepository {
  Future<Result<WaiterRequestsPageEntity>> getPendingRequests();

  Future<Result<WaiterRequestEntity>> acceptRequest(String requestId);

  Future<Result<WaiterRequestEntity>> completeRequest(String requestId);
  Future<Result<CreateOrderEntity>> createDineOrder(
    CreateDineOrderParams params,
  );
  Future<Result<CreateOrderEntity>> createTakeAwayOrder(
    CreateTakeAwayOrderParams params,
  );
  Future<Result<OrdersPageEntity>> getOrders();
  Future<Result<OrdersPageEntity>> getOrdersByStatus(String status);
  Future<Result<OrderWaiterEntity>> getOrderById(String orderId);
  Future<Result<OrderWaiterEntity>> updateOrderStatus(
  String orderId,
  String status,
);
  Future<Result<TableEntity>> getTables();

Future<Result<TableEntity>> getAvailableTables();

Future<Result<TableEntity>> getTableById(String tableId);

Future<Result<TableEntity>> updateTable(
  String tableId,
  String status,
);

  

}
