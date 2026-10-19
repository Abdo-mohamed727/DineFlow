import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';

class DiningSessionModel {
  final String id;
  final String tableId;
  final String status;

  const DiningSessionModel({
    required this.id,
    required this.tableId,
    required this.status,
  });

  factory DiningSessionModel.fromJson(Map<String, dynamic> json) {
    final rawTableId = json['tableId'];
    final tableId = rawTableId is Map
        ? (rawTableId['id'] ?? rawTableId['_id'])?.toString()
        : rawTableId?.toString();
    final id = (json['id'] ?? json['_id'])?.toString();

    if (id == null || id.isEmpty || tableId == null || tableId.isEmpty) {
      throw const ServerException('Dining session data is incomplete.');
    }

    return DiningSessionModel(
      id: id,
      tableId: tableId,
      status: json['status']?.toString() ?? '',
    );
  }

  factory DiningSessionModel.fromSessionResponse(dynamic response) {
    if (response is! Map) {
      throw const ServerException('Unexpected dining session response.');
    }
    final data = response['data'];
    final session = data is Map ? data['session'] : null;
    if (session is! Map) {
      throw const ServerException('Dining session data is missing.');
    }
    return DiningSessionModel.fromJson(Map<String, dynamic>.from(session));
  }

  static List<DiningSessionModel> listFromResponse(dynamic response) {
    if (response is! Map) {
      throw const ServerException('Unexpected dining sessions response.');
    }

    final data = response['data'];
    final sessions = data is List
        ? data
        : data is Map
        ? data['sessions']
        : response['sessions'];
    if (sessions is! List) {
      throw const ServerException('Dining sessions list is missing.');
    }

    return sessions
        .whereType<Map>()
        .map(
          (session) =>
              DiningSessionModel.fromJson(Map<String, dynamic>.from(session)),
        )
        .toList();
  }

  DiningSessionEntity toEntity() =>
      DiningSessionEntity(id: id, tableId: tableId, status: status);
}
