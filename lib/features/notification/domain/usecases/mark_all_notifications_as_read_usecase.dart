import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/notification/domain/repo/notification_repo_interface.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MarkAllNotificationsAsReadUseCase implements UseCase<Result<void>, NoParams> {
  final NotificationRepoInterface _repository;

  MarkAllNotificationsAsReadUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.markAllNotificationsAsRead();
  }
}
