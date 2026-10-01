import 'package:dineflow/core/networking/api_error_handler.dart';
import 'package:dineflow/core/networking/api_error_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/features/notification/data/data_source/notification_data_source_interface.dart';
import 'package:dineflow/features/notification/data/model/notification_page_model.dart';

@LazySingleton(as: NotificationDataSourceInterface)
class NotificationDataSourceImp
    implements NotificationDataSourceInterface {
  final Dio _dio;

  NotificationDataSourceImp(this._dio);

  @override
  Future<NotificationsPageModel> getNotifications() async {
    try {
      final response = await _dio.get(
        ApiConstants.notifications,
      );

      return NotificationsPageModel.fromJson(
        response.data['data'],
      );
    } on DioException catch (e) {
      throw  ApiErrorHandler.throwAppException(e);
    }
  }

  @override
  Future<NotificationsPageModel> getUnreadNotifications() async {
    try {
      final response = await _dio.get(
        ApiConstants.notifications,
        queryParameters: {
          'isRead': false,
        },
      );

      return NotificationsPageModel.fromJson(
        response.data['data'],
      );
    } on DioException catch (e) {
      throw  ApiErrorHandler.throwAppException(e);
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _dio.patch(
        ApiConstants.markAllNotificationsAsRead,
      );
    } on DioException catch (e) {
      throw  ApiErrorHandler.throwAppException(e);
    }
  }

  @override
  Future<void> markNotificationAsRead(
    String id,
  ) async {
    try {
      await _dio.patch(
        ApiConstants.markNotificationAsRead(id),
      );
    } on DioException catch (e) {
      throw  ApiErrorHandler.throwAppException(e);
    }
  }
}