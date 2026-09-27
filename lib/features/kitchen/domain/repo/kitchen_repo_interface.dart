 
 import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';

abstract interface class KitchenRepoInterface {
 
  Future<Result<OrderEntity>> confirmOrder(String id);
  Future<Result<OrderEntity>> startPreparing(String id);
  Future<Result<OrderEntity>> markReady(String id);
}
