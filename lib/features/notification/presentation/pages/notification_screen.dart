import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/notification/presentation/view_models/notification_cubit.dart';
import 'package:dineflow/features/notification/presentation/widgets/notification_empty_view.dart';
import 'package:dineflow/features/notification/presentation/widgets/notification_error_view.dart';
import 'package:dineflow/features/notification/presentation/widgets/notification_loading_view.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationCubit>()..fetchNotifications(),
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final hasUnread = state.maybeWhen(
                loaded: (notifications, unreadCount, _, _, _, _) => unreadCount > 0,
                orElse: () => false,
              );

              return TextButton(
                onPressed: hasUnread 
                    ? () => context.read<NotificationCubit>().markAllNotificationsAsRead()
                    : null,
                child: Text(
                  'Mark all as read',
                  style: TextStyle(
                    color: hasUnread ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Icon(Icons.person, size: 20, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return state.when(
            initial: () => const NotificationLoadingView(),
            loading: () => const NotificationLoadingView(),
            error: (message) => NotificationErrorView(
              message: message,
              onRetry: () => context.read<NotificationCubit>().fetchNotifications(),
            ),
            loaded: (notifications, unreadCount, total, page, limit, totalPages) {
              if (notifications.isEmpty) {
                return const NotificationEmptyView();
              }
              return RefreshIndicator(
                onRefresh: () => context.read<NotificationCubit>().fetchNotifications(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      tileColor: notification.isRead 
                          ? AppColors.surfaceContainerLow 
                          : AppColors.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: notification.isRead 
                            ? AppColors.surfaceContainerHighest
                            : AppColors.primaryContainer.withOpacity(0.2),
                        child: Icon(
                          Icons.notifications,
                          color: notification.isRead 
                              ? AppColors.onSurfaceVariant
                              : AppColors.primaryContainer,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        notification.message,
                        style: const TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      onTap: () {
                        if (!notification.isRead) {
                          context.read<NotificationCubit>().markNotificationAsRead(notification.id);
                        }
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
