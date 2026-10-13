import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/tables_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_state.freezed.dart';

enum TableStatus { initial, loading, success, failure }

@freezed
abstract class TableState with _$TableState {
  const factory TableState({
    @Default(TableStatus.initial) TableStatus status,
    @Default(TablesEntity(tables: [])) TablesEntity tables,
    @Default([]) List<RestaurantTableEntity> availableTables,
    TableEntity? selectedTable,
    String? errorMessage,
    @Default(false) bool updated, // one-shot flag, consume in BlocListener
  }) = _TableState;
}
