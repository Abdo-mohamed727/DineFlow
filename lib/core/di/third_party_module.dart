import 'package:dineflow/core/networking/dio_factory.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  Dio get dio => getdio();
}
