import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StartDiningUseCase implements UseCase<Result<SessionId>, String> {
  final OrderRepositoryInterface _repository;

  const StartDiningUseCase(this._repository);

  @override
  Future<Result<SessionId>> call(String tableId) {
    return _repository.startDining(tableId);
  }
}
