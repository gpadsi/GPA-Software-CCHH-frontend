// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jefe_inmediato.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JefeInmediato {

@JsonKey(name: 'posicion_id') String? get posicionId; String? get puesto;@JsonKey(name: 'empleado_id') String? get empleadoId; String? get nombre;
/// Create a copy of JefeInmediato
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JefeInmediatoCopyWith<JefeInmediato> get copyWith => _$JefeInmediatoCopyWithImpl<JefeInmediato>(this as JefeInmediato, _$identity);

  /// Serializes this JefeInmediato to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JefeInmediato;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JefeInmediato&&(identical(other.posicionId, _this.posicionId) || other.posicionId == _this.posicionId)&&(identical(other.puesto, _this.puesto) || other.puesto == _this.puesto)&&(identical(other.empleadoId, _this.empleadoId) || other.empleadoId == _this.empleadoId)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JefeInmediato;
  return Object.hash(runtimeType,_this.posicionId,_this.puesto,_this.empleadoId,_this.nombre);
}

@override
String toString() {
  final _this = this as JefeInmediato;
  return 'JefeInmediato(posicionId: ${_this.posicionId}, puesto: ${_this.puesto}, empleadoId: ${_this.empleadoId}, nombre: ${_this.nombre})';
}


}

/// @nodoc
abstract mixin class $JefeInmediatoCopyWith<$Res>  {
  factory $JefeInmediatoCopyWith(JefeInmediato value, $Res Function(JefeInmediato) _then) = _$JefeInmediatoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'posicion_id') String? posicionId, String? puesto,@JsonKey(name: 'empleado_id') String? empleadoId, String? nombre
});




}
/// @nodoc
class _$JefeInmediatoCopyWithImpl<$Res>
    implements $JefeInmediatoCopyWith<$Res> {
  _$JefeInmediatoCopyWithImpl(this._self, this._then);

  final JefeInmediato _self;
  final $Res Function(JefeInmediato) _then;

/// Create a copy of JefeInmediato
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posicionId = freezed,Object? puesto = freezed,Object? empleadoId = freezed,Object? nombre = freezed,}) {
  return _then(JefeInmediato(
posicionId: freezed == posicionId ? _self.posicionId : posicionId // ignore: cast_nullable_to_non_nullable
as String?,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as String?,empleadoId: freezed == empleadoId ? _self.empleadoId : empleadoId // ignore: cast_nullable_to_non_nullable
as String?,nombre: freezed == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JefeInmediato].
extension JefeInmediatoPatterns on JefeInmediato {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JefeInmediato value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JefeInmediato() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JefeInmediato value)  $default,){
final _that = this;
switch (_that) {
case _JefeInmediato():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JefeInmediato value)?  $default,){
final _that = this;
switch (_that) {
case _JefeInmediato() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'posicion_id')  String? posicionId,  String? puesto, @JsonKey(name: 'empleado_id')  String? empleadoId,  String? nombre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JefeInmediato() when $default != null:
return $default(_that.posicionId,_that.puesto,_that.empleadoId,_that.nombre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'posicion_id')  String? posicionId,  String? puesto, @JsonKey(name: 'empleado_id')  String? empleadoId,  String? nombre)  $default,) {final _that = this;
switch (_that) {
case _JefeInmediato():
return $default(_that.posicionId,_that.puesto,_that.empleadoId,_that.nombre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'posicion_id')  String? posicionId,  String? puesto, @JsonKey(name: 'empleado_id')  String? empleadoId,  String? nombre)?  $default,) {final _that = this;
switch (_that) {
case _JefeInmediato() when $default != null:
return $default(_that.posicionId,_that.puesto,_that.empleadoId,_that.nombre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JefeInmediato implements JefeInmediato {
  const _JefeInmediato({@JsonKey(name: 'posicion_id') this.posicionId, this.puesto, @JsonKey(name: 'empleado_id') this.empleadoId, this.nombre});
  factory _JefeInmediato.fromJson(Map<String, dynamic> json) => _$JefeInmediatoFromJson(json);

@override@JsonKey(name: 'posicion_id') final  String? posicionId;
@override final  String? puesto;
@override@JsonKey(name: 'empleado_id') final  String? empleadoId;
@override final  String? nombre;

/// Create a copy of JefeInmediato
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JefeInmediatoCopyWith<_JefeInmediato> get copyWith => __$JefeInmediatoCopyWithImpl<_JefeInmediato>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JefeInmediatoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JefeInmediato&&(identical(other.posicionId, posicionId) || other.posicionId == posicionId)&&(identical(other.puesto, puesto) || other.puesto == puesto)&&(identical(other.empleadoId, empleadoId) || other.empleadoId == empleadoId)&&(identical(other.nombre, nombre) || other.nombre == nombre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,posicionId,puesto,empleadoId,nombre);
}

@override
String toString() {
    return 'JefeInmediato(posicionId: $posicionId, puesto: $puesto, empleadoId: $empleadoId, nombre: $nombre)';
}


}

/// @nodoc
abstract mixin class _$JefeInmediatoCopyWith<$Res> implements $JefeInmediatoCopyWith<$Res> {
  factory _$JefeInmediatoCopyWith(_JefeInmediato value, $Res Function(_JefeInmediato) _then) = __$JefeInmediatoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'posicion_id') String? posicionId, String? puesto,@JsonKey(name: 'empleado_id') String? empleadoId, String? nombre
});




}
/// @nodoc
class __$JefeInmediatoCopyWithImpl<$Res>
    implements _$JefeInmediatoCopyWith<$Res> {
  __$JefeInmediatoCopyWithImpl(this._self, this._then);

  final _JefeInmediato _self;
  final $Res Function(_JefeInmediato) _then;

/// Create a copy of JefeInmediato
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posicionId = freezed,Object? puesto = freezed,Object? empleadoId = freezed,Object? nombre = freezed,}) {
  return _then(_JefeInmediato(
posicionId: freezed == posicionId ? _self.posicionId : posicionId // ignore: cast_nullable_to_non_nullable
as String?,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as String?,empleadoId: freezed == empleadoId ? _self.empleadoId : empleadoId // ignore: cast_nullable_to_non_nullable
as String?,nombre: freezed == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
