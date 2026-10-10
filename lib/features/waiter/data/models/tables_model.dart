import 'package:dineflow/features/waiter/domain/entity/tables_entity.dart';

import 'table_model.dart';

class TablesModel {
  final List<TableModel> tables;

  const TablesModel({
    required this.tables,
  });

  factory TablesModel.fromJson(Map<String, dynamic> json) {
    return TablesModel(
      tables: (json['tables'] as List<dynamic>? ?? [])
          .map(
            (table) => TableModel.fromJson(
              table as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  TablesEntity toEntity() {
    return TablesEntity(
      tables: tables.map((table) => table.toEntity()).toList(),
    );
  }
}