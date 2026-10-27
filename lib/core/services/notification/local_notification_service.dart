import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static const _channelId = 'dineflow_notifications';
  static const _channelName = 'DineFlow Notifications';
  static const _channelDesc =
      'Notifications for orders and restaurant activity';

  static final _plugin = FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static ValueChanged<String?>? onLocalNotificationTap;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );

    await _createAndroidChannel();
  }

  static Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  static Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('[LocalNotificationService] show() called before initialize()');
      return;
    }

    try {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('[LocalNotificationService] show() error: $e');
    }
  }


  static void _onTap(NotificationResponse response) {
    debugPrint('[LocalNotificationService] tapped: ${response.payload}');
    onLocalNotificationTap?.call(response.payload);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundTap(NotificationResponse response) {
    debugPrint('[LocalNotificationService] bg-tapped: ${response.payload}');
  }
}
