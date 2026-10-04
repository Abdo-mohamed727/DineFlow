import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:dineflow/core/services/notification/notification_handler.dart';
import 'package:dineflow/features/notification/domain/usecases/register_device_token_usecase.dart';
import 'package:dineflow/features/notification/domain/usecases/unregister_device_token_usecase.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message safely
  print("Background notification:");
  print("ID: ${message.messageId}");
  print("Title: ${message.notification?.title}");
  print("Data: ${message.data}");
}

@lazySingleton
class FcmTokenManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final RegisterDeviceTokenUseCase _registerDeviceTokenUseCase;
  final UnregisterDeviceTokenUseCase _unregisterDeviceTokenUseCase;
  
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _isAuthenticated = false;
  String? _currentToken;
  bool _isInitialized = false;

  FcmTokenManager(
    this._registerDeviceTokenUseCase,
    this._unregisterDeviceTokenUseCase,
  );

  void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationHandler.handleForeground(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationHandler.handleBackgroundOpened(message);
    });

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        NotificationHandler.handleInitialMessage(message);
      }
    });
  }

  Future<void> registerFCMToken() async {
    _isAuthenticated = true;

    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    final token = await _messaging.getToken();

    if (token != null) {
      _currentToken = token;
      await _registerDeviceTokenUseCase(RegisterDeviceTokenParams(token: token));
    }

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((newToken) async {
      _currentToken = newToken;
      if (_isAuthenticated) {
        await _registerDeviceTokenUseCase(RegisterDeviceTokenParams(token: newToken));
      }
    });
  }

  Future<void> unregisterFCMToken() async {
    _isAuthenticated = false;
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    
    final token = _currentToken ?? await _messaging.getToken();
    
    if (token != null) {
      await _unregisterDeviceTokenUseCase(UnregisterDeviceTokenParams(token: token));
    }
    
    _currentToken = null;
  }
}

