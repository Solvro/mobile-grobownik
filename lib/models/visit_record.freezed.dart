// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisitRecord {

 String get id; String get graveId; DateTime get visitDate;
/// Create a copy of VisitRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitRecordCopyWith<VisitRecord> get copyWith => _$VisitRecordCopyWithImpl<VisitRecord>(this as VisitRecord, _$identity);

  /// Serializes this VisitRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.graveId, graveId) || other.graveId == graveId)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,graveId,visitDate);

@override
String toString() {
  return 'VisitRecord(id: $id, graveId: $graveId, visitDate: $visitDate)';
}


}

/// @nodoc
abstract mixin class $VisitRecordCopyWith<$Res>  {
  factory $VisitRecordCopyWith(VisitRecord value, $Res Function(VisitRecord) _then) = _$VisitRecordCopyWithImpl;
@useResult
$Res call({
 String id, String graveId, DateTime visitDate
});




}
/// @nodoc
class _$VisitRecordCopyWithImpl<$Res>
    implements $VisitRecordCopyWith<$Res> {
  _$VisitRecordCopyWithImpl(this._self, this._then);

  final VisitRecord _self;
  final $Res Function(VisitRecord) _then;

/// Create a copy of VisitRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? graveId = null,Object? visitDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,graveId: null == graveId ? _self.graveId : graveId // ignore: cast_nullable_to_non_nullable
as String,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitRecord].
extension VisitRecordPatterns on VisitRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitRecord value)  $default,){
final _that = this;
switch (_that) {
case _VisitRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitRecord value)?  $default,){
final _that = this;
switch (_that) {
case _VisitRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String graveId,  DateTime visitDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitRecord() when $default != null:
return $default(_that.id,_that.graveId,_that.visitDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String graveId,  DateTime visitDate)  $default,) {final _that = this;
switch (_that) {
case _VisitRecord():
return $default(_that.id,_that.graveId,_that.visitDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String graveId,  DateTime visitDate)?  $default,) {final _that = this;
switch (_that) {
case _VisitRecord() when $default != null:
return $default(_that.id,_that.graveId,_that.visitDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisitRecord implements VisitRecord {
  const _VisitRecord({required this.id, required this.graveId, required this.visitDate});
  factory _VisitRecord.fromJson(Map<String, dynamic> json) => _$VisitRecordFromJson(json);

@override final  String id;
@override final  String graveId;
@override final  DateTime visitDate;

/// Create a copy of VisitRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitRecordCopyWith<_VisitRecord> get copyWith => __$VisitRecordCopyWithImpl<_VisitRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.graveId, graveId) || other.graveId == graveId)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,graveId,visitDate);

@override
String toString() {
  return 'VisitRecord(id: $id, graveId: $graveId, visitDate: $visitDate)';
}


}

/// @nodoc
abstract mixin class _$VisitRecordCopyWith<$Res> implements $VisitRecordCopyWith<$Res> {
  factory _$VisitRecordCopyWith(_VisitRecord value, $Res Function(_VisitRecord) _then) = __$VisitRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String graveId, DateTime visitDate
});




}
/// @nodoc
class __$VisitRecordCopyWithImpl<$Res>
    implements _$VisitRecordCopyWith<$Res> {
  __$VisitRecordCopyWithImpl(this._self, this._then);

  final _VisitRecord _self;
  final $Res Function(_VisitRecord) _then;

/// Create a copy of VisitRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? graveId = null,Object? visitDate = null,}) {
  return _then(_VisitRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,graveId: null == graveId ? _self.graveId : graveId // ignore: cast_nullable_to_non_nullable
as String,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
