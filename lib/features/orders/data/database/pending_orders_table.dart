import 'package:drift/drift.dart';

@DataClassName('PendingOrderRow')
class PendingOrders extends Table {
  IntColumn get sequence => integer().autoIncrement()();
  TextColumn get clientOrderId => text().unique()();
  TextColumn get payload => text()();
  TextColumn get status => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get lastError => text().nullable()();
  TextColumn get serverOrderId => text().nullable()();
}
