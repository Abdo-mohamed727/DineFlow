import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/category_list_card.dart';
import 'package:dineflow/features/menu/presentation/view_model/cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    // If context already contains a MenuCubit, use it; otherwise create one.
    final existingCubit = context.read<MenuCubit?>();
    if (existingCubit != null) {
      return const _CategoriesViewBody();
    }

    return BlocProvider(
      create: (_) => sl<MenuCubit>()..loadMenu(),
      child: const _CategoriesViewBody(),
    );
  }
}

class _CategoriesViewBody extends StatelessWidget {
  const _CategoriesViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => _buildLoading(),
                    loading: () => _buildLoading(),
                    error: (message) => _buildError(context, message),
                    loaded: (categories, products, selectedCategoryId, searchQuery) {
                      return _buildCategoriesList(
                        context,
                        categories,
                        products,
                      );
                    },
                    empty: (categories, selectedCategoryId, searchQuery, message) {
                      return _buildCategoriesList(
                        context,
                        categories,
                        const [],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.onSurface,
              size: 20,
            ),
          ),
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primaryContainer,
                  size: 24,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<CategoryEntity> categories,
    List<ProductEntity> products,
  ) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'No categories found',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final category = categories[index];
        final itemCount = products.isEmpty
            ? _getFallbackItemCount(category.name)
            : products.where((p) => p.category.id == category.id).length;

        return CategoryListCard(
          category: category,
          itemCount: itemCount > 0 ? itemCount : _getFallbackItemCount(category.name),
          onTap: () {
            context.read<MenuCubit>().selectCategory(category.id);
            if (context.canPop()) {
              context.pop();
            }
          },
        );
      },
    );
  }

  int _getFallbackItemCount(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('pizza')) return 24;
    if (lower.contains('burger')) return 12;
    if (lower.contains('sandwich')) return 18;
    if (lower.contains('side')) return 8;
    if (lower.contains('drink')) return 15;
    if (lower.contains('dessert')) return 10;
    return 10;
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryContainer,
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.read<MenuCubit>().loadMenu(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
