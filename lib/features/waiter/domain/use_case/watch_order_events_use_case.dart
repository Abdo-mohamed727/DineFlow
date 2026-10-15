
import 'package:dineflow/features/waiter/domain/entity/order_realtime_event.dart';
import 'package:dineflow/features/waiter/domain/repo/order_realtime_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchOrderEventsUseCase {
  final OrderRealtimeRepository _repository;

  WatchOrderEventsUseCase(this._repository);

  Stream<OrderRealtimeEvent> call() {
    return _repository.watchOrderEvents();
  }
}
