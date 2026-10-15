// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState()';
}


}

/// @nodoc
class $OrderStateCopyWith<$Res>  {
$OrderStateCopyWith(OrderState _, $Res Function(OrderState) __);
}


/// Adds pattern-matching-related methods to [OrderState].
extension OrderStatePatterns on OrderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _OrderLoaded value)?  orderLoaded,TResult Function( _OrdersLoaded value)?  ordersLoaded,TResult Function( _OrderStatusUpdated value)?  orderStatusUpdated,TResult Function( _OrderCreated value)?  orderCreated,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that);case _OrderCreated() when orderCreated != null:
return orderCreated(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _OrderLoaded value)  orderLoaded,required TResult Function( _OrdersLoaded value)  ordersLoaded,required TResult Function( _OrderStatusUpdated value)  orderStatusUpdated,required TResult Function( _OrderCreated value)  orderCreated,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _OrderLoaded():
return orderLoaded(_that);case _OrdersLoaded():
return ordersLoaded(_that);case _OrderStatusUpdated():
return orderStatusUpdated(_that);case _OrderCreated():
return orderCreated(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _OrderLoaded value)?  orderLoaded,TResult? Function( _OrdersLoaded value)?  ordersLoaded,TResult? Function( _OrderStatusUpdated value)?  orderStatusUpdated,TResult? Function( _OrderCreated value)?  orderCreated,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that);case _OrderCreated() when orderCreated != null:
return orderCreated(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( OrderWaiterEntity order)?  orderLoaded,TResult Function( OrdersPageEntity orders)?  ordersLoaded,TResult Function( OrderWaiterEntity order)?  orderStatusUpdated,TResult Function( CreateOrderEntity order)?  orderCreated,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that.order);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that.orders);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that.order);case _OrderCreated() when orderCreated != null:
return orderCreated(_that.order);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( OrderWaiterEntity order)  orderLoaded,required TResult Function( OrdersPageEntity orders)  ordersLoaded,required TResult Function( OrderWaiterEntity order)  orderStatusUpdated,required TResult Function( CreateOrderEntity order)  orderCreated,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _OrderLoaded():
return orderLoaded(_that.order);case _OrdersLoaded():
return ordersLoaded(_that.orders);case _OrderStatusUpdated():
return orderStatusUpdated(_that.order);case _OrderCreated():
return orderCreated(_that.order);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( OrderWaiterEntity order)?  orderLoaded,TResult? Function( OrdersPageEntity orders)?  ordersLoaded,TResult? Function( OrderWaiterEntity order)?  orderStatusUpdated,TResult? Function( CreateOrderEntity order)?  orderCreated,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that.order);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that.orders);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that.order);case _OrderCreated() when orderCreated != null:
return orderCreated(_that.order);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OrderState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.initial()';
}


}




/// @nodoc


class _Loading implements OrderState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.loading()';
}


}




/// @nodoc


class _OrderLoaded implements OrderState {
  const _OrderLoaded(this.order);
  

 final  OrderWaiterEntity order;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLoadedCopyWith<_OrderLoaded> get copyWith => __$OrderLoadedCopyWithImpl<_OrderLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLoaded&&const DeepCollectionEquality().equals(other.order, order));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(order));

@override
String toString() {
  return 'OrderState.orderLoaded(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$OrderLoadedCopyWith(_OrderLoaded value, $Res Function(_OrderLoaded) _then) = __$OrderLoadedCopyWithImpl;
@useResult
$Res call({
 OrderWaiterEntity order
});




}
/// @nodoc
class __$OrderLoadedCopyWithImpl<$Res>
    implements _$OrderLoadedCopyWith<$Res> {
  __$OrderLoadedCopyWithImpl(this._self, this._then);

  final _OrderLoaded _self;
  final $Res Function(_OrderLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = freezed,}) {
  return _then(_OrderLoaded(
freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderWaiterEntity,
  ));
}


}

/// @nodoc


class _OrdersLoaded implements OrderState {
  const _OrdersLoaded(this.orders);
  

 final  OrdersPageEntity orders;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersLoadedCopyWith<_OrdersLoaded> get copyWith => __$OrdersLoadedCopyWithImpl<_OrdersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersLoaded&&const DeepCollectionEquality().equals(other.orders, orders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(orders));

@override
String toString() {
  return 'OrderState.ordersLoaded(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$OrdersLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$OrdersLoadedCopyWith(_OrdersLoaded value, $Res Function(_OrdersLoaded) _then) = __$OrdersLoadedCopyWithImpl;
@useResult
$Res call({
 OrdersPageEntity orders
});




}
/// @nodoc
class __$OrdersLoadedCopyWithImpl<$Res>
    implements _$OrdersLoadedCopyWith<$Res> {
  __$OrdersLoadedCopyWithImpl(this._self, this._then);

  final _OrdersLoaded _self;
  final $Res Function(_OrdersLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = freezed,}) {
  return _then(_OrdersLoaded(
freezed == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as OrdersPageEntity,
  ));
}


}

/// @nodoc


class _OrderStatusUpdated implements OrderState {
  const _OrderStatusUpdated(this.order);
  

 final  OrderWaiterEntity order;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusUpdatedCopyWith<_OrderStatusUpdated> get copyWith => __$OrderStatusUpdatedCopyWithImpl<_OrderStatusUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusUpdated&&const DeepCollectionEquality().equals(other.order, order));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(order));

@override
String toString() {
  return 'OrderState.orderStatusUpdated(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusUpdatedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$OrderStatusUpdatedCopyWith(_OrderStatusUpdated value, $Res Function(_OrderStatusUpdated) _then) = __$OrderStatusUpdatedCopyWithImpl;
@useResult
$Res call({
 OrderWaiterEntity order
});




}
/// @nodoc
class __$OrderStatusUpdatedCopyWithImpl<$Res>
    implements _$OrderStatusUpdatedCopyWith<$Res> {
  __$OrderStatusUpdatedCopyWithImpl(this._self, this._then);

  final _OrderStatusUpdated _self;
  final $Res Function(_OrderStatusUpdated) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = freezed,}) {
  return _then(_OrderStatusUpdated(
freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderWaiterEntity,
  ));
}


}

/// @nodoc


class _OrderCreated implements OrderState {
  const _OrderCreated(this.order);
  

 final  CreateOrderEntity order;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCreatedCopyWith<_OrderCreated> get copyWith => __$OrderCreatedCopyWithImpl<_OrderCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderCreated&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'OrderState.orderCreated(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderCreatedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$OrderCreatedCopyWith(_OrderCreated value, $Res Function(_OrderCreated) _then) = __$OrderCreatedCopyWithImpl;
@useResult
$Res call({
 CreateOrderEntity order
});




}
/// @nodoc
class __$OrderCreatedCopyWithImpl<$Res>
    implements _$OrderCreatedCopyWith<$Res> {
  __$OrderCreatedCopyWithImpl(this._self, this._then);

  final _OrderCreated _self;
  final $Res Function(_OrderCreated) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_OrderCreated(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as CreateOrderEntity,
  ));
}


}

/// @nodoc


class _Error implements OrderState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of OrderState
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
  return 'OrderState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
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

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
