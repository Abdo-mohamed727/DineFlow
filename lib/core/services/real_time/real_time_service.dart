import 'package:dineflow/core/networking/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class RealTimeService {
  io.Socket? _socket;
  final Set<void Function(Map<String, dynamic>)> _orderCreatedListeners = {};
  final Set<void Function(Map<String, dynamic>)> _orderUpdateListeners = {};

  bool get isConnected => _socket?.connected ?? false;

  void connect({required String token}) {
    if (_socket != null) return;

    _socket = io.io(
      ApiConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setAuth({'token': token})
          .build(),
    );

    _socket!
      ..onConnect((_) {
        debugPrint('Socket connected: ${_socket?.id}');
      })
      ..onDisconnect((_) {
        debugPrint('Socket disconnected');
      })
      ..onConnectError((error) {
        debugPrint('Socket connection error: $error');
      })
      ..onError((error) {
        debugPrint('Socket error: $error');
      })
      ..on(RealtimeEvents.orderCreated, (data) {
        if (data is! Map) return;

        final payload = Map<String, dynamic>.from(data);
        final order = payload['order'];
        if (order is! Map) return;

        final orderData = Map<String, dynamic>.from(order);
        for (final listener in _orderCreatedListeners.toList()) {
          listener(orderData);
        }
      })
      ..on(RealtimeEvents.orderStatusChanged, (data) {
        if (data is! Map) return;

        final payload = Map<String, dynamic>.from(data);
        for (final listener in _orderUpdateListeners.toList()) {
          listener(payload);
        }
      });

    _socket!.connect();
  }

  void onOrderCreated(void Function(Map<String, dynamic> order) callback) {
    _orderCreatedListeners.add(callback);
  }

  void offOrderCreated(void Function(Map<String, dynamic> order) callback) {
    _orderCreatedListeners.remove(callback);
  }

  void onOrderUpdate(void Function(Map<String, dynamic> payload) callback) {
    _orderUpdateListeners.add(callback);
  }

  void offOrderUpdate(void Function(Map<String, dynamic> payload) callback) {
    _orderUpdateListeners.remove(callback);
  }

  void offOrderEvents() {
    _orderCreatedListeners.clear();
    _orderUpdateListeners.clear();
  }

  void disconnect() {
    offOrderEvents();
    _socket?.dispose();
    _socket = null;
  }
}
