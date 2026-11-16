import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/create_order_params.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateTakeAwayOrderUsecase
    implements UseCase<Result<OrderEntity>, CreateOrderParams> {
  final OrderRepositoryInterface _repository;

  const CreateTakeAwayOrderUsecase(this._repository);

  @override
  Future<Result<OrderEntity>> call(CreateOrderParams params) {
    return _repository.createTakeAwayOrder(params);
  }
}
