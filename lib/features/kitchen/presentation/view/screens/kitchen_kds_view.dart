import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/kitchen/presentation/view/widgets/kitchen_kds_widgets.dart';
import 'package:dineflow/features/kitchen/presentation/view/widgets/kitchen_order_card.dart';
import 'package:dineflow/features/kitchen/presentation/view_model/cubit/kitchen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenKdsView extends StatelessWidget {
  const KitchenKdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KitchenCubit>()..fetchOrders(),
      child: const _KdsBody(),
    );
  }
}

class _KdsBody extends StatefulWidget {
  const _KdsBody();

  @override
  State<_KdsBody> createState() => _KdsBodyState();
}

class _KdsBodyState extends State<_KdsBody> {
  String _selectedStation = 'All Stations';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<KitchenCubit, KitchenState>(
              buildWhen: (p, c) =>
                  p.maybeWhen(loaded: (_) => true, orElse: () => false) ||
                  c.maybeWhen(loaded: (_) => true, orElse: () => false),
              builder: (_, state) {
                final count = state.maybeWhen(loaded: (o) => o.length, orElse: () => 0);
                return KdsHeader(orderCount: count);
              },
            ),
            const SizedBox(height: 8),
            KdsStationFilter(
              selected: _selectedStation,
              onSelect: (s) => setState(() => _selectedStation = s),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: BlocBuilder<KitchenCubit, KitchenState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(
                      child: CircularProgressIndicator(color: Color(0xFF81C784)),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Color(0xFF81C784)),
                    ),
                    loaded: (orders) => orders.isEmpty
                        ? const KdsEmptyState()
                        : KdsOrderList(
                            orders: orders,
                            cardBuilder: (o) => KitchenOrderCard(order: o),
                          ),
                    error: (f) => KdsErrorState(
                      message: f.message,
                      onRetry: () => context.read<KitchenCubit>().fetchOrders(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
