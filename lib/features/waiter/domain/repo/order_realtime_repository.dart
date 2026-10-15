
import 'package:dineflow/features/waiter/domain/entity/order_realtime_event.dart';

abstract interface class OrderRealtimeRepository {
  Stream<OrderRealtimeEvent> watchOrderEvents();
}
