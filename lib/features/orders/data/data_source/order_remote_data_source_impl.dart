import 'package:dineflow/core/error/exception.dart';
import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/core/networking/api_error_handler.dart';
import 'package:dineflow/features/orders/data/data_source/order_remote_data_source_interface.dart';
import 'package:dineflow/features/orders/data/models/order_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio _dio;

  OrderRemoteDataSourceImpl(this._dio);

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dio.get(ApiConstants.orders);
      final list = _extractList(response.data);
      return list
          .whereType<Map>()
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not load orders. Please try again.',
      );
    }
  }

  @override
  Future<OrderModel> createTakeAwayOrder(CreateOrderRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.orders,
        data: request.toJson(),
      );
      if (response.data == null) {
        throw const ServerException('Order was not created.');
      }
      return OrderModel.fromJson(_asMap(response.data));
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not place your order. Please try again.',
      );
    }
  }

  @override
  Future<List<RestaurantTableModel>> getTables() async {
    try {
      Response response;
      try {
        response = await _dio.get(
          ApiConstants.tables,
          queryParameters: const {'status': 'AVAILABLE'},
        );
      } catch (_) {
        response = await _dio.get(ApiConstants.tables);
      }
      var tables = _parseTables(response.data);
      if (tables.isEmpty) {
        final fallbackResponse = await _dio.get(ApiConstants.tables);
        tables = _parseTables(fallbackResponse.data);
      }
      return tables;
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not load available tables.',
      );
    }
  }

  @override
  Future<String> startDining(String tableId) async {
    try {
      final response = await _dio.post(
        ApiConstants.startDining,
        data: {'tableId': tableId},
      );
      final sessionId = _sessionIdFrom(response.data);
      if (sessionId == null || sessionId.isEmpty) {
        throw const ServerException('Dining session was not started.');
      }
      return sessionId;
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not start your dining session. Please try again.',
      );
    }
  }

  List<RestaurantTableModel> _parseTables(dynamic data) {
    final list = _extractList(data);
    return list
        .whereType<Map>()
        .map((e) => RestaurantTableModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final nested = map['data'];
      if (nested is List) return nested;
      if (nested is Map) {
        final nestedMap = Map<String, dynamic>.from(nested);
        if (nestedMap['tables'] is List) return nestedMap['tables'] as List;
        if (nestedMap['items'] is List) return nestedMap['items'] as List;
        if (nestedMap['data'] is List) return nestedMap['data'] as List;
      }
      if (map['tables'] is List) return map['tables'] as List;
      if (map['items'] is List) return map['items'] as List;
      if (map['results'] is List) return map['results'] as List;
    }
    return const [];
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ServerException('Unexpected order response.');
  }

String? _sessionIdFrom(dynamic data) {
  if (data is! Map) return null;

  final map = Map<String, dynamic>.from(data);
  final dataObject = map['data'];

  if (dataObject is! Map) return null;

  final dataMap = Map<String, dynamic>.from(dataObject);
  final session = dataMap['session'];

  if (session is! Map) return null;

  final sessionMap = Map<String, dynamic>.from(session);
  final sessionId = sessionMap['id'] ?? sessionMap['_id'];

  if (sessionId == null || sessionId.toString().isEmpty) {
    return null;
  }

  return sessionId.toString();
}

  @override
  Future<OrderModel> createDineInOrder(
    CreateOrderRequest request, {
    required String diningSessionId,
  }) async {
    try {
      final payload = {...request.toJson(), 'diningSessionId': diningSessionId};
      final response = await _dio.post(ApiConstants.orders, data: payload);
      if (response.data == null) {
        throw const ServerException('Order was not created.');
      }
      return OrderModel.fromJson(_asMap(response.data));
    } on AppException {
      rethrow;
    } catch (e) {
      ApiErrorHandler.throwAppException(
        e,
        fallback: 'Could not place your order. Please try again.',
      );
    }
  }
}
