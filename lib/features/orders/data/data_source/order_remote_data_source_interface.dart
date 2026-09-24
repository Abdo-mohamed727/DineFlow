import 'package:dineflow/features/orders/data/models/order_model.dart';

abstract interface class OrderRemoteDataSource {
  Future<OrderModel> createTakeAwayOrder(CreateOrderRequest request);

  Future<OrderModel> createDineInOrder(
    CreateOrderRequest request, {
    required String diningSessionId,
  });
  Future<List<RestaurantTableModel>> getTables();

  Future<String> startDining(String tableId);
}
