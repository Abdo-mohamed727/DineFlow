import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAvailableTablesUseCase
    implements UseCase<Result<List<RestaurantTableEntity>>, NoParams> {
  final OrderRepositoryInterface _repository;

  const GetAvailableTablesUseCase(this._repository);

  @override
  Future<Result<List<RestaurantTableEntity>>> call(NoParams params) {
    return _repository.getAvailableTables();
  }
}
