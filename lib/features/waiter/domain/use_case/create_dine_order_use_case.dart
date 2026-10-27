import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateDineOrderUseCase
    implements UseCase<Result<CreateOrderEntity>, CreateDineOrderParams> {
  final WaiterRepository _repository;

  const CreateDineOrderUseCase(this._repository);

  @override
  Future<Result<CreateOrderEntity>> call(
    CreateDineOrderParams params,
  ) {
    return _repository.createDineOrder(params);
  }
}