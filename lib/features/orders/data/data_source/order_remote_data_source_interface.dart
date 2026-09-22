import 'package:dineflow/features/orders/data/models/order_model.dart';
 
abstract interface class OrderRemoteDataSource {
  Future<OrderModel> createOrder(CreateOrderRequest request);

  Future<List<RestaurantTableModel>> getTables();
}
