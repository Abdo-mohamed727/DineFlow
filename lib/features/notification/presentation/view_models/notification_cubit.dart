import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/notification/domain/entity/notification_entity.dart';
import 'package:dineflow/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:dineflow/features/notification/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:dineflow/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'notification_state.dart';
part 'notification_cubit.freezed.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllNotificationsAsReadUseCase;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._markNotificationAsReadUseCase,
    this._markAllNotificationsAsReadUseCase,
  ) : super(const NotificationState.initial());

  Future<void> fetchNotifications() async {
    emit(const NotificationState.loading());
    final result = await _getNotificationsUseCase(const NoParams());
    switch (result) {
      case Success(data: final pageEntity):
        emit(NotificationState.loaded(
          notifications: pageEntity.items,
          unreadCount: pageEntity.unreadCount,
          total: pageEntity.total,
          page: pageEntity.page,
          limit: pageEntity.limit,
          totalPages: pageEntity.totalPages,
        ));
      case FailureResult(failure: final failure):
        emit(NotificationState.error(failure.message));
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final result = await _markNotificationAsReadUseCase(notificationId);
    
    switch (result) {
      case Success():
        bool wasUnread = false;
        final updatedNotifications = currentState.notifications.map((notification) {
          if (notification.id == notificationId && !notification.isRead) {
            wasUnread = true;
            return NotificationEntity(
              id: notification.id,
              title: notification.title,
              message: notification.message,
              type: notification.type,
              isRead: true,
              createdAt: notification.createdAt,
              data: notification.data,
            );
          }
          return notification;
        }).toList();

        final unreadCount = wasUnread 
            ? (currentState.unreadCount > 0 ? currentState.unreadCount - 1 : 0)
            : currentState.unreadCount;

        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));

      case FailureResult(failure: final failure):
        emit(NotificationState.error(failure.message));
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final result = await _markAllNotificationsAsReadUseCase(const NoParams());
    
    switch (result) {
      case Success():
        final updatedNotifications = currentState.notifications.map((notification) {
          if (!notification.isRead) {
            return NotificationEntity(
              id: notification.id,
              title: notification.title,
              message: notification.message,
              type: notification.type,
              isRead: true,
              createdAt: notification.createdAt,
              data: notification.data,
            );
          }
          return notification;
        }).toList();

        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: 0,
        ));

      case FailureResult(failure: final failure):
        emit(NotificationState.error(failure.message));
    }
  }
}
