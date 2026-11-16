import 'dart:convert';

import 'package:dineflow/features/orders/data/data_source/pending_order_local_data_source_interface.dart';
import 'package:dineflow/features/orders/data/database/dine_flow_database.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PendingOrderLocalDataSource)
class PendingOrderLocalDataSourceImpl implements PendingOrderLocalDataSource {
  PendingOrderLocalDataSourceImpl(this._database);

  final DineFlowDatabase _database;

  @override
  Future<void> add(PendingOrder order) async {
    await _database
        .into(_database.pendingOrders)
        .insert(_toCompanion(order), mode: InsertMode.insertOrIgnore);
  }

  @override
  Future<List<PendingOrder>> getAll() async {
    final rows =
        await (_database.select(_database.pendingOrders)..orderBy([
              (row) => OrderingTerm.asc(row.createdAt),
              (row) => OrderingTerm.asc(row.sequence),
            ]))
            .get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<void> updateStatus(
    String clientOrderId,
    PendingOrderStatus status, {
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
  }) async {
    final changes = PendingOrdersCompanion(
      status: Value(status.name),
      retryCount: retryCount == null ? const Value.absent() : Value(retryCount),
      lastError: clearLastError
          ? const Value(null)
          : lastError == null
          ? const Value.absent()
          : Value(lastError),
    );
    final updated = await (_database.update(
      _database.pendingOrders,
    )..where((row) => row.clientOrderId.equals(clientOrderId))).write(changes);
    if (updated == 0) {
      throw StateError('Pending order $clientOrderId was not found.');
    }
  }

  @override
  Future<void> recordServerOrderId(
    String clientOrderId,
    String serverOrderId,
  ) async {
    final updated =
        await (_database.update(_database.pendingOrders)
              ..where((row) => row.clientOrderId.equals(clientOrderId)))
            .write(PendingOrdersCompanion(serverOrderId: Value(serverOrderId)));
    if (updated == 0) {
      throw StateError('Pending order $clientOrderId was not found.');
    }
  }

  @override
  Future<void> delete(String clientOrderId) async {
    await (_database.delete(
      _database.pendingOrders,
    )..where((row) => row.clientOrderId.equals(clientOrderId))).go();
  }

  PendingOrdersCompanion _toCompanion(PendingOrder order) {
    return PendingOrdersCompanion.insert(
      clientOrderId: order.clientOrderId,
      payload: jsonEncode(order.payload),
      status: order.status.name,
      retryCount: Value(order.retryCount),
      createdAt: order.createdAt,
      lastError: Value(order.lastError),
      serverOrderId: Value(order.serverOrderId),
    );
  }

  PendingOrder _fromRow(PendingOrderRow row) {
    final payload = jsonDecode(row.payload);
    if (payload is! Map) {
      throw FormatException(
        'Stored payload for pending order ${row.clientOrderId} is invalid.',
      );
    }
    return PendingOrder(
      clientOrderId: row.clientOrderId,
      payload: Map<String, dynamic>.from(payload),
      status: PendingOrderStatus.values.byName(row.status),
      retryCount: row.retryCount,
      createdAt: row.createdAt,
      lastError: row.lastError,
      serverOrderId: row.serverOrderId,
    );
  }
}
