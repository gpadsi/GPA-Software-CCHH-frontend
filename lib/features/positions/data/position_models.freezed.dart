// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PositionCatalogEntry {

 int get id; String get code; String get name;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of PositionCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PositionCatalogEntryCopyWith<PositionCatalogEntry> get copyWith => _$PositionCatalogEntryCopyWithImpl<PositionCatalogEntry>(this as PositionCatalogEntry, _$identity);

  /// Serializes this PositionCatalogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PositionCatalogEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PositionCatalogEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PositionCatalogEntry;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.isActive);
}

@override
String toString() {
  final _this = this as PositionCatalogEntry;
  return 'PositionCatalogEntry(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $PositionCatalogEntryCopyWith<$Res>  {
  factory $PositionCatalogEntryCopyWith(PositionCatalogEntry value, $Res Function(PositionCatalogEntry) _then) = _$PositionCatalogEntryCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$PositionCatalogEntryCopyWithImpl<$Res>
    implements $PositionCatalogEntryCopyWith<$Res> {
  _$PositionCatalogEntryCopyWithImpl(this._self, this._then);

  final PositionCatalogEntry _self;
  final $Res Function(PositionCatalogEntry) _then;

/// Create a copy of PositionCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(PositionCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PositionCatalogEntry].
extension PositionCatalogEntryPatterns on PositionCatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PositionCatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PositionCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PositionCatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _PositionCatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PositionCatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PositionCatalogEntry() when $default != null:
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
case _PositionCatalogEntry() when $default != null:
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
case _PositionCatalogEntry():
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
case _PositionCatalogEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PositionCatalogEntry implements PositionCatalogEntry {
  const _PositionCatalogEntry({required this.id, required this.code, required this.name, @JsonKey(name: 'is_active') required this.isActive});
  factory _PositionCatalogEntry.fromJson(Map<String, dynamic> json) => _$PositionCatalogEntryFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of PositionCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PositionCatalogEntryCopyWith<_PositionCatalogEntry> get copyWith => __$PositionCatalogEntryCopyWithImpl<_PositionCatalogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PositionCatalogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PositionCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,isActive);
}

@override
String toString() {
    return 'PositionCatalogEntry(id: $id, code: $code, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$PositionCatalogEntryCopyWith<$Res> implements $PositionCatalogEntryCopyWith<$Res> {
  factory _$PositionCatalogEntryCopyWith(_PositionCatalogEntry value, $Res Function(_PositionCatalogEntry) _then) = __$PositionCatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$PositionCatalogEntryCopyWithImpl<$Res>
    implements _$PositionCatalogEntryCopyWith<$Res> {
  __$PositionCatalogEntryCopyWithImpl(this._self, this._then);

  final _PositionCatalogEntry _self;
  final $Res Function(_PositionCatalogEntry) _then;

/// Create a copy of PositionCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,}) {
  return _then(_PositionCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RefEntry {

 String get id; String get code; String get name;
/// Create a copy of RefEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefEntryCopyWith<RefEntry> get copyWith => _$RefEntryCopyWithImpl<RefEntry>(this as RefEntry, _$identity);

  /// Serializes this RefEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RefEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RefEntry;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as RefEntry;
  return 'RefEntry(id: ${_this.id}, code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $RefEntryCopyWith<$Res>  {
  factory $RefEntryCopyWith(RefEntry value, $Res Function(RefEntry) _then) = _$RefEntryCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class _$RefEntryCopyWithImpl<$Res>
    implements $RefEntryCopyWith<$Res> {
  _$RefEntryCopyWithImpl(this._self, this._then);

  final RefEntry _self;
  final $Res Function(RefEntry) _then;

/// Create a copy of RefEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(RefEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RefEntry].
extension RefEntryPatterns on RefEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefEntry value)  $default,){
final _that = this;
switch (_that) {
case _RefEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefEntry value)?  $default,){
final _that = this;
switch (_that) {
case _RefEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefEntry() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _RefEntry():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _RefEntry() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefEntry implements RefEntry {
  const _RefEntry({required this.id, required this.code, required this.name});
  factory _RefEntry.fromJson(Map<String, dynamic> json) => _$RefEntryFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;

/// Create a copy of RefEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefEntryCopyWith<_RefEntry> get copyWith => __$RefEntryCopyWithImpl<_RefEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name);
}

@override
String toString() {
    return 'RefEntry(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$RefEntryCopyWith<$Res> implements $RefEntryCopyWith<$Res> {
  factory _$RefEntryCopyWith(_RefEntry value, $Res Function(_RefEntry) _then) = __$RefEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class __$RefEntryCopyWithImpl<$Res>
    implements _$RefEntryCopyWith<$Res> {
  __$RefEntryCopyWithImpl(this._self, this._then);

  final _RefEntry _self;
  final $Res Function(_RefEntry) _then;

/// Create a copy of RefEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_RefEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Posicion {

 String get id;@JsonKey(name: 'organization_node') String get organizationNode; String? get area; int? get puesto;@JsonKey(name: 'reports_to') String? get reportsTo;@JsonKey(name: 'supervision_texto') String get supervisionTexto; int? get alcance;@JsonKey(name: 'tipo_posicion') int? get tipoPosicion;@JsonKey(name: 'tipo_requisicion') int? get tipoRequisicion; int get estatus;@JsonKey(name: 'genero_requerido') int? get generoRequerido;@JsonKey(name: 'fecha_registro_vacante') String? get fechaRegistroVacante;@JsonKey(name: 'fecha_autorizacion_vacante') String? get fechaAutorizacionVacante; String get headhunter;@JsonKey(name: 'solicitante_vacante') String get solicitanteVacante;@JsonKey(name: 'proyecto_eventual') String get proyectoEventual;@JsonKey(name: 'fecha_esperada_termino') String? get fechaEsperadaTermino;
/// Create a copy of Posicion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosicionCopyWith<Posicion> get copyWith => _$PosicionCopyWithImpl<Posicion>(this as Posicion, _$identity);

  /// Serializes this Posicion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Posicion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Posicion&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.organizationNode, _this.organizationNode) || other.organizationNode == _this.organizationNode)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.puesto, _this.puesto) || other.puesto == _this.puesto)&&(identical(other.reportsTo, _this.reportsTo) || other.reportsTo == _this.reportsTo)&&(identical(other.supervisionTexto, _this.supervisionTexto) || other.supervisionTexto == _this.supervisionTexto)&&(identical(other.alcance, _this.alcance) || other.alcance == _this.alcance)&&(identical(other.tipoPosicion, _this.tipoPosicion) || other.tipoPosicion == _this.tipoPosicion)&&(identical(other.tipoRequisicion, _this.tipoRequisicion) || other.tipoRequisicion == _this.tipoRequisicion)&&(identical(other.estatus, _this.estatus) || other.estatus == _this.estatus)&&(identical(other.generoRequerido, _this.generoRequerido) || other.generoRequerido == _this.generoRequerido)&&(identical(other.fechaRegistroVacante, _this.fechaRegistroVacante) || other.fechaRegistroVacante == _this.fechaRegistroVacante)&&(identical(other.fechaAutorizacionVacante, _this.fechaAutorizacionVacante) || other.fechaAutorizacionVacante == _this.fechaAutorizacionVacante)&&(identical(other.headhunter, _this.headhunter) || other.headhunter == _this.headhunter)&&(identical(other.solicitanteVacante, _this.solicitanteVacante) || other.solicitanteVacante == _this.solicitanteVacante)&&(identical(other.proyectoEventual, _this.proyectoEventual) || other.proyectoEventual == _this.proyectoEventual)&&(identical(other.fechaEsperadaTermino, _this.fechaEsperadaTermino) || other.fechaEsperadaTermino == _this.fechaEsperadaTermino));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Posicion;
  return Object.hash(runtimeType,_this.id,_this.organizationNode,_this.area,_this.puesto,_this.reportsTo,_this.supervisionTexto,_this.alcance,_this.tipoPosicion,_this.tipoRequisicion,_this.estatus,_this.generoRequerido,_this.fechaRegistroVacante,_this.fechaAutorizacionVacante,_this.headhunter,_this.solicitanteVacante,_this.proyectoEventual,_this.fechaEsperadaTermino);
}

@override
String toString() {
  final _this = this as Posicion;
  return 'Posicion(id: ${_this.id}, organizationNode: ${_this.organizationNode}, area: ${_this.area}, puesto: ${_this.puesto}, reportsTo: ${_this.reportsTo}, supervisionTexto: ${_this.supervisionTexto}, alcance: ${_this.alcance}, tipoPosicion: ${_this.tipoPosicion}, tipoRequisicion: ${_this.tipoRequisicion}, estatus: ${_this.estatus}, generoRequerido: ${_this.generoRequerido}, fechaRegistroVacante: ${_this.fechaRegistroVacante}, fechaAutorizacionVacante: ${_this.fechaAutorizacionVacante}, headhunter: ${_this.headhunter}, solicitanteVacante: ${_this.solicitanteVacante}, proyectoEventual: ${_this.proyectoEventual}, fechaEsperadaTermino: ${_this.fechaEsperadaTermino})';
}


}

/// @nodoc
abstract mixin class $PosicionCopyWith<$Res>  {
  factory $PosicionCopyWith(Posicion value, $Res Function(Posicion) _then) = _$PosicionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'organization_node') String organizationNode, String? area, int? puesto,@JsonKey(name: 'reports_to') String? reportsTo,@JsonKey(name: 'supervision_texto') String supervisionTexto, int? alcance,@JsonKey(name: 'tipo_posicion') int? tipoPosicion,@JsonKey(name: 'tipo_requisicion') int? tipoRequisicion, int estatus,@JsonKey(name: 'genero_requerido') int? generoRequerido,@JsonKey(name: 'fecha_registro_vacante') String? fechaRegistroVacante,@JsonKey(name: 'fecha_autorizacion_vacante') String? fechaAutorizacionVacante, String headhunter,@JsonKey(name: 'solicitante_vacante') String solicitanteVacante,@JsonKey(name: 'proyecto_eventual') String proyectoEventual,@JsonKey(name: 'fecha_esperada_termino') String? fechaEsperadaTermino
});




}
/// @nodoc
class _$PosicionCopyWithImpl<$Res>
    implements $PosicionCopyWith<$Res> {
  _$PosicionCopyWithImpl(this._self, this._then);

  final Posicion _self;
  final $Res Function(Posicion) _then;

/// Create a copy of Posicion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationNode = null,Object? area = freezed,Object? puesto = freezed,Object? reportsTo = freezed,Object? supervisionTexto = null,Object? alcance = freezed,Object? tipoPosicion = freezed,Object? tipoRequisicion = freezed,Object? estatus = null,Object? generoRequerido = freezed,Object? fechaRegistroVacante = freezed,Object? fechaAutorizacionVacante = freezed,Object? headhunter = null,Object? solicitanteVacante = null,Object? proyectoEventual = null,Object? fechaEsperadaTermino = freezed,}) {
  return _then(Posicion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationNode: null == organizationNode ? _self.organizationNode : organizationNode // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as int?,reportsTo: freezed == reportsTo ? _self.reportsTo : reportsTo // ignore: cast_nullable_to_non_nullable
as String?,supervisionTexto: null == supervisionTexto ? _self.supervisionTexto : supervisionTexto // ignore: cast_nullable_to_non_nullable
as String,alcance: freezed == alcance ? _self.alcance : alcance // ignore: cast_nullable_to_non_nullable
as int?,tipoPosicion: freezed == tipoPosicion ? _self.tipoPosicion : tipoPosicion // ignore: cast_nullable_to_non_nullable
as int?,tipoRequisicion: freezed == tipoRequisicion ? _self.tipoRequisicion : tipoRequisicion // ignore: cast_nullable_to_non_nullable
as int?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as int,generoRequerido: freezed == generoRequerido ? _self.generoRequerido : generoRequerido // ignore: cast_nullable_to_non_nullable
as int?,fechaRegistroVacante: freezed == fechaRegistroVacante ? _self.fechaRegistroVacante : fechaRegistroVacante // ignore: cast_nullable_to_non_nullable
as String?,fechaAutorizacionVacante: freezed == fechaAutorizacionVacante ? _self.fechaAutorizacionVacante : fechaAutorizacionVacante // ignore: cast_nullable_to_non_nullable
as String?,headhunter: null == headhunter ? _self.headhunter : headhunter // ignore: cast_nullable_to_non_nullable
as String,solicitanteVacante: null == solicitanteVacante ? _self.solicitanteVacante : solicitanteVacante // ignore: cast_nullable_to_non_nullable
as String,proyectoEventual: null == proyectoEventual ? _self.proyectoEventual : proyectoEventual // ignore: cast_nullable_to_non_nullable
as String,fechaEsperadaTermino: freezed == fechaEsperadaTermino ? _self.fechaEsperadaTermino : fechaEsperadaTermino // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Posicion].
extension PosicionPatterns on Posicion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Posicion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Posicion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Posicion value)  $default,){
final _that = this;
switch (_that) {
case _Posicion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Posicion value)?  $default,){
final _that = this;
switch (_that) {
case _Posicion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'organization_node')  String organizationNode,  String? area,  int? puesto, @JsonKey(name: 'reports_to')  String? reportsTo, @JsonKey(name: 'supervision_texto')  String supervisionTexto,  int? alcance, @JsonKey(name: 'tipo_posicion')  int? tipoPosicion, @JsonKey(name: 'tipo_requisicion')  int? tipoRequisicion,  int estatus, @JsonKey(name: 'genero_requerido')  int? generoRequerido, @JsonKey(name: 'fecha_registro_vacante')  String? fechaRegistroVacante, @JsonKey(name: 'fecha_autorizacion_vacante')  String? fechaAutorizacionVacante,  String headhunter, @JsonKey(name: 'solicitante_vacante')  String solicitanteVacante, @JsonKey(name: 'proyecto_eventual')  String proyectoEventual, @JsonKey(name: 'fecha_esperada_termino')  String? fechaEsperadaTermino)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Posicion() when $default != null:
return $default(_that.id,_that.organizationNode,_that.area,_that.puesto,_that.reportsTo,_that.supervisionTexto,_that.alcance,_that.tipoPosicion,_that.tipoRequisicion,_that.estatus,_that.generoRequerido,_that.fechaRegistroVacante,_that.fechaAutorizacionVacante,_that.headhunter,_that.solicitanteVacante,_that.proyectoEventual,_that.fechaEsperadaTermino);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'organization_node')  String organizationNode,  String? area,  int? puesto, @JsonKey(name: 'reports_to')  String? reportsTo, @JsonKey(name: 'supervision_texto')  String supervisionTexto,  int? alcance, @JsonKey(name: 'tipo_posicion')  int? tipoPosicion, @JsonKey(name: 'tipo_requisicion')  int? tipoRequisicion,  int estatus, @JsonKey(name: 'genero_requerido')  int? generoRequerido, @JsonKey(name: 'fecha_registro_vacante')  String? fechaRegistroVacante, @JsonKey(name: 'fecha_autorizacion_vacante')  String? fechaAutorizacionVacante,  String headhunter, @JsonKey(name: 'solicitante_vacante')  String solicitanteVacante, @JsonKey(name: 'proyecto_eventual')  String proyectoEventual, @JsonKey(name: 'fecha_esperada_termino')  String? fechaEsperadaTermino)  $default,) {final _that = this;
switch (_that) {
case _Posicion():
return $default(_that.id,_that.organizationNode,_that.area,_that.puesto,_that.reportsTo,_that.supervisionTexto,_that.alcance,_that.tipoPosicion,_that.tipoRequisicion,_that.estatus,_that.generoRequerido,_that.fechaRegistroVacante,_that.fechaAutorizacionVacante,_that.headhunter,_that.solicitanteVacante,_that.proyectoEventual,_that.fechaEsperadaTermino);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'organization_node')  String organizationNode,  String? area,  int? puesto, @JsonKey(name: 'reports_to')  String? reportsTo, @JsonKey(name: 'supervision_texto')  String supervisionTexto,  int? alcance, @JsonKey(name: 'tipo_posicion')  int? tipoPosicion, @JsonKey(name: 'tipo_requisicion')  int? tipoRequisicion,  int estatus, @JsonKey(name: 'genero_requerido')  int? generoRequerido, @JsonKey(name: 'fecha_registro_vacante')  String? fechaRegistroVacante, @JsonKey(name: 'fecha_autorizacion_vacante')  String? fechaAutorizacionVacante,  String headhunter, @JsonKey(name: 'solicitante_vacante')  String solicitanteVacante, @JsonKey(name: 'proyecto_eventual')  String proyectoEventual, @JsonKey(name: 'fecha_esperada_termino')  String? fechaEsperadaTermino)?  $default,) {final _that = this;
switch (_that) {
case _Posicion() when $default != null:
return $default(_that.id,_that.organizationNode,_that.area,_that.puesto,_that.reportsTo,_that.supervisionTexto,_that.alcance,_that.tipoPosicion,_that.tipoRequisicion,_that.estatus,_that.generoRequerido,_that.fechaRegistroVacante,_that.fechaAutorizacionVacante,_that.headhunter,_that.solicitanteVacante,_that.proyectoEventual,_that.fechaEsperadaTermino);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Posicion implements Posicion {
  const _Posicion({required this.id, @JsonKey(name: 'organization_node') required this.organizationNode, this.area, this.puesto, @JsonKey(name: 'reports_to') this.reportsTo, @JsonKey(name: 'supervision_texto') this.supervisionTexto = '', this.alcance, @JsonKey(name: 'tipo_posicion') this.tipoPosicion, @JsonKey(name: 'tipo_requisicion') this.tipoRequisicion, required this.estatus, @JsonKey(name: 'genero_requerido') this.generoRequerido, @JsonKey(name: 'fecha_registro_vacante') this.fechaRegistroVacante, @JsonKey(name: 'fecha_autorizacion_vacante') this.fechaAutorizacionVacante, this.headhunter = '', @JsonKey(name: 'solicitante_vacante') this.solicitanteVacante = '', @JsonKey(name: 'proyecto_eventual') this.proyectoEventual = '', @JsonKey(name: 'fecha_esperada_termino') this.fechaEsperadaTermino});
  factory _Posicion.fromJson(Map<String, dynamic> json) => _$PosicionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'organization_node') final  String organizationNode;
@override final  String? area;
@override final  int? puesto;
@override@JsonKey(name: 'reports_to') final  String? reportsTo;
@override@JsonKey(name: 'supervision_texto') final  String supervisionTexto;
@override final  int? alcance;
@override@JsonKey(name: 'tipo_posicion') final  int? tipoPosicion;
@override@JsonKey(name: 'tipo_requisicion') final  int? tipoRequisicion;
@override final  int estatus;
@override@JsonKey(name: 'genero_requerido') final  int? generoRequerido;
@override@JsonKey(name: 'fecha_registro_vacante') final  String? fechaRegistroVacante;
@override@JsonKey(name: 'fecha_autorizacion_vacante') final  String? fechaAutorizacionVacante;
@override@JsonKey() final  String headhunter;
@override@JsonKey(name: 'solicitante_vacante') final  String solicitanteVacante;
@override@JsonKey(name: 'proyecto_eventual') final  String proyectoEventual;
@override@JsonKey(name: 'fecha_esperada_termino') final  String? fechaEsperadaTermino;

/// Create a copy of Posicion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosicionCopyWith<_Posicion> get copyWith => __$PosicionCopyWithImpl<_Posicion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PosicionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Posicion&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationNode, organizationNode) || other.organizationNode == organizationNode)&&(identical(other.area, area) || other.area == area)&&(identical(other.puesto, puesto) || other.puesto == puesto)&&(identical(other.reportsTo, reportsTo) || other.reportsTo == reportsTo)&&(identical(other.supervisionTexto, supervisionTexto) || other.supervisionTexto == supervisionTexto)&&(identical(other.alcance, alcance) || other.alcance == alcance)&&(identical(other.tipoPosicion, tipoPosicion) || other.tipoPosicion == tipoPosicion)&&(identical(other.tipoRequisicion, tipoRequisicion) || other.tipoRequisicion == tipoRequisicion)&&(identical(other.estatus, estatus) || other.estatus == estatus)&&(identical(other.generoRequerido, generoRequerido) || other.generoRequerido == generoRequerido)&&(identical(other.fechaRegistroVacante, fechaRegistroVacante) || other.fechaRegistroVacante == fechaRegistroVacante)&&(identical(other.fechaAutorizacionVacante, fechaAutorizacionVacante) || other.fechaAutorizacionVacante == fechaAutorizacionVacante)&&(identical(other.headhunter, headhunter) || other.headhunter == headhunter)&&(identical(other.solicitanteVacante, solicitanteVacante) || other.solicitanteVacante == solicitanteVacante)&&(identical(other.proyectoEventual, proyectoEventual) || other.proyectoEventual == proyectoEventual)&&(identical(other.fechaEsperadaTermino, fechaEsperadaTermino) || other.fechaEsperadaTermino == fechaEsperadaTermino));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,organizationNode,area,puesto,reportsTo,supervisionTexto,alcance,tipoPosicion,tipoRequisicion,estatus,generoRequerido,fechaRegistroVacante,fechaAutorizacionVacante,headhunter,solicitanteVacante,proyectoEventual,fechaEsperadaTermino);
}

@override
String toString() {
    return 'Posicion(id: $id, organizationNode: $organizationNode, area: $area, puesto: $puesto, reportsTo: $reportsTo, supervisionTexto: $supervisionTexto, alcance: $alcance, tipoPosicion: $tipoPosicion, tipoRequisicion: $tipoRequisicion, estatus: $estatus, generoRequerido: $generoRequerido, fechaRegistroVacante: $fechaRegistroVacante, fechaAutorizacionVacante: $fechaAutorizacionVacante, headhunter: $headhunter, solicitanteVacante: $solicitanteVacante, proyectoEventual: $proyectoEventual, fechaEsperadaTermino: $fechaEsperadaTermino)';
}


}

/// @nodoc
abstract mixin class _$PosicionCopyWith<$Res> implements $PosicionCopyWith<$Res> {
  factory _$PosicionCopyWith(_Posicion value, $Res Function(_Posicion) _then) = __$PosicionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'organization_node') String organizationNode, String? area, int? puesto,@JsonKey(name: 'reports_to') String? reportsTo,@JsonKey(name: 'supervision_texto') String supervisionTexto, int? alcance,@JsonKey(name: 'tipo_posicion') int? tipoPosicion,@JsonKey(name: 'tipo_requisicion') int? tipoRequisicion, int estatus,@JsonKey(name: 'genero_requerido') int? generoRequerido,@JsonKey(name: 'fecha_registro_vacante') String? fechaRegistroVacante,@JsonKey(name: 'fecha_autorizacion_vacante') String? fechaAutorizacionVacante, String headhunter,@JsonKey(name: 'solicitante_vacante') String solicitanteVacante,@JsonKey(name: 'proyecto_eventual') String proyectoEventual,@JsonKey(name: 'fecha_esperada_termino') String? fechaEsperadaTermino
});




}
/// @nodoc
class __$PosicionCopyWithImpl<$Res>
    implements _$PosicionCopyWith<$Res> {
  __$PosicionCopyWithImpl(this._self, this._then);

  final _Posicion _self;
  final $Res Function(_Posicion) _then;

/// Create a copy of Posicion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationNode = null,Object? area = freezed,Object? puesto = freezed,Object? reportsTo = freezed,Object? supervisionTexto = null,Object? alcance = freezed,Object? tipoPosicion = freezed,Object? tipoRequisicion = freezed,Object? estatus = null,Object? generoRequerido = freezed,Object? fechaRegistroVacante = freezed,Object? fechaAutorizacionVacante = freezed,Object? headhunter = null,Object? solicitanteVacante = null,Object? proyectoEventual = null,Object? fechaEsperadaTermino = freezed,}) {
  return _then(_Posicion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationNode: null == organizationNode ? _self.organizationNode : organizationNode // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as int?,reportsTo: freezed == reportsTo ? _self.reportsTo : reportsTo // ignore: cast_nullable_to_non_nullable
as String?,supervisionTexto: null == supervisionTexto ? _self.supervisionTexto : supervisionTexto // ignore: cast_nullable_to_non_nullable
as String,alcance: freezed == alcance ? _self.alcance : alcance // ignore: cast_nullable_to_non_nullable
as int?,tipoPosicion: freezed == tipoPosicion ? _self.tipoPosicion : tipoPosicion // ignore: cast_nullable_to_non_nullable
as int?,tipoRequisicion: freezed == tipoRequisicion ? _self.tipoRequisicion : tipoRequisicion // ignore: cast_nullable_to_non_nullable
as int?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as int,generoRequerido: freezed == generoRequerido ? _self.generoRequerido : generoRequerido // ignore: cast_nullable_to_non_nullable
as int?,fechaRegistroVacante: freezed == fechaRegistroVacante ? _self.fechaRegistroVacante : fechaRegistroVacante // ignore: cast_nullable_to_non_nullable
as String?,fechaAutorizacionVacante: freezed == fechaAutorizacionVacante ? _self.fechaAutorizacionVacante : fechaAutorizacionVacante // ignore: cast_nullable_to_non_nullable
as String?,headhunter: null == headhunter ? _self.headhunter : headhunter // ignore: cast_nullable_to_non_nullable
as String,solicitanteVacante: null == solicitanteVacante ? _self.solicitanteVacante : solicitanteVacante // ignore: cast_nullable_to_non_nullable
as String,proyectoEventual: null == proyectoEventual ? _self.proyectoEventual : proyectoEventual // ignore: cast_nullable_to_non_nullable
as String,fechaEsperadaTermino: freezed == fechaEsperadaTermino ? _self.fechaEsperadaTermino : fechaEsperadaTermino // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
