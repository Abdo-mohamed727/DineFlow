import 'package:dineflow/core/router/route_guard.dart';
import 'package:injectable/injectable.dart';

/// Injectable singleton wrapper so [RouterNotifier] can be retrieved
/// from GetIt and updated from anywhere (e.g. auth BlocListeners).
@module
abstract class RouterModule {
  @singleton
  RouterNotifier get routerNotifier => RouterNotifier();
}
