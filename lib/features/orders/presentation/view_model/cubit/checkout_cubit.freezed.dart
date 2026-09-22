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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CheckoutInitial value)?  initial,TResult Function( _CheckoutSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that);case _CheckoutSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CheckoutInitial value)  initial,required TResult Function( _CheckoutSuccess value)  success,}){
final _that = this;
switch (_that) {
case _CheckoutInitial():
return initial(_that);case _CheckoutSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CheckoutInitial value)?  initial,TResult? Function( _CheckoutSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that);case _CheckoutSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( OrderType? orderType,  String? selectedTableId,  List<RestaurantTableEntity> tables,  bool isLoadingTables,  bool isPlacingOrder,  String? errorMessage)?  initial,TResult Function( OrderEntity order)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that.orderType,_that.selectedTableId,_that.tables,_that.isLoadingTables,_that.isPlacingOrder,_that.errorMessage);case _CheckoutSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( OrderType? orderType,  String? selectedTableId,  List<RestaurantTableEntity> tables,  bool isLoadingTables,  bool isPlacingOrder,  String? errorMessage)  initial,required TResult Function( OrderEntity order)  success,}) {final _that = this;
switch (_that) {
case _CheckoutInitial():
return initial(_that.orderType,_that.selectedTableId,_that.tables,_that.isLoadingTables,_that.isPlacingOrder,_that.errorMessage);case _CheckoutSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( OrderType? orderType,  String? selectedTableId,  List<RestaurantTableEntity> tables,  bool isLoadingTables,  bool isPlacingOrder,  String? errorMessage)?  initial,TResult? Function( OrderEntity order)?  success,}) {final _that = this;
switch (_that) {
case _CheckoutInitial() when initial != null:
return initial(_that.orderType,_that.selectedTableId,_that.tables,_that.isLoadingTables,_that.isPlacingOrder,_that.errorMessage);case _CheckoutSuccess() when success != null:
return success(_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutInitial implements CheckoutState {
  const _CheckoutInitial({this.orderType, this.selectedTableId, final  List<RestaurantTableEntity> tables = const [], this.isLoadingTables = false, this.isPlacingOrder = false, this.errorMessage}): _tables = tables;
  

 final  OrderType? orderType;
 final  String? selectedTableId;
 final  List<RestaurantTableEntity> _tables;
@JsonKey() List<RestaurantTableEntity> get tables {
  if (_tables is EqualUnmodifiableListView) return _tables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tables);
}

@JsonKey() final  bool isLoadingTables;
@JsonKey() final  bool isPlacingOrder;
 final  String? errorMessage;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutInitialCopyWith<_CheckoutInitial> get copyWith => __$CheckoutInitialCopyWithImpl<_CheckoutInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutInitial&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.selectedTableId, selectedTableId) || other.selectedTableId == selectedTableId)&&const DeepCollectionEquality().equals(other._tables, _tables)&&(identical(other.isLoadingTables, isLoadingTables) || other.isLoadingTables == isLoadingTables)&&(identical(other.isPlacingOrder, isPlacingOrder) || other.isPlacingOrder == isPlacingOrder)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,orderType,selectedTableId,const DeepCollectionEquality().hash(_tables),isLoadingTables,isPlacingOrder,errorMessage);

@override
String toString() {
  return 'CheckoutState.initial(orderType: $orderType, selectedTableId: $selectedTableId, tables: $tables, isLoadingTables: $isLoadingTables, isPlacingOrder: $isPlacingOrder, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CheckoutInitialCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutInitialCopyWith(_CheckoutInitial value, $Res Function(_CheckoutInitial) _then) = __$CheckoutInitialCopyWithImpl;
@useResult
$Res call({
 OrderType? orderType, String? selectedTableId, List<RestaurantTableEntity> tables, bool isLoadingTables, bool isPlacingOrder, String? errorMessage
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
@pragma('vm:prefer-inline') $Res call({Object? orderType = freezed,Object? selectedTableId = freezed,Object? tables = null,Object? isLoadingTables = null,Object? isPlacingOrder = null,Object? errorMessage = freezed,}) {
  return _then(_CheckoutInitial(
orderType: freezed == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType?,selectedTableId: freezed == selectedTableId ? _self.selectedTableId : selectedTableId // ignore: cast_nullable_to_non_nullable
as String?,tables: null == tables ? _self._tables : tables // ignore: cast_nullable_to_non_nullable
as List<RestaurantTableEntity>,isLoadingTables: null == isLoadingTables ? _self.isLoadingTables : isLoadingTables // ignore: cast_nullable_to_non_nullable
as bool,isPlacingOrder: null == isPlacingOrder ? _self.isPlacingOrder : isPlacingOrder // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
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
