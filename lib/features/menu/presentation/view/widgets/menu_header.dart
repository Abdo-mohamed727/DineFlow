import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MenuHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationPressed;

  const MenuHeader({
    super.key,
    this.userName = 'Guest',
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $userName',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Good Food, Great Mood',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            // Cart Icon Button with Badge
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                final totalQty = context.watch<CartCubit?>()?.totalQuantity ?? 0;
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.onSurface,
                        ),
                        onPressed: () =>
                            context.pushNamed(AppRoutes.customerCart),
                      ),
                      if (totalQty > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$totalQty',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.onSurface,
                ),
                onPressed: onNotificationPressed ?? () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
