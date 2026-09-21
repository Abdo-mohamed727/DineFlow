import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'route_guard.dart';

/// Pure function that maps [UserRole] → [AuthStatus].
///
/// Kept in `core/router` because it bridges the auth domain with the
/// router domain without coupling either side to the other.
AuthStatus authStatusFromRole(UserRole role) => switch (role) {
      UserRole.customer => AuthStatus.customer,
      UserRole.waiter => AuthStatus.waiter,
      UserRole.kitchen => AuthStatus.kitchen,
    };
