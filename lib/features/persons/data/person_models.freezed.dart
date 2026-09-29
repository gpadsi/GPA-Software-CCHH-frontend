// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonCatalogEntry {

 int get id; String get code; String get name;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of PersonCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonCatalogEntryCopyWith<PersonCatalogEntry> get copyWith => _$PersonCatalogEntryCopyWithImpl<PersonCatalogEntry>(this as PersonCatalogEntry, _$identity);

  /// Serializes this PersonCatalogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonCatalogEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonCatalogEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonCatalogEntry;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.isActive);
}

@override
String toString() {
  final _this = this as PersonCatalogEntry;
  return 'PersonCatalogEntry(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $PersonCatalogEntryCopyWith<$Res>  {
  factory $PersonCatalogEntryCopyWith(PersonCatalogEntry value, $Res Function(PersonCatalogEntry) _then) = _$PersonCatalogEntryCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$PersonCatalogEntryCopyWithImpl<$Res>
    implements $PersonCatalogEntryCopyWith<$Res> {
  _$PersonCatalogEntryCopyWithImpl(this._self, this._then);

  final PersonCatalogEntry _self;
  final $Res Function(PersonCatalogEntry) _then;

/// Create a copy of PersonCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(PersonCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonCatalogEntry].
extension PersonCatalogEntryPatterns on PersonCatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonCatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonCatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _PersonCatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonCatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PersonCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonCatalogEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _PersonCatalogEntry():
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _PersonCatalogEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonCatalogEntry implements PersonCatalogEntry {
  const _PersonCatalogEntry({required this.id, required this.code, required this.name, @JsonKey(name: 'is_active') required this.isActive});
  factory _PersonCatalogEntry.fromJson(Map<String, dynamic> json) => _$PersonCatalogEntryFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of PersonCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonCatalogEntryCopyWith<_PersonCatalogEntry> get copyWith => __$PersonCatalogEntryCopyWithImpl<_PersonCatalogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonCatalogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,isActive);
}

@override
String toString() {
    return 'PersonCatalogEntry(id: $id, code: $code, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$PersonCatalogEntryCopyWith<$Res> implements $PersonCatalogEntryCopyWith<$Res> {
  factory _$PersonCatalogEntryCopyWith(_PersonCatalogEntry value, $Res Function(_PersonCatalogEntry) _then) = __$PersonCatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$PersonCatalogEntryCopyWithImpl<$Res>
    implements _$PersonCatalogEntryCopyWith<$Res> {
  __$PersonCatalogEntryCopyWithImpl(this._self, this._then);

  final _PersonCatalogEntry _self;
  final $Res Function(_PersonCatalogEntry) _then;

/// Create a copy of PersonCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(_PersonCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Persona {

 String get id;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name_paternal') String get lastNamePaternal;@JsonKey(name: 'last_name_maternal') String get lastNameMaternal; String? get curp; String? get nss; String? get rfc;@JsonKey(name: 'birth_date') String? get birthDate;@JsonKey(name: 'birth_place_state') String get birthPlaceState; int? get gender;@JsonKey(name: 'marital_status') int? get maritalStatus;@JsonKey(name: 'education_level') int? get educationLevel;@JsonKey(name: 'has_children') bool get hasChildren;@JsonKey(name: 'personal_email') String get personalEmail; String get phone;@JsonKey(name: 'address_line') String get addressLine;@JsonKey(name: 'postal_code') String get postalCode; String get city; String get municipality; String get state;
/// Create a copy of Persona
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaCopyWith<Persona> get copyWith => _$PersonaCopyWithImpl<Persona>(this as Persona, _$identity);

  /// Serializes this Persona to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Persona;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Persona&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastNamePaternal, _this.lastNamePaternal) || other.lastNamePaternal == _this.lastNamePaternal)&&(identical(other.lastNameMaternal, _this.lastNameMaternal) || other.lastNameMaternal == _this.lastNameMaternal)&&(identical(other.curp, _this.curp) || other.curp == _this.curp)&&(identical(other.nss, _this.nss) || other.nss == _this.nss)&&(identical(other.rfc, _this.rfc) || other.rfc == _this.rfc)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.birthPlaceState, _this.birthPlaceState) || other.birthPlaceState == _this.birthPlaceState)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.maritalStatus, _this.maritalStatus) || other.maritalStatus == _this.maritalStatus)&&(identical(other.educationLevel, _this.educationLevel) || other.educationLevel == _this.educationLevel)&&(identical(other.hasChildren, _this.hasChildren) || other.hasChildren == _this.hasChildren)&&(identical(other.personalEmail, _this.personalEmail) || other.personalEmail == _this.personalEmail)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.addressLine, _this.addressLine) || other.addressLine == _this.addressLine)&&(identical(other.postalCode, _this.postalCode) || other.postalCode == _this.postalCode)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.municipality, _this.municipality) || other.municipality == _this.municipality)&&(identical(other.state, _this.state) || other.state == _this.state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Persona;
  return Object.hashAll([runtimeType,_this.id,_this.firstName,_this.lastNamePaternal,_this.lastNameMaternal,_this.curp,_this.nss,_this.rfc,_this.birthDate,_this.birthPlaceState,_this.gender,_this.maritalStatus,_this.educationLevel,_this.hasChildren,_this.personalEmail,_this.phone,_this.addressLine,_this.postalCode,_this.city,_this.municipality,_this.state]);
}

@override
String toString() {
  final _this = this as Persona;
  return 'Persona(id: ${_this.id}, firstName: ${_this.firstName}, lastNamePaternal: ${_this.lastNamePaternal}, lastNameMaternal: ${_this.lastNameMaternal}, curp: ${_this.curp}, nss: ${_this.nss}, rfc: ${_this.rfc}, birthDate: ${_this.birthDate}, birthPlaceState: ${_this.birthPlaceState}, gender: ${_this.gender}, maritalStatus: ${_this.maritalStatus}, educationLevel: ${_this.educationLevel}, hasChildren: ${_this.hasChildren}, personalEmail: ${_this.personalEmail}, phone: ${_this.phone}, addressLine: ${_this.addressLine}, postalCode: ${_this.postalCode}, city: ${_this.city}, municipality: ${_this.municipality}, state: ${_this.state})';
}


}

/// @nodoc
abstract mixin class $PersonaCopyWith<$Res>  {
  factory $PersonaCopyWith(Persona value, $Res Function(Persona) _then) = _$PersonaCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name_paternal') String lastNamePaternal,@JsonKey(name: 'last_name_maternal') String lastNameMaternal, String? curp, String? nss, String? rfc,@JsonKey(name: 'birth_date') String? birthDate,@JsonKey(name: 'birth_place_state') String birthPlaceState, int? gender,@JsonKey(name: 'marital_status') int? maritalStatus,@JsonKey(name: 'education_level') int? educationLevel,@JsonKey(name: 'has_children') bool hasChildren,@JsonKey(name: 'personal_email') String personalEmail, String phone,@JsonKey(name: 'address_line') String addressLine,@JsonKey(name: 'postal_code') String postalCode, String city, String municipality, String state
});




}
/// @nodoc
class _$PersonaCopyWithImpl<$Res>
    implements $PersonaCopyWith<$Res> {
  _$PersonaCopyWithImpl(this._self, this._then);

  final Persona _self;
  final $Res Function(Persona) _then;

/// Create a copy of Persona
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastNamePaternal = null,Object? lastNameMaternal = null,Object? curp = freezed,Object? nss = freezed,Object? rfc = freezed,Object? birthDate = freezed,Object? birthPlaceState = null,Object? gender = freezed,Object? maritalStatus = freezed,Object? educationLevel = freezed,Object? hasChildren = null,Object? personalEmail = null,Object? phone = null,Object? addressLine = null,Object? postalCode = null,Object? city = null,Object? municipality = null,Object? state = null,}) {
  return _then(Persona(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastNamePaternal: null == lastNamePaternal ? _self.lastNamePaternal : lastNamePaternal // ignore: cast_nullable_to_non_nullable
as String,lastNameMaternal: null == lastNameMaternal ? _self.lastNameMaternal : lastNameMaternal // ignore: cast_nullable_to_non_nullable
as String,curp: freezed == curp ? _self.curp : curp // ignore: cast_nullable_to_non_nullable
as String?,nss: freezed == nss ? _self.nss : nss // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,birthPlaceState: null == birthPlaceState ? _self.birthPlaceState : birthPlaceState // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as int?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as int?,hasChildren: null == hasChildren ? _self.hasChildren : hasChildren // ignore: cast_nullable_to_non_nullable
as bool,personalEmail: null == personalEmail ? _self.personalEmail : personalEmail // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,addressLine: null == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,municipality: null == municipality ? _self.municipality : municipality // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Persona].
extension PersonaPatterns on Persona {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Persona value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Persona() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Persona value)  $default,){
final _that = this;
switch (_that) {
case _Persona():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Persona value)?  $default,){
final _that = this;
switch (_that) {
case _Persona() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name_paternal')  String lastNamePaternal, @JsonKey(name: 'last_name_maternal')  String lastNameMaternal,  String? curp,  String? nss,  String? rfc, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'birth_place_state')  String birthPlaceState,  int? gender, @JsonKey(name: 'marital_status')  int? maritalStatus, @JsonKey(name: 'education_level')  int? educationLevel, @JsonKey(name: 'has_children')  bool hasChildren, @JsonKey(name: 'personal_email')  String personalEmail,  String phone, @JsonKey(name: 'address_line')  String addressLine, @JsonKey(name: 'postal_code')  String postalCode,  String city,  String municipality,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Persona() when $default != null:
return $default(_that.id,_that.firstName,_that.lastNamePaternal,_that.lastNameMaternal,_that.curp,_that.nss,_that.rfc,_that.birthDate,_that.birthPlaceState,_that.gender,_that.maritalStatus,_that.educationLevel,_that.hasChildren,_that.personalEmail,_that.phone,_that.addressLine,_that.postalCode,_that.city,_that.municipality,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name_paternal')  String lastNamePaternal, @JsonKey(name: 'last_name_maternal')  String lastNameMaternal,  String? curp,  String? nss,  String? rfc, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'birth_place_state')  String birthPlaceState,  int? gender, @JsonKey(name: 'marital_status')  int? maritalStatus, @JsonKey(name: 'education_level')  int? educationLevel, @JsonKey(name: 'has_children')  bool hasChildren, @JsonKey(name: 'personal_email')  String personalEmail,  String phone, @JsonKey(name: 'address_line')  String addressLine, @JsonKey(name: 'postal_code')  String postalCode,  String city,  String municipality,  String state)  $default,) {final _that = this;
switch (_that) {
case _Persona():
return $default(_that.id,_that.firstName,_that.lastNamePaternal,_that.lastNameMaternal,_that.curp,_that.nss,_that.rfc,_that.birthDate,_that.birthPlaceState,_that.gender,_that.maritalStatus,_that.educationLevel,_that.hasChildren,_that.personalEmail,_that.phone,_that.addressLine,_that.postalCode,_that.city,_that.municipality,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name_paternal')  String lastNamePaternal, @JsonKey(name: 'last_name_maternal')  String lastNameMaternal,  String? curp,  String? nss,  String? rfc, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'birth_place_state')  String birthPlaceState,  int? gender, @JsonKey(name: 'marital_status')  int? maritalStatus, @JsonKey(name: 'education_level')  int? educationLevel, @JsonKey(name: 'has_children')  bool hasChildren, @JsonKey(name: 'personal_email')  String personalEmail,  String phone, @JsonKey(name: 'address_line')  String addressLine, @JsonKey(name: 'postal_code')  String postalCode,  String city,  String municipality,  String state)?  $default,) {final _that = this;
switch (_that) {
case _Persona() when $default != null:
return $default(_that.id,_that.firstName,_that.lastNamePaternal,_that.lastNameMaternal,_that.curp,_that.nss,_that.rfc,_that.birthDate,_that.birthPlaceState,_that.gender,_that.maritalStatus,_that.educationLevel,_that.hasChildren,_that.personalEmail,_that.phone,_that.addressLine,_that.postalCode,_that.city,_that.municipality,_that.state);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Persona extends Persona {
  const _Persona({required this.id, @JsonKey(name: 'first_name') this.firstName = '', @JsonKey(name: 'last_name_paternal') this.lastNamePaternal = '', @JsonKey(name: 'last_name_maternal') this.lastNameMaternal = '', this.curp, this.nss, this.rfc, @JsonKey(name: 'birth_date') this.birthDate, @JsonKey(name: 'birth_place_state') this.birthPlaceState = '', this.gender, @JsonKey(name: 'marital_status') this.maritalStatus, @JsonKey(name: 'education_level') this.educationLevel, @JsonKey(name: 'has_children') this.hasChildren = false, @JsonKey(name: 'personal_email') this.personalEmail = '', this.phone = '', @JsonKey(name: 'address_line') this.addressLine = '', @JsonKey(name: 'postal_code') this.postalCode = '', this.city = '', this.municipality = '', this.state = ''}): super._();
  factory _Persona.fromJson(Map<String, dynamic> json) => _$PersonaFromJson(json);

@override final  String id;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name_paternal') final  String lastNamePaternal;
@override@JsonKey(name: 'last_name_maternal') final  String lastNameMaternal;
@override final  String? curp;
@override final  String? nss;
@override final  String? rfc;
@override@JsonKey(name: 'birth_date') final  String? birthDate;
@override@JsonKey(name: 'birth_place_state') final  String birthPlaceState;
@override final  int? gender;
@override@JsonKey(name: 'marital_status') final  int? maritalStatus;
@override@JsonKey(name: 'education_level') final  int? educationLevel;
@override@JsonKey(name: 'has_children') final  bool hasChildren;
@override@JsonKey(name: 'personal_email') final  String personalEmail;
@override@JsonKey() final  String phone;
@override@JsonKey(name: 'address_line') final  String addressLine;
@override@JsonKey(name: 'postal_code') final  String postalCode;
@override@JsonKey() final  String city;
@override@JsonKey() final  String municipality;
@override@JsonKey() final  String state;

/// Create a copy of Persona
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaCopyWith<_Persona> get copyWith => __$PersonaCopyWithImpl<_Persona>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Persona&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastNamePaternal, lastNamePaternal) || other.lastNamePaternal == lastNamePaternal)&&(identical(other.lastNameMaternal, lastNameMaternal) || other.lastNameMaternal == lastNameMaternal)&&(identical(other.curp, curp) || other.curp == curp)&&(identical(other.nss, nss) || other.nss == nss)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthPlaceState, birthPlaceState) || other.birthPlaceState == birthPlaceState)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.hasChildren, hasChildren) || other.hasChildren == hasChildren)&&(identical(other.personalEmail, personalEmail) || other.personalEmail == personalEmail)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.municipality, municipality) || other.municipality == municipality)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,firstName,lastNamePaternal,lastNameMaternal,curp,nss,rfc,birthDate,birthPlaceState,gender,maritalStatus,educationLevel,hasChildren,personalEmail,phone,addressLine,postalCode,city,municipality,state]);
}

@override
String toString() {
    return 'Persona(id: $id, firstName: $firstName, lastNamePaternal: $lastNamePaternal, lastNameMaternal: $lastNameMaternal, curp: $curp, nss: $nss, rfc: $rfc, birthDate: $birthDate, birthPlaceState: $birthPlaceState, gender: $gender, maritalStatus: $maritalStatus, educationLevel: $educationLevel, hasChildren: $hasChildren, personalEmail: $personalEmail, phone: $phone, addressLine: $addressLine, postalCode: $postalCode, city: $city, municipality: $municipality, state: $state)';
}


}

/// @nodoc
abstract mixin class _$PersonaCopyWith<$Res> implements $PersonaCopyWith<$Res> {
  factory _$PersonaCopyWith(_Persona value, $Res Function(_Persona) _then) = __$PersonaCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name_paternal') String lastNamePaternal,@JsonKey(name: 'last_name_maternal') String lastNameMaternal, String? curp, String? nss, String? rfc,@JsonKey(name: 'birth_date') String? birthDate,@JsonKey(name: 'birth_place_state') String birthPlaceState, int? gender,@JsonKey(name: 'marital_status') int? maritalStatus,@JsonKey(name: 'education_level') int? educationLevel,@JsonKey(name: 'has_children') bool hasChildren,@JsonKey(name: 'personal_email') String personalEmail, String phone,@JsonKey(name: 'address_line') String addressLine,@JsonKey(name: 'postal_code') String postalCode, String city, String municipality, String state
});




}
/// @nodoc
class __$PersonaCopyWithImpl<$Res>
    implements _$PersonaCopyWith<$Res> {
  __$PersonaCopyWithImpl(this._self, this._then);

  final _Persona _self;
  final $Res Function(_Persona) _then;

/// Create a copy of Persona
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastNamePaternal = null,Object? lastNameMaternal = null,Object? curp = freezed,Object? nss = freezed,Object? rfc = freezed,Object? birthDate = freezed,Object? birthPlaceState = null,Object? gender = freezed,Object? maritalStatus = freezed,Object? educationLevel = freezed,Object? hasChildren = null,Object? personalEmail = null,Object? phone = null,Object? addressLine = null,Object? postalCode = null,Object? city = null,Object? municipality = null,Object? state = null,}) {
  return _then(_Persona(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastNamePaternal: null == lastNamePaternal ? _self.lastNamePaternal : lastNamePaternal // ignore: cast_nullable_to_non_nullable
as String,lastNameMaternal: null == lastNameMaternal ? _self.lastNameMaternal : lastNameMaternal // ignore: cast_nullable_to_non_nullable
as String,curp: freezed == curp ? _self.curp : curp // ignore: cast_nullable_to_non_nullable
as String?,nss: freezed == nss ? _self.nss : nss // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,birthPlaceState: null == birthPlaceState ? _self.birthPlaceState : birthPlaceState // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as int?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as int?,hasChildren: null == hasChildren ? _self.hasChildren : hasChildren // ignore: cast_nullable_to_non_nullable
as bool,personalEmail: null == personalEmail ? _self.personalEmail : personalEmail // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,addressLine: null == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,municipality: null == municipality ? _self.municipality : municipality // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ContactoUrgencia {

 String get id; String get persona; String get name; String get relationship; String get phone;
/// Create a copy of ContactoUrgencia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactoUrgenciaCopyWith<ContactoUrgencia> get copyWith => _$ContactoUrgenciaCopyWithImpl<ContactoUrgencia>(this as ContactoUrgencia, _$identity);

  /// Serializes this ContactoUrgencia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContactoUrgencia;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactoUrgencia&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.persona, _this.persona) || other.persona == _this.persona)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.relationship, _this.relationship) || other.relationship == _this.relationship)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContactoUrgencia;
  return Object.hash(runtimeType,_this.id,_this.persona,_this.name,_this.relationship,_this.phone);
}

@override
String toString() {
  final _this = this as ContactoUrgencia;
  return 'ContactoUrgencia(id: ${_this.id}, persona: ${_this.persona}, name: ${_this.name}, relationship: ${_this.relationship}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $ContactoUrgenciaCopyWith<$Res>  {
  factory $ContactoUrgenciaCopyWith(ContactoUrgencia value, $Res Function(ContactoUrgencia) _then) = _$ContactoUrgenciaCopyWithImpl;
@useResult
$Res call({
 String id, String persona, String name, String relationship, String phone
});




}
/// @nodoc
class _$ContactoUrgenciaCopyWithImpl<$Res>
    implements $ContactoUrgenciaCopyWith<$Res> {
  _$ContactoUrgenciaCopyWithImpl(this._self, this._then);

  final ContactoUrgencia _self;
  final $Res Function(ContactoUrgencia) _then;

/// Create a copy of ContactoUrgencia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? persona = null,Object? name = null,Object? relationship = null,Object? phone = null,}) {
  return _then(ContactoUrgencia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactoUrgencia].
extension ContactoUrgenciaPatterns on ContactoUrgencia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactoUrgencia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactoUrgencia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactoUrgencia value)  $default,){
final _that = this;
switch (_that) {
case _ContactoUrgencia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactoUrgencia value)?  $default,){
final _that = this;
switch (_that) {
case _ContactoUrgencia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String persona,  String name,  String relationship,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactoUrgencia() when $default != null:
return $default(_that.id,_that.persona,_that.name,_that.relationship,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String persona,  String name,  String relationship,  String phone)  $default,) {final _that = this;
switch (_that) {
case _ContactoUrgencia():
return $default(_that.id,_that.persona,_that.name,_that.relationship,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String persona,  String name,  String relationship,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _ContactoUrgencia() when $default != null:
return $default(_that.id,_that.persona,_that.name,_that.relationship,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactoUrgencia implements ContactoUrgencia {
  const _ContactoUrgencia({required this.id, required this.persona, this.name = '', this.relationship = '', this.phone = ''});
  factory _ContactoUrgencia.fromJson(Map<String, dynamic> json) => _$ContactoUrgenciaFromJson(json);

@override final  String id;
@override final  String persona;
@override@JsonKey() final  String name;
@override@JsonKey() final  String relationship;
@override@JsonKey() final  String phone;

/// Create a copy of ContactoUrgencia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactoUrgenciaCopyWith<_ContactoUrgencia> get copyWith => __$ContactoUrgenciaCopyWithImpl<_ContactoUrgencia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactoUrgenciaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactoUrgencia&&(identical(other.id, id) || other.id == id)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.name, name) || other.name == name)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,persona,name,relationship,phone);
}

@override
String toString() {
    return 'ContactoUrgencia(id: $id, persona: $persona, name: $name, relationship: $relationship, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ContactoUrgenciaCopyWith<$Res> implements $ContactoUrgenciaCopyWith<$Res> {
  factory _$ContactoUrgenciaCopyWith(_ContactoUrgencia value, $Res Function(_ContactoUrgencia) _then) = __$ContactoUrgenciaCopyWithImpl;
@override @useResult
$Res call({
 String id, String persona, String name, String relationship, String phone
});




}
/// @nodoc
class __$ContactoUrgenciaCopyWithImpl<$Res>
    implements _$ContactoUrgenciaCopyWith<$Res> {
  __$ContactoUrgenciaCopyWithImpl(this._self, this._then);

  final _ContactoUrgencia _self;
  final $Res Function(_ContactoUrgencia) _then;

/// Create a copy of ContactoUrgencia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? persona = null,Object? name = null,Object? relationship = null,Object? phone = null,}) {
  return _then(_ContactoUrgencia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PerfilMedico {

 String get id; String get persona;@JsonKey(name: 'blood_type') int? get bloodType; String get allergies;
/// Create a copy of PerfilMedico
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerfilMedicoCopyWith<PerfilMedico> get copyWith => _$PerfilMedicoCopyWithImpl<PerfilMedico>(this as PerfilMedico, _$identity);

  /// Serializes this PerfilMedico to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PerfilMedico;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerfilMedico&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.persona, _this.persona) || other.persona == _this.persona)&&(identical(other.bloodType, _this.bloodType) || other.bloodType == _this.bloodType)&&(identical(other.allergies, _this.allergies) || other.allergies == _this.allergies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PerfilMedico;
  return Object.hash(runtimeType,_this.id,_this.persona,_this.bloodType,_this.allergies);
}

@override
String toString() {
  final _this = this as PerfilMedico;
  return 'PerfilMedico(id: ${_this.id}, persona: ${_this.persona}, bloodType: ${_this.bloodType}, allergies: ${_this.allergies})';
}


}

/// @nodoc
abstract mixin class $PerfilMedicoCopyWith<$Res>  {
  factory $PerfilMedicoCopyWith(PerfilMedico value, $Res Function(PerfilMedico) _then) = _$PerfilMedicoCopyWithImpl;
@useResult
$Res call({
 String id, String persona,@JsonKey(name: 'blood_type') int? bloodType, String allergies
});




}
/// @nodoc
class _$PerfilMedicoCopyWithImpl<$Res>
    implements $PerfilMedicoCopyWith<$Res> {
  _$PerfilMedicoCopyWithImpl(this._self, this._then);

  final PerfilMedico _self;
  final $Res Function(PerfilMedico) _then;

/// Create a copy of PerfilMedico
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? persona = null,Object? bloodType = freezed,Object? allergies = null,}) {
  return _then(PerfilMedico(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String,bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as int?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PerfilMedico].
extension PerfilMedicoPatterns on PerfilMedico {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerfilMedico value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerfilMedico() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerfilMedico value)  $default,){
final _that = this;
switch (_that) {
case _PerfilMedico():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerfilMedico value)?  $default,){
final _that = this;
switch (_that) {
case _PerfilMedico() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String persona, @JsonKey(name: 'blood_type')  int? bloodType,  String allergies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PerfilMedico() when $default != null:
return $default(_that.id,_that.persona,_that.bloodType,_that.allergies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String persona, @JsonKey(name: 'blood_type')  int? bloodType,  String allergies)  $default,) {final _that = this;
switch (_that) {
case _PerfilMedico():
return $default(_that.id,_that.persona,_that.bloodType,_that.allergies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String persona, @JsonKey(name: 'blood_type')  int? bloodType,  String allergies)?  $default,) {final _that = this;
switch (_that) {
case _PerfilMedico() when $default != null:
return $default(_that.id,_that.persona,_that.bloodType,_that.allergies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PerfilMedico implements PerfilMedico {
  const _PerfilMedico({required this.id, required this.persona, @JsonKey(name: 'blood_type') this.bloodType, this.allergies = ''});
  factory _PerfilMedico.fromJson(Map<String, dynamic> json) => _$PerfilMedicoFromJson(json);

@override final  String id;
@override final  String persona;
@override@JsonKey(name: 'blood_type') final  int? bloodType;
@override@JsonKey() final  String allergies;

/// Create a copy of PerfilMedico
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerfilMedicoCopyWith<_PerfilMedico> get copyWith => __$PerfilMedicoCopyWithImpl<_PerfilMedico>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerfilMedicoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerfilMedico&&(identical(other.id, id) || other.id == id)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.allergies, allergies) || other.allergies == allergies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,persona,bloodType,allergies);
}

@override
String toString() {
    return 'PerfilMedico(id: $id, persona: $persona, bloodType: $bloodType, allergies: $allergies)';
}


}

/// @nodoc
abstract mixin class _$PerfilMedicoCopyWith<$Res> implements $PerfilMedicoCopyWith<$Res> {
  factory _$PerfilMedicoCopyWith(_PerfilMedico value, $Res Function(_PerfilMedico) _then) = __$PerfilMedicoCopyWithImpl;
@override @useResult
$Res call({
 String id, String persona,@JsonKey(name: 'blood_type') int? bloodType, String allergies
});




}
/// @nodoc
class __$PerfilMedicoCopyWithImpl<$Res>
    implements _$PerfilMedicoCopyWith<$Res> {
  __$PerfilMedicoCopyWithImpl(this._self, this._then);

  final _PerfilMedico _self;
  final $Res Function(_PerfilMedico) _then;

/// Create a copy of PerfilMedico
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? persona = null,Object? bloodType = freezed,Object? allergies = null,}) {
  return _then(_PerfilMedico(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String,bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as int?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
