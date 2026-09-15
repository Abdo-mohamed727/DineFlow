import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_skeletonizer.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/category_card.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/product_card.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/special_banner.dart';
import 'package:flutter/material.dart';

class MenuShimmerLoading extends StatelessWidget {
  const MenuShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy entities for skeletonizer structure
    final dummyCategories = List.generate(
      5,
      (index) => CategoryEntity(
        id: 'dummy_$index',
        name: 'Category $index',
      ),
    );

    final dummyProducts = List.generate(
      6,
      (index) => ProductEntity(
        id: 'dummy_prod_$index',
        categoryId: 'dummy_cat',
        name: 'Dish Name Sample',
        description: 'Sample description placeholder text',
        price: 12.99,
      ),
    );

    return AppSkeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 14,
                      color: AppColors.surfaceContainerHigh,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 180,
                      height: 22,
                      color: AppColors.surfaceContainerHigh,
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar Skeleton
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 20),

            // Banner Skeleton
            const SpecialBanner(),
            const SizedBox(height: 24),

            // Categories Section Skeleton Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 18,
                  color: AppColors.surfaceContainerHigh,
                ),
                Container(
                  width: 60,
                  height: 14,
                  color: AppColors.surfaceContainerHigh,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Categories Row Skeleton
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dummyCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: dummyCategories[index],
                    isSelected: index == 0,
                    onTap: () {},
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Popular Dishes Section Skeleton Title
            Container(
              width: 140,
              height: 20,
              color: AppColors.surfaceContainerHigh,
            ),
            const SizedBox(height: 16),

            // Products Grid Skeleton
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: dummyProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: dummyProducts[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
