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

 WaiterRequestStatus get waiterRequestStatus; String get waiterRequestMessage;
/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersStateCopyWith<OrdersState> get copyWith => _$OrdersStateCopyWithImpl<OrdersState>(this as OrdersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersState&&(identical(other.waiterRequestStatus, waiterRequestStatus) || other.waiterRequestStatus == waiterRequestStatus)&&(identical(other.waiterRequestMessage, waiterRequestMessage) || other.waiterRequestMessage == waiterRequestMessage));
}


@override
int get hashCode => Object.hash(runtimeType,waiterRequestStatus,waiterRequestMessage);

@override
String toString() {
  return 'OrdersState(waiterRequestStatus: $waiterRequestStatus, waiterRequestMessage: $waiterRequestMessage)';
}


}

/// @nodoc
abstract mixin class $OrdersStateCopyWith<$Res>  {
  factory $OrdersStateCopyWith(OrdersState value, $Res Function(OrdersState) _then) = _$OrdersStateCopyWithImpl;
@useResult
$Res call({
 WaiterRequestStatus waiterRequestStatus, String waiterRequestMessage
});




}
/// @nodoc
class _$OrdersStateCopyWithImpl<$Res>
    implements $OrdersStateCopyWith<$Res> {
  _$OrdersStateCopyWithImpl(this._self, this._then);

  final OrdersState _self;
  final $Res Function(OrdersState) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? waiterRequestStatus = null,Object? waiterRequestMessage = null,}) {
  return _then(_self.copyWith(
waiterRequestStatus: null == waiterRequestStatus ? _self.waiterRequestStatus : waiterRequestStatus // ignore: cast_nullable_to_non_nullable
as WaiterRequestStatus,waiterRequestMessage: null == waiterRequestMessage ? _self.waiterRequestMessage : waiterRequestMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  initial,TResult Function( WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  loading,TResult Function( List<OrderEntity> allOrders,  List<OrderEntity> filteredOrders,  OrderStatus? selectedStatus,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  loaded,TResult Function( List<OrderEntity> allOrders,  OrderStatus? selectedStatus,  String message,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  empty,TResult Function( String message,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.waiterRequestStatus,_that.waiterRequestMessage);case _Loading() when loading != null:
return loading(_that.waiterRequestStatus,_that.waiterRequestMessage);case _Loaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.selectedStatus,_that.waiterRequestStatus,_that.waiterRequestMessage);case _Empty() when empty != null:
return empty(_that.allOrders,_that.selectedStatus,_that.message,_that.waiterRequestStatus,_that.waiterRequestMessage);case _Error() when error != null:
return error(_that.message,_that.waiterRequestStatus,_that.waiterRequestMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)  initial,required TResult Function( WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)  loading,required TResult Function( List<OrderEntity> allOrders,  List<OrderEntity> filteredOrders,  OrderStatus? selectedStatus,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)  loaded,required TResult Function( List<OrderEntity> allOrders,  OrderStatus? selectedStatus,  String message,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)  empty,required TResult Function( String message,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.waiterRequestStatus,_that.waiterRequestMessage);case _Loading():
return loading(_that.waiterRequestStatus,_that.waiterRequestMessage);case _Loaded():
return loaded(_that.allOrders,_that.filteredOrders,_that.selectedStatus,_that.waiterRequestStatus,_that.waiterRequestMessage);case _Empty():
return empty(_that.allOrders,_that.selectedStatus,_that.message,_that.waiterRequestStatus,_that.waiterRequestMessage);case _Error():
return error(_that.message,_that.waiterRequestStatus,_that.waiterRequestMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  initial,TResult? Function( WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  loading,TResult? Function( List<OrderEntity> allOrders,  List<OrderEntity> filteredOrders,  OrderStatus? selectedStatus,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  loaded,TResult? Function( List<OrderEntity> allOrders,  OrderStatus? selectedStatus,  String message,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  empty,TResult? Function( String message,  WaiterRequestStatus waiterRequestStatus,  String waiterRequestMessage)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.waiterRequestStatus,_that.waiterRequestMessage);case _Loading() when loading != null:
return loading(_that.waiterRequestStatus,_that.waiterRequestMessage);case _Loaded() when loaded != null:
return loaded(_that.allOrders,_that.filteredOrders,_that.selectedStatus,_that.waiterRequestStatus,_that.waiterRequestMessage);case _Empty() when empty != null:
return empty(_that.allOrders,_that.selectedStatus,_that.message,_that.waiterRequestStatus,_that.waiterRequestMessage);case _Error() when error != null:
return error(_that.message,_that.waiterRequestStatus,_that.waiterRequestMessage);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OrdersState {
  const _Initial({this.waiterRequestStatus = WaiterRequestStatus.idle, this.waiterRequestMessage = ''});
  

@override@JsonKey() final  WaiterRequestStatus waiterRequestStatus;
@override@JsonKey() final  String waiterRequestMessage;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.waiterRequestStatus, waiterRequestStatus) || other.waiterRequestStatus == waiterRequestStatus)&&(identical(other.waiterRequestMessage, waiterRequestMessage) || other.waiterRequestMessage == waiterRequestMessage));
}


@override
int get hashCode => Object.hash(runtimeType,waiterRequestStatus,waiterRequestMessage);

@override
String toString() {
  return 'OrdersState.initial(waiterRequestStatus: $waiterRequestStatus, waiterRequestMessage: $waiterRequestMessage)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 WaiterRequestStatus waiterRequestStatus, String waiterRequestMessage
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? waiterRequestStatus = null,Object? waiterRequestMessage = null,}) {
  return _then(_Initial(
waiterRequestStatus: null == waiterRequestStatus ? _self.waiterRequestStatus : waiterRequestStatus // ignore: cast_nullable_to_non_nullable
as WaiterRequestStatus,waiterRequestMessage: null == waiterRequestMessage ? _self.waiterRequestMessage : waiterRequestMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loading implements OrdersState {
  const _Loading({this.waiterRequestStatus = WaiterRequestStatus.idle, this.waiterRequestMessage = ''});
  

@override@JsonKey() final  WaiterRequestStatus waiterRequestStatus;
@override@JsonKey() final  String waiterRequestMessage;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.waiterRequestStatus, waiterRequestStatus) || other.waiterRequestStatus == waiterRequestStatus)&&(identical(other.waiterRequestMessage, waiterRequestMessage) || other.waiterRequestMessage == waiterRequestMessage));
}


@override
int get hashCode => Object.hash(runtimeType,waiterRequestStatus,waiterRequestMessage);

@override
String toString() {
  return 'OrdersState.loading(waiterRequestStatus: $waiterRequestStatus, waiterRequestMessage: $waiterRequestMessage)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@override @useResult
$Res call({
 WaiterRequestStatus waiterRequestStatus, String waiterRequestMessage
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? waiterRequestStatus = null,Object? waiterRequestMessage = null,}) {
  return _then(_Loading(
waiterRequestStatus: null == waiterRequestStatus ? _self.waiterRequestStatus : waiterRequestStatus // ignore: cast_nullable_to_non_nullable
as WaiterRequestStatus,waiterRequestMessage: null == waiterRequestMessage ? _self.waiterRequestMessage : waiterRequestMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements OrdersState {
  const _Loaded({required final  List<OrderEntity> allOrders, required final  List<OrderEntity> filteredOrders, this.selectedStatus, this.waiterRequestStatus = WaiterRequestStatus.idle, this.waiterRequestMessage = ''}): _allOrders = allOrders,_filteredOrders = filteredOrders;
  

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
@override@JsonKey() final  WaiterRequestStatus waiterRequestStatus;
@override@JsonKey() final  String waiterRequestMessage;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._allOrders, _allOrders)&&const DeepCollectionEquality().equals(other._filteredOrders, _filteredOrders)&&(identical(other.selectedStatus, selectedStatus) || other.selectedStatus == selectedStatus)&&(identical(other.waiterRequestStatus, waiterRequestStatus) || other.waiterRequestStatus == waiterRequestStatus)&&(identical(other.waiterRequestMessage, waiterRequestMessage) || other.waiterRequestMessage == waiterRequestMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allOrders),const DeepCollectionEquality().hash(_filteredOrders),selectedStatus,waiterRequestStatus,waiterRequestMessage);

@override
String toString() {
  return 'OrdersState.loaded(allOrders: $allOrders, filteredOrders: $filteredOrders, selectedStatus: $selectedStatus, waiterRequestStatus: $waiterRequestStatus, waiterRequestMessage: $waiterRequestMessage)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@override @useResult
$Res call({
 List<OrderEntity> allOrders, List<OrderEntity> filteredOrders, OrderStatus? selectedStatus, WaiterRequestStatus waiterRequestStatus, String waiterRequestMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? allOrders = null,Object? filteredOrders = null,Object? selectedStatus = freezed,Object? waiterRequestStatus = null,Object? waiterRequestMessage = null,}) {
  return _then(_Loaded(
allOrders: null == allOrders ? _self._allOrders : allOrders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,filteredOrders: null == filteredOrders ? _self._filteredOrders : filteredOrders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,selectedStatus: freezed == selectedStatus ? _self.selectedStatus : selectedStatus // ignore: cast_nullable_to_non_nullable
as OrderStatus?,waiterRequestStatus: null == waiterRequestStatus ? _self.waiterRequestStatus : waiterRequestStatus // ignore: cast_nullable_to_non_nullable
as WaiterRequestStatus,waiterRequestMessage: null == waiterRequestMessage ? _self.waiterRequestMessage : waiterRequestMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Empty implements OrdersState {
  const _Empty({final  List<OrderEntity> allOrders = const [], this.selectedStatus, this.message = 'No orders found', this.waiterRequestStatus = WaiterRequestStatus.idle, this.waiterRequestMessage = ''}): _allOrders = allOrders;
  

 final  List<OrderEntity> _allOrders;
@JsonKey() List<OrderEntity> get allOrders {
  if (_allOrders is EqualUnmodifiableListView) return _allOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allOrders);
}

 final  OrderStatus? selectedStatus;
@JsonKey() final  String message;
@override@JsonKey() final  WaiterRequestStatus waiterRequestStatus;
@override@JsonKey() final  String waiterRequestMessage;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmptyCopyWith<_Empty> get copyWith => __$EmptyCopyWithImpl<_Empty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty&&const DeepCollectionEquality().equals(other._allOrders, _allOrders)&&(identical(other.selectedStatus, selectedStatus) || other.selectedStatus == selectedStatus)&&(identical(other.message, message) || other.message == message)&&(identical(other.waiterRequestStatus, waiterRequestStatus) || other.waiterRequestStatus == waiterRequestStatus)&&(identical(other.waiterRequestMessage, waiterRequestMessage) || other.waiterRequestMessage == waiterRequestMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allOrders),selectedStatus,message,waiterRequestStatus,waiterRequestMessage);

@override
String toString() {
  return 'OrdersState.empty(allOrders: $allOrders, selectedStatus: $selectedStatus, message: $message, waiterRequestStatus: $waiterRequestStatus, waiterRequestMessage: $waiterRequestMessage)';
}


}

/// @nodoc
abstract mixin class _$EmptyCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$EmptyCopyWith(_Empty value, $Res Function(_Empty) _then) = __$EmptyCopyWithImpl;
@override @useResult
$Res call({
 List<OrderEntity> allOrders, OrderStatus? selectedStatus, String message, WaiterRequestStatus waiterRequestStatus, String waiterRequestMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? allOrders = null,Object? selectedStatus = freezed,Object? message = null,Object? waiterRequestStatus = null,Object? waiterRequestMessage = null,}) {
  return _then(_Empty(
allOrders: null == allOrders ? _self._allOrders : allOrders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,selectedStatus: freezed == selectedStatus ? _self.selectedStatus : selectedStatus // ignore: cast_nullable_to_non_nullable
as OrderStatus?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,waiterRequestStatus: null == waiterRequestStatus ? _self.waiterRequestStatus : waiterRequestStatus // ignore: cast_nullable_to_non_nullable
as WaiterRequestStatus,waiterRequestMessage: null == waiterRequestMessage ? _self.waiterRequestMessage : waiterRequestMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements OrdersState {
  const _Error(this.message, {this.waiterRequestStatus = WaiterRequestStatus.idle, this.waiterRequestMessage = ''});
  

 final  String message;
@override@JsonKey() final  WaiterRequestStatus waiterRequestStatus;
@override@JsonKey() final  String waiterRequestMessage;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.waiterRequestStatus, waiterRequestStatus) || other.waiterRequestStatus == waiterRequestStatus)&&(identical(other.waiterRequestMessage, waiterRequestMessage) || other.waiterRequestMessage == waiterRequestMessage));
}


@override
int get hashCode => Object.hash(runtimeType,message,waiterRequestStatus,waiterRequestMessage);

@override
String toString() {
  return 'OrdersState.error(message: $message, waiterRequestStatus: $waiterRequestStatus, waiterRequestMessage: $waiterRequestMessage)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, WaiterRequestStatus waiterRequestStatus, String waiterRequestMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? waiterRequestStatus = null,Object? waiterRequestMessage = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,waiterRequestStatus: null == waiterRequestStatus ? _self.waiterRequestStatus : waiterRequestStatus // ignore: cast_nullable_to_non_nullable
as WaiterRequestStatus,waiterRequestMessage: null == waiterRequestMessage ? _self.waiterRequestMessage : waiterRequestMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
