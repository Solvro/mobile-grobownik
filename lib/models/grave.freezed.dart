// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grave.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Grave {

 String get id; String get firstName; String get lastName; List<Subject> get subjects; String? get education; String? get biography; List<Achievement> get achievements; DateTime? get birthDate; DateTime? get deathDate; Location get location; List<String> get photoUrls;
/// Create a copy of Grave
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraveCopyWith<Grave> get copyWith => _$GraveCopyWithImpl<Grave>(this as Grave, _$identity);

  /// Serializes this Grave to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Grave&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&(identical(other.education, education) || other.education == education)&&(identical(other.biography, biography) || other.biography == biography)&&const DeepCollectionEquality().equals(other.achievements, achievements)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.deathDate, deathDate) || other.deathDate == deathDate)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,const DeepCollectionEquality().hash(subjects),education,biography,const DeepCollectionEquality().hash(achievements),birthDate,deathDate,location,const DeepCollectionEquality().hash(photoUrls));

@override
String toString() {
  return 'Grave(id: $id, firstName: $firstName, lastName: $lastName, subjects: $subjects, education: $education, biography: $biography, achievements: $achievements, birthDate: $birthDate, deathDate: $deathDate, location: $location, photoUrls: $photoUrls)';
}


}

/// @nodoc
abstract mixin class $GraveCopyWith<$Res>  {
  factory $GraveCopyWith(Grave value, $Res Function(Grave) _then) = _$GraveCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, String lastName, List<Subject> subjects, String? education, String? biography, List<Achievement> achievements, DateTime? birthDate, DateTime? deathDate, Location location, List<String> photoUrls
});


$LocationCopyWith<$Res> get location;

}
/// @nodoc
class _$GraveCopyWithImpl<$Res>
    implements $GraveCopyWith<$Res> {
  _$GraveCopyWithImpl(this._self, this._then);

  final Grave _self;
  final $Res Function(Grave) _then;

/// Create a copy of Grave
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? subjects = null,Object? education = freezed,Object? biography = freezed,Object? achievements = null,Object? birthDate = freezed,Object? deathDate = freezed,Object? location = null,Object? photoUrls = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<Subject>,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,biography: freezed == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as String?,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<Achievement>,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deathDate: freezed == deathDate ? _self.deathDate : deathDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Grave
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res> get location {
  
  return $LocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Grave].
extension GravePatterns on Grave {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Grave value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Grave() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Grave value)  $default,){
final _that = this;
switch (_that) {
case _Grave():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Grave value)?  $default,){
final _that = this;
switch (_that) {
case _Grave() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  List<Subject> subjects,  String? education,  String? biography,  List<Achievement> achievements,  DateTime? birthDate,  DateTime? deathDate,  Location location,  List<String> photoUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Grave() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.subjects,_that.education,_that.biography,_that.achievements,_that.birthDate,_that.deathDate,_that.location,_that.photoUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  List<Subject> subjects,  String? education,  String? biography,  List<Achievement> achievements,  DateTime? birthDate,  DateTime? deathDate,  Location location,  List<String> photoUrls)  $default,) {final _that = this;
switch (_that) {
case _Grave():
return $default(_that.id,_that.firstName,_that.lastName,_that.subjects,_that.education,_that.biography,_that.achievements,_that.birthDate,_that.deathDate,_that.location,_that.photoUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  String lastName,  List<Subject> subjects,  String? education,  String? biography,  List<Achievement> achievements,  DateTime? birthDate,  DateTime? deathDate,  Location location,  List<String> photoUrls)?  $default,) {final _that = this;
switch (_that) {
case _Grave() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.subjects,_that.education,_that.biography,_that.achievements,_that.birthDate,_that.deathDate,_that.location,_that.photoUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Grave implements Grave {
  const _Grave({required this.id, required this.firstName, required this.lastName, final  List<Subject> subjects = const [], this.education, this.biography, final  List<Achievement> achievements = const [], this.birthDate, this.deathDate, required this.location, final  List<String> photoUrls = const []}): _subjects = subjects,_achievements = achievements,_photoUrls = photoUrls;
  factory _Grave.fromJson(Map<String, dynamic> json) => _$GraveFromJson(json);

@override final  String id;
@override final  String firstName;
@override final  String lastName;
 final  List<Subject> _subjects;
@override@JsonKey() List<Subject> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

@override final  String? education;
@override final  String? biography;
 final  List<Achievement> _achievements;
@override@JsonKey() List<Achievement> get achievements {
  if (_achievements is EqualUnmodifiableListView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievements);
}

@override final  DateTime? birthDate;
@override final  DateTime? deathDate;
@override final  Location location;
 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}


/// Create a copy of Grave
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GraveCopyWith<_Grave> get copyWith => __$GraveCopyWithImpl<_Grave>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GraveToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Grave&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&(identical(other.education, education) || other.education == education)&&(identical(other.biography, biography) || other.biography == biography)&&const DeepCollectionEquality().equals(other._achievements, _achievements)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.deathDate, deathDate) || other.deathDate == deathDate)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,const DeepCollectionEquality().hash(_subjects),education,biography,const DeepCollectionEquality().hash(_achievements),birthDate,deathDate,location,const DeepCollectionEquality().hash(_photoUrls));

@override
String toString() {
  return 'Grave(id: $id, firstName: $firstName, lastName: $lastName, subjects: $subjects, education: $education, biography: $biography, achievements: $achievements, birthDate: $birthDate, deathDate: $deathDate, location: $location, photoUrls: $photoUrls)';
}


}

/// @nodoc
abstract mixin class _$GraveCopyWith<$Res> implements $GraveCopyWith<$Res> {
  factory _$GraveCopyWith(_Grave value, $Res Function(_Grave) _then) = __$GraveCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, String lastName, List<Subject> subjects, String? education, String? biography, List<Achievement> achievements, DateTime? birthDate, DateTime? deathDate, Location location, List<String> photoUrls
});


@override $LocationCopyWith<$Res> get location;

}
/// @nodoc
class __$GraveCopyWithImpl<$Res>
    implements _$GraveCopyWith<$Res> {
  __$GraveCopyWithImpl(this._self, this._then);

  final _Grave _self;
  final $Res Function(_Grave) _then;

/// Create a copy of Grave
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? subjects = null,Object? education = freezed,Object? biography = freezed,Object? achievements = null,Object? birthDate = freezed,Object? deathDate = freezed,Object? location = null,Object? photoUrls = null,}) {
  return _then(_Grave(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<Subject>,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,biography: freezed == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as String?,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<Achievement>,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deathDate: freezed == deathDate ? _self.deathDate : deathDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Grave
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res> get location {
  
  return $LocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
