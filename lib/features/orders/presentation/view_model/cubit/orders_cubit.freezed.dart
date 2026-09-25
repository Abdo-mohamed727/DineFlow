// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState()';
}


}

/// @nodoc
class $OrdersStateCopyWith<$Res>  {
$OrdersStateCopyWith(OrdersState _, $Res Function(OrdersState) __);
}


/// Adds pattern-matching-related methods to [OrdersState].
extension OrdersStatePatterns on OrdersState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Empty value)?  empty,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Empty() when empty != null:
return empty(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Empty value)  empty,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Empty():
return empty(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Empty value)?  empty,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Empty() when empty != null:
return empty(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<OrderEntity> allOrders,  List<OrderEntity> filteredOrders,  OrderStatus? selectedStatus)?  loaded,TResult Function( List<OrderEntity> allOrders,  OrderStatus? selectedStatus,  String message)?  empty,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.selectedStatus);case _Empty() when empty != null:
return empty(_that.allOrders,_that.selectedStatus,_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<OrderEntity> allOrders,  List<OrderEntity> filteredOrders,  OrderStatus? selectedStatus)  loaded,required TResult Function( List<OrderEntity> allOrders,  OrderStatus? selectedStatus,  String message)  empty,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.allOrders,_that.filteredOrders,_that.selectedStatus);case _Empty():
return empty(_that.allOrders,_that.selectedStatus,_that.message);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<OrderEntity> allOrders,  List<OrderEntity> filteredOrders,  OrderStatus? selectedStatus)?  loaded,TResult? Function( List<OrderEntity> allOrders,  OrderStatus? selectedStatus,  String message)?  empty,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.selectedStatus);case _Empty() when empty != null:
return empty(_that.allOrders,_that.selectedStatus,_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OrdersState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState.initial()';
}


}




/// @nodoc


class _Loading implements OrdersState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState.loading()';
}


}




/// @nodoc


class _Loaded implements OrdersState {
  const _Loaded({required final  List<OrderEntity> allOrders, required final  List<OrderEntity> filteredOrders, this.selectedStatus}): _allOrders = allOrders,_filteredOrders = filteredOrders;
  

 final  List<OrderEntity> _allOrders;
 List<OrderEntity> get allOrders {
  if (_allOrders is EqualUnmodifiableListView) return _allOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allOrders);
}

 final  List<OrderEntity> _filteredOrders;
 List<OrderEntity> get filteredOrders {
  if (_filteredOrders is EqualUnmodifiableListView) return _filteredOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredOrders);
}

 final  OrderStatus? selectedStatus;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._allOrders, _allOrders)&&const DeepCollectionEquality().equals(other._filteredOrders, _filteredOrders)&&(identical(other.selectedStatus, selectedStatus) || other.selectedStatus == selectedStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allOrders),const DeepCollectionEquality().hash(_filteredOrders),selectedStatus);

@override
String toString() {
  return 'OrdersState.loaded(allOrders: $allOrders, filteredOrders: $filteredOrders, selectedStatus: $selectedStatus)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<OrderEntity> allOrders, List<OrderEntity> filteredOrders, OrderStatus? selectedStatus
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allOrders = null,Object? filteredOrders = null,Object? selectedStatus = freezed,}) {
  return _then(_Loaded(
allOrders: null == allOrders ? _self._allOrders : allOrders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,filteredOrders: null == filteredOrders ? _self._filteredOrders : filteredOrders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,selectedStatus: freezed == selectedStatus ? _self.selectedStatus : selectedStatus // ignore: cast_nullable_to_non_nullable
as OrderStatus?,
  ));
}


}

/// @nodoc


class _Empty implements OrdersState {
  const _Empty({final  List<OrderEntity> allOrders = const [], this.selectedStatus, this.message = 'No orders found'}): _allOrders = allOrders;
  

 final  List<OrderEntity> _allOrders;
@JsonKey() List<OrderEntity> get allOrders {
  if (_allOrders is EqualUnmodifiableListView) return _allOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allOrders);
}

 final  OrderStatus? selectedStatus;
@JsonKey() final  String message;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmptyCopyWith<_Empty> get copyWith => __$EmptyCopyWithImpl<_Empty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty&&const DeepCollectionEquality().equals(other._allOrders, _allOrders)&&(identical(other.selectedStatus, selectedStatus) || other.selectedStatus == selectedStatus)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allOrders),selectedStatus,message);

@override
String toString() {
  return 'OrdersState.empty(allOrders: $allOrders, selectedStatus: $selectedStatus, message: $message)';
}


}

/// @nodoc
abstract mixin class _$EmptyCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$EmptyCopyWith(_Empty value, $Res Function(_Empty) _then) = __$EmptyCopyWithImpl;
@useResult
$Res call({
 List<OrderEntity> allOrders, OrderStatus? selectedStatus, String message
});




}
/// @nodoc
class __$EmptyCopyWithImpl<$Res>
    implements _$EmptyCopyWith<$Res> {
  __$EmptyCopyWithImpl(this._self, this._then);

  final _Empty _self;
  final $Res Function(_Empty) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allOrders = null,Object? selectedStatus = freezed,Object? message = null,}) {
  return _then(_Empty(
allOrders: null == allOrders ? _self._allOrders : allOrders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,selectedStatus: freezed == selectedStatus ? _self.selectedStatus : selectedStatus // ignore: cast_nullable_to_non_nullable
as OrderStatus?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements OrdersState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OrdersState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
