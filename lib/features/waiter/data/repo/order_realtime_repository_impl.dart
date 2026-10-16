
import 'package:dineflow/features/waiter/data/data_source/order_realtime_data_source.dart';
import 'package:dineflow/features/waiter/domain/entity/order_realtime_event.dart';
import 'package:dineflow/features/waiter/domain/repo/order_realtime_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRealtimeRepository)
class OrderRealtimeRepositoryImpl implements OrderRealtimeRepository {
  final OrderRealtimeDataSource _dataSource;

  OrderRealtimeRepositoryImpl(this._dataSource);

  @override
  Stream<OrderRealtimeEvent> watchOrderEvents() {
    return _dataSource.watchOrderEvents();
  }
}
