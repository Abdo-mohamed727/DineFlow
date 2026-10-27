// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState()';
}


}

/// @nodoc
class $CheckoutStateCopyWith<$Res>  {
$CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CheckoutInitial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Error value)?  error,TResult Function( _NavigateToOrder value)?  navigateToOrder,TResult Function( _CheckoutSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _NavigateToOrder() when navigateToOrder != null:
return navigateToOrder(_that);case _CheckoutSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CheckoutInitial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Error value)  error,required TResult Function( _NavigateToOrder value)  navigateToOrder,required TResult Function( _CheckoutSuccess value)  success,}){
final _that = this;
switch (_that) {
case _CheckoutInitial():
return initial(_that);case _Loading():
return loading(_that);case _Error():
return error(_that);case _NavigateToOrder():
return navigateToOrder(_that);case _CheckoutSuccess():
return success(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CheckoutInitial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Error value)?  error,TResult? Function( _NavigateToOrder value)?  navigateToOrder,TResult? Function( _CheckoutSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _NavigateToOrder() when navigateToOrder != null:
return navigateToOrder(_that);case _CheckoutSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CheckoutSelection selection)?  initial,TResult Function( CheckoutSelection selection)?  loading,TResult Function( CheckoutSelection selection,  String message)?  error,TResult Function( String? sessionId,  OrderType orderType,  String? tableId,  String? tableName)?  navigateToOrder,TResult Function( OrderEntity order)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that.selection);case _Loading() when loading != null:
return loading(_that.selection);case _Error() when error != null:
return error(_that.selection,_that.message);case _NavigateToOrder() when navigateToOrder != null:
return navigateToOrder(_that.sessionId,_that.orderType,_that.tableId,_that.tableName);case _CheckoutSuccess() when success != null:
return success(_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CheckoutSelection selection)  initial,required TResult Function( CheckoutSelection selection)  loading,required TResult Function( CheckoutSelection selection,  String message)  error,required TResult Function( String? sessionId,  OrderType orderType,  String? tableId,  String? tableName)  navigateToOrder,required TResult Function( OrderEntity order)  success,}) {final _that = this;
switch (_that) {
case _CheckoutInitial():
return initial(_that.selection);case _Loading():
return loading(_that.selection);case _Error():
return error(_that.selection,_that.message);case _NavigateToOrder():
return navigateToOrder(_that.sessionId,_that.orderType,_that.tableId,_that.tableName);case _CheckoutSuccess():
return success(_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CheckoutSelection selection)?  initial,TResult? Function( CheckoutSelection selection)?  loading,TResult? Function( CheckoutSelection selection,  String message)?  error,TResult? Function( String? sessionId,  OrderType orderType,  String? tableId,  String? tableName)?  navigateToOrder,TResult? Function( OrderEntity order)?  success,}) {final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that.selection);case _Loading() when loading != null:
return loading(_that.selection);case _Error() when error != null:
return error(_that.selection,_that.message);case _NavigateToOrder() when navigateToOrder != null:
return navigateToOrder(_that.sessionId,_that.orderType,_that.tableId,_that.tableName);case _CheckoutSuccess() when success != null:
return success(_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutInitial implements CheckoutState {
  const _CheckoutInitial({this.selection = const CheckoutSelection()});
  

@JsonKey() final  CheckoutSelection selection;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutInitialCopyWith<_CheckoutInitial> get copyWith => __$CheckoutInitialCopyWithImpl<_CheckoutInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutInitial&&(identical(other.selection, selection) || other.selection == selection));
}


@override
int get hashCode => Object.hash(runtimeType,selection);

@override
String toString() {
  return 'CheckoutState.initial(selection: $selection)';
}


}

/// @nodoc
abstract mixin class _$CheckoutInitialCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutInitialCopyWith(_CheckoutInitial value, $Res Function(_CheckoutInitial) _then) = __$CheckoutInitialCopyWithImpl;
@useResult
$Res call({
 CheckoutSelection selection
});




}
/// @nodoc
class __$CheckoutInitialCopyWithImpl<$Res>
    implements _$CheckoutInitialCopyWith<$Res> {
  __$CheckoutInitialCopyWithImpl(this._self, this._then);

  final _CheckoutInitial _self;
  final $Res Function(_CheckoutInitial) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selection = null,}) {
  return _then(_CheckoutInitial(
selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as CheckoutSelection,
  ));
}


}

/// @nodoc


class _Loading implements CheckoutState {
  const _Loading(this.selection);
  

 final  CheckoutSelection selection;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.selection, selection) || other.selection == selection));
}


@override
int get hashCode => Object.hash(runtimeType,selection);

@override
String toString() {
  return 'CheckoutState.loading(selection: $selection)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@useResult
$Res call({
 CheckoutSelection selection
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selection = null,}) {
  return _then(_Loading(
null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as CheckoutSelection,
  ));
}


}

/// @nodoc


class _Error implements CheckoutState {
  const _Error({required this.selection, required this.message});
  

 final  CheckoutSelection selection;
 final  String message;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.selection, selection) || other.selection == selection)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,selection,message);

@override
String toString() {
  return 'CheckoutState.error(selection: $selection, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 CheckoutSelection selection, String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selection = null,Object? message = null,}) {
  return _then(_Error(
selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as CheckoutSelection,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NavigateToOrder implements CheckoutState {
  const _NavigateToOrder({required this.sessionId, required this.orderType, this.tableId, this.tableName});
  

 final  String? sessionId;
 final  OrderType orderType;
 final  String? tableId;
 final  String? tableName;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigateToOrderCopyWith<_NavigateToOrder> get copyWith => __$NavigateToOrderCopyWithImpl<_NavigateToOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToOrder&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableName, tableName) || other.tableName == tableName));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,orderType,tableId,tableName);

@override
String toString() {
  return 'CheckoutState.navigateToOrder(sessionId: $sessionId, orderType: $orderType, tableId: $tableId, tableName: $tableName)';
}


}

/// @nodoc
abstract mixin class _$NavigateToOrderCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$NavigateToOrderCopyWith(_NavigateToOrder value, $Res Function(_NavigateToOrder) _then) = __$NavigateToOrderCopyWithImpl;
@useResult
$Res call({
 String? sessionId, OrderType orderType, String? tableId, String? tableName
});




}
/// @nodoc
class __$NavigateToOrderCopyWithImpl<$Res>
    implements _$NavigateToOrderCopyWith<$Res> {
  __$NavigateToOrderCopyWithImpl(this._self, this._then);

  final _NavigateToOrder _self;
  final $Res Function(_NavigateToOrder) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? orderType = null,Object? tableId = freezed,Object? tableName = freezed,}) {
  return _then(_NavigateToOrder(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CheckoutSuccess implements CheckoutState {
  const _CheckoutSuccess(this.order);
  

 final  OrderEntity order;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutSuccessCopyWith<_CheckoutSuccess> get copyWith => __$CheckoutSuccessCopyWithImpl<_CheckoutSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutSuccess&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'CheckoutState.success(order: $order)';
}


}

/// @nodoc
abstract mixin class _$CheckoutSuccessCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutSuccessCopyWith(_CheckoutSuccess value, $Res Function(_CheckoutSuccess) _then) = __$CheckoutSuccessCopyWithImpl;
@useResult
$Res call({
 OrderEntity order
});




}
/// @nodoc
class __$CheckoutSuccessCopyWithImpl<$Res>
    implements _$CheckoutSuccessCopyWith<$Res> {
  __$CheckoutSuccessCopyWithImpl(this._self, this._then);

  final _CheckoutSuccess _self;
  final $Res Function(_CheckoutSuccess) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_CheckoutSuccess(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OrderEntity,
  ));
}


}

// dart format on
