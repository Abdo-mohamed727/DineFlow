import 'package:dineflow/features/notification/domain/entity/notification_entity.dart';

class NotificationsPageEntity {
  final List<NotificationEntity> items;
  final int total;
  final int unreadCount;
  final int page;
  final int limit;
  final int totalPages;

  const NotificationsPageEntity({
    required this.items,
    required this.total,
    required this.unreadCount,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}