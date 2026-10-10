// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiter_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WaiterState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaiterState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WaiterState()';
}


}

/// @nodoc
class $WaiterStateCopyWith<$Res>  {
$WaiterStateCopyWith(WaiterState _, $Res Function(WaiterState) __);
}


/// Adds pattern-matching-related methods to [WaiterState].
extension WaiterStatePatterns on WaiterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Error value)?  error,TResult Function( _RequestsLoaded value)?  requestsLoaded,TResult Function( _RequestUpdated value)?  requestUpdated,TResult Function( _OrdersLoaded value)?  ordersLoaded,TResult Function( _OrderLoaded value)?  orderLoaded,TResult Function( _OrderCreated value)?  orderCreated,TResult Function( _OrderStatusUpdated value)?  orderStatusUpdated,TResult Function( _TablesLoaded value)?  tablesLoaded,TResult Function( _TableLoaded value)?  tableLoaded,TResult Function( _TableUpdated value)?  tableUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that);case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that);case _OrderCreated() when orderCreated != null:
return orderCreated(_that);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that);case _TablesLoaded() when tablesLoaded != null:
return tablesLoaded(_that);case _TableLoaded() when tableLoaded != null:
return tableLoaded(_that);case _TableUpdated() when tableUpdated != null:
return tableUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Error value)  error,required TResult Function( _RequestsLoaded value)  requestsLoaded,required TResult Function( _RequestUpdated value)  requestUpdated,required TResult Function( _OrdersLoaded value)  ordersLoaded,required TResult Function( _OrderLoaded value)  orderLoaded,required TResult Function( _OrderCreated value)  orderCreated,required TResult Function( _OrderStatusUpdated value)  orderStatusUpdated,required TResult Function( _TablesLoaded value)  tablesLoaded,required TResult Function( _TableLoaded value)  tableLoaded,required TResult Function( _TableUpdated value)  tableUpdated,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Error():
return error(_that);case _RequestsLoaded():
return requestsLoaded(_that);case _RequestUpdated():
return requestUpdated(_that);case _OrdersLoaded():
return ordersLoaded(_that);case _OrderLoaded():
return orderLoaded(_that);case _OrderCreated():
return orderCreated(_that);case _OrderStatusUpdated():
return orderStatusUpdated(_that);case _TablesLoaded():
return tablesLoaded(_that);case _TableLoaded():
return tableLoaded(_that);case _TableUpdated():
return tableUpdated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Error value)?  error,TResult? Function( _RequestsLoaded value)?  requestsLoaded,TResult? Function( _RequestUpdated value)?  requestUpdated,TResult? Function( _OrdersLoaded value)?  ordersLoaded,TResult? Function( _OrderLoaded value)?  orderLoaded,TResult? Function( _OrderCreated value)?  orderCreated,TResult? Function( _OrderStatusUpdated value)?  orderStatusUpdated,TResult? Function( _TablesLoaded value)?  tablesLoaded,TResult? Function( _TableLoaded value)?  tableLoaded,TResult? Function( _TableUpdated value)?  tableUpdated,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that);case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that);case _OrderCreated() when orderCreated != null:
return orderCreated(_that);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that);case _TablesLoaded() when tablesLoaded != null:
return tablesLoaded(_that);case _TableLoaded() when tableLoaded != null:
return tableLoaded(_that);case _TableUpdated() when tableUpdated != null:
return tableUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( WaiterRequestsPageEntity requests)?  requestsLoaded,TResult Function( WaiterRequestEntity request)?  requestUpdated,TResult Function( OrdersPageEntity orders)?  ordersLoaded,TResult Function( OrderWaiterEntity order)?  orderLoaded,TResult Function( CreateOrderEntity order)?  orderCreated,TResult Function( OrderWaiterEntity order)?  orderStatusUpdated,TResult Function( TablesEntity tables)?  tablesLoaded,TResult Function( TableEntity table)?  tableLoaded,TResult Function( TableEntity table)?  tableUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that.requests);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that.request);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that.orders);case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that.order);case _OrderCreated() when orderCreated != null:
return orderCreated(_that.order);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that.order);case _TablesLoaded() when tablesLoaded != null:
return tablesLoaded(_that.tables);case _TableLoaded() when tableLoaded != null:
return tableLoaded(_that.table);case _TableUpdated() when tableUpdated != null:
return tableUpdated(_that.table);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( WaiterRequestsPageEntity requests)  requestsLoaded,required TResult Function( WaiterRequestEntity request)  requestUpdated,required TResult Function( OrdersPageEntity orders)  ordersLoaded,required TResult Function( OrderWaiterEntity order)  orderLoaded,required TResult Function( CreateOrderEntity order)  orderCreated,required TResult Function( OrderWaiterEntity order)  orderStatusUpdated,required TResult Function( TablesEntity tables)  tablesLoaded,required TResult Function( TableEntity table)  tableLoaded,required TResult Function( TableEntity table)  tableUpdated,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.message);case _RequestsLoaded():
return requestsLoaded(_that.requests);case _RequestUpdated():
return requestUpdated(_that.request);case _OrdersLoaded():
return ordersLoaded(_that.orders);case _OrderLoaded():
return orderLoaded(_that.order);case _OrderCreated():
return orderCreated(_that.order);case _OrderStatusUpdated():
return orderStatusUpdated(_that.order);case _TablesLoaded():
return tablesLoaded(_that.tables);case _TableLoaded():
return tableLoaded(_that.table);case _TableUpdated():
return tableUpdated(_that.table);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( WaiterRequestsPageEntity requests)?  requestsLoaded,TResult? Function( WaiterRequestEntity request)?  requestUpdated,TResult? Function( OrdersPageEntity orders)?  ordersLoaded,TResult? Function( OrderWaiterEntity order)?  orderLoaded,TResult? Function( CreateOrderEntity order)?  orderCreated,TResult? Function( OrderWaiterEntity order)?  orderStatusUpdated,TResult? Function( TablesEntity tables)?  tablesLoaded,TResult? Function( TableEntity table)?  tableLoaded,TResult? Function( TableEntity table)?  tableUpdated,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that.requests);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that.request);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that.orders);case _OrderLoaded() when orderLoaded != null:
return orderLoaded(_that.order);case _OrderCreated() when orderCreated != null:
return orderCreated(_that.order);case _OrderStatusUpdated() when orderStatusUpdated != null:
return orderStatusUpdated(_that.order);case _TablesLoaded() when tablesLoaded != null:
return tablesLoaded(_that.tables);case _TableLoaded() when tableLoaded != null:
return tableLoaded(_that.table);case _TableUpdated() when tableUpdated != null:
return tableUpdated(_that.table);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements WaiterState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WaiterState.initial()';
}


}




/// @nodoc


class _Loading implements WaiterState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WaiterState.loading()';
}


}




/// @nodoc


class _Error implements WaiterState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of WaiterState
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
  return 'WaiterState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
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

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RequestsLoaded implements WaiterState {
  const _RequestsLoaded(this.requests);
  

 final  WaiterRequestsPageEntity requests;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestsLoadedCopyWith<_RequestsLoaded> get copyWith => __$RequestsLoadedCopyWithImpl<_RequestsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestsLoaded&&(identical(other.requests, requests) || other.requests == requests));
}


@override
int get hashCode => Object.hash(runtimeType,requests);

@override
String toString() {
  return 'WaiterState.requestsLoaded(requests: $requests)';
}


}

/// @nodoc
abstract mixin class _$RequestsLoadedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
  factory _$RequestsLoadedCopyWith(_RequestsLoaded value, $Res Function(_RequestsLoaded) _then) = __$RequestsLoadedCopyWithImpl;
@useResult
$Res call({
 WaiterRequestsPageEntity requests
});




}
/// @nodoc
class __$RequestsLoadedCopyWithImpl<$Res>
    implements _$RequestsLoadedCopyWith<$Res> {
  __$RequestsLoadedCopyWithImpl(this._self, this._then);

  final _RequestsLoaded _self;
  final $Res Function(_RequestsLoaded) _then;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requests = null,}) {
  return _then(_RequestsLoaded(
null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as WaiterRequestsPageEntity,
  ));
}


}

/// @nodoc


class _RequestUpdated implements WaiterState {
  const _RequestUpdated(this.request);
  

 final  WaiterRequestEntity request;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestUpdatedCopyWith<_RequestUpdated> get copyWith => __$RequestUpdatedCopyWithImpl<_RequestUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestUpdated&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,request);

@override
String toString() {
  return 'WaiterState.requestUpdated(request: $request)';
}


}

/// @nodoc
abstract mixin class _$RequestUpdatedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
  factory _$RequestUpdatedCopyWith(_RequestUpdated value, $Res Function(_RequestUpdated) _then) = __$RequestUpdatedCopyWithImpl;
@useResult
$Res call({
 WaiterRequestEntity request
});




}
/// @nodoc
class __$RequestUpdatedCopyWithImpl<$Res>
    implements _$RequestUpdatedCopyWith<$Res> {
  __$RequestUpdatedCopyWithImpl(this._self, this._then);

  final _RequestUpdated _self;
  final $Res Function(_RequestUpdated) _then;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? request = null,}) {
  return _then(_RequestUpdated(
null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as WaiterRequestEntity,
  ));
}


}

/// @nodoc


class _OrdersLoaded implements WaiterState {
  const _OrdersLoaded(this.orders);
  

 final  OrdersPageEntity orders;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersLoadedCopyWith<_OrdersLoaded> get copyWith => __$OrdersLoadedCopyWithImpl<_OrdersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersLoaded&&(identical(other.orders, orders) || other.orders == orders));
}


@override
int get hashCode => Object.hash(runtimeType,orders);

@override
String toString() {
  return 'WaiterState.ordersLoaded(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$OrdersLoadedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
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

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_OrdersLoaded(
null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as OrdersPageEntity,
  ));
}


}

/// @nodoc


class _OrderLoaded implements WaiterState {
  const _OrderLoaded(this.order);
  

 final  OrderWaiterEntity order;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLoadedCopyWith<_OrderLoaded> get copyWith => __$OrderLoadedCopyWithImpl<_OrderLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLoaded&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'WaiterState.orderLoaded(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderLoadedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
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

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_OrderLoaded(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderWaiterEntity,
  ));
}


}

/// @nodoc


class _OrderCreated implements WaiterState {
  const _OrderCreated(this.order);
  

 final  CreateOrderEntity order;

/// Create a copy of WaiterState
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
  return 'WaiterState.orderCreated(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderCreatedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
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

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_OrderCreated(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as CreateOrderEntity,
  ));
}


}

/// @nodoc


class _OrderStatusUpdated implements WaiterState {
  const _OrderStatusUpdated(this.order);
  

 final  OrderWaiterEntity order;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusUpdatedCopyWith<_OrderStatusUpdated> get copyWith => __$OrderStatusUpdatedCopyWithImpl<_OrderStatusUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusUpdated&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'WaiterState.orderStatusUpdated(order: $order)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusUpdatedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
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

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_OrderStatusUpdated(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderWaiterEntity,
  ));
}


}

/// @nodoc


class _TablesLoaded implements WaiterState {
  const _TablesLoaded(this.tables);
  

 final  TablesEntity tables;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TablesLoadedCopyWith<_TablesLoaded> get copyWith => __$TablesLoadedCopyWithImpl<_TablesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TablesLoaded&&(identical(other.tables, tables) || other.tables == tables));
}


@override
int get hashCode => Object.hash(runtimeType,tables);

@override
String toString() {
  return 'WaiterState.tablesLoaded(tables: $tables)';
}


}

/// @nodoc
abstract mixin class _$TablesLoadedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
  factory _$TablesLoadedCopyWith(_TablesLoaded value, $Res Function(_TablesLoaded) _then) = __$TablesLoadedCopyWithImpl;
@useResult
$Res call({
 TablesEntity tables
});




}
/// @nodoc
class __$TablesLoadedCopyWithImpl<$Res>
    implements _$TablesLoadedCopyWith<$Res> {
  __$TablesLoadedCopyWithImpl(this._self, this._then);

  final _TablesLoaded _self;
  final $Res Function(_TablesLoaded) _then;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tables = null,}) {
  return _then(_TablesLoaded(
null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as TablesEntity,
  ));
}


}

/// @nodoc


class _TableLoaded implements WaiterState {
  const _TableLoaded(this.table);
  

 final  TableEntity table;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableLoadedCopyWith<_TableLoaded> get copyWith => __$TableLoadedCopyWithImpl<_TableLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableLoaded&&(identical(other.table, table) || other.table == table));
}


@override
int get hashCode => Object.hash(runtimeType,table);

@override
String toString() {
  return 'WaiterState.tableLoaded(table: $table)';
}


}

/// @nodoc
abstract mixin class _$TableLoadedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
  factory _$TableLoadedCopyWith(_TableLoaded value, $Res Function(_TableLoaded) _then) = __$TableLoadedCopyWithImpl;
@useResult
$Res call({
 TableEntity table
});




}
/// @nodoc
class __$TableLoadedCopyWithImpl<$Res>
    implements _$TableLoadedCopyWith<$Res> {
  __$TableLoadedCopyWithImpl(this._self, this._then);

  final _TableLoaded _self;
  final $Res Function(_TableLoaded) _then;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? table = null,}) {
  return _then(_TableLoaded(
null == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as TableEntity,
  ));
}


}

/// @nodoc


class _TableUpdated implements WaiterState {
  const _TableUpdated(this.table);
  

 final  TableEntity table;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableUpdatedCopyWith<_TableUpdated> get copyWith => __$TableUpdatedCopyWithImpl<_TableUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableUpdated&&(identical(other.table, table) || other.table == table));
}


@override
int get hashCode => Object.hash(runtimeType,table);

@override
String toString() {
  return 'WaiterState.tableUpdated(table: $table)';
}


}

/// @nodoc
abstract mixin class _$TableUpdatedCopyWith<$Res> implements $WaiterStateCopyWith<$Res> {
  factory _$TableUpdatedCopyWith(_TableUpdated value, $Res Function(_TableUpdated) _then) = __$TableUpdatedCopyWithImpl;
@useResult
$Res call({
 TableEntity table
});




}
/// @nodoc
class __$TableUpdatedCopyWithImpl<$Res>
    implements _$TableUpdatedCopyWith<$Res> {
  __$TableUpdatedCopyWithImpl(this._self, this._then);

  final _TableUpdated _self;
  final $Res Function(_TableUpdated) _then;

/// Create a copy of WaiterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? table = null,}) {
  return _then(_TableUpdated(
null == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as TableEntity,
  ));
}


}

// dart format on
