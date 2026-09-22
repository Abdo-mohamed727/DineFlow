import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:dineflow/features/cart/domain/usecase/add_to_cart_usecase.dart';
import 'package:dineflow/features/cart/domain/usecase/clear_cart_usecase.dart';
import 'package:dineflow/features/cart/domain/usecase/get_cart_usecase.dart';
import 'package:dineflow/features/cart/domain/usecase/remove_cart_item_usecase.dart';
import 'package:dineflow/features/cart/domain/usecase/update_cart_item_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'cart_state.dart';
part 'cart_cubit.freezed.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartCubit(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateCartItemUseCase,
    this._removeCartItemUseCase,
    this._clearCartUseCase,
  ) : super(const CartState.initial());

  String? lastActionError;

  Future<void> getCart({bool silent = false}) async {
    if (!silent) {
      emit(const CartState.loading());
    }

    final result = await _getCartUseCase(const NoParams());
    _emitCartResult(result, previous: state);
  }

  Future<bool> addItem(String productId, int quantity) async {
    if (quantity < 1) return false;

    final previous = state;
    previous.maybeWhen(
      loaded: (cart, updating, isAdding, actionError) {
        emit(
          CartState.loaded(
            cart: cart,
            updatingProductIds: updating,
            isAdding: true,
          ),
        );
      },
      orElse: () {},
    );

    final result = await _addToCartUseCase(
      AddToCartParams(productId: productId, quantity: quantity),
    );

    return _emitMutationResult(result, previous: previous);
  }

  Future<bool> updateQuantity(String productId, int quantity) async {
    if (quantity < 1) return false;

    final previous = state;
    final alreadyUpdating = previous.maybeWhen(
      loaded: (cart, updating, isAdding, actionError) =>
          updating.contains(productId),
      orElse: () => false,
    );
    if (alreadyUpdating) return false;

    previous.maybeWhen(
      loaded: (cart, updating, isAdding, actionError) {
        emit(
          CartState.loaded(
            cart: cart,
            updatingProductIds: {...updating, productId},
            isAdding: isAdding,
          ),
        );
      },
      orElse: () {},
    );

    final result = await _updateCartItemUseCase(
      UpdateCartItemParams(productId: productId, quantity: quantity),
    );

    return _emitMutationResult(result, previous: previous);
  }

  Future<bool> removeItem(String productId) async {
    final previous = state;
    previous.maybeWhen(
      loaded: (cart, updating, isAdding, actionError) {
        emit(
          CartState.loaded(
            cart: cart,
            updatingProductIds: {...updating, productId},
            isAdding: isAdding,
          ),
        );
      },
      orElse: () {},
    );

    final result = await _removeCartItemUseCase(
      RemoveCartItemParams(productId: productId),
    );

    return _emitMutationResult(result, previous: previous);
  }

  Future<bool> clearCart() async {
    final previous = state;
    final result = await _clearCartUseCase(const NoParams());
    return _emitMutationResult(result, previous: previous);
  }

  int get totalQuantity => state.maybeWhen(
        loaded: (cart, _, _, _) => cart.totalQuantity,
        orElse: () => 0,
      );

  void _emitCartResult(
    Result<CartEntity> result, {
    required CartState previous,
  }) {
    lastActionError = null;
    switch (result) {
      case Success(data: final cart):
        _emitFromCart(cart);
      case FailureResult(failure: final failure):
        lastActionError = failure.message;
        previous.maybeWhen(
          loaded: (cart, updating, isAdding, actionError) {
            emit(
              CartState.loaded(
                cart: cart,
                updatingProductIds: updating,
                isAdding: isAdding,
                actionError: failure.message,
              ),
            );
          },
          orElse: () => emit(CartState.error(failure.message)),
        );
    }
  }

  bool _emitMutationResult(
    Result<CartEntity> result, {
    required CartState previous,
  }) {
    lastActionError = null;
    switch (result) {
      case Success(data: final cart):
        _emitFromCart(cart);
        return true;
      case FailureResult(failure: final failure):
        lastActionError = failure.message;
        previous.maybeWhen(
          loaded: (cart, updating, isAdding, actionError) {
            emit(
              CartState.loaded(
                cart: cart,
                actionError: failure.message,
              ),
            );
          },
          empty: () => emit(const CartState.empty()),
          orElse: () => emit(CartState.error(failure.message)),
        );
        return false;
    }
  }

  void _emitFromCart(CartEntity cart) {
    if (cart.isEmpty) {
      emit(const CartState.empty());
    } else {
      emit(CartState.loaded(cart: cart));
    }
  }
}
