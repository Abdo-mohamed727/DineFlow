import 'package:dineflow/features/orders/data/database/dine_flow_database.dart';
import 'package:dineflow/features/orders/data/services/order_sync_service.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';
import 'package:dineflow/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  Dio get dio => getdio();

  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  DineFlowDatabase get database => DineFlowDatabase();

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  OrderSyncService orderSyncService(OrderRepositoryInterface repository) =>
      OrderSyncService(repository);
}
