import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrdersShimmerLoading extends StatelessWidget {
  const OrdersShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          _ShimmerBox(width: 120, height: 28),
          SizedBox(height: 18),
          _ShimmerBox(width: 180, height: 16),
          SizedBox(height: 16),
          _ShimmerCard(height: 180),
          SizedBox(height: 18),
          _ShimmerBox(width: 190, height: 16),
          SizedBox(height: 16),
          _ShimmerCard(height: 110),
          SizedBox(height: 12),
          _ShimmerCard(height: 110),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
