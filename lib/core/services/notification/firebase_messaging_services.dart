import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingServices {
  final FirebaseMessaging _messaging;

  FirebaseMessagingServices(this._messaging);

  Future<String?> getToken() async {
    try {
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }
  Future<void> initialize() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();

    print('FCM TOKEN: $token');

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification opened');
      print(message.data);
    });
  }
}
