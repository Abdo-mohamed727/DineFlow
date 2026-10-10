import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_empty_state.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/waiter_cubit.dart';

class WaiterRequestsView extends StatefulWidget {
  const WaiterRequestsView({super.key});

  @override
  State<WaiterRequestsView> createState() => _WaiterRequestsViewState();
}

class _WaiterRequestsViewState extends State<WaiterRequestsView> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    context.read<WaiterCubit>().getPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Requests',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadRequests,
            tooltip: 'Refresh requests',
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
          ),
        ],
      ),
      body: BlocBuilder<WaiterCubit, WaiterState>(
        builder: (context, state) {
          return state.when(
            initial: () =>
                const AppLoadingIndicator(message: 'Loading requests...'),
            loading: () =>
                const AppLoadingIndicator(message: 'Loading requests...'),
            error: (message) =>
                AppErrorState(message: message, onRetry: _loadRequests),
            requestsLoaded: (requests) {
              if (requests.items.isEmpty) {
                return AppEmptyState(
                  title: 'No requests',
                  message: 'New waiter requests will appear here.',
                  iconData: Icons.inbox_outlined,
                  actionText: 'Refresh',
                  onAction: _loadRequests,
                );
              }
              return _buildRequestsList(requests.items);
            },
            requestUpdated: (_) =>
                const AppLoadingIndicator(message: 'Updating requests...'),
            tablesLoaded: (_) => const SizedBox.shrink(),
            tableLoaded: (_) => const SizedBox.shrink(),
            tableUpdated: (_) => const SizedBox.shrink(),
            ordersLoaded: (_) => const SizedBox.shrink(),
            orderLoaded: (_) => const SizedBox.shrink(),
            orderCreated: (_) => const SizedBox.shrink(),
            orderStatusUpdated: (_) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildRequestsList(List<WaiterRequestEntity> requests) {
    return RefreshIndicator(
      color: AppColors.primaryContainer,
      backgroundColor: AppColors.surfaceContainer,
      onRefresh: () async => _loadRequests(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _RequestCard(
          request: requests[index],
          onAccept: () =>
              context.read<WaiterCubit>().acceptRequest(requests[index].id),
          onComplete: () =>
              context.read<WaiterCubit>().completeRequest(requests[index].id),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onComplete,
  });

  final WaiterRequestEntity request;
  final VoidCallback onAccept;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final status = request.status.toLowerCase();
    final isPending = status == 'pending';
    final isAccepted = status == 'accepted';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.customer.name.isEmpty
                      ? 'Customer request'
                      : request.customer.name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _RequestStatusBadge(status: request.status),
            ],
          ),
          const SizedBox(height: 14),
          _InfoLine(
            icon: Icons.table_restaurant_outlined,
            text: 'Table ${request.table.tableNumber}',
          ),
          const SizedBox(height: 8),
          _InfoLine(
            icon: Icons.restaurant_outlined,
            text: request.type.isEmpty ? 'Dine in' : request.type,
          ),
          if (request.message.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              request.message,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final Widget? action = isAccepted
                  ? _RequestActionButton(
                      label: 'Complete',
                      icon: Icons.check_circle_outline,
                      onPressed: onComplete,
                    )
                  : isPending
                  ? _RequestActionButton(
                      label: 'Accept',
                      icon: Icons.thumb_up_alt_outlined,
                      onPressed: onAccept,
                    )
                  : null;

              if (action == null) {
                return const SizedBox.shrink();
              }

              if (constraints.maxWidth < 300) {
                return SizedBox(width: double.infinity, child: action);
              }
              return Align(alignment: Alignment.centerRight, child: action);
            },
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RequestStatusBadge extends StatelessWidget {
  const _RequestStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = normalized == 'accepted'
        ? const Color(0xFF81C784)
        : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _capitalize(status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return 'Pending';
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _RequestActionButton extends StatelessWidget {
  const _RequestActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        elevation: 0,
        minimumSize: const Size(132, 44),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
