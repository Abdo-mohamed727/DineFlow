import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/notification/data/data_source/notification_data_source_interface.dart';
import 'package:dineflow/features/notification/domain/entity/notification_page_entity.dart';
import 'package:dineflow/features/notification/domain/repo/notification_repo_interface.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepoInterface)
class NotificationRepoImpl implements NotificationRepoInterface {
  final NotificationDataSourceInterface _notificationDataSourceInterface;

  NotificationRepoImpl(this._notificationDataSourceInterface);

  @override
  Future<Result<NotificationsPageEntity>> getNotifications() async {
    try {
      final response = await _notificationDataSourceInterface
          .getNotifications();

      return Success(response.toEntity());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<NotificationsPageEntity>> getUnreadNotifications() async {
    try {
      final response = await _notificationDataSourceInterface
          .getUnreadNotifications();

      return Success(response.toEntity());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAllNotificationsAsRead() async {
    try {
      await _notificationDataSourceInterface.markAllNotificationsAsRead();

      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markNotificationAsRead(String id) async {
    try {
      await _notificationDataSourceInterface.markNotificationAsRead(id);

      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> registerDeviceToken(String token) async {
    try {
      await _notificationDataSourceInterface.registerDeviceToken(token);
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> unregisterDeviceToken(String token) async {
    try {
      await _notificationDataSourceInterface.unregisterDeviceToken(token);
      return Success(null);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
