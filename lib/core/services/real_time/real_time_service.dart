import 'package:dineflow/core/networking/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class RealTimeService {
  io.Socket? _socket;

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
      });

    _socket!.connect();
  }

  void onOrderCreated(void Function(Map<String, dynamic> order) callback) {
    _socket?.off(RealtimeEvents.orderCreated);

    _socket?.on(RealtimeEvents.orderCreated, (data) {
      if (data is! Map) return;

      final payload = Map<String, dynamic>.from(data);
      final order = payload['order'];

      if (order is Map) {
        callback(Map<String, dynamic>.from(order));
      }
    });
  }

  void onOrderUpdate(void Function(Map<String, dynamic> payload) callback) {
    _socket?.off(RealtimeEvents.orderStatusChanged);

    _socket?.on(RealtimeEvents.orderStatusChanged, (data) {
      if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }

  void offWaiterRequestUpdated() {
    _socket?.off(RealtimeEvents.waiterRequestUpdated);
  }

  void offOrderEvents() {
    _orderCreatedListeners.clear();
    _orderUpdateListeners.clear();
  }

  void disconnect() {
    offOrderEvents();
    _waiterRequestCreatedListeners.clear();
    _waiterRequestUpdatedListeners.clear();
    _socket?.dispose();
    _socket = null;
  }
}
