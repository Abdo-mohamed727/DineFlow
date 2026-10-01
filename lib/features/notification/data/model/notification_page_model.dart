import 'package:dineflow/features/notification/domain/entity/notification_page_entity.dart';

 import 'notification_model.dart';

class NotificationsPageModel {
  final List<NotificationModel> items;
  final int total;
  final int unreadCount;
  final int page;
  final int limit;
  final int totalPages;

  const NotificationsPageModel({
    required this.items,
    required this.total,
    required this.unreadCount,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationsPageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationsPageModel(
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => NotificationModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      total: json['total'] as int,
      unreadCount: json['unreadCount'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  NotificationsPageEntity toEntity() {
    return NotificationsPageEntity(
      items: items
          .map((notification) => notification.toEntity())
          .toList(),
      total: total,
      unreadCount: unreadCount,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}