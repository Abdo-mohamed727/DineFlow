import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/notification/domain/repo/notification_repo_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MarkNotificationAsReadUseCase implements UseCase<Result<void>, String> {
  final NotificationRepoInterface _repository;

  MarkNotificationAsReadUseCase(this._repository);

  @override
  Future<Result<void>> call(String params) {
    return _repository.markNotificationAsRead(params);
  }
}
