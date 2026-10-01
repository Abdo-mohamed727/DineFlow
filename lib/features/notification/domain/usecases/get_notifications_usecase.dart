import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/core/usecases/usecase.dart';
import 'package:dineflow/features/notification/domain/entity/notification_page_entity.dart';
import 'package:dineflow/features/notification/domain/repo/notification_repo_interface.dart';

class GetNotificationsUseCase implements UseCase<Result<NotificationsPageEntity>, NoParams> {
  final NotificationRepoInterface _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Result<NotificationsPageEntity>> call(NoParams params) {
    return _repository.getNotifications();
  }
}
