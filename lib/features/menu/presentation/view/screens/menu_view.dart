import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/categories_section.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/menu_empty_view.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/menu_error_view.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/menu_header.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/menu_search_field.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/menu_shimmer_loading.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/products_grid.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/special_banner.dart';
import 'package:dineflow/features/menu/presentation/view_model/cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuCubit>()..loadMenu(),
      child: const _MenuViewBody(),
    );
  }
}

class _MenuViewBody extends StatelessWidget {
  const _MenuViewBody();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit?>()?.state;
    String userName = 'Guest';
    authState?.maybeWhen(
      authenticated: (user) {
        if (user.name.isNotEmpty) {
          userName = user.name.split(' ').first;
        }
      },
      orElse: () {},
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            return state.when(
              initial: () => const MenuShimmerLoading(),
              loading: () => const MenuShimmerLoading(),
              error: (message) => MenuErrorView(message: message),
              loaded: (categories, products, selectedCategoryId, searchQuery) {
                return _buildMenuContent(
                  context: context,
                  userName: userName,
                  categories: categories,
                  products: products,
                  selectedCategoryId: selectedCategoryId,
                  isEmpty: false,
                );
              },
              empty: (categories, selectedCategoryId, searchQuery, message) {
                return _buildMenuContent(
                  context: context,
                  userName: userName,
                  categories: categories,
                  products: const [],
                  selectedCategoryId: selectedCategoryId,
                  isEmpty: true,
                  emptyMessage: message,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuContent({
    required BuildContext context,
    required String userName,
    required List<CategoryEntity> categories,
    required List<ProductEntity> products,
    required String? selectedCategoryId,
    required bool isEmpty,
    String? emptyMessage,
  }) {
    final selectedCategoryName =
        selectedCategoryId != null && selectedCategoryId.isNotEmpty
            ? categories
                .firstWhere(
                  (c) => c.id == selectedCategoryId,
                  orElse: () => const CategoryEntity(id: '', name: 'Dishes'),
                )
                .name
            : 'Popular Dishes';

    return RefreshIndicator(
      onRefresh: () => context.read<MenuCubit>().loadMenu(),
      color: AppColors.primaryContainer,
      backgroundColor: AppColors.surfaceContainerHigh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuHeader(userName: userName),
                  const SizedBox(height: 16),
                  const MenuSearchField(),
                  const SizedBox(height: 20),
                  const SpecialBanner(),
                  const SizedBox(height: 24),
                  CategoriesSection(
                    categories: categories,
                    selectedCategoryId: selectedCategoryId,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedCategoryName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: MenuEmptyView(
                message: emptyMessage ?? 'No products found',
              ),
            )
          else
            ProductsGrid(products: products),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }
}
