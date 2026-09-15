// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MenuState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MenuState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MenuState()';
  }
}

/// @nodoc
class $MenuStateCopyWith<$Res> {
  $MenuStateCopyWith(MenuState _, $Res Function(MenuState) __);
}

/// Adds pattern-matching-related methods to [MenuState].
extension MenuStatePatterns on MenuState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Empty value)? empty,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _Loaded() when loaded != null:
        return loaded(_that);
      case _Empty() when empty != null:
        return empty(_that);
      case _Error() when error != null:
        return error(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Loading():
        return loading(_that);
      case _Loaded():
        return loaded(_that);
      case _Empty():
        return empty(_that);
      case _Error():
        return error(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _Loaded() when loaded != null:
        return loaded(_that);
      case _Empty() when empty != null:
        return empty(_that);
      case _Error() when error != null:
        return error(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<CategoryEntity> categories,
      List<ProductEntity> products,
      String? selectedCategoryId,
      String searchQuery,
    )? loaded,
    TResult Function(
      List<CategoryEntity> categories,
      String? selectedCategoryId,
      String searchQuery,
      String message,
    )? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _Loaded() when loaded != null:
        return loaded(
          _that.categories,
          _that.products,
          _that.selectedCategoryId,
          _that.searchQuery,
        );
      case _Empty() when empty != null:
        return empty(
          _that.categories,
          _that.selectedCategoryId,
          _that.searchQuery,
          _that.message,
        );
      case _Error() when error != null:
        return error(_that.message);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<CategoryEntity> categories,
      List<ProductEntity> products,
      String? selectedCategoryId,
      String searchQuery,
    ) loaded,
    required TResult Function(
      List<CategoryEntity> categories,
      String? selectedCategoryId,
      String searchQuery,
      String message,
    ) empty,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Loading():
        return loading();
      case _Loaded():
        return loaded(
          _that.categories,
          _that.products,
          _that.selectedCategoryId,
          _that.searchQuery,
        );
      case _Empty():
        return empty(
          _that.categories,
          _that.selectedCategoryId,
          _that.searchQuery,
          _that.message,
        );
      case _Error():
        return error(_that.message);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<CategoryEntity> categories,
      List<ProductEntity> products,
      String? selectedCategoryId,
      String searchQuery,
    )? loaded,
    TResult? Function(
      List<CategoryEntity> categories,
      String? selectedCategoryId,
      String searchQuery,
      String message,
    )? empty,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _Loaded() when loaded != null:
        return loaded(
          _that.categories,
          _that.products,
          _that.selectedCategoryId,
          _that.searchQuery,
        );
      case _Empty() when empty != null:
        return empty(
          _that.categories,
          _that.selectedCategoryId,
          _that.searchQuery,
          _that.message,
        );
      case _Error() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _Initial implements MenuState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MenuState.initial()';
  }
}

/// @nodoc
class _Loading implements MenuState {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MenuState.loading()';
  }
}

/// @nodoc
class _Loaded implements MenuState {
  const _Loaded({
    required this.categories,
    required this.products,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final String? selectedCategoryId;
  final String searchQuery;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Loaded &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality().equals(other.products, products) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(categories),
        const DeepCollectionEquality().hash(products),
        selectedCategoryId,
        searchQuery,
      );

  @override
  String toString() {
    return 'MenuState.loaded(categories: $categories, products: $products, selectedCategoryId: $selectedCategoryId, searchQuery: $searchQuery)';
  }
}

/// @nodoc
class _Empty implements MenuState {
  const _Empty({
    required this.categories,
    this.selectedCategoryId,
    this.searchQuery = '',
    this.message = 'No products found',
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final String searchQuery;
  final String message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Empty &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(categories),
        selectedCategoryId,
        searchQuery,
        message,
      );

  @override
  String toString() {
    return 'MenuState.empty(categories: $categories, selectedCategoryId: $selectedCategoryId, searchQuery: $searchQuery, message: $message)';
  }
}

/// @nodoc
class _Error implements MenuState {
  const _Error(this.message);

  final String message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'MenuState.error(message: $message)';
  }
}

// dart format on
