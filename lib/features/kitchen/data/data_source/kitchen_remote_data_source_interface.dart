import 'package:dineflow/features/orders/data/models/order_model.dart';

abstract interface class KitchenRemoteDataSourceInterface {
  Future<OrderModel> confirmOrder(String id);
  Future<OrderModel> startPreparing(String id);
  Future<OrderModel> markReady(String id);
}