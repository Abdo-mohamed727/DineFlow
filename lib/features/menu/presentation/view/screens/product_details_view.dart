import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/product_details_bottom_bar.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/product_details_header.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/product_details_hero.dart';
import 'package:dineflow/features/menu/presentation/view/widgets/product_details_options.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _quantity = 1;
  bool _isFavorite = false;
  int _selectedPattySize = 0;
  int _selectedSpiceLevel = 0;

  double get _extraPrice => _selectedPattySize == 1 ? 2.50 : 0.00;

  double get _totalPrice => (widget.product.price + _extraPrice) * _quantity;

  @override
  void initState() {
    super.initState();
    if (widget.product.spiceLevel != null) {
      final level = widget.product.spiceLevel!.toLowerCase();
      if (level.contains('medium')) {
        _selectedSpiceLevel = 1;
      } else if (level.contains('hot') || level.contains('spicy')) {
        _selectedSpiceLevel = 2;
      }
    }
  }

  void _handleAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $_quantity x ${widget.product.name} to cart (\$${_totalPrice.toStringAsFixed(2)})',
        ),
        backgroundColor: AppColors.surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailsHero(
                  product: widget.product,
                  isFavorite: _isFavorite,
                  onFavoriteToggle: () =>
                      setState(() => _isFavorite = !_isFavorite),
                  onBackTap: () => Navigator.of(context).pop(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductDetailsHeader(product: widget.product),
                      const SizedBox(height: 20),
                      ProductDetailsOptions(
                        selectedPattySize: _selectedPattySize,
                        onPattySizeChanged: (val) =>
                            setState(() => _selectedPattySize = val),
                        selectedSpiceLevel: _selectedSpiceLevel,
                        onSpiceLevelChanged: (val) =>
                            setState(() => _selectedSpiceLevel = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProductDetailsBottomBar(
              quantity: _quantity,
              totalPrice: _totalPrice,
              onIncrement: () => setState(() => _quantity++),
              onDecrement: () {
                if (_quantity > 1) {
                  setState(() => _quantity--);
                }
              },
              onAddToCart: _handleAddToCart,
            ),
          ),
        ],
      ),
    );
  }
}
