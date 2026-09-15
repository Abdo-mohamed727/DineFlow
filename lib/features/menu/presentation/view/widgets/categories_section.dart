import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/presentation/view/screens/categories_view.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/category_card.dart';
import 'package:dineflow/features/menu/presentation/view_model/cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    const allCategory = CategoryEntity(id: '', name: 'All');
    final displayCategories = [allCategory, ...categories];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            GestureDetector(
              onTap: () {
                try {
                  context.pushNamed(AppRoutes.customerCategories);
                } catch (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CategoriesView(),
                    ),
                  );
                }
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primaryContainer,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = displayCategories[index];
              final isSelected = index == 0
                  ? (selectedCategoryId == null || selectedCategoryId!.isEmpty)
                  : (selectedCategoryId == cat.id);

              return CategoryCard(
                category: cat,
                isSelected: isSelected,
                onTap: () {
                  context.read<MenuCubit>().selectCategory(
                        cat.id.isEmpty ? null : cat.id,
                      );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
