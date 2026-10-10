import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/waiter/domain/repo/waiter_repo_interface.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class CreateTakeAwayOrderUseCase
    implements UseCase<Result<CreateOrderEntity>, CreateTakeAwayOrderParams> {
  final WaiterRepository _repository;

  const CreateTakeAwayOrderUseCase(this._repository);

  @override
  Future<Result<CreateOrderEntity>> call(
    CreateTakeAwayOrderParams params,
  ) {
    return _repository.createTakeAwayOrder(params);
  }
}