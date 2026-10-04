import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:dineflow/core/services/notification/local_notification_service.dart';

int _messageToId(String? messageId) {
  if (messageId == null || messageId.isEmpty) return 0;
  return messageId.hashCode.abs() % 0x7FFFFFFF;
}

String _encodePayload(Map<String, dynamic> data) {
  try {
    return jsonEncode(data);
  } catch (_) {
    return '{}';
  }
}

Map<String, dynamic> _decodePayload(String? payload) {
  if (payload == null || payload.isEmpty) return {};
  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) return decoded;
  } catch (_) {}
  return {};
}


const _typeNewOrder = 'NEW_ORDER';
const _typeOrderUpdate = 'ORDER_STATUS_CHANGED';

class NotificationHandler {
  NotificationHandler._();
  static GoRouter? _router;
  static Map<String, dynamic>? _pendingNavigation;
  static void setRouter(GoRouter router) {
    _router = router;

    LocalNotificationService.onLocalNotificationTap = (payload) {
      final data = _decodePayload(payload);
      _handleNavigation(data);
    };
    if (_pendingNavigation != null) {
      final pending = _pendingNavigation!;
      _pendingNavigation = null;
      Future.microtask(() => _handleNavigation(pending));
    }
  }

  static void handleForeground(RemoteMessage message) {
    debugPrint('[NotificationHandler] foreground: ${message.messageId}');
    try {
      final title = message.notification?.title ?? 'DineFlow';
      final body = message.notification?.body ?? '';
      final payload = _encodePayload(message.data);
      final id = _messageToId(message.messageId);

      LocalNotificationService.show(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
    } catch (e) {
      debugPrint('[NotificationHandler] handleForeground error: $e');
    }
  }
  static void handleBackgroundOpened(RemoteMessage message) {
    debugPrint('[NotificationHandler] bg-opened: ${message.messageId}');
    _handleNavigation(message.data);
  }

  static void handleInitialMessage(RemoteMessage message) {
    debugPrint('[NotificationHandler] initial: ${message.messageId}');
    if (_router != null) {
      Future.microtask(() => _handleNavigation(message.data));
    } else {
      _pendingNavigation = message.data;
    }
  }


  static void _handleNavigation(Map<String, dynamic> data) {
    final router = _router;
    if (router == null) {
      debugPrint('[NotificationHandler] router not ready — storing pending');
      _pendingNavigation = data;
      return;
    }

    try {
      final type = (data['type'] ?? data['clickAction'] ?? '') as String;
      debugPrint('[NotificationHandler] navigating for type=$type data=$data');

      switch (type) {
        case _typeNewOrder:
          router.go('/kitchen/kds');

        case _typeOrderUpdate:
          final orderId = data['orderId'] as String?;
          if (orderId == null || orderId.isEmpty) {
            debugPrint('[NotificationHandler] ORDER_STATUS_CHANGED missing orderId');
            router.go('/customer/orders');
            return;
          }
          router.go('/customer/orders/$orderId');

        default:
          debugPrint('[NotificationHandler] unknown type: $type — ignoring');
      }
    } catch (e) {
      debugPrint('[NotificationHandler] _handleNavigation error: $e');
    }
  }
}
