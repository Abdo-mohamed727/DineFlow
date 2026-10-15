import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaiterAssistanceSection extends StatelessWidget {
  const WaiterAssistanceSection({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showActions(context),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryContainer.withValues(alpha: 0.18),
                AppColors.surfaceContainerLow,
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primaryContainer, width: 1.2),
          ),
          child: const Row(
            children: [
              _AssistanceIcon(),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need assistance?',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Call waiter · Request bill · Other help',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceVariant,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssistanceActionsSheet(order: order),
    );
  }
}

class _AssistanceActionsSheet extends StatelessWidget {
  const _AssistanceActionsSheet({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listenWhen: (previous, current) =>
          previous.waiterRequestStatus != current.waiterRequestStatus &&
          current.waiterRequestStatus == WaiterRequestStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'How can we help?',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.notifications_active_rounded,
                    title: 'Call waiter',
                    subtitle: 'Get assistance',
                    onTap: () => _submit(context, WaiterRequestKind.callWaiter),
                  ),
                  _divider(),
                  _ActionButton(
                    icon: Icons.receipt_long_rounded,
                    title: 'Request bill',
                    subtitle: 'Ready to pay',
                    onTap: () =>
                        _submit(context, WaiterRequestKind.requestBill),
                  ),
                  _divider(),
                  _ActionButton(
                    icon: Icons.help_outline_rounded,
                    title: 'Other help',
                    subtitle: 'Something else',
                    onTap: () => _submit(context, WaiterRequestKind.otherHelp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 80,
    color: AppColors.outlineVariant.withValues(alpha: 0.5),
  );

  void _submit(BuildContext context, WaiterRequestKind kind) {
    final sessionId = order.diningSessionId;
    final tableId = order.tableId;
    if (sessionId == null ||
        sessionId.isEmpty ||
        tableId == null ||
        tableId.isEmpty) {
      return;
    }
    context.read<OrdersCubit>().submitWaiterRequest(
      diningSessionId: sessionId,
      tableId: tableId,
      kind: kind,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryContainer),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistanceIcon extends StatelessWidget {
  const _AssistanceIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_active_rounded,
        color: AppColors.primaryContainer,
      ),
    );
  }
}
