import 'package:dineflow/features/orders/domain/entity/pending_order.dart';

abstract interface class PendingOrderLocalDataSource {
  Future<void> add(PendingOrder order);

  Future<List<PendingOrder>> getAll();

  Future<void> updateStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  });

  Future<void> recordServerOrderId(String clientOrderId, String serverOrderId);

  Future<void> delete(String clientOrderId);
}
