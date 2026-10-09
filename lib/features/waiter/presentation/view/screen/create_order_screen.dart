import 'package:dineflow/features/menu/domain/usecase/get_categories_usecase.dart';
import 'package:dineflow/features/menu/domain/usecase/get_products_usecase.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/waiter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';

import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';

import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';

class CreateOrderScreen extends StatefulWidget {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  const CreateOrderScreen({
    super.key,
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<ProductEntity> _products = [];
  List<CategoryEntity> _categories = [];

  final Map<String, int> _quantities = {};

  String _orderType = 'takeaway';
  String? _selectedCategoryId;
  String _searchQuery = '';

  bool _isLoadingProducts = true;
  bool _isLoadingCategories = true;
  bool _isSubmitting = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sessionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _loadError = null;
    });

    final result = await widget.getProductsUseCase(const GetProductsParams());

    if (!mounted) return;

    switch (result) {
      case Success(data: final products):
        setState(() {
          _products = products;
          _isLoadingProducts = false;
        });
      case FailureResult(failure: final failure):
        setState(() {
          _loadError = failure.message;
          _isLoadingProducts = false;
        });
    }
  }

  Future<void> _loadCategories() async {
    final result = await widget.getCategoriesUseCase(const NoParams());

    if (!mounted) return;

    switch (result) {
      case Success(data: final categories):
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      case FailureResult():
        setState(() {
          _isLoadingCategories = false;
        });
    }
  }

  List<ProductEntity> get _filteredProducts {
    return _products.where((product) {
      if (!product.isAvailable) return false;

      final matchesCategory =
          _selectedCategoryId == null ||
          product.category.id == _selectedCategoryId;

      final query = _searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _totalQuantity {
    return _quantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get _subtotal {
    double total = 0;

    for (final product in _products) {
      total += (product.price * (_quantities[product.id] ?? 0));
    }

    return total;
  }

  void _changeQuantity(ProductEntity product, int change) {
    final current = _quantities[product.id] ?? 0;
    final next = current + change;

    setState(() {
      if (next <= 0) {
        _quantities.remove(product.id);
      } else {
        _quantities[product.id] = next;
      }
    });
  }

  Future<void> _submitOrder() async {
    if (_totalQuantity == 0) {
      _showMessage('Add at least one product to the order.');
      return;
    }

    if (_orderType == 'dineIn' && _sessionController.text.trim().isEmpty) {
      _showMessage('Enter the dining session ID.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final items = _quantities.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) =>
              OrderItemParams(productId: entry.key, quantity: entry.value),
        )
        .toList();

    final cubit = context.read<WaiterCubit>();

    if (_orderType == 'dineIn') {
      await cubit.createDineOrder(
        CreateDineOrderParams(
          diningSessionId: _sessionController.text.trim(),
          items: items,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    } else {
      await cubit.createTakeawayOrder(CreateTakeAwayOrderParams(items: items));
    }

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surfaceContainerHigh,
      ),
    );
  }

  Future<void> _showOrderCreatedDialog(String orderNumber) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.greenAccent,
          size: 56,
        ),
        title: const Text(
          'Order created successfully',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: Text(
          orderNumber.isEmpty
              ? 'The order has been created.'
              : 'Order $orderNumber has been created.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    setState(() {
      _quantities.clear();
      _notesController.clear();
      _sessionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WaiterCubit, WaiterState>(
      listener: (context, state) {
        state.maybeWhen(
          orderCreated: (order) {
            _showOrderCreatedDialog(order.orderNumber);
          },
          error: (message) {
            _showMessage(message);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoadingProducts
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryContainer,
                        ),
                      )
                    : _loadError != null
                    ? _buildError()
                    : _buildContent(),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Order',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Select products and quantities',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_totalQuantity items',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        _buildOrderTypeSelector(),
        if (_orderType == 'dineIn') ...[
          const SizedBox(height: 16),
          _buildSessionField(),
        ],
        const SizedBox(height: 22),
        _buildSearchField(),
        const SizedBox(height: 18),
        _buildCategories(),
        const SizedBox(height: 22),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${_filteredProducts.length} products',
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (_filteredProducts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 42,
                  color: AppColors.onSurfaceVariant,
                ),
                SizedBox(height: 12),
                Text(
                  'No available products found',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          )
        else
          ..._filteredProducts.map(_buildProductCard),
        if (_orderType == 'dineIn') ...[
          const SizedBox(height: 16),
          _buildNotesField(),
        ],
      ],
    );
  }

  Widget _buildOrderTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.outlineVariant, width: 0.6),
      ),
      child: Row(
        children: [
          _typeButton(
            label: 'Dine In',
            icon: Icons.table_restaurant_rounded,
            value: 'dineIn',
          ),
          _typeButton(
            label: 'Takeaway',
            icon: Icons.shopping_bag_outlined,
            value: 'takeaway',
          ),
        ],
      ),
    );
  }

  Widget _typeButton({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final selected = _orderType == value;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: () {
          setState(() {
            _orderType = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionField() {
    return _inputField(
      controller: _sessionController,
      label: 'Dining Session ID',
      hint: 'Enter the active dining session ID',
      icon: Icons.table_restaurant_outlined,
    );
  }

  Widget _buildSearchField() {
    return _inputField(
      controller: _searchController,
      label: 'Search products',
      hint: 'Search by product name...',
      icon: Icons.search_rounded,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.onSurface, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
            ),
            prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.outlineVariant,
                width: 0.6,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppColors.primaryContainer),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    if (_isLoadingCategories) {
      return const LinearProgressIndicator(
        color: AppColors.primaryContainer,
        backgroundColor: AppColors.surfaceContainer,
      );
    }

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _categoryChip('All', null),
          ..._categories.map(
            (category) => _categoryChip(category.name, category.id),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, String? id) {
    final selected = _selectedCategoryId == id;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: () {
          setState(() {
            _selectedCategoryId = id;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: selected
                  ? AppColors.primaryContainer
                  : AppColors.outlineVariant,
              width: 0.6,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    final quantity = _quantities[product.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quantity > 0
              ? AppColors.primaryContainer
              : AppColors.outlineVariant,
          width: quantity > 0 ? 1 : 0.6,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.primary,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  product.price.toString(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (quantity == 0)
            IconButton.filled(
              onPressed: () => _changeQuantity(product, 1),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
              ),
              icon: const Icon(Icons.add_rounded),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _quantityButton(
                  icon: Icons.remove_rounded,
                  onTap: () => _changeQuantity(product, -1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _quantityButton(
                  icon: Icons.add_rounded,
                  onTap: () => _changeQuantity(product, 1),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 17, color: AppColors.onSurface),
      ),
    );
  }

  Widget _buildNotesField() {
    return _inputField(
      controller: _notesController,
      label: 'Order notes (optional)',
      hint: 'Any special instructions...',
      icon: Icons.notes_rounded,
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              _loadError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.onSurface),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadProducts,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 18),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.6),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtotal.toStringAsFixed(2),
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitOrder,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimaryContainer,
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 19),
                label: Text(
                  _isSubmitting ? 'Creating...' : 'Create Order',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
