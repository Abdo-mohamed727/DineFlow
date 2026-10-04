import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/notification/domain/entity/notification_entity.dart';
import 'package:dineflow/features/notification/presentation/view_models/notification_cubit.dart';
import 'package:dineflow/features/notification/presentation/widgets/notification_error_view.dart';
import 'package:dineflow/features/notification/presentation/widgets/notification_loading_view.dart';

// Kitchen KDS accent green â€” mirrors the value used throughout the KDS.
const _kGreen = Color(0xFF81C784);

/// Kitchen Notifications tab.
///
/// Reuses [NotificationCubit], [GetNotificationsUseCase],
/// [MarkNotificationAsReadUseCase] and [MarkAllNotificationsAsReadUseCase]
/// exactly as they are registered in the DI container.
/// No Kitchen-specific data layer is created.
/// Consumes the [NotificationCubit] provided by [_KitchenShell] â€” no new
/// cubit or data-layer object is created here.
class KitchenNotificationsScreen extends StatelessWidget {
  const KitchenNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger a fresh fetch every time this tab is entered so the list stays
    // in sync with the shell-level cubit's badge count.
    context.read<NotificationCubit>().fetchNotifications();
    return const _KitchenNotificationsView();
  }
}

// ---------------------------------------------------------------------------
// View
// ---------------------------------------------------------------------------

class _KitchenNotificationsView extends StatelessWidget {
  const _KitchenNotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // â”€â”€ Custom header matching the KDS style â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _KitchenNotificationsHeader(),
            // â”€â”€ Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const NotificationLoadingView(),
                    loading: () => const NotificationLoadingView(),
                    error: (message) => NotificationErrorView(
                      message: message,
                      onRetry: () =>
                          context.read<NotificationCubit>().fetchNotifications(),
                    ),
                    loaded: (notifications, unreadCount, _, _, _, _) {
                      if (notifications.isEmpty) {
                        return const _KitchenEmptyNotifications();
                      }
                      return RefreshIndicator(
                        color: _kGreen,
                        backgroundColor: AppColors.surfaceContainerLow,
                        onRefresh: () =>
                            context.read<NotificationCubit>().fetchNotifications(),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: notifications.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _KitchenNotificationCard(
                              notification: notifications[index],
                              onTap: () => _handleTap(
                                context,
                                notifications[index],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles tapping a notification:
  /// - Marks it as read via the existing [MarkNotificationAsReadUseCase].
  /// - For NEW_ORDER type, navigates to the KDS using the existing
  ///   [NotificationHandler] navigation path (`/kitchen/kds`).
  void _handleTap(BuildContext context, NotificationEntity notification) {
    if (!notification.isRead) {
      context
          .read<NotificationCubit>()
          .markNotificationAsRead(notification.id);
    }

    // Reuse the same navigation target the NotificationHandler uses for NEW_ORDER.
    if (notification.type == 'NEW_ORDER') {
      context.go('/kitchen/kds');
    }
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _KitchenNotificationsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: [
          // Live indicator dot + label
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _kGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'NOTIFICATIONS',
            style: TextStyle(
              color: _kGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),

          // Unread count badge
          BlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (p, c) =>
                p.maybeWhen(
                  loaded: (_, u, _, _, _, _) => u,
                  orElse: () => -1,
                ) !=
                c.maybeWhen(
                  loaded: (_, u, _, _, _, _) => u,
                  orElse: () => -1,
                ),
            builder: (context, state) {
              final unread = state.maybeWhen(
                loaded: (_, u, _, _, _, _) => u,
                orElse: () => 0,
              );
              if (unread > 0) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _kGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$unread unread',
                    style: const TextStyle(
                      color: _kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const Spacer(),

          // Mark all as read button
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final hasUnread = state.maybeWhen(
                loaded: (_, u, _, _, _, _) => u > 0,
                orElse: () => false,
              );
              return TextButton(
                onPressed: hasUnread
                    ? () => context
                        .read<NotificationCubit>()
                        .markAllNotificationsAsRead()
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: _kGreen,
                  disabledForegroundColor:
                      AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Mark all read',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification card
// ---------------------------------------------------------------------------

class _KitchenNotificationCard extends StatelessWidget {
  const _KitchenNotificationCard({
    required this.notification,
    required this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final isNewOrder = notification.type == 'NEW_ORDER';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.surfaceContainerHigh
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnread
                ? _kGreen.withValues(alpha: 0.35)
                : AppColors.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon avatar
            _NotificationIcon(
              type: notification.type,
              isUnread: isUnread,
              isNewOrder: isNewOrder,
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: _kGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Timestamp
                      Text(
                        _formatTime(notification.createdAt),
                        style: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 11,
                        ),
                      ),
                      // NEW_ORDER chip â€” tap hint
                      if (isNewOrder) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _kGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _kGreen.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Text(
                            'NEW ORDER â†’ KDS',
                            style: TextStyle(
                              color: _kGreen,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ---------------------------------------------------------------------------
// Notification icon
// ---------------------------------------------------------------------------

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({
    required this.type,
    required this.isUnread,
    required this.isNewOrder,
  });

  final String type;
  final bool isUnread;
  final bool isNewOrder;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      'NEW_ORDER' => (Icons.restaurant_rounded, _kGreen),
      'ORDER_STATUS_CHANGED' => (Icons.sync_rounded, const Color(0xFF42A5F5)),
      _ => (Icons.notifications_rounded, AppColors.onSurfaceVariant),
    };

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isUnread ? 0.18 : 0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: isUnread ? 0.5 : 0.2),
          width: 1,
        ),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _KitchenEmptyNotifications extends StatelessWidget {
  const _KitchenEmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainer,
                boxShadow: [
                  BoxShadow(
                    color: _kGreen.withValues(alpha: 0.12),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: _kGreen,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'All clear!',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No notifications yet. New order alerts\nwill appear here instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


