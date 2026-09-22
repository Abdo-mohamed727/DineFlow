import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CartCookingNotesCard extends StatelessWidget {
  const CartCookingNotesCard({
    super.key,
    required this.notesController,
  });

  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.primaryContainer,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Cooking Notes',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
              Text(
                'Optional',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: notesController,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 13.5),
            decoration: InputDecoration(
              hintText: 'e.g. Extra napkins, no spicy sauce please...',
              hintStyle: TextStyle(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.background.withValues(alpha: 0.5),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryContainer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
