

import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/notification/domain/entity/notification_page_entity.dart';

abstract interface class NotificationRepoInterface{
  Future<Result<NotificationsPageEntity>> getNotifications();

  Future<Result<void>> markNotificationAsRead(String id);

  Future<Result<void>> markAllNotificationsAsRead();

  Future<Result<NotificationsPageEntity>> getUnreadNotifications();

  Future<Result<void>> registerDeviceToken(String token);

  Future<Result<void>> unregisterDeviceToken(String token);
}