part of 'notification_cubit.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = _Initial;
  const factory NotificationState.loading() = _Loading;
  const factory NotificationState.loaded({
    required List<NotificationEntity> notifications,
    required int unreadCount,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _Loaded;
  const factory NotificationState.error(String message) = _Error;
}
