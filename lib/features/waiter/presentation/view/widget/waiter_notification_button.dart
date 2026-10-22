import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/notification/presentation/view_models/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WaiterNotificationButton extends StatelessWidget {
  const WaiterNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unreadCount = state.maybeWhen(
          loaded: (_, unreadCount, _, _, _, _) => unreadCount,
          orElse: () => 0,
        );

        return IconButton(
          tooltip: 'Notifications',
          onPressed: () => context.pushNamed(AppRoutes.waiterNotifications),
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
            backgroundColor: AppColors.waiterPrimary,
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurface,
            ),
          ),
        );
      },
    );
  }
}
