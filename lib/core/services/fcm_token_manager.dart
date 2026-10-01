import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dineflow/core/di/servise_locator.dart';

@lazySingleton
class FcmTokenManager {
  String? _userId;

  Future<void> registerFCMToken(String userId) async {
    _userId = userId;
    
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _saveTokenToPreferences(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (_userId != null) {
        _saveTokenToPreferences(newToken);
      }
    });
  }

  Future<void> _saveTokenToPreferences(String token) async {
    try {
      final prefs = sl<SharedPreferences>();
      await prefs.setString('fcm_token', token);
    } catch (e) {
      // Handle error or ignore
    }
  }

  void clearUserId() {
    _userId = null;
  }
}
