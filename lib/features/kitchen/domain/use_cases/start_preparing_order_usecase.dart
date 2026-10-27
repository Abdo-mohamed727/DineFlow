import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/kitchen/domain/repo/kitchen_repo_interface.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StartPreparingUseCase implements UseCase<Result<OrderEntity>, String> {
  final KitchenRepoInterface _repo;
  const StartPreparingUseCase(this._repo);

  @override
  Future<Result<OrderEntity>> call(String params) {
    return _repo.startPreparing(params);
  }
}
