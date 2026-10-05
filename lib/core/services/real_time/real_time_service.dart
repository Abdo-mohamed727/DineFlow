import 'package:dineflow/core/networking/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class RealTimeService {
  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect({String? token}) {
    if (_socket != null) return;  

    _socket = io.io(
      ApiConstants.socketUrl,  
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setAuth(token != null ? {'token': token} : {})
          .build(),
    );

    _socket!
      ..onConnect((_) => debugPrint('Socket Connected: ${_socket!.id}'))
      ..onDisconnect((_) => debugPrint('Socket Disconnected'))
      ..onConnectError((e) => debugPrint('Socket Connect Error: $e'))
      ..onError((e) => debugPrint('Socket Error: $e'));

    _socket!.connect();
  }

  void onOrderCreated(void Function(Map<String, dynamic> order) callback) {
    _socket?.off(RealtimeEvents.orderCreated);  
    _socket?.on(RealtimeEvents.orderCreated, (data) {
      callback(Map<String, dynamic>.from(data as Map));
    });
  }

  void onOrderUpdate(void Function(Map<String, dynamic> order) callback) {
    _socket?.off(RealtimeEvents.orderStatusChanged);
    _socket?.on(RealtimeEvents.orderStatusChanged, (data) {
      callback(Map<String, dynamic>.from(data as Map));
    });
  }

  void offOrderEvents() {
    _socket?.off(RealtimeEvents.orderCreated);
    _socket?.off(RealtimeEvents.orderStatusChanged);
  }

  void disconnect() {
    offOrderEvents();
    _socket?.dispose();
    _socket = null;
  }
}