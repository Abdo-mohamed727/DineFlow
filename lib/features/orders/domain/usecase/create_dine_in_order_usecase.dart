import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateDineInOrderUsecase
    implements UseCase<Result<OrderEntity>, CreateOrderRequest> {
  final OrderRepositoryInterface _repository;

  const CreateDineInOrderUsecase(this._repository);

  @override
  Future<Result<OrderEntity>> call(CreateOrderRequest request) {
    return _repository.createDineInOrder(request);
  }
}
