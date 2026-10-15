import 'package:dineflow/features/orders/data/models/order_model.dart';
import 'package:dineflow/features/orders/data/models/request_waiter_model.dart';

abstract interface class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();

  Future<OrderModel> createTakeAwayOrder(CreateOrderRequest request);

  Future<OrderModel> createDineInOrder(
    CreateOrderRequest request, {
    required String diningSessionId,
  });
  Future<List<RestaurantTableModel>> getTables();

  Future<String> startDining(String tableId);

  Future<RequestModel> requestWaiter(
    RequestModel request, {
    required String diningSessionId,
  });
}
