import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProductDetailsOptions extends StatelessWidget {
  final int selectedPattySize;
  final ValueChanged<int> onPattySizeChanged;
  final int selectedSpiceLevel;
  final ValueChanged<int> onSpiceLevelChanged;

  const ProductDetailsOptions({
    super.key,
    required this.selectedPattySize,
    required this.onPattySizeChanged,
    required this.selectedSpiceLevel,
    required this.onSpiceLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Patty Size Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PATTY SIZE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Select 1',
                style: TextStyle(
                  color: AppColors.outline,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _buildRadioOptionCard(
                title: 'Single Patty',
                subtitle: 'Standard',
                isSelected: selectedPattySize == 0,
                onTap: () => onPattySizeChanged(0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRadioOptionCard(
                title: 'Double Patty',
                subtitle: '+\$2.50',
                isSelected: selectedPattySize == 1,
                subtitleColor: AppColors.primaryContainer,
                onTap: () => onPattySizeChanged(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Spice Level Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Spice Level',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Optional',
              style: TextStyle(
                color: AppColors.outline,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _buildSpiceChip(
                label: 'Mild',
                isSelected: selectedSpiceLevel == 0,
                onTap: () => onSpiceLevelChanged(0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpiceChip(
                label: 'Medium 🌶️',
                isSelected: selectedSpiceLevel == 1,
                onTap: () => onSpiceLevelChanged(1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpiceChip(
                label: 'Hot 🌶️🌶️',
                isSelected: selectedSpiceLevel == 2,
                onTap: () => onSpiceLevelChanged(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOptionCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHigh,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor ?? AppColors.outline,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHigh,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.onSurface,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
