// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TableState {

 TableStatus get status; TablesEntity get tables; List<RestaurantTableEntity> get availableTables; TableEntity? get selectedTable; String? get errorMessage; bool get updated;// one-shot flag, consume in BlocListener
 bool get closingSession; String get closingTableId; bool get sessionClosed;
/// Create a copy of TableState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableStateCopyWith<TableState> get copyWith => _$TableStateCopyWithImpl<TableState>(this as TableState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableState&&(identical(other.status, status) || other.status == status)&&(identical(other.tables, tables) || other.tables == tables)&&const DeepCollectionEquality().equals(other.availableTables, availableTables)&&(identical(other.selectedTable, selectedTable) || other.selectedTable == selectedTable)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.closingSession, closingSession) || other.closingSession == closingSession)&&(identical(other.closingTableId, closingTableId) || other.closingTableId == closingTableId)&&(identical(other.sessionClosed, sessionClosed) || other.sessionClosed == sessionClosed));
}


@override
int get hashCode => Object.hash(runtimeType,status,tables,const DeepCollectionEquality().hash(availableTables),selectedTable,errorMessage,updated,closingSession,closingTableId,sessionClosed);

@override
String toString() {
  return 'TableState(status: $status, tables: $tables, availableTables: $availableTables, selectedTable: $selectedTable, errorMessage: $errorMessage, updated: $updated, closingSession: $closingSession, closingTableId: $closingTableId, sessionClosed: $sessionClosed)';
}


}

/// @nodoc
abstract mixin class $TableStateCopyWith<$Res>  {
  factory $TableStateCopyWith(TableState value, $Res Function(TableState) _then) = _$TableStateCopyWithImpl;
@useResult
$Res call({
 TableStatus status, TablesEntity tables, List<RestaurantTableEntity> availableTables, TableEntity? selectedTable, String? errorMessage, bool updated, bool closingSession, String closingTableId, bool sessionClosed
});




}
/// @nodoc
class _$TableStateCopyWithImpl<$Res>
    implements $TableStateCopyWith<$Res> {
  _$TableStateCopyWithImpl(this._self, this._then);

  final TableState _self;
  final $Res Function(TableState) _then;

/// Create a copy of TableState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? tables = null,Object? availableTables = null,Object? selectedTable = freezed,Object? errorMessage = freezed,Object? updated = null,Object? closingSession = null,Object? closingTableId = null,Object? sessionClosed = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableStatus,tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as TablesEntity,availableTables: null == availableTables ? _self.availableTables : availableTables // ignore: cast_nullable_to_non_nullable
as List<RestaurantTableEntity>,selectedTable: freezed == selectedTable ? _self.selectedTable : selectedTable // ignore: cast_nullable_to_non_nullable
as TableEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,closingSession: null == closingSession ? _self.closingSession : closingSession // ignore: cast_nullable_to_non_nullable
as bool,closingTableId: null == closingTableId ? _self.closingTableId : closingTableId // ignore: cast_nullable_to_non_nullable
as String,sessionClosed: null == sessionClosed ? _self.sessionClosed : sessionClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TableState].
extension TableStatePatterns on TableState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableState value)  $default,){
final _that = this;
switch (_that) {
case _TableState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableState value)?  $default,){
final _that = this;
switch (_that) {
case _TableState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableStatus status,  TablesEntity tables,  List<RestaurantTableEntity> availableTables,  TableEntity? selectedTable,  String? errorMessage,  bool updated,  bool closingSession,  String closingTableId,  bool sessionClosed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableState() when $default != null:
return $default(_that.status,_that.tables,_that.availableTables,_that.selectedTable,_that.errorMessage,_that.updated,_that.closingSession,_that.closingTableId,_that.sessionClosed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableStatus status,  TablesEntity tables,  List<RestaurantTableEntity> availableTables,  TableEntity? selectedTable,  String? errorMessage,  bool updated,  bool closingSession,  String closingTableId,  bool sessionClosed)  $default,) {final _that = this;
switch (_that) {
case _TableState():
return $default(_that.status,_that.tables,_that.availableTables,_that.selectedTable,_that.errorMessage,_that.updated,_that.closingSession,_that.closingTableId,_that.sessionClosed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableStatus status,  TablesEntity tables,  List<RestaurantTableEntity> availableTables,  TableEntity? selectedTable,  String? errorMessage,  bool updated,  bool closingSession,  String closingTableId,  bool sessionClosed)?  $default,) {final _that = this;
switch (_that) {
case _TableState() when $default != null:
return $default(_that.status,_that.tables,_that.availableTables,_that.selectedTable,_that.errorMessage,_that.updated,_that.closingSession,_that.closingTableId,_that.sessionClosed);case _:
  return null;

}
}

}

/// @nodoc


class _TableState implements TableState {
  const _TableState({this.status = TableStatus.initial, this.tables = const TablesEntity(tables: []), final  List<RestaurantTableEntity> availableTables = const [], this.selectedTable, this.errorMessage, this.updated = false, this.closingSession = false, this.closingTableId = '', this.sessionClosed = false}): _availableTables = availableTables;
  

@override@JsonKey() final  TableStatus status;
@override@JsonKey() final  TablesEntity tables;
 final  List<RestaurantTableEntity> _availableTables;
@override@JsonKey() List<RestaurantTableEntity> get availableTables {
  if (_availableTables is EqualUnmodifiableListView) return _availableTables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableTables);
}

@override final  TableEntity? selectedTable;
@override final  String? errorMessage;
@override@JsonKey() final  bool updated;
// one-shot flag, consume in BlocListener
@override@JsonKey() final  bool closingSession;
@override@JsonKey() final  String closingTableId;
@override@JsonKey() final  bool sessionClosed;

/// Create a copy of TableState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableStateCopyWith<_TableState> get copyWith => __$TableStateCopyWithImpl<_TableState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableState&&(identical(other.status, status) || other.status == status)&&(identical(other.tables, tables) || other.tables == tables)&&const DeepCollectionEquality().equals(other._availableTables, _availableTables)&&(identical(other.selectedTable, selectedTable) || other.selectedTable == selectedTable)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.closingSession, closingSession) || other.closingSession == closingSession)&&(identical(other.closingTableId, closingTableId) || other.closingTableId == closingTableId)&&(identical(other.sessionClosed, sessionClosed) || other.sessionClosed == sessionClosed));
}


@override
int get hashCode => Object.hash(runtimeType,status,tables,const DeepCollectionEquality().hash(_availableTables),selectedTable,errorMessage,updated,closingSession,closingTableId,sessionClosed);

@override
String toString() {
  return 'TableState(status: $status, tables: $tables, availableTables: $availableTables, selectedTable: $selectedTable, errorMessage: $errorMessage, updated: $updated, closingSession: $closingSession, closingTableId: $closingTableId, sessionClosed: $sessionClosed)';
}


}

/// @nodoc
abstract mixin class _$TableStateCopyWith<$Res> implements $TableStateCopyWith<$Res> {
  factory _$TableStateCopyWith(_TableState value, $Res Function(_TableState) _then) = __$TableStateCopyWithImpl;
@override @useResult
$Res call({
 TableStatus status, TablesEntity tables, List<RestaurantTableEntity> availableTables, TableEntity? selectedTable, String? errorMessage, bool updated, bool closingSession, String closingTableId, bool sessionClosed
});




}
/// @nodoc
class __$TableStateCopyWithImpl<$Res>
    implements _$TableStateCopyWith<$Res> {
  __$TableStateCopyWithImpl(this._self, this._then);

  final _TableState _self;
  final $Res Function(_TableState) _then;

/// Create a copy of TableState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? tables = null,Object? availableTables = null,Object? selectedTable = freezed,Object? errorMessage = freezed,Object? updated = null,Object? closingSession = null,Object? closingTableId = null,Object? sessionClosed = null,}) {
  return _then(_TableState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableStatus,tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as TablesEntity,availableTables: null == availableTables ? _self._availableTables : availableTables // ignore: cast_nullable_to_non_nullable
as List<RestaurantTableEntity>,selectedTable: freezed == selectedTable ? _self.selectedTable : selectedTable // ignore: cast_nullable_to_non_nullable
as TableEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,closingSession: null == closingSession ? _self.closingSession : closingSession // ignore: cast_nullable_to_non_nullable
as bool,closingTableId: null == closingTableId ? _self.closingTableId : closingTableId // ignore: cast_nullable_to_non_nullable
as String,sessionClosed: null == sessionClosed ? _self.sessionClosed : sessionClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
