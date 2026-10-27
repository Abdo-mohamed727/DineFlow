import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/domain/usecase/get_categories_usecase.dart';
import 'package:dineflow/features/menu/domain/usecase/get_products_usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/start_dining_usecase.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/order_cubit.dart';
import 'package:flutter/material.dart';

class CreateOrderController extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final StartDiningUseCase startDiningUseCase;
  final searchController = TextEditingController();
  final notesController = TextEditingController();
  final Map<String, int> quantities = {};

  RestaurantTableEntity? selectedTable;
  String? sessionId; // set after startDining succeeds
  bool isStartingSession = false;
  String? sessionError;

  List<ProductEntity> products = [];
  List<CategoryEntity> categories = [];
  String orderType = 'takeaway';
  String? selectedCategoryId;
  String searchQuery = '';
  bool isLoadingProducts = true;
  bool isLoadingCategories = true;
  bool isSubmitting = false;
  String? loadError;
  bool _disposed = false;

  CreateOrderController({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
    required this.startDiningUseCase,
  });

  Future<void> initialize() async {
    await Future.wait([loadProducts(), _loadCategories()]);
  }

  Future<void> loadProducts() async {
    isLoadingProducts = true;
    loadError = null;
    _notify();
    final result = await getProductsUseCase(const GetProductsParams());
    if (_disposed) return;
    switch (result) {
      case Success(data: final data):
        products = data;
        isLoadingProducts = false;
      case FailureResult(failure: final failure):
        loadError = failure.message;
        isLoadingProducts = false;
    }
    _notify();
  }

  Future<void> _loadCategories() async {
    final result = await getCategoriesUseCase(const NoParams());
    if (_disposed) return;
    switch (result) {
      case Success(data: final data):
        categories = data;
      case FailureResult():
    }
    isLoadingCategories = false;
    _notify();
  }

  List<ProductEntity> get filteredProducts => products.where((product) {
    if (!product.isAvailable) return false;
    final matchesCategory =
        selectedCategoryId == null || product.category.id == selectedCategoryId;
    final query = searchQuery.trim().toLowerCase();
    final matchesSearch =
        query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        product.description.toLowerCase().contains(query);
    return matchesCategory && matchesSearch;
  }).toList();

  int get totalQuantity =>
      quantities.values.fold(0, (sum, count) => sum + count);
  double get subtotal => products.fold(
    0,
    (total, product) => total + product.price * (quantities[product.id] ?? 0),
  );

  void setOrderType(String value) => _update(() {
    orderType = value;
    // Clear table + session when switching away from dine-in.
    if (value != 'dineIn') {
      selectedTable = null;
      sessionId = null;
      sessionError = null;
    }
  });

  /// Called when the waiter picks a table from the bottom sheet.
  /// Immediately starts a dining session for that table.
  Future<void> setSelectedTable(RestaurantTableEntity table) async {
    _update(() {
      selectedTable = table;
      sessionId = null;
      sessionError = null;
      isStartingSession = true;
    });
    final result = await startDiningUseCase(table.id);
    if (_disposed) return;
    switch (result) {
      case Success(data: final id):
        _update(() {
          sessionId = id;
          isStartingSession = false;
        });
      case FailureResult(failure: final failure):
        _update(() {
          sessionError = failure.message;
          isStartingSession = false;
          selectedTable = null; // reset so the user can try again
        });
    }
  }

  void setCategory(String? id) => _update(() => selectedCategoryId = id);

  void setSearchQuery(String value) => _update(() => searchQuery = value);

  void changeQuantity(ProductEntity product, int change) {
    final next = (quantities[product.id] ?? 0) + change;
    if (next <= 0) {
      quantities.remove(product.id);
    } else {
      quantities[product.id] = next;
    }
    _notify();
  }

  Future<String?> submitOrder(OrderCubit cubit) async {
    if (totalQuantity == 0) return 'Add at least one product to the order.';
    if (orderType == 'dineIn') {
      if (selectedTable == null) {
        return 'Please select a table for the dine-in order.';
      }
      if (isStartingSession) {
        return 'Please wait — starting dining session...';
      }
      if (sessionId == null) {
        return sessionError ?? 'Could not start dining session. Tap the table field to retry.';
      }
    }
    isSubmitting = true;
    _notify();
    final items = quantities.entries
        .map(
          (entry) =>
              OrderItemParams(productId: entry.key, quantity: entry.value),
        )
        .toList();
    try {
      if (orderType == 'dineIn') {
        final notes = notesController.text.trim();
        await cubit.createDineOrder(
          CreateDineOrderParams(
            diningSessionId: sessionId!,
            items: items,
            notes: notes.isEmpty ? null : notes,
          ),
        );
      } else {
        await cubit.createTakeawayOrder(
          CreateTakeAwayOrderParams(items: items),
        );
      }
      return null;
    } finally {
      isSubmitting = false;
      _notify();
    }
  }

  void resetAfterOrderCreated() {
    quantities.clear();
    notesController.clear();
    selectedTable = null;
    sessionId = null;
    sessionError = null;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _update(VoidCallback update) {
    update();
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    searchController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
