import 'dart:io';

import 'package:dineflow/features/orders/data/data_source/pending_order_local_data_source_impl.dart';
import 'package:dineflow/features/orders/data/database/dine_flow_database.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DineFlowDatabase database;
  late PendingOrderLocalDataSourceImpl dataSource;
  var closeDatabaseInTearDown = true;

  setUp(() async {
    closeDatabaseInTearDown = true;
    database = DineFlowDatabase(NativeDatabase.memory());
    dataSource = PendingOrderLocalDataSourceImpl(database);
  });

  tearDown(() async {
    if (closeDatabaseInTearDown) await database.close();
  });

  PendingOrder createOrder(String clientOrderId, {DateTime? createdAt}) {
    return PendingOrder(
      clientOrderId: clientOrderId,
      payload: {
        'orderType': 'TAKEAWAY',
        'items': [
          {'id': 'item-1', 'quantity': 2},
        ],
      },
      createdAt: createdAt ?? DateTime.utc(2026, 11, 15),
    );
  }

  test(
    'adds, retrieves, updates, records server ID, and deletes an order',
    () async {
      final order = createOrder('order-1');

      await dataSource.add(order);
      var storedOrders = await dataSource.getAll();
      expect(storedOrders, hasLength(1));
      expect(storedOrders.single.clientOrderId, order.clientOrderId);
      expect(storedOrders.single.payload, order.payload);

      await dataSource.updateStatus(
        order.clientOrderId,
        PendingOrderStatus.failed,
        retryCount: 2,
        lastError: 'Item unavailable',
      );
      storedOrders = await dataSource.getAll();
      expect(storedOrders.single.status, PendingOrderStatus.failed);
      expect(storedOrders.single.retryCount, 2);
      expect(storedOrders.single.lastError, 'Item unavailable');

      await dataSource.recordServerOrderId(
        order.clientOrderId,
        'server-order-1',
      );
      storedOrders = await dataSource.getAll();
      expect(storedOrders.single.serverOrderId, 'server-order-1');

      await dataSource.delete(order.clientOrderId);
      expect(await dataSource.getAll(), isEmpty);
    },
  );

  test('returns orders in FIFO order by createdAt', () async {
    await dataSource.add(
      createOrder('later', createdAt: DateTime.utc(2026, 11, 17)),
    );
    await dataSource.add(
      createOrder('earlier', createdAt: DateTime.utc(2026, 11, 15)),
    );
    await dataSource.add(
      createOrder('middle', createdAt: DateTime.utc(2026, 11, 16)),
    );

    final orders = await dataSource.getAll();
    expect(orders.map((order) => order.clientOrderId), [
      'earlier',
      'middle',
      'later',
    ]);
  });

  test(
    'preserves insertion order when createdAt values are identical',
    () async {
      final createdAt = DateTime.utc(2026, 11, 15, 10);
      await dataSource.add(createOrder('first', createdAt: createdAt));
      await dataSource.add(createOrder('second', createdAt: createdAt));

      final orders = await dataSource.getAll();

      expect(orders.map((order) => order.clientOrderId), ['first', 'second']);
    },
  );

  test(
    'preserves queued data after closing and reopening the database',
    () async {
      final order = createOrder(
        'persistent-order',
        createdAt: DateTime.utc(2026, 11, 15, 10),
      );
      final databasePath =
          '${Directory.systemTemp.path}\\dineflow-orders-test-${DateTime.now().microsecondsSinceEpoch}.sqlite';
      await database.close();
      closeDatabaseInTearDown = false;
      final firstDatabase = DineFlowDatabase(
        NativeDatabase(File(databasePath)),
      );
      final firstDataSource = PendingOrderLocalDataSourceImpl(firstDatabase);
      await firstDataSource.add(order);
      await firstDatabase.close();

      final reopenedDatabase = DineFlowDatabase(
        NativeDatabase(File(databasePath)),
      );
      final reopenedDataSource = PendingOrderLocalDataSourceImpl(
        reopenedDatabase,
      );

      final storedOrders = await reopenedDataSource.getAll();
      expect(storedOrders, hasLength(1));
      expect(storedOrders.single.clientOrderId, order.clientOrderId);
      expect(storedOrders.single.payload, order.payload);
      await reopenedDatabase.close();
      final file = File(databasePath);
      if (await file.exists()) await file.delete();
    },
  );
}
