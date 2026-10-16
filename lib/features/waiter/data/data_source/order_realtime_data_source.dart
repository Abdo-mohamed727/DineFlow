
import 'dart:async';

import 'package:dineflow/core/services/real_time/real_time_service.dart';
import 'package:dineflow/features/waiter/data/models/order_model.dart';
import 'package:dineflow/features/waiter/domain/entity/order_realtime_event.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderRealtimeDataSource {
  final RealTimeService _realTimeService;

  OrderRealtimeDataSource(this._realTimeService);

  Stream<OrderRealtimeEvent> watchOrderEvents() {
    late final StreamController<OrderRealtimeEvent> controller;

    void onOrderCreated(Map<String, dynamic> json) {
      try {
        final order = OrderModel.fromJson(json).toEntity();
        controller.add(OrderCreatedRealtimeEvent(order));
      } catch (error, stackTrace) {
        controller.addError(error, stackTrace);
      }
    }

    void onOrderStatusChanged(Map<String, dynamic> payload) {
      final orderId = payload['orderId']?.toString();
      final newStatus = payload['newStatus']?.toString();

      if (orderId == null || newStatus == null) return;

      controller.add(
        OrderStatusChangedRealtimeEvent(
          orderId: orderId,
          newStatus: newStatus,
        ),
      );
    }

    controller = StreamController<OrderRealtimeEvent>(
      onListen: () {
        _realTimeService.onOrderCreated(onOrderCreated);
        _realTimeService.onOrderUpdate(onOrderStatusChanged);
      },
      onCancel: () {
        _realTimeService.offOrderEvents();
      },
    );

    return controller.stream;
  }
}
