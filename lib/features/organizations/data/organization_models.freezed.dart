// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizationTenant {

 int get id; String get code; String get name;
/// Create a copy of OrganizationTenant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationTenantCopyWith<OrganizationTenant> get copyWith => _$OrganizationTenantCopyWithImpl<OrganizationTenant>(this as OrganizationTenant, _$identity);

  /// Serializes this OrganizationTenant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrganizationTenant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationTenant&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrganizationTenant;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as OrganizationTenant;
  return 'OrganizationTenant(id: ${_this.id}, code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $OrganizationTenantCopyWith<$Res>  {
  factory $OrganizationTenantCopyWith(OrganizationTenant value, $Res Function(OrganizationTenant) _then) = _$OrganizationTenantCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name
});




}
/// @nodoc
class _$OrganizationTenantCopyWithImpl<$Res>
    implements $OrganizationTenantCopyWith<$Res> {
  _$OrganizationTenantCopyWithImpl(this._self, this._then);

  final OrganizationTenant _self;
  final $Res Function(OrganizationTenant) _then;

/// Create a copy of OrganizationTenant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(OrganizationTenant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationTenant].
extension OrganizationTenantPatterns on OrganizationTenant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationTenant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationTenant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationTenant value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationTenant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationTenant value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationTenant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationTenant() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _OrganizationTenant():
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationTenant() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationTenant implements OrganizationTenant {
  const _OrganizationTenant({required this.id, required this.code, required this.name});
  factory _OrganizationTenant.fromJson(Map<String, dynamic> json) => _$OrganizationTenantFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;

/// Create a copy of OrganizationTenant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationTenantCopyWith<_OrganizationTenant> get copyWith => __$OrganizationTenantCopyWithImpl<_OrganizationTenant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationTenantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationTenant&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name);
}

@override
String toString() {
    return 'OrganizationTenant(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$OrganizationTenantCopyWith<$Res> implements $OrganizationTenantCopyWith<$Res> {
  factory _$OrganizationTenantCopyWith(_OrganizationTenant value, $Res Function(_OrganizationTenant) _then) = __$OrganizationTenantCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name
});




}
/// @nodoc
class __$OrganizationTenantCopyWithImpl<$Res>
    implements _$OrganizationTenantCopyWith<$Res> {
  __$OrganizationTenantCopyWithImpl(this._self, this._then);

  final _OrganizationTenant _self;
  final $Res Function(_OrganizationTenant) _then;

/// Create a copy of OrganizationTenant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_OrganizationTenant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OrganizationLevel {

 int get id; int get numero; String get code; String get name;@JsonKey(name: 'allows_recursive_nesting') bool get allowsRecursiveNesting;
/// Create a copy of OrganizationLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationLevelCopyWith<OrganizationLevel> get copyWith => _$OrganizationLevelCopyWithImpl<OrganizationLevel>(this as OrganizationLevel, _$identity);

  /// Serializes this OrganizationLevel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrganizationLevel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationLevel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numero, _this.numero) || other.numero == _this.numero)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.allowsRecursiveNesting, _this.allowsRecursiveNesting) || other.allowsRecursiveNesting == _this.allowsRecursiveNesting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrganizationLevel;
  return Object.hash(runtimeType,_this.id,_this.numero,_this.code,_this.name,_this.allowsRecursiveNesting);
}

@override
String toString() {
  final _this = this as OrganizationLevel;
  return 'OrganizationLevel(id: ${_this.id}, numero: ${_this.numero}, code: ${_this.code}, name: ${_this.name}, allowsRecursiveNesting: ${_this.allowsRecursiveNesting})';
}


}

/// @nodoc
abstract mixin class $OrganizationLevelCopyWith<$Res>  {
  factory $OrganizationLevelCopyWith(OrganizationLevel value, $Res Function(OrganizationLevel) _then) = _$OrganizationLevelCopyWithImpl;
@useResult
$Res call({
 int id, int numero, String code, String name,@JsonKey(name: 'allows_recursive_nesting') bool allowsRecursiveNesting
});




}
/// @nodoc
class _$OrganizationLevelCopyWithImpl<$Res>
    implements $OrganizationLevelCopyWith<$Res> {
  _$OrganizationLevelCopyWithImpl(this._self, this._then);

  final OrganizationLevel _self;
  final $Res Function(OrganizationLevel) _then;

/// Create a copy of OrganizationLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numero = null,Object? code = null,Object? name = null,Object? allowsRecursiveNesting = null,}) {
  return _then(OrganizationLevel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,allowsRecursiveNesting: null == allowsRecursiveNesting ? _self.allowsRecursiveNesting : allowsRecursiveNesting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationLevel].
extension OrganizationLevelPatterns on OrganizationLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationLevel value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationLevel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int numero,  String code,  String name, @JsonKey(name: 'allows_recursive_nesting')  bool allowsRecursiveNesting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationLevel() when $default != null:
return $default(_that.id,_that.numero,_that.code,_that.name,_that.allowsRecursiveNesting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int numero,  String code,  String name, @JsonKey(name: 'allows_recursive_nesting')  bool allowsRecursiveNesting)  $default,) {final _that = this;
switch (_that) {
case _OrganizationLevel():
return $default(_that.id,_that.numero,_that.code,_that.name,_that.allowsRecursiveNesting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int numero,  String code,  String name, @JsonKey(name: 'allows_recursive_nesting')  bool allowsRecursiveNesting)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationLevel() when $default != null:
return $default(_that.id,_that.numero,_that.code,_that.name,_that.allowsRecursiveNesting);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationLevel implements OrganizationLevel {
  const _OrganizationLevel({required this.id, required this.numero, required this.code, required this.name, @JsonKey(name: 'allows_recursive_nesting') required this.allowsRecursiveNesting});
  factory _OrganizationLevel.fromJson(Map<String, dynamic> json) => _$OrganizationLevelFromJson(json);

@override final  int id;
@override final  int numero;
@override final  String code;
@override final  String name;
@override@JsonKey(name: 'allows_recursive_nesting') final  bool allowsRecursiveNesting;

/// Create a copy of OrganizationLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationLevelCopyWith<_OrganizationLevel> get copyWith => __$OrganizationLevelCopyWithImpl<_OrganizationLevel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationLevelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationLevel&&(identical(other.id, id) || other.id == id)&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.allowsRecursiveNesting, allowsRecursiveNesting) || other.allowsRecursiveNesting == allowsRecursiveNesting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numero,code,name,allowsRecursiveNesting);
}

@override
String toString() {
    return 'OrganizationLevel(id: $id, numero: $numero, code: $code, name: $name, allowsRecursiveNesting: $allowsRecursiveNesting)';
}


}

/// @nodoc
abstract mixin class _$OrganizationLevelCopyWith<$Res> implements $OrganizationLevelCopyWith<$Res> {
  factory _$OrganizationLevelCopyWith(_OrganizationLevel value, $Res Function(_OrganizationLevel) _then) = __$OrganizationLevelCopyWithImpl;
@override @useResult
$Res call({
 int id, int numero, String code, String name,@JsonKey(name: 'allows_recursive_nesting') bool allowsRecursiveNesting
});




}
/// @nodoc
class __$OrganizationLevelCopyWithImpl<$Res>
    implements _$OrganizationLevelCopyWith<$Res> {
  __$OrganizationLevelCopyWithImpl(this._self, this._then);

  final _OrganizationLevel _self;
  final $Res Function(_OrganizationLevel) _then;

/// Create a copy of OrganizationLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numero = null,Object? code = null,Object? name = null,Object? allowsRecursiveNesting = null,}) {
  return _then(_OrganizationLevel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,allowsRecursiveNesting: null == allowsRecursiveNesting ? _self.allowsRecursiveNesting : allowsRecursiveNesting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$OrganizationNode {

 String get id; int get tenant; int get level; String? get parent; String get code; String get name;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of OrganizationNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationNodeCopyWith<OrganizationNode> get copyWith => _$OrganizationNodeCopyWithImpl<OrganizationNode>(this as OrganizationNode, _$identity);

  /// Serializes this OrganizationNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrganizationNode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationNode&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.tenant, _this.tenant) || other.tenant == _this.tenant)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.parent, _this.parent) || other.parent == _this.parent)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrganizationNode;
  return Object.hash(runtimeType,_this.id,_this.tenant,_this.level,_this.parent,_this.code,_this.name,_this.isActive);
}

@override
String toString() {
  final _this = this as OrganizationNode;
  return 'OrganizationNode(id: ${_this.id}, tenant: ${_this.tenant}, level: ${_this.level}, parent: ${_this.parent}, code: ${_this.code}, name: ${_this.name}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $OrganizationNodeCopyWith<$Res>  {
  factory $OrganizationNodeCopyWith(OrganizationNode value, $Res Function(OrganizationNode) _then) = _$OrganizationNodeCopyWithImpl;
@useResult
$Res call({
 String id, int tenant, int level, String? parent, String code, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$OrganizationNodeCopyWithImpl<$Res>
    implements $OrganizationNodeCopyWith<$Res> {
  _$OrganizationNodeCopyWithImpl(this._self, this._then);

  final OrganizationNode _self;
  final $Res Function(OrganizationNode) _then;

/// Create a copy of OrganizationNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenant = null,Object? level = null,Object? parent = freezed,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(OrganizationNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenant: null == tenant ? _self.tenant : tenant // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationNode].
extension OrganizationNodePatterns on OrganizationNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationNode value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationNode value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int tenant,  int level,  String? parent,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationNode() when $default != null:
return $default(_that.id,_that.tenant,_that.level,_that.parent,_that.code,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int tenant,  int level,  String? parent,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _OrganizationNode():
return $default(_that.id,_that.tenant,_that.level,_that.parent,_that.code,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int tenant,  int level,  String? parent,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationNode() when $default != null:
return $default(_that.id,_that.tenant,_that.level,_that.parent,_that.code,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationNode implements OrganizationNode {
  const _OrganizationNode({required this.id, required this.tenant, required this.level, this.parent, required this.code, required this.name, @JsonKey(name: 'is_active') required this.isActive});
  factory _OrganizationNode.fromJson(Map<String, dynamic> json) => _$OrganizationNodeFromJson(json);

@override final  String id;
@override final  int tenant;
@override final  int level;
@override final  String? parent;
@override final  String code;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of OrganizationNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationNodeCopyWith<_OrganizationNode> get copyWith => __$OrganizationNodeCopyWithImpl<_OrganizationNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationNode&&(identical(other.id, id) || other.id == id)&&(identical(other.tenant, tenant) || other.tenant == tenant)&&(identical(other.level, level) || other.level == level)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,tenant,level,parent,code,name,isActive);
}

@override
String toString() {
    return 'OrganizationNode(id: $id, tenant: $tenant, level: $level, parent: $parent, code: $code, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$OrganizationNodeCopyWith<$Res> implements $OrganizationNodeCopyWith<$Res> {
  factory _$OrganizationNodeCopyWith(_OrganizationNode value, $Res Function(_OrganizationNode) _then) = __$OrganizationNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, int tenant, int level, String? parent, String code, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$OrganizationNodeCopyWithImpl<$Res>
    implements _$OrganizationNodeCopyWith<$Res> {
  __$OrganizationNodeCopyWithImpl(this._self, this._then);

  final _OrganizationNode _self;
  final $Res Function(_OrganizationNode) _then;

/// Create a copy of OrganizationNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenant = null,Object? level = null,Object? parent = freezed,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(_OrganizationNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenant: null == tenant ? _self.tenant : tenant // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Company {

 String get id;@JsonKey(name: 'organization_node') String get organizationNode;@JsonKey(name: 'legal_name') String? get legalName; String? get rfc;@JsonKey(name: 'employer_registration') String? get employerRegistration;
/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyCopyWith<Company> get copyWith => _$CompanyCopyWithImpl<Company>(this as Company, _$identity);

  /// Serializes this Company to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Company;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Company&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.organizationNode, _this.organizationNode) || other.organizationNode == _this.organizationNode)&&(identical(other.legalName, _this.legalName) || other.legalName == _this.legalName)&&(identical(other.rfc, _this.rfc) || other.rfc == _this.rfc)&&(identical(other.employerRegistration, _this.employerRegistration) || other.employerRegistration == _this.employerRegistration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Company;
  return Object.hash(runtimeType,_this.id,_this.organizationNode,_this.legalName,_this.rfc,_this.employerRegistration);
}

@override
String toString() {
  final _this = this as Company;
  return 'Company(id: ${_this.id}, organizationNode: ${_this.organizationNode}, legalName: ${_this.legalName}, rfc: ${_this.rfc}, employerRegistration: ${_this.employerRegistration})';
}


}

/// @nodoc
abstract mixin class $CompanyCopyWith<$Res>  {
  factory $CompanyCopyWith(Company value, $Res Function(Company) _then) = _$CompanyCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'organization_node') String organizationNode,@JsonKey(name: 'legal_name') String? legalName, String? rfc,@JsonKey(name: 'employer_registration') String? employerRegistration
});




}
/// @nodoc
class _$CompanyCopyWithImpl<$Res>
    implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._self, this._then);

  final Company _self;
  final $Res Function(Company) _then;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationNode = null,Object? legalName = freezed,Object? rfc = freezed,Object? employerRegistration = freezed,}) {
  return _then(Company(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationNode: null == organizationNode ? _self.organizationNode : organizationNode // ignore: cast_nullable_to_non_nullable
as String,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,employerRegistration: freezed == employerRegistration ? _self.employerRegistration : employerRegistration // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Company].
extension CompanyPatterns on Company {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Company value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Company() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Company value)  $default,){
final _that = this;
switch (_that) {
case _Company():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Company value)?  $default,){
final _that = this;
switch (_that) {
case _Company() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'organization_node')  String organizationNode, @JsonKey(name: 'legal_name')  String? legalName,  String? rfc, @JsonKey(name: 'employer_registration')  String? employerRegistration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.id,_that.organizationNode,_that.legalName,_that.rfc,_that.employerRegistration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'organization_node')  String organizationNode, @JsonKey(name: 'legal_name')  String? legalName,  String? rfc, @JsonKey(name: 'employer_registration')  String? employerRegistration)  $default,) {final _that = this;
switch (_that) {
case _Company():
return $default(_that.id,_that.organizationNode,_that.legalName,_that.rfc,_that.employerRegistration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'organization_node')  String organizationNode, @JsonKey(name: 'legal_name')  String? legalName,  String? rfc, @JsonKey(name: 'employer_registration')  String? employerRegistration)?  $default,) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.id,_that.organizationNode,_that.legalName,_that.rfc,_that.employerRegistration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Company implements Company {
  const _Company({required this.id, @JsonKey(name: 'organization_node') required this.organizationNode, @JsonKey(name: 'legal_name') this.legalName, this.rfc, @JsonKey(name: 'employer_registration') this.employerRegistration});
  factory _Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

@override final  String id;
@override@JsonKey(name: 'organization_node') final  String organizationNode;
@override@JsonKey(name: 'legal_name') final  String? legalName;
@override final  String? rfc;
@override@JsonKey(name: 'employer_registration') final  String? employerRegistration;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyCopyWith<_Company> get copyWith => __$CompanyCopyWithImpl<_Company>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Company&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationNode, organizationNode) || other.organizationNode == organizationNode)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.employerRegistration, employerRegistration) || other.employerRegistration == employerRegistration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,organizationNode,legalName,rfc,employerRegistration);
}

@override
String toString() {
    return 'Company(id: $id, organizationNode: $organizationNode, legalName: $legalName, rfc: $rfc, employerRegistration: $employerRegistration)';
}


}

/// @nodoc
abstract mixin class _$CompanyCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$CompanyCopyWith(_Company value, $Res Function(_Company) _then) = __$CompanyCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'organization_node') String organizationNode,@JsonKey(name: 'legal_name') String? legalName, String? rfc,@JsonKey(name: 'employer_registration') String? employerRegistration
});




}
/// @nodoc
class __$CompanyCopyWithImpl<$Res>
    implements _$CompanyCopyWith<$Res> {
  __$CompanyCopyWithImpl(this._self, this._then);

  final _Company _self;
  final $Res Function(_Company) _then;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationNode = null,Object? legalName = freezed,Object? rfc = freezed,Object? employerRegistration = freezed,}) {
  return _then(_Company(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationNode: null == organizationNode ? _self.organizationNode : organizationNode // ignore: cast_nullable_to_non_nullable
as String,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,employerRegistration: freezed == employerRegistration ? _self.employerRegistration : employerRegistration // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
