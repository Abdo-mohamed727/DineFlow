import 'package:dineflow/features/orders/data/database/pending_orders_table.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'dine_flow_database.g.dart';

@DriftDatabase(tables: [PendingOrders])
class DineFlowDatabase extends _$DineFlowDatabase {
  DineFlowDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'dineflow'));

  @override
  int get schemaVersion => 1;
}
