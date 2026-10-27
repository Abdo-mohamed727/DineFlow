import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CloseDiningSessionUseCase
    implements UseCase<Result<DiningSessionEntity>, String> {
  final OrderRepositoryInterface _repository;

  const CloseDiningSessionUseCase(this._repository);

  @override
  Future<Result<DiningSessionEntity>> call(String sessionId) {
    return _repository.closeDiningSession(sessionId);
  }
}
