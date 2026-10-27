// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RequestState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState()';
}


}

/// @nodoc
class $RequestStateCopyWith<$Res>  {
$RequestStateCopyWith(RequestState _, $Res Function(RequestState) __);
}


/// Adds pattern-matching-related methods to [RequestState].
extension RequestStatePatterns on RequestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Error value)?  error,TResult Function( _RequestsLoaded value)?  requestsLoaded,TResult Function( _RequestUpdated value)?  requestUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Error value)  error,required TResult Function( _RequestsLoaded value)  requestsLoaded,required TResult Function( _RequestUpdated value)  requestUpdated,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Error():
return error(_that);case _RequestsLoaded():
return requestsLoaded(_that);case _RequestUpdated():
return requestUpdated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Error value)?  error,TResult? Function( _RequestsLoaded value)?  requestsLoaded,TResult? Function( _RequestUpdated value)?  requestUpdated,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String error)?  error,TResult Function( WaiterRequestsPageEntity data)?  requestsLoaded,TResult Function( WaiterRequestEntity data)?  requestUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.error);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that.data);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String error)  error,required TResult Function( WaiterRequestsPageEntity data)  requestsLoaded,required TResult Function( WaiterRequestEntity data)  requestUpdated,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.error);case _RequestsLoaded():
return requestsLoaded(_that.data);case _RequestUpdated():
return requestUpdated(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String error)?  error,TResult? Function( WaiterRequestsPageEntity data)?  requestsLoaded,TResult? Function( WaiterRequestEntity data)?  requestUpdated,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.error);case _RequestsLoaded() when requestsLoaded != null:
return requestsLoaded(_that.data);case _RequestUpdated() when requestUpdated != null:
return requestUpdated(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RequestState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState.initial()';
}


}




/// @nodoc


class _Loading implements RequestState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState.loading()';
}


}




/// @nodoc


class _Error implements RequestState {
  const _Error(this.error);
  

 final  String error;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RequestState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $RequestStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RequestsLoaded implements RequestState {
  const _RequestsLoaded(this.data);
  

 final  WaiterRequestsPageEntity data;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestsLoadedCopyWith<_RequestsLoaded> get copyWith => __$RequestsLoadedCopyWithImpl<_RequestsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestsLoaded&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'RequestState.requestsLoaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$RequestsLoadedCopyWith<$Res> implements $RequestStateCopyWith<$Res> {
  factory _$RequestsLoadedCopyWith(_RequestsLoaded value, $Res Function(_RequestsLoaded) _then) = __$RequestsLoadedCopyWithImpl;
@useResult
$Res call({
 WaiterRequestsPageEntity data
});




}
/// @nodoc
class __$RequestsLoadedCopyWithImpl<$Res>
    implements _$RequestsLoadedCopyWith<$Res> {
  __$RequestsLoadedCopyWithImpl(this._self, this._then);

  final _RequestsLoaded _self;
  final $Res Function(_RequestsLoaded) _then;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_RequestsLoaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WaiterRequestsPageEntity,
  ));
}


}

/// @nodoc


class _RequestUpdated implements RequestState {
  const _RequestUpdated(this.data);
  

 final  WaiterRequestEntity data;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestUpdatedCopyWith<_RequestUpdated> get copyWith => __$RequestUpdatedCopyWithImpl<_RequestUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestUpdated&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'RequestState.requestUpdated(data: $data)';
}


}

/// @nodoc
abstract mixin class _$RequestUpdatedCopyWith<$Res> implements $RequestStateCopyWith<$Res> {
  factory _$RequestUpdatedCopyWith(_RequestUpdated value, $Res Function(_RequestUpdated) _then) = __$RequestUpdatedCopyWithImpl;
@useResult
$Res call({
 WaiterRequestEntity data
});




}
/// @nodoc
class __$RequestUpdatedCopyWithImpl<$Res>
    implements _$RequestUpdatedCopyWith<$Res> {
  __$RequestUpdatedCopyWithImpl(this._self, this._then);

  final _RequestUpdated _self;
  final $Res Function(_RequestUpdated) _then;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_RequestUpdated(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WaiterRequestEntity,
  ));
}


}

// dart format on
