import 'package:dineflow/core/networking/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class RealTimeService {
  io.Socket? _socket;
  final Set<void Function(Map<String, dynamic>)> _orderCreatedListeners = {};
  final Set<void Function(Map<String, dynamic>)> _orderUpdateListeners = {};
  final Set<void Function(Map<String, dynamic>)>
  _waiterRequestCreatedListeners = {};
  final Set<void Function(Map<String, dynamic>)>
  _waiterRequestUpdatedListeners = {};

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
      })
      ..on(RealtimeEvents.waiterRequestCreated, (data) {
        if (data is! Map) return;

        final payload = Map<String, dynamic>.from(data);
        final request = payload['request'];
        if (request is! Map) return;

        final requestData = Map<String, dynamic>.from(request);
        for (final listener in _waiterRequestCreatedListeners.toList()) {
          listener(requestData);
        }
      })
      ..on(RealtimeEvents.waiterRequestUpdated, (data) {
        if (data is! Map) return;

        final payload = Map<String, dynamic>.from(data);
        for (final listener in _waiterRequestUpdatedListeners.toList()) {
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

  void onWaiterRequestCreated(
    void Function(Map<String, dynamic> request) callback,
  ) {
    _waiterRequestCreatedListeners.add(callback);
  }

  void offWaiterRequestCreated(
    void Function(Map<String, dynamic> request) callback,
  ) {
    _waiterRequestCreatedListeners.remove(callback);
  }

  void onWaiterRequestUpdated(
    void Function(Map<String, dynamic> payload) callback,
  ) {
    _waiterRequestUpdatedListeners.add(callback);
  }

  void offWaiterRequestUpdated(
    void Function(Map<String, dynamic> payload) callback,
  ) {
    _waiterRequestUpdatedListeners.remove(callback);
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
