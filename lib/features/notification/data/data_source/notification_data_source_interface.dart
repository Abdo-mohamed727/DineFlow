

import 'package:dineflow/features/notification/data/model/notification_model.dart';
import 'package:dineflow/features/notification/data/model/notification_page_model.dart';

abstract interface class NotificationDataSourceInterface{


  
   Future<NotificationsPageModel> getNotifications();

  Future<void> markNotificationAsRead(String id);

  Future<void> markAllNotificationsAsRead();

  Future<NotificationsPageModel> getUnreadNotifications();

  
  
}
