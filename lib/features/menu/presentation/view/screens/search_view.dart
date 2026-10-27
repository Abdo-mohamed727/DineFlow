import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/popular_searches_chips.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/search_bar_header.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/search_filter_bottom_sheet.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/search_result_card.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/search_results_header.dart';
import 'package:dineflow/features/menu/presentation/view_model/cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatelessWidget {
  final String? initialQuery;

  const SearchView({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuCubit>()
        ..loadMenu()
        ..searchProducts(initialQuery ?? ''),
      child: _SearchViewBody(initialQuery: initialQuery),
    );
  }
}

class _SearchViewBody extends StatefulWidget {
  final String? initialQuery;

  const _SearchViewBody({this.initialQuery});

  @override
  State<_SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<_SearchViewBody> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _popularSearches = [
    'Spicy Burger',
    'Pepperoni',
    'Banh Mi',
    'Sushi',
  ];

  String _selectedSort = 'Recommended';
  final Set<String> _addedProductIds = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onPopularChipTap(String query) {
    if (_searchController.text.toLowerCase() == query.toLowerCase()) {
      _searchController.clear();
      context.read<MenuCubit>().searchProducts('');
    } else {
      _searchController.text = query;
      context.read<MenuCubit>().searchProducts(query);
    }
    setState(() {});
  }

  List<ProductEntity> _sortProducts(List<ProductEntity> products) {
    final list = List<ProductEntity>.from(products);
    switch (_selectedSort) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Name: A-Z':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Recommended':
      default:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SearchBarHeader(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                context.read<MenuCubit>().searchProducts(value);
                setState(() {});
              },
              onClear: () {
                _searchController.clear();
                context.read<MenuCubit>().searchProducts('');
                setState(() {});
              },
              onFilterTap: () {
                SearchFilterBottomSheet.show(
                  context,
                  selectedSort: _selectedSort,
                  onSortSelected: (sort) => setState(() => _selectedSort = sort),
                );
              },
              onBackTap: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    PopularSearchesChips(
                      searches: _popularSearches,
                      activeQuery: _searchController.text,
                      onChipTap: _onPopularChipTap,
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<MenuCubit, MenuState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => _buildLoadingSkeleton(),
                          loading: () => _buildLoadingSkeleton(),
                          error: (msg) => _buildMessageView(msg),
                          empty: (categories, selectedCategoryId, query, msg) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchResultsHeader(
                                  count: 0,
                                  query: query,
                                  selectedSort: _selectedSort,
                                  onSortChanged: (val) =>
                                      setState(() => _selectedSort = val),
                                ),
                                const SizedBox(height: 30),
                                _buildEmptyView(query),
                              ],
                            );
                          },
                          loaded: (categories, products, selectedCategoryId, query) {
                            final sortedProducts = _sortProducts(products);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchResultsHeader(
                                  count: sortedProducts.length,
                                  query: query,
                                  selectedSort: _selectedSort,
                                  onSortChanged: (val) =>
                                      setState(() => _selectedSort = val),
                                ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortedProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = sortedProducts[index];
                                    final isAdded =
                                        _addedProductIds.contains(product.id);
                                    return SearchResultCard(
                                      product: product,
                                      isAdded: isAdded,
                                      onTap: () {
                                        context.pushNamed(
                                          AppRoutes.customerProductDetails,
                                          extra: product,
                                        );
                                      },
                                      onAddToCart: () {
                                        setState(() {
                                          if (isAdded) {
                                            _addedProductIds.remove(product.id);
                                          } else {
                                            _addedProductIds.add(product.id);
                                          }
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Added ${product.name} to cart!',
                                            ),
                                            backgroundColor:
                                                AppColors.surfaceContainerHigh,
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 40),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(String query) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "$query"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try checking spelling or keyword searches',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageView(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(msg, style: const TextStyle(color: AppColors.error)),
      ),
    );
  }
}
