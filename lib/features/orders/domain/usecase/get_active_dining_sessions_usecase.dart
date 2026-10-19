import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetActiveDiningSessionsUseCase
    implements UseCase<Result<List<DiningSessionEntity>>, NoParams> {
  final OrderRepositoryInterface _repository;

  const GetActiveDiningSessionsUseCase(this._repository);

  @override
  Future<Result<List<DiningSessionEntity>>> call(NoParams params) {
    return _repository.getActiveDiningSessions();
  }
}
