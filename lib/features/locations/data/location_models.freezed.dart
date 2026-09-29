// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationRecord {

 String get id; String get code; String get name;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'employer_registration') String get employerRegistration; String? get ubicacion; String? get nave;
/// Create a copy of LocationRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationRecordCopyWith<LocationRecord> get copyWith => _$LocationRecordCopyWithImpl<LocationRecord>(this as LocationRecord, _$identity);

  /// Serializes this LocationRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocationRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.employerRegistration, _this.employerRegistration) || other.employerRegistration == _this.employerRegistration)&&(identical(other.ubicacion, _this.ubicacion) || other.ubicacion == _this.ubicacion)&&(identical(other.nave, _this.nave) || other.nave == _this.nave));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocationRecord;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.isActive,_this.employerRegistration,_this.ubicacion,_this.nave);
}

@override
String toString() {
  final _this = this as LocationRecord;
  return 'LocationRecord(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, isActive: ${_this.isActive}, employerRegistration: ${_this.employerRegistration}, ubicacion: ${_this.ubicacion}, nave: ${_this.nave})';
}


}

/// @nodoc
abstract mixin class $LocationRecordCopyWith<$Res>  {
  factory $LocationRecordCopyWith(LocationRecord value, $Res Function(LocationRecord) _then) = _$LocationRecordCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'employer_registration') String employerRegistration, String? ubicacion, String? nave
});




}
/// @nodoc
class _$LocationRecordCopyWithImpl<$Res>
    implements $LocationRecordCopyWith<$Res> {
  _$LocationRecordCopyWithImpl(this._self, this._then);

  final LocationRecord _self;
  final $Res Function(LocationRecord) _then;

/// Create a copy of LocationRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,Object? employerRegistration = null,Object? ubicacion = freezed,Object? nave = freezed,}) {
  return _then(LocationRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,employerRegistration: null == employerRegistration ? _self.employerRegistration : employerRegistration // ignore: cast_nullable_to_non_nullable
as String,ubicacion: freezed == ubicacion ? _self.ubicacion : ubicacion // ignore: cast_nullable_to_non_nullable
as String?,nave: freezed == nave ? _self.nave : nave // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationRecord].
extension LocationRecordPatterns on LocationRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationRecord value)  $default,){
final _that = this;
switch (_that) {
case _LocationRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationRecord value)?  $default,){
final _that = this;
switch (_that) {
case _LocationRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'employer_registration')  String employerRegistration,  String? ubicacion,  String? nave)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationRecord() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive,_that.employerRegistration,_that.ubicacion,_that.nave);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'employer_registration')  String employerRegistration,  String? ubicacion,  String? nave)  $default,) {final _that = this;
switch (_that) {
case _LocationRecord():
return $default(_that.id,_that.code,_that.name,_that.isActive,_that.employerRegistration,_that.ubicacion,_that.nave);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'employer_registration')  String employerRegistration,  String? ubicacion,  String? nave)?  $default,) {final _that = this;
switch (_that) {
case _LocationRecord() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive,_that.employerRegistration,_that.ubicacion,_that.nave);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationRecord extends LocationRecord {
  const _LocationRecord({required this.id, required this.code, this.name = '', @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'employer_registration') this.employerRegistration = '', this.ubicacion, this.nave}): super._();
  factory _LocationRecord.fromJson(Map<String, dynamic> json) => _$LocationRecordFromJson(json);

@override final  String id;
@override final  String code;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'employer_registration') final  String employerRegistration;
@override final  String? ubicacion;
@override final  String? nave;

/// Create a copy of LocationRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationRecordCopyWith<_LocationRecord> get copyWith => __$LocationRecordCopyWithImpl<_LocationRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.employerRegistration, employerRegistration) || other.employerRegistration == employerRegistration)&&(identical(other.ubicacion, ubicacion) || other.ubicacion == ubicacion)&&(identical(other.nave, nave) || other.nave == nave));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,isActive,employerRegistration,ubicacion,nave);
}

@override
String toString() {
    return 'LocationRecord(id: $id, code: $code, name: $name, isActive: $isActive, employerRegistration: $employerRegistration, ubicacion: $ubicacion, nave: $nave)';
}


}

/// @nodoc
abstract mixin class _$LocationRecordCopyWith<$Res> implements $LocationRecordCopyWith<$Res> {
  factory _$LocationRecordCopyWith(_LocationRecord value, $Res Function(_LocationRecord) _then) = __$LocationRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'employer_registration') String employerRegistration, String? ubicacion, String? nave
});




}
/// @nodoc
class __$LocationRecordCopyWithImpl<$Res>
    implements _$LocationRecordCopyWith<$Res> {
  __$LocationRecordCopyWithImpl(this._self, this._then);

  final _LocationRecord _self;
  final $Res Function(_LocationRecord) _then;

/// Create a copy of LocationRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,Object? employerRegistration = null,Object? ubicacion = freezed,Object? nave = freezed,}) {
  return _then(_LocationRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,employerRegistration: null == employerRegistration ? _self.employerRegistration : employerRegistration // ignore: cast_nullable_to_non_nullable
as String,ubicacion: freezed == ubicacion ? _self.ubicacion : ubicacion // ignore: cast_nullable_to_non_nullable
as String?,nave: freezed == nave ? _self.nave : nave // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
