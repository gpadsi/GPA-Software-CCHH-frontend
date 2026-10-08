// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruitment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitmentCatalogEntry {

 int get id; String get code; String get name;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'es_terminal') bool get esTerminal;@JsonKey(name: 'requiere_justificacion') bool get requiereJustificacion;@JsonKey(name: 'requiere_persona') bool get requierePersona;
/// Create a copy of RecruitmentCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecruitmentCatalogEntryCopyWith<RecruitmentCatalogEntry> get copyWith => _$RecruitmentCatalogEntryCopyWithImpl<RecruitmentCatalogEntry>(this as RecruitmentCatalogEntry, _$identity);

  /// Serializes this RecruitmentCatalogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecruitmentCatalogEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecruitmentCatalogEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.esTerminal, _this.esTerminal) || other.esTerminal == _this.esTerminal)&&(identical(other.requiereJustificacion, _this.requiereJustificacion) || other.requiereJustificacion == _this.requiereJustificacion)&&(identical(other.requierePersona, _this.requierePersona) || other.requierePersona == _this.requierePersona));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecruitmentCatalogEntry;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.isActive,_this.esTerminal,_this.requiereJustificacion,_this.requierePersona);
}

@override
String toString() {
  final _this = this as RecruitmentCatalogEntry;
  return 'RecruitmentCatalogEntry(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, isActive: ${_this.isActive}, esTerminal: ${_this.esTerminal}, requiereJustificacion: ${_this.requiereJustificacion}, requierePersona: ${_this.requierePersona})';
}


}

/// @nodoc
abstract mixin class $RecruitmentCatalogEntryCopyWith<$Res>  {
  factory $RecruitmentCatalogEntryCopyWith(RecruitmentCatalogEntry value, $Res Function(RecruitmentCatalogEntry) _then) = _$RecruitmentCatalogEntryCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'es_terminal') bool esTerminal,@JsonKey(name: 'requiere_justificacion') bool requiereJustificacion,@JsonKey(name: 'requiere_persona') bool requierePersona
});




}
/// @nodoc
class _$RecruitmentCatalogEntryCopyWithImpl<$Res>
    implements $RecruitmentCatalogEntryCopyWith<$Res> {
  _$RecruitmentCatalogEntryCopyWithImpl(this._self, this._then);

  final RecruitmentCatalogEntry _self;
  final $Res Function(RecruitmentCatalogEntry) _then;

/// Create a copy of RecruitmentCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,Object? esTerminal = null,Object? requiereJustificacion = null,Object? requierePersona = null,}) {
  return _then(RecruitmentCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,esTerminal: null == esTerminal ? _self.esTerminal : esTerminal // ignore: cast_nullable_to_non_nullable
as bool,requiereJustificacion: null == requiereJustificacion ? _self.requiereJustificacion : requiereJustificacion // ignore: cast_nullable_to_non_nullable
as bool,requierePersona: null == requierePersona ? _self.requierePersona : requierePersona // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecruitmentCatalogEntry].
extension RecruitmentCatalogEntryPatterns on RecruitmentCatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecruitmentCatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecruitmentCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecruitmentCatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _RecruitmentCatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecruitmentCatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _RecruitmentCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'es_terminal')  bool esTerminal, @JsonKey(name: 'requiere_justificacion')  bool requiereJustificacion, @JsonKey(name: 'requiere_persona')  bool requierePersona)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecruitmentCatalogEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive,_that.esTerminal,_that.requiereJustificacion,_that.requierePersona);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'es_terminal')  bool esTerminal, @JsonKey(name: 'requiere_justificacion')  bool requiereJustificacion, @JsonKey(name: 'requiere_persona')  bool requierePersona)  $default,) {final _that = this;
switch (_that) {
case _RecruitmentCatalogEntry():
return $default(_that.id,_that.code,_that.name,_that.isActive,_that.esTerminal,_that.requiereJustificacion,_that.requierePersona);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'es_terminal')  bool esTerminal, @JsonKey(name: 'requiere_justificacion')  bool requiereJustificacion, @JsonKey(name: 'requiere_persona')  bool requierePersona)?  $default,) {final _that = this;
switch (_that) {
case _RecruitmentCatalogEntry() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.isActive,_that.esTerminal,_that.requiereJustificacion,_that.requierePersona);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecruitmentCatalogEntry implements RecruitmentCatalogEntry {
  const _RecruitmentCatalogEntry({required this.id, required this.code, required this.name, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'es_terminal') this.esTerminal = false, @JsonKey(name: 'requiere_justificacion') this.requiereJustificacion = false, @JsonKey(name: 'requiere_persona') this.requierePersona = false});
  factory _RecruitmentCatalogEntry.fromJson(Map<String, dynamic> json) => _$RecruitmentCatalogEntryFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'es_terminal') final  bool esTerminal;
@override@JsonKey(name: 'requiere_justificacion') final  bool requiereJustificacion;
@override@JsonKey(name: 'requiere_persona') final  bool requierePersona;

/// Create a copy of RecruitmentCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecruitmentCatalogEntryCopyWith<_RecruitmentCatalogEntry> get copyWith => __$RecruitmentCatalogEntryCopyWithImpl<_RecruitmentCatalogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecruitmentCatalogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecruitmentCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.esTerminal, esTerminal) || other.esTerminal == esTerminal)&&(identical(other.requiereJustificacion, requiereJustificacion) || other.requiereJustificacion == requiereJustificacion)&&(identical(other.requierePersona, requierePersona) || other.requierePersona == requierePersona));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,isActive,esTerminal,requiereJustificacion,requierePersona);
}

@override
String toString() {
    return 'RecruitmentCatalogEntry(id: $id, code: $code, name: $name, isActive: $isActive, esTerminal: $esTerminal, requiereJustificacion: $requiereJustificacion, requierePersona: $requierePersona)';
}


}

/// @nodoc
abstract mixin class _$RecruitmentCatalogEntryCopyWith<$Res> implements $RecruitmentCatalogEntryCopyWith<$Res> {
  factory _$RecruitmentCatalogEntryCopyWith(_RecruitmentCatalogEntry value, $Res Function(_RecruitmentCatalogEntry) _then) = __$RecruitmentCatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'es_terminal') bool esTerminal,@JsonKey(name: 'requiere_justificacion') bool requiereJustificacion,@JsonKey(name: 'requiere_persona') bool requierePersona
});




}
/// @nodoc
class __$RecruitmentCatalogEntryCopyWithImpl<$Res>
    implements _$RecruitmentCatalogEntryCopyWith<$Res> {
  __$RecruitmentCatalogEntryCopyWithImpl(this._self, this._then);

  final _RecruitmentCatalogEntry _self;
  final $Res Function(_RecruitmentCatalogEntry) _then;

/// Create a copy of RecruitmentCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? isActive = null,Object? esTerminal = null,Object? requiereJustificacion = null,Object? requierePersona = null,}) {
  return _then(_RecruitmentCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,esTerminal: null == esTerminal ? _self.esTerminal : esTerminal // ignore: cast_nullable_to_non_nullable
as bool,requiereJustificacion: null == requiereJustificacion ? _self.requiereJustificacion : requiereJustificacion // ignore: cast_nullable_to_non_nullable
as bool,requierePersona: null == requierePersona ? _self.requierePersona : requierePersona // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PosicionRef {

 String get id; String get etiqueta;
/// Create a copy of PosicionRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosicionRefCopyWith<PosicionRef> get copyWith => _$PosicionRefCopyWithImpl<PosicionRef>(this as PosicionRef, _$identity);

  /// Serializes this PosicionRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PosicionRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosicionRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.etiqueta, _this.etiqueta) || other.etiqueta == _this.etiqueta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PosicionRef;
  return Object.hash(runtimeType,_this.id,_this.etiqueta);
}

@override
String toString() {
  final _this = this as PosicionRef;
  return 'PosicionRef(id: ${_this.id}, etiqueta: ${_this.etiqueta})';
}


}

/// @nodoc
abstract mixin class $PosicionRefCopyWith<$Res>  {
  factory $PosicionRefCopyWith(PosicionRef value, $Res Function(PosicionRef) _then) = _$PosicionRefCopyWithImpl;
@useResult
$Res call({
 String id, String etiqueta
});




}
/// @nodoc
class _$PosicionRefCopyWithImpl<$Res>
    implements $PosicionRefCopyWith<$Res> {
  _$PosicionRefCopyWithImpl(this._self, this._then);

  final PosicionRef _self;
  final $Res Function(PosicionRef) _then;

/// Create a copy of PosicionRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? etiqueta = null,}) {
  return _then(PosicionRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,etiqueta: null == etiqueta ? _self.etiqueta : etiqueta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PosicionRef].
extension PosicionRefPatterns on PosicionRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosicionRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosicionRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosicionRef value)  $default,){
final _that = this;
switch (_that) {
case _PosicionRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosicionRef value)?  $default,){
final _that = this;
switch (_that) {
case _PosicionRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String etiqueta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosicionRef() when $default != null:
return $default(_that.id,_that.etiqueta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String etiqueta)  $default,) {final _that = this;
switch (_that) {
case _PosicionRef():
return $default(_that.id,_that.etiqueta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String etiqueta)?  $default,) {final _that = this;
switch (_that) {
case _PosicionRef() when $default != null:
return $default(_that.id,_that.etiqueta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PosicionRef implements PosicionRef {
  const _PosicionRef({required this.id, this.etiqueta = ''});
  factory _PosicionRef.fromJson(Map<String, dynamic> json) => _$PosicionRefFromJson(json);

@override final  String id;
@override@JsonKey() final  String etiqueta;

/// Create a copy of PosicionRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosicionRefCopyWith<_PosicionRef> get copyWith => __$PosicionRefCopyWithImpl<_PosicionRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PosicionRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosicionRef&&(identical(other.id, id) || other.id == id)&&(identical(other.etiqueta, etiqueta) || other.etiqueta == etiqueta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,etiqueta);
}

@override
String toString() {
    return 'PosicionRef(id: $id, etiqueta: $etiqueta)';
}


}

/// @nodoc
abstract mixin class _$PosicionRefCopyWith<$Res> implements $PosicionRefCopyWith<$Res> {
  factory _$PosicionRefCopyWith(_PosicionRef value, $Res Function(_PosicionRef) _then) = __$PosicionRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String etiqueta
});




}
/// @nodoc
class __$PosicionRefCopyWithImpl<$Res>
    implements _$PosicionRefCopyWith<$Res> {
  __$PosicionRefCopyWithImpl(this._self, this._then);

  final _PosicionRef _self;
  final $Res Function(_PosicionRef) _then;

/// Create a copy of PosicionRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? etiqueta = null,}) {
  return _then(_PosicionRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,etiqueta: null == etiqueta ? _self.etiqueta : etiqueta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TramiteAbierto {

 String get tipo; String? get id; String? get estado;
/// Create a copy of TramiteAbierto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TramiteAbiertoCopyWith<TramiteAbierto> get copyWith => _$TramiteAbiertoCopyWithImpl<TramiteAbierto>(this as TramiteAbierto, _$identity);

  /// Serializes this TramiteAbierto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TramiteAbierto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TramiteAbierto&&(identical(other.tipo, _this.tipo) || other.tipo == _this.tipo)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.estado, _this.estado) || other.estado == _this.estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TramiteAbierto;
  return Object.hash(runtimeType,_this.tipo,_this.id,_this.estado);
}

@override
String toString() {
  final _this = this as TramiteAbierto;
  return 'TramiteAbierto(tipo: ${_this.tipo}, id: ${_this.id}, estado: ${_this.estado})';
}


}

/// @nodoc
abstract mixin class $TramiteAbiertoCopyWith<$Res>  {
  factory $TramiteAbiertoCopyWith(TramiteAbierto value, $Res Function(TramiteAbierto) _then) = _$TramiteAbiertoCopyWithImpl;
@useResult
$Res call({
 String tipo, String? id, String? estado
});




}
/// @nodoc
class _$TramiteAbiertoCopyWithImpl<$Res>
    implements $TramiteAbiertoCopyWith<$Res> {
  _$TramiteAbiertoCopyWithImpl(this._self, this._then);

  final TramiteAbierto _self;
  final $Res Function(TramiteAbierto) _then;

/// Create a copy of TramiteAbierto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tipo = null,Object? id = freezed,Object? estado = freezed,}) {
  return _then(TramiteAbierto(
tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,estado: freezed == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TramiteAbierto].
extension TramiteAbiertoPatterns on TramiteAbierto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TramiteAbierto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TramiteAbierto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TramiteAbierto value)  $default,){
final _that = this;
switch (_that) {
case _TramiteAbierto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TramiteAbierto value)?  $default,){
final _that = this;
switch (_that) {
case _TramiteAbierto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tipo,  String? id,  String? estado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TramiteAbierto() when $default != null:
return $default(_that.tipo,_that.id,_that.estado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tipo,  String? id,  String? estado)  $default,) {final _that = this;
switch (_that) {
case _TramiteAbierto():
return $default(_that.tipo,_that.id,_that.estado);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tipo,  String? id,  String? estado)?  $default,) {final _that = this;
switch (_that) {
case _TramiteAbierto() when $default != null:
return $default(_that.tipo,_that.id,_that.estado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TramiteAbierto implements TramiteAbierto {
  const _TramiteAbierto({required this.tipo, this.id, this.estado});
  factory _TramiteAbierto.fromJson(Map<String, dynamic> json) => _$TramiteAbiertoFromJson(json);

@override final  String tipo;
@override final  String? id;
@override final  String? estado;

/// Create a copy of TramiteAbierto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TramiteAbiertoCopyWith<_TramiteAbierto> get copyWith => __$TramiteAbiertoCopyWithImpl<_TramiteAbierto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TramiteAbiertoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TramiteAbierto&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.id, id) || other.id == id)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tipo,id,estado);
}

@override
String toString() {
    return 'TramiteAbierto(tipo: $tipo, id: $id, estado: $estado)';
}


}

/// @nodoc
abstract mixin class _$TramiteAbiertoCopyWith<$Res> implements $TramiteAbiertoCopyWith<$Res> {
  factory _$TramiteAbiertoCopyWith(_TramiteAbierto value, $Res Function(_TramiteAbierto) _then) = __$TramiteAbiertoCopyWithImpl;
@override @useResult
$Res call({
 String tipo, String? id, String? estado
});




}
/// @nodoc
class __$TramiteAbiertoCopyWithImpl<$Res>
    implements _$TramiteAbiertoCopyWith<$Res> {
  __$TramiteAbiertoCopyWithImpl(this._self, this._then);

  final _TramiteAbierto _self;
  final $Res Function(_TramiteAbierto) _then;

/// Create a copy of TramiteAbierto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tipo = null,Object? id = freezed,Object? estado = freezed,}) {
  return _then(_TramiteAbierto(
tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,estado: freezed == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PosicionElegible {

 String get id; String get etiqueta; String? get puesto; String get unidad; String? get area; String get estatus;@JsonKey(name: 'estatus_code') String get estatusCode; bool get ocupada;@JsonKey(name: 'tramite_abierto') TramiteAbierto? get tramiteAbierto;
/// Create a copy of PosicionElegible
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosicionElegibleCopyWith<PosicionElegible> get copyWith => _$PosicionElegibleCopyWithImpl<PosicionElegible>(this as PosicionElegible, _$identity);

  /// Serializes this PosicionElegible to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PosicionElegible;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosicionElegible&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.etiqueta, _this.etiqueta) || other.etiqueta == _this.etiqueta)&&(identical(other.puesto, _this.puesto) || other.puesto == _this.puesto)&&(identical(other.unidad, _this.unidad) || other.unidad == _this.unidad)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.estatus, _this.estatus) || other.estatus == _this.estatus)&&(identical(other.estatusCode, _this.estatusCode) || other.estatusCode == _this.estatusCode)&&(identical(other.ocupada, _this.ocupada) || other.ocupada == _this.ocupada)&&(identical(other.tramiteAbierto, _this.tramiteAbierto) || other.tramiteAbierto == _this.tramiteAbierto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PosicionElegible;
  return Object.hash(runtimeType,_this.id,_this.etiqueta,_this.puesto,_this.unidad,_this.area,_this.estatus,_this.estatusCode,_this.ocupada,_this.tramiteAbierto);
}

@override
String toString() {
  final _this = this as PosicionElegible;
  return 'PosicionElegible(id: ${_this.id}, etiqueta: ${_this.etiqueta}, puesto: ${_this.puesto}, unidad: ${_this.unidad}, area: ${_this.area}, estatus: ${_this.estatus}, estatusCode: ${_this.estatusCode}, ocupada: ${_this.ocupada}, tramiteAbierto: ${_this.tramiteAbierto})';
}


}

/// @nodoc
abstract mixin class $PosicionElegibleCopyWith<$Res>  {
  factory $PosicionElegibleCopyWith(PosicionElegible value, $Res Function(PosicionElegible) _then) = _$PosicionElegibleCopyWithImpl;
@useResult
$Res call({
 String id, String etiqueta, String? puesto, String unidad, String? area, String estatus,@JsonKey(name: 'estatus_code') String estatusCode, bool ocupada,@JsonKey(name: 'tramite_abierto') TramiteAbierto? tramiteAbierto
});


$TramiteAbiertoCopyWith<$Res>? get tramiteAbierto;

}
/// @nodoc
class _$PosicionElegibleCopyWithImpl<$Res>
    implements $PosicionElegibleCopyWith<$Res> {
  _$PosicionElegibleCopyWithImpl(this._self, this._then);

  final PosicionElegible _self;
  final $Res Function(PosicionElegible) _then;

/// Create a copy of PosicionElegible
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? etiqueta = null,Object? puesto = freezed,Object? unidad = null,Object? area = freezed,Object? estatus = null,Object? estatusCode = null,Object? ocupada = null,Object? tramiteAbierto = freezed,}) {
  return _then(PosicionElegible(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,etiqueta: null == etiqueta ? _self.etiqueta : etiqueta // ignore: cast_nullable_to_non_nullable
as String,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as String?,unidad: null == unidad ? _self.unidad : unidad // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as String,estatusCode: null == estatusCode ? _self.estatusCode : estatusCode // ignore: cast_nullable_to_non_nullable
as String,ocupada: null == ocupada ? _self.ocupada : ocupada // ignore: cast_nullable_to_non_nullable
as bool,tramiteAbierto: freezed == tramiteAbierto ? _self.tramiteAbierto : tramiteAbierto // ignore: cast_nullable_to_non_nullable
as TramiteAbierto?,
  ));
}
/// Create a copy of PosicionElegible
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TramiteAbiertoCopyWith<$Res>? get tramiteAbierto {
    if (_self.tramiteAbierto == null) {
    return null;
  }

  return $TramiteAbiertoCopyWith<$Res>(_self.tramiteAbierto!, (value) {
    return _then(_self.copyWith(tramiteAbierto: value));
  });
}
}


/// Adds pattern-matching-related methods to [PosicionElegible].
extension PosicionElegiblePatterns on PosicionElegible {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosicionElegible value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosicionElegible() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosicionElegible value)  $default,){
final _that = this;
switch (_that) {
case _PosicionElegible():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosicionElegible value)?  $default,){
final _that = this;
switch (_that) {
case _PosicionElegible() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String etiqueta,  String? puesto,  String unidad,  String? area,  String estatus, @JsonKey(name: 'estatus_code')  String estatusCode,  bool ocupada, @JsonKey(name: 'tramite_abierto')  TramiteAbierto? tramiteAbierto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosicionElegible() when $default != null:
return $default(_that.id,_that.etiqueta,_that.puesto,_that.unidad,_that.area,_that.estatus,_that.estatusCode,_that.ocupada,_that.tramiteAbierto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String etiqueta,  String? puesto,  String unidad,  String? area,  String estatus, @JsonKey(name: 'estatus_code')  String estatusCode,  bool ocupada, @JsonKey(name: 'tramite_abierto')  TramiteAbierto? tramiteAbierto)  $default,) {final _that = this;
switch (_that) {
case _PosicionElegible():
return $default(_that.id,_that.etiqueta,_that.puesto,_that.unidad,_that.area,_that.estatus,_that.estatusCode,_that.ocupada,_that.tramiteAbierto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String etiqueta,  String? puesto,  String unidad,  String? area,  String estatus, @JsonKey(name: 'estatus_code')  String estatusCode,  bool ocupada, @JsonKey(name: 'tramite_abierto')  TramiteAbierto? tramiteAbierto)?  $default,) {final _that = this;
switch (_that) {
case _PosicionElegible() when $default != null:
return $default(_that.id,_that.etiqueta,_that.puesto,_that.unidad,_that.area,_that.estatus,_that.estatusCode,_that.ocupada,_that.tramiteAbierto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PosicionElegible implements PosicionElegible {
  const _PosicionElegible({required this.id, required this.etiqueta, this.puesto, required this.unidad, this.area, required this.estatus, @JsonKey(name: 'estatus_code') required this.estatusCode, required this.ocupada, @JsonKey(name: 'tramite_abierto') this.tramiteAbierto});
  factory _PosicionElegible.fromJson(Map<String, dynamic> json) => _$PosicionElegibleFromJson(json);

@override final  String id;
@override final  String etiqueta;
@override final  String? puesto;
@override final  String unidad;
@override final  String? area;
@override final  String estatus;
@override@JsonKey(name: 'estatus_code') final  String estatusCode;
@override final  bool ocupada;
@override@JsonKey(name: 'tramite_abierto') final  TramiteAbierto? tramiteAbierto;

/// Create a copy of PosicionElegible
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosicionElegibleCopyWith<_PosicionElegible> get copyWith => __$PosicionElegibleCopyWithImpl<_PosicionElegible>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PosicionElegibleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosicionElegible&&(identical(other.id, id) || other.id == id)&&(identical(other.etiqueta, etiqueta) || other.etiqueta == etiqueta)&&(identical(other.puesto, puesto) || other.puesto == puesto)&&(identical(other.unidad, unidad) || other.unidad == unidad)&&(identical(other.area, area) || other.area == area)&&(identical(other.estatus, estatus) || other.estatus == estatus)&&(identical(other.estatusCode, estatusCode) || other.estatusCode == estatusCode)&&(identical(other.ocupada, ocupada) || other.ocupada == ocupada)&&(identical(other.tramiteAbierto, tramiteAbierto) || other.tramiteAbierto == tramiteAbierto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,etiqueta,puesto,unidad,area,estatus,estatusCode,ocupada,tramiteAbierto);
}

@override
String toString() {
    return 'PosicionElegible(id: $id, etiqueta: $etiqueta, puesto: $puesto, unidad: $unidad, area: $area, estatus: $estatus, estatusCode: $estatusCode, ocupada: $ocupada, tramiteAbierto: $tramiteAbierto)';
}


}

/// @nodoc
abstract mixin class _$PosicionElegibleCopyWith<$Res> implements $PosicionElegibleCopyWith<$Res> {
  factory _$PosicionElegibleCopyWith(_PosicionElegible value, $Res Function(_PosicionElegible) _then) = __$PosicionElegibleCopyWithImpl;
@override @useResult
$Res call({
 String id, String etiqueta, String? puesto, String unidad, String? area, String estatus,@JsonKey(name: 'estatus_code') String estatusCode, bool ocupada,@JsonKey(name: 'tramite_abierto') TramiteAbierto? tramiteAbierto
});


@override $TramiteAbiertoCopyWith<$Res>? get tramiteAbierto;

}
/// @nodoc
class __$PosicionElegibleCopyWithImpl<$Res>
    implements _$PosicionElegibleCopyWith<$Res> {
  __$PosicionElegibleCopyWithImpl(this._self, this._then);

  final _PosicionElegible _self;
  final $Res Function(_PosicionElegible) _then;

/// Create a copy of PosicionElegible
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? etiqueta = null,Object? puesto = freezed,Object? unidad = null,Object? area = freezed,Object? estatus = null,Object? estatusCode = null,Object? ocupada = null,Object? tramiteAbierto = freezed,}) {
  return _then(_PosicionElegible(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,etiqueta: null == etiqueta ? _self.etiqueta : etiqueta // ignore: cast_nullable_to_non_nullable
as String,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as String?,unidad: null == unidad ? _self.unidad : unidad // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as String,estatusCode: null == estatusCode ? _self.estatusCode : estatusCode // ignore: cast_nullable_to_non_nullable
as String,ocupada: null == ocupada ? _self.ocupada : ocupada // ignore: cast_nullable_to_non_nullable
as bool,tramiteAbierto: freezed == tramiteAbierto ? _self.tramiteAbierto : tramiteAbierto // ignore: cast_nullable_to_non_nullable
as TramiteAbierto?,
  ));
}

/// Create a copy of PosicionElegible
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TramiteAbiertoCopyWith<$Res>? get tramiteAbierto {
    if (_self.tramiteAbierto == null) {
    return null;
  }

  return $TramiteAbiertoCopyWith<$Res>(_self.tramiteAbierto!, (value) {
    return _then(_self.copyWith(tramiteAbierto: value));
  });
}
}


/// @nodoc
mixin _$PosicionContexto {

 String get id; String get etiqueta; String? get puesto; String get unidad; String? get area; String get estatus;@JsonKey(name: 'estatus_code') String get estatusCode; bool get ocupada;@JsonKey(name: 'tramite_abierto') TramiteAbierto? get tramiteAbierto; String? get empresa;@JsonKey(name: 'reporta_a') String? get reportaA;
/// Create a copy of PosicionContexto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosicionContextoCopyWith<PosicionContexto> get copyWith => _$PosicionContextoCopyWithImpl<PosicionContexto>(this as PosicionContexto, _$identity);

  /// Serializes this PosicionContexto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PosicionContexto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosicionContexto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.etiqueta, _this.etiqueta) || other.etiqueta == _this.etiqueta)&&(identical(other.puesto, _this.puesto) || other.puesto == _this.puesto)&&(identical(other.unidad, _this.unidad) || other.unidad == _this.unidad)&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.estatus, _this.estatus) || other.estatus == _this.estatus)&&(identical(other.estatusCode, _this.estatusCode) || other.estatusCode == _this.estatusCode)&&(identical(other.ocupada, _this.ocupada) || other.ocupada == _this.ocupada)&&(identical(other.tramiteAbierto, _this.tramiteAbierto) || other.tramiteAbierto == _this.tramiteAbierto)&&(identical(other.empresa, _this.empresa) || other.empresa == _this.empresa)&&(identical(other.reportaA, _this.reportaA) || other.reportaA == _this.reportaA));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PosicionContexto;
  return Object.hash(runtimeType,_this.id,_this.etiqueta,_this.puesto,_this.unidad,_this.area,_this.estatus,_this.estatusCode,_this.ocupada,_this.tramiteAbierto,_this.empresa,_this.reportaA);
}

@override
String toString() {
  final _this = this as PosicionContexto;
  return 'PosicionContexto(id: ${_this.id}, etiqueta: ${_this.etiqueta}, puesto: ${_this.puesto}, unidad: ${_this.unidad}, area: ${_this.area}, estatus: ${_this.estatus}, estatusCode: ${_this.estatusCode}, ocupada: ${_this.ocupada}, tramiteAbierto: ${_this.tramiteAbierto}, empresa: ${_this.empresa}, reportaA: ${_this.reportaA})';
}


}

/// @nodoc
abstract mixin class $PosicionContextoCopyWith<$Res>  {
  factory $PosicionContextoCopyWith(PosicionContexto value, $Res Function(PosicionContexto) _then) = _$PosicionContextoCopyWithImpl;
@useResult
$Res call({
 String id, String etiqueta, String? puesto, String unidad, String? area, String estatus,@JsonKey(name: 'estatus_code') String estatusCode, bool ocupada,@JsonKey(name: 'tramite_abierto') TramiteAbierto? tramiteAbierto, String? empresa,@JsonKey(name: 'reporta_a') String? reportaA
});


$TramiteAbiertoCopyWith<$Res>? get tramiteAbierto;

}
/// @nodoc
class _$PosicionContextoCopyWithImpl<$Res>
    implements $PosicionContextoCopyWith<$Res> {
  _$PosicionContextoCopyWithImpl(this._self, this._then);

  final PosicionContexto _self;
  final $Res Function(PosicionContexto) _then;

/// Create a copy of PosicionContexto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? etiqueta = null,Object? puesto = freezed,Object? unidad = null,Object? area = freezed,Object? estatus = null,Object? estatusCode = null,Object? ocupada = null,Object? tramiteAbierto = freezed,Object? empresa = freezed,Object? reportaA = freezed,}) {
  return _then(PosicionContexto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,etiqueta: null == etiqueta ? _self.etiqueta : etiqueta // ignore: cast_nullable_to_non_nullable
as String,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as String?,unidad: null == unidad ? _self.unidad : unidad // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as String,estatusCode: null == estatusCode ? _self.estatusCode : estatusCode // ignore: cast_nullable_to_non_nullable
as String,ocupada: null == ocupada ? _self.ocupada : ocupada // ignore: cast_nullable_to_non_nullable
as bool,tramiteAbierto: freezed == tramiteAbierto ? _self.tramiteAbierto : tramiteAbierto // ignore: cast_nullable_to_non_nullable
as TramiteAbierto?,empresa: freezed == empresa ? _self.empresa : empresa // ignore: cast_nullable_to_non_nullable
as String?,reportaA: freezed == reportaA ? _self.reportaA : reportaA // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PosicionContexto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TramiteAbiertoCopyWith<$Res>? get tramiteAbierto {
    if (_self.tramiteAbierto == null) {
    return null;
  }

  return $TramiteAbiertoCopyWith<$Res>(_self.tramiteAbierto!, (value) {
    return _then(_self.copyWith(tramiteAbierto: value));
  });
}
}


/// Adds pattern-matching-related methods to [PosicionContexto].
extension PosicionContextoPatterns on PosicionContexto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosicionContexto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosicionContexto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosicionContexto value)  $default,){
final _that = this;
switch (_that) {
case _PosicionContexto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosicionContexto value)?  $default,){
final _that = this;
switch (_that) {
case _PosicionContexto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String etiqueta,  String? puesto,  String unidad,  String? area,  String estatus, @JsonKey(name: 'estatus_code')  String estatusCode,  bool ocupada, @JsonKey(name: 'tramite_abierto')  TramiteAbierto? tramiteAbierto,  String? empresa, @JsonKey(name: 'reporta_a')  String? reportaA)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosicionContexto() when $default != null:
return $default(_that.id,_that.etiqueta,_that.puesto,_that.unidad,_that.area,_that.estatus,_that.estatusCode,_that.ocupada,_that.tramiteAbierto,_that.empresa,_that.reportaA);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String etiqueta,  String? puesto,  String unidad,  String? area,  String estatus, @JsonKey(name: 'estatus_code')  String estatusCode,  bool ocupada, @JsonKey(name: 'tramite_abierto')  TramiteAbierto? tramiteAbierto,  String? empresa, @JsonKey(name: 'reporta_a')  String? reportaA)  $default,) {final _that = this;
switch (_that) {
case _PosicionContexto():
return $default(_that.id,_that.etiqueta,_that.puesto,_that.unidad,_that.area,_that.estatus,_that.estatusCode,_that.ocupada,_that.tramiteAbierto,_that.empresa,_that.reportaA);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String etiqueta,  String? puesto,  String unidad,  String? area,  String estatus, @JsonKey(name: 'estatus_code')  String estatusCode,  bool ocupada, @JsonKey(name: 'tramite_abierto')  TramiteAbierto? tramiteAbierto,  String? empresa, @JsonKey(name: 'reporta_a')  String? reportaA)?  $default,) {final _that = this;
switch (_that) {
case _PosicionContexto() when $default != null:
return $default(_that.id,_that.etiqueta,_that.puesto,_that.unidad,_that.area,_that.estatus,_that.estatusCode,_that.ocupada,_that.tramiteAbierto,_that.empresa,_that.reportaA);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PosicionContexto extends PosicionContexto {
  const _PosicionContexto({required this.id, required this.etiqueta, this.puesto, required this.unidad, this.area, required this.estatus, @JsonKey(name: 'estatus_code') required this.estatusCode, required this.ocupada, @JsonKey(name: 'tramite_abierto') this.tramiteAbierto, this.empresa, @JsonKey(name: 'reporta_a') this.reportaA}): super._();
  factory _PosicionContexto.fromJson(Map<String, dynamic> json) => _$PosicionContextoFromJson(json);

@override final  String id;
@override final  String etiqueta;
@override final  String? puesto;
@override final  String unidad;
@override final  String? area;
@override final  String estatus;
@override@JsonKey(name: 'estatus_code') final  String estatusCode;
@override final  bool ocupada;
@override@JsonKey(name: 'tramite_abierto') final  TramiteAbierto? tramiteAbierto;
@override final  String? empresa;
@override@JsonKey(name: 'reporta_a') final  String? reportaA;

/// Create a copy of PosicionContexto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosicionContextoCopyWith<_PosicionContexto> get copyWith => __$PosicionContextoCopyWithImpl<_PosicionContexto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PosicionContextoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosicionContexto&&(identical(other.id, id) || other.id == id)&&(identical(other.etiqueta, etiqueta) || other.etiqueta == etiqueta)&&(identical(other.puesto, puesto) || other.puesto == puesto)&&(identical(other.unidad, unidad) || other.unidad == unidad)&&(identical(other.area, area) || other.area == area)&&(identical(other.estatus, estatus) || other.estatus == estatus)&&(identical(other.estatusCode, estatusCode) || other.estatusCode == estatusCode)&&(identical(other.ocupada, ocupada) || other.ocupada == ocupada)&&(identical(other.tramiteAbierto, tramiteAbierto) || other.tramiteAbierto == tramiteAbierto)&&(identical(other.empresa, empresa) || other.empresa == empresa)&&(identical(other.reportaA, reportaA) || other.reportaA == reportaA));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,etiqueta,puesto,unidad,area,estatus,estatusCode,ocupada,tramiteAbierto,empresa,reportaA);
}

@override
String toString() {
    return 'PosicionContexto(id: $id, etiqueta: $etiqueta, puesto: $puesto, unidad: $unidad, area: $area, estatus: $estatus, estatusCode: $estatusCode, ocupada: $ocupada, tramiteAbierto: $tramiteAbierto, empresa: $empresa, reportaA: $reportaA)';
}


}

/// @nodoc
abstract mixin class _$PosicionContextoCopyWith<$Res> implements $PosicionContextoCopyWith<$Res> {
  factory _$PosicionContextoCopyWith(_PosicionContexto value, $Res Function(_PosicionContexto) _then) = __$PosicionContextoCopyWithImpl;
@override @useResult
$Res call({
 String id, String etiqueta, String? puesto, String unidad, String? area, String estatus,@JsonKey(name: 'estatus_code') String estatusCode, bool ocupada,@JsonKey(name: 'tramite_abierto') TramiteAbierto? tramiteAbierto, String? empresa,@JsonKey(name: 'reporta_a') String? reportaA
});


@override $TramiteAbiertoCopyWith<$Res>? get tramiteAbierto;

}
/// @nodoc
class __$PosicionContextoCopyWithImpl<$Res>
    implements _$PosicionContextoCopyWith<$Res> {
  __$PosicionContextoCopyWithImpl(this._self, this._then);

  final _PosicionContexto _self;
  final $Res Function(_PosicionContexto) _then;

/// Create a copy of PosicionContexto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? etiqueta = null,Object? puesto = freezed,Object? unidad = null,Object? area = freezed,Object? estatus = null,Object? estatusCode = null,Object? ocupada = null,Object? tramiteAbierto = freezed,Object? empresa = freezed,Object? reportaA = freezed,}) {
  return _then(_PosicionContexto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,etiqueta: null == etiqueta ? _self.etiqueta : etiqueta // ignore: cast_nullable_to_non_nullable
as String,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as String?,unidad: null == unidad ? _self.unidad : unidad // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as String,estatusCode: null == estatusCode ? _self.estatusCode : estatusCode // ignore: cast_nullable_to_non_nullable
as String,ocupada: null == ocupada ? _self.ocupada : ocupada // ignore: cast_nullable_to_non_nullable
as bool,tramiteAbierto: freezed == tramiteAbierto ? _self.tramiteAbierto : tramiteAbierto // ignore: cast_nullable_to_non_nullable
as TramiteAbierto?,empresa: freezed == empresa ? _self.empresa : empresa // ignore: cast_nullable_to_non_nullable
as String?,reportaA: freezed == reportaA ? _self.reportaA : reportaA // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PosicionContexto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TramiteAbiertoCopyWith<$Res>? get tramiteAbierto {
    if (_self.tramiteAbierto == null) {
    return null;
  }

  return $TramiteAbiertoCopyWith<$Res>(_self.tramiteAbierto!, (value) {
    return _then(_self.copyWith(tramiteAbierto: value));
  });
}
}


/// @nodoc
mixin _$Aprobacion {

 String get id; String get requisicion; int get etapa; String? get fecha; String? get usuario;@JsonKey(name: 'nombre_manual') String get nombreManual;
/// Create a copy of Aprobacion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AprobacionCopyWith<Aprobacion> get copyWith => _$AprobacionCopyWithImpl<Aprobacion>(this as Aprobacion, _$identity);

  /// Serializes this Aprobacion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Aprobacion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Aprobacion&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.requisicion, _this.requisicion) || other.requisicion == _this.requisicion)&&(identical(other.etapa, _this.etapa) || other.etapa == _this.etapa)&&(identical(other.fecha, _this.fecha) || other.fecha == _this.fecha)&&(identical(other.usuario, _this.usuario) || other.usuario == _this.usuario)&&(identical(other.nombreManual, _this.nombreManual) || other.nombreManual == _this.nombreManual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Aprobacion;
  return Object.hash(runtimeType,_this.id,_this.requisicion,_this.etapa,_this.fecha,_this.usuario,_this.nombreManual);
}

@override
String toString() {
  final _this = this as Aprobacion;
  return 'Aprobacion(id: ${_this.id}, requisicion: ${_this.requisicion}, etapa: ${_this.etapa}, fecha: ${_this.fecha}, usuario: ${_this.usuario}, nombreManual: ${_this.nombreManual})';
}


}

/// @nodoc
abstract mixin class $AprobacionCopyWith<$Res>  {
  factory $AprobacionCopyWith(Aprobacion value, $Res Function(Aprobacion) _then) = _$AprobacionCopyWithImpl;
@useResult
$Res call({
 String id, String requisicion, int etapa, String? fecha, String? usuario,@JsonKey(name: 'nombre_manual') String nombreManual
});




}
/// @nodoc
class _$AprobacionCopyWithImpl<$Res>
    implements $AprobacionCopyWith<$Res> {
  _$AprobacionCopyWithImpl(this._self, this._then);

  final Aprobacion _self;
  final $Res Function(Aprobacion) _then;

/// Create a copy of Aprobacion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requisicion = null,Object? etapa = null,Object? fecha = freezed,Object? usuario = freezed,Object? nombreManual = null,}) {
  return _then(Aprobacion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requisicion: null == requisicion ? _self.requisicion : requisicion // ignore: cast_nullable_to_non_nullable
as String,etapa: null == etapa ? _self.etapa : etapa // ignore: cast_nullable_to_non_nullable
as int,fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,usuario: freezed == usuario ? _self.usuario : usuario // ignore: cast_nullable_to_non_nullable
as String?,nombreManual: null == nombreManual ? _self.nombreManual : nombreManual // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Aprobacion].
extension AprobacionPatterns on Aprobacion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Aprobacion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Aprobacion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Aprobacion value)  $default,){
final _that = this;
switch (_that) {
case _Aprobacion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Aprobacion value)?  $default,){
final _that = this;
switch (_that) {
case _Aprobacion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requisicion,  int etapa,  String? fecha,  String? usuario, @JsonKey(name: 'nombre_manual')  String nombreManual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Aprobacion() when $default != null:
return $default(_that.id,_that.requisicion,_that.etapa,_that.fecha,_that.usuario,_that.nombreManual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requisicion,  int etapa,  String? fecha,  String? usuario, @JsonKey(name: 'nombre_manual')  String nombreManual)  $default,) {final _that = this;
switch (_that) {
case _Aprobacion():
return $default(_that.id,_that.requisicion,_that.etapa,_that.fecha,_that.usuario,_that.nombreManual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requisicion,  int etapa,  String? fecha,  String? usuario, @JsonKey(name: 'nombre_manual')  String nombreManual)?  $default,) {final _that = this;
switch (_that) {
case _Aprobacion() when $default != null:
return $default(_that.id,_that.requisicion,_that.etapa,_that.fecha,_that.usuario,_that.nombreManual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Aprobacion implements Aprobacion {
  const _Aprobacion({required this.id, required this.requisicion, required this.etapa, this.fecha, this.usuario, @JsonKey(name: 'nombre_manual') this.nombreManual = ''});
  factory _Aprobacion.fromJson(Map<String, dynamic> json) => _$AprobacionFromJson(json);

@override final  String id;
@override final  String requisicion;
@override final  int etapa;
@override final  String? fecha;
@override final  String? usuario;
@override@JsonKey(name: 'nombre_manual') final  String nombreManual;

/// Create a copy of Aprobacion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AprobacionCopyWith<_Aprobacion> get copyWith => __$AprobacionCopyWithImpl<_Aprobacion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AprobacionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Aprobacion&&(identical(other.id, id) || other.id == id)&&(identical(other.requisicion, requisicion) || other.requisicion == requisicion)&&(identical(other.etapa, etapa) || other.etapa == etapa)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.usuario, usuario) || other.usuario == usuario)&&(identical(other.nombreManual, nombreManual) || other.nombreManual == nombreManual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,requisicion,etapa,fecha,usuario,nombreManual);
}

@override
String toString() {
    return 'Aprobacion(id: $id, requisicion: $requisicion, etapa: $etapa, fecha: $fecha, usuario: $usuario, nombreManual: $nombreManual)';
}


}

/// @nodoc
abstract mixin class _$AprobacionCopyWith<$Res> implements $AprobacionCopyWith<$Res> {
  factory _$AprobacionCopyWith(_Aprobacion value, $Res Function(_Aprobacion) _then) = __$AprobacionCopyWithImpl;
@override @useResult
$Res call({
 String id, String requisicion, int etapa, String? fecha, String? usuario,@JsonKey(name: 'nombre_manual') String nombreManual
});




}
/// @nodoc
class __$AprobacionCopyWithImpl<$Res>
    implements _$AprobacionCopyWith<$Res> {
  __$AprobacionCopyWithImpl(this._self, this._then);

  final _Aprobacion _self;
  final $Res Function(_Aprobacion) _then;

/// Create a copy of Aprobacion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requisicion = null,Object? etapa = null,Object? fecha = freezed,Object? usuario = freezed,Object? nombreManual = null,}) {
  return _then(_Aprobacion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requisicion: null == requisicion ? _self.requisicion : requisicion // ignore: cast_nullable_to_non_nullable
as String,etapa: null == etapa ? _self.etapa : etapa // ignore: cast_nullable_to_non_nullable
as int,fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,usuario: freezed == usuario ? _self.usuario : usuario // ignore: cast_nullable_to_non_nullable
as String?,nombreManual: null == nombreManual ? _self.nombreManual : nombreManual // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Requisicion {

 String get id; String get posicion;@JsonKey(name: 'posicion_etiqueta') String get posicionEtiqueta; int get tipo; int get estado;@JsonKey(name: 'creado_por') String? get creadoPor; String? get solicitante;@JsonKey(name: 'fecha_solicitud') String get fechaSolicitud;@JsonKey(name: 'fecha_a_cubrir_vacante') String? get fechaACubrirVacante;@JsonKey(name: 'fecha_entrega_a_capital_humano') String? get fechaEntregaACapitalHumano;@JsonKey(name: 'area_solicitante') String get areaSolicitante; String get justificacion;@JsonKey(name: 'horario_a_cubrir') int? get horarioACubrir;@JsonKey(name: 'idiomas_requeridos') String get idiomasRequeridos;@JsonKey(name: 'disposicion_viajar') bool? get disposicionViajar;@JsonKey(name: 'nivel_tabulador') String get nivelTabulador;@JsonKey(name: 'sueldo_mensual_compuesto') String? get sueldoMensualCompuesto;@JsonKey(name: 'sueldo_mensual_bruto') String? get sueldoMensualBruto;@JsonKey(name: 'sueldo_mensual_neto') String? get sueldoMensualNeto;@JsonKey(name: 'tipo_contrato_ofrecido') int? get tipoContratoOfrecido;@JsonKey(name: 'motivo_suspension') String get motivoSuspension;@JsonKey(name: 'fecha_suspension') String? get fechaSuspension;@JsonKey(name: 'autorizado_por_suspension') String get autorizadoPorSuspension; List<Aprobacion> get aprobaciones;
/// Create a copy of Requisicion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequisicionCopyWith<Requisicion> get copyWith => _$RequisicionCopyWithImpl<Requisicion>(this as Requisicion, _$identity);

  /// Serializes this Requisicion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Requisicion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Requisicion&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.posicion, _this.posicion) || other.posicion == _this.posicion)&&(identical(other.posicionEtiqueta, _this.posicionEtiqueta) || other.posicionEtiqueta == _this.posicionEtiqueta)&&(identical(other.tipo, _this.tipo) || other.tipo == _this.tipo)&&(identical(other.estado, _this.estado) || other.estado == _this.estado)&&(identical(other.creadoPor, _this.creadoPor) || other.creadoPor == _this.creadoPor)&&(identical(other.solicitante, _this.solicitante) || other.solicitante == _this.solicitante)&&(identical(other.fechaSolicitud, _this.fechaSolicitud) || other.fechaSolicitud == _this.fechaSolicitud)&&(identical(other.fechaACubrirVacante, _this.fechaACubrirVacante) || other.fechaACubrirVacante == _this.fechaACubrirVacante)&&(identical(other.fechaEntregaACapitalHumano, _this.fechaEntregaACapitalHumano) || other.fechaEntregaACapitalHumano == _this.fechaEntregaACapitalHumano)&&(identical(other.areaSolicitante, _this.areaSolicitante) || other.areaSolicitante == _this.areaSolicitante)&&(identical(other.justificacion, _this.justificacion) || other.justificacion == _this.justificacion)&&(identical(other.horarioACubrir, _this.horarioACubrir) || other.horarioACubrir == _this.horarioACubrir)&&(identical(other.idiomasRequeridos, _this.idiomasRequeridos) || other.idiomasRequeridos == _this.idiomasRequeridos)&&(identical(other.disposicionViajar, _this.disposicionViajar) || other.disposicionViajar == _this.disposicionViajar)&&(identical(other.nivelTabulador, _this.nivelTabulador) || other.nivelTabulador == _this.nivelTabulador)&&(identical(other.sueldoMensualCompuesto, _this.sueldoMensualCompuesto) || other.sueldoMensualCompuesto == _this.sueldoMensualCompuesto)&&(identical(other.sueldoMensualBruto, _this.sueldoMensualBruto) || other.sueldoMensualBruto == _this.sueldoMensualBruto)&&(identical(other.sueldoMensualNeto, _this.sueldoMensualNeto) || other.sueldoMensualNeto == _this.sueldoMensualNeto)&&(identical(other.tipoContratoOfrecido, _this.tipoContratoOfrecido) || other.tipoContratoOfrecido == _this.tipoContratoOfrecido)&&(identical(other.motivoSuspension, _this.motivoSuspension) || other.motivoSuspension == _this.motivoSuspension)&&(identical(other.fechaSuspension, _this.fechaSuspension) || other.fechaSuspension == _this.fechaSuspension)&&(identical(other.autorizadoPorSuspension, _this.autorizadoPorSuspension) || other.autorizadoPorSuspension == _this.autorizadoPorSuspension)&&const DeepCollectionEquality().equals(other.aprobaciones, _this.aprobaciones));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Requisicion;
  return Object.hashAll([runtimeType,_this.id,_this.posicion,_this.posicionEtiqueta,_this.tipo,_this.estado,_this.creadoPor,_this.solicitante,_this.fechaSolicitud,_this.fechaACubrirVacante,_this.fechaEntregaACapitalHumano,_this.areaSolicitante,_this.justificacion,_this.horarioACubrir,_this.idiomasRequeridos,_this.disposicionViajar,_this.nivelTabulador,_this.sueldoMensualCompuesto,_this.sueldoMensualBruto,_this.sueldoMensualNeto,_this.tipoContratoOfrecido,_this.motivoSuspension,_this.fechaSuspension,_this.autorizadoPorSuspension,const DeepCollectionEquality().hash(_this.aprobaciones)]);
}

@override
String toString() {
  final _this = this as Requisicion;
  return 'Requisicion(id: ${_this.id}, posicion: ${_this.posicion}, posicionEtiqueta: ${_this.posicionEtiqueta}, tipo: ${_this.tipo}, estado: ${_this.estado}, creadoPor: ${_this.creadoPor}, solicitante: ${_this.solicitante}, fechaSolicitud: ${_this.fechaSolicitud}, fechaACubrirVacante: ${_this.fechaACubrirVacante}, fechaEntregaACapitalHumano: ${_this.fechaEntregaACapitalHumano}, areaSolicitante: ${_this.areaSolicitante}, justificacion: ${_this.justificacion}, horarioACubrir: ${_this.horarioACubrir}, idiomasRequeridos: ${_this.idiomasRequeridos}, disposicionViajar: ${_this.disposicionViajar}, nivelTabulador: ${_this.nivelTabulador}, sueldoMensualCompuesto: ${_this.sueldoMensualCompuesto}, sueldoMensualBruto: ${_this.sueldoMensualBruto}, sueldoMensualNeto: ${_this.sueldoMensualNeto}, tipoContratoOfrecido: ${_this.tipoContratoOfrecido}, motivoSuspension: ${_this.motivoSuspension}, fechaSuspension: ${_this.fechaSuspension}, autorizadoPorSuspension: ${_this.autorizadoPorSuspension}, aprobaciones: ${_this.aprobaciones})';
}


}

/// @nodoc
abstract mixin class $RequisicionCopyWith<$Res>  {
  factory $RequisicionCopyWith(Requisicion value, $Res Function(Requisicion) _then) = _$RequisicionCopyWithImpl;
@useResult
$Res call({
 String id, String posicion,@JsonKey(name: 'posicion_etiqueta') String posicionEtiqueta, int tipo, int estado,@JsonKey(name: 'creado_por') String? creadoPor, String? solicitante,@JsonKey(name: 'fecha_solicitud') String fechaSolicitud,@JsonKey(name: 'fecha_a_cubrir_vacante') String? fechaACubrirVacante,@JsonKey(name: 'fecha_entrega_a_capital_humano') String? fechaEntregaACapitalHumano,@JsonKey(name: 'area_solicitante') String areaSolicitante, String justificacion,@JsonKey(name: 'horario_a_cubrir') int? horarioACubrir,@JsonKey(name: 'idiomas_requeridos') String idiomasRequeridos,@JsonKey(name: 'disposicion_viajar') bool? disposicionViajar,@JsonKey(name: 'nivel_tabulador') String nivelTabulador,@JsonKey(name: 'sueldo_mensual_compuesto') String? sueldoMensualCompuesto,@JsonKey(name: 'sueldo_mensual_bruto') String? sueldoMensualBruto,@JsonKey(name: 'sueldo_mensual_neto') String? sueldoMensualNeto,@JsonKey(name: 'tipo_contrato_ofrecido') int? tipoContratoOfrecido,@JsonKey(name: 'motivo_suspension') String motivoSuspension,@JsonKey(name: 'fecha_suspension') String? fechaSuspension,@JsonKey(name: 'autorizado_por_suspension') String autorizadoPorSuspension, List<Aprobacion> aprobaciones
});




}
/// @nodoc
class _$RequisicionCopyWithImpl<$Res>
    implements $RequisicionCopyWith<$Res> {
  _$RequisicionCopyWithImpl(this._self, this._then);

  final Requisicion _self;
  final $Res Function(Requisicion) _then;

/// Create a copy of Requisicion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? posicion = null,Object? posicionEtiqueta = null,Object? tipo = null,Object? estado = null,Object? creadoPor = freezed,Object? solicitante = freezed,Object? fechaSolicitud = null,Object? fechaACubrirVacante = freezed,Object? fechaEntregaACapitalHumano = freezed,Object? areaSolicitante = null,Object? justificacion = null,Object? horarioACubrir = freezed,Object? idiomasRequeridos = null,Object? disposicionViajar = freezed,Object? nivelTabulador = null,Object? sueldoMensualCompuesto = freezed,Object? sueldoMensualBruto = freezed,Object? sueldoMensualNeto = freezed,Object? tipoContratoOfrecido = freezed,Object? motivoSuspension = null,Object? fechaSuspension = freezed,Object? autorizadoPorSuspension = null,Object? aprobaciones = null,}) {
  return _then(Requisicion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,posicion: null == posicion ? _self.posicion : posicion // ignore: cast_nullable_to_non_nullable
as String,posicionEtiqueta: null == posicionEtiqueta ? _self.posicionEtiqueta : posicionEtiqueta // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as int,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as int,creadoPor: freezed == creadoPor ? _self.creadoPor : creadoPor // ignore: cast_nullable_to_non_nullable
as String?,solicitante: freezed == solicitante ? _self.solicitante : solicitante // ignore: cast_nullable_to_non_nullable
as String?,fechaSolicitud: null == fechaSolicitud ? _self.fechaSolicitud : fechaSolicitud // ignore: cast_nullable_to_non_nullable
as String,fechaACubrirVacante: freezed == fechaACubrirVacante ? _self.fechaACubrirVacante : fechaACubrirVacante // ignore: cast_nullable_to_non_nullable
as String?,fechaEntregaACapitalHumano: freezed == fechaEntregaACapitalHumano ? _self.fechaEntregaACapitalHumano : fechaEntregaACapitalHumano // ignore: cast_nullable_to_non_nullable
as String?,areaSolicitante: null == areaSolicitante ? _self.areaSolicitante : areaSolicitante // ignore: cast_nullable_to_non_nullable
as String,justificacion: null == justificacion ? _self.justificacion : justificacion // ignore: cast_nullable_to_non_nullable
as String,horarioACubrir: freezed == horarioACubrir ? _self.horarioACubrir : horarioACubrir // ignore: cast_nullable_to_non_nullable
as int?,idiomasRequeridos: null == idiomasRequeridos ? _self.idiomasRequeridos : idiomasRequeridos // ignore: cast_nullable_to_non_nullable
as String,disposicionViajar: freezed == disposicionViajar ? _self.disposicionViajar : disposicionViajar // ignore: cast_nullable_to_non_nullable
as bool?,nivelTabulador: null == nivelTabulador ? _self.nivelTabulador : nivelTabulador // ignore: cast_nullable_to_non_nullable
as String,sueldoMensualCompuesto: freezed == sueldoMensualCompuesto ? _self.sueldoMensualCompuesto : sueldoMensualCompuesto // ignore: cast_nullable_to_non_nullable
as String?,sueldoMensualBruto: freezed == sueldoMensualBruto ? _self.sueldoMensualBruto : sueldoMensualBruto // ignore: cast_nullable_to_non_nullable
as String?,sueldoMensualNeto: freezed == sueldoMensualNeto ? _self.sueldoMensualNeto : sueldoMensualNeto // ignore: cast_nullable_to_non_nullable
as String?,tipoContratoOfrecido: freezed == tipoContratoOfrecido ? _self.tipoContratoOfrecido : tipoContratoOfrecido // ignore: cast_nullable_to_non_nullable
as int?,motivoSuspension: null == motivoSuspension ? _self.motivoSuspension : motivoSuspension // ignore: cast_nullable_to_non_nullable
as String,fechaSuspension: freezed == fechaSuspension ? _self.fechaSuspension : fechaSuspension // ignore: cast_nullable_to_non_nullable
as String?,autorizadoPorSuspension: null == autorizadoPorSuspension ? _self.autorizadoPorSuspension : autorizadoPorSuspension // ignore: cast_nullable_to_non_nullable
as String,aprobaciones: null == aprobaciones ? _self.aprobaciones : aprobaciones // ignore: cast_nullable_to_non_nullable
as List<Aprobacion>,
  ));
}

}


/// Adds pattern-matching-related methods to [Requisicion].
extension RequisicionPatterns on Requisicion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Requisicion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Requisicion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Requisicion value)  $default,){
final _that = this;
switch (_that) {
case _Requisicion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Requisicion value)?  $default,){
final _that = this;
switch (_that) {
case _Requisicion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String posicion, @JsonKey(name: 'posicion_etiqueta')  String posicionEtiqueta,  int tipo,  int estado, @JsonKey(name: 'creado_por')  String? creadoPor,  String? solicitante, @JsonKey(name: 'fecha_solicitud')  String fechaSolicitud, @JsonKey(name: 'fecha_a_cubrir_vacante')  String? fechaACubrirVacante, @JsonKey(name: 'fecha_entrega_a_capital_humano')  String? fechaEntregaACapitalHumano, @JsonKey(name: 'area_solicitante')  String areaSolicitante,  String justificacion, @JsonKey(name: 'horario_a_cubrir')  int? horarioACubrir, @JsonKey(name: 'idiomas_requeridos')  String idiomasRequeridos, @JsonKey(name: 'disposicion_viajar')  bool? disposicionViajar, @JsonKey(name: 'nivel_tabulador')  String nivelTabulador, @JsonKey(name: 'sueldo_mensual_compuesto')  String? sueldoMensualCompuesto, @JsonKey(name: 'sueldo_mensual_bruto')  String? sueldoMensualBruto, @JsonKey(name: 'sueldo_mensual_neto')  String? sueldoMensualNeto, @JsonKey(name: 'tipo_contrato_ofrecido')  int? tipoContratoOfrecido, @JsonKey(name: 'motivo_suspension')  String motivoSuspension, @JsonKey(name: 'fecha_suspension')  String? fechaSuspension, @JsonKey(name: 'autorizado_por_suspension')  String autorizadoPorSuspension,  List<Aprobacion> aprobaciones)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Requisicion() when $default != null:
return $default(_that.id,_that.posicion,_that.posicionEtiqueta,_that.tipo,_that.estado,_that.creadoPor,_that.solicitante,_that.fechaSolicitud,_that.fechaACubrirVacante,_that.fechaEntregaACapitalHumano,_that.areaSolicitante,_that.justificacion,_that.horarioACubrir,_that.idiomasRequeridos,_that.disposicionViajar,_that.nivelTabulador,_that.sueldoMensualCompuesto,_that.sueldoMensualBruto,_that.sueldoMensualNeto,_that.tipoContratoOfrecido,_that.motivoSuspension,_that.fechaSuspension,_that.autorizadoPorSuspension,_that.aprobaciones);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String posicion, @JsonKey(name: 'posicion_etiqueta')  String posicionEtiqueta,  int tipo,  int estado, @JsonKey(name: 'creado_por')  String? creadoPor,  String? solicitante, @JsonKey(name: 'fecha_solicitud')  String fechaSolicitud, @JsonKey(name: 'fecha_a_cubrir_vacante')  String? fechaACubrirVacante, @JsonKey(name: 'fecha_entrega_a_capital_humano')  String? fechaEntregaACapitalHumano, @JsonKey(name: 'area_solicitante')  String areaSolicitante,  String justificacion, @JsonKey(name: 'horario_a_cubrir')  int? horarioACubrir, @JsonKey(name: 'idiomas_requeridos')  String idiomasRequeridos, @JsonKey(name: 'disposicion_viajar')  bool? disposicionViajar, @JsonKey(name: 'nivel_tabulador')  String nivelTabulador, @JsonKey(name: 'sueldo_mensual_compuesto')  String? sueldoMensualCompuesto, @JsonKey(name: 'sueldo_mensual_bruto')  String? sueldoMensualBruto, @JsonKey(name: 'sueldo_mensual_neto')  String? sueldoMensualNeto, @JsonKey(name: 'tipo_contrato_ofrecido')  int? tipoContratoOfrecido, @JsonKey(name: 'motivo_suspension')  String motivoSuspension, @JsonKey(name: 'fecha_suspension')  String? fechaSuspension, @JsonKey(name: 'autorizado_por_suspension')  String autorizadoPorSuspension,  List<Aprobacion> aprobaciones)  $default,) {final _that = this;
switch (_that) {
case _Requisicion():
return $default(_that.id,_that.posicion,_that.posicionEtiqueta,_that.tipo,_that.estado,_that.creadoPor,_that.solicitante,_that.fechaSolicitud,_that.fechaACubrirVacante,_that.fechaEntregaACapitalHumano,_that.areaSolicitante,_that.justificacion,_that.horarioACubrir,_that.idiomasRequeridos,_that.disposicionViajar,_that.nivelTabulador,_that.sueldoMensualCompuesto,_that.sueldoMensualBruto,_that.sueldoMensualNeto,_that.tipoContratoOfrecido,_that.motivoSuspension,_that.fechaSuspension,_that.autorizadoPorSuspension,_that.aprobaciones);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String posicion, @JsonKey(name: 'posicion_etiqueta')  String posicionEtiqueta,  int tipo,  int estado, @JsonKey(name: 'creado_por')  String? creadoPor,  String? solicitante, @JsonKey(name: 'fecha_solicitud')  String fechaSolicitud, @JsonKey(name: 'fecha_a_cubrir_vacante')  String? fechaACubrirVacante, @JsonKey(name: 'fecha_entrega_a_capital_humano')  String? fechaEntregaACapitalHumano, @JsonKey(name: 'area_solicitante')  String areaSolicitante,  String justificacion, @JsonKey(name: 'horario_a_cubrir')  int? horarioACubrir, @JsonKey(name: 'idiomas_requeridos')  String idiomasRequeridos, @JsonKey(name: 'disposicion_viajar')  bool? disposicionViajar, @JsonKey(name: 'nivel_tabulador')  String nivelTabulador, @JsonKey(name: 'sueldo_mensual_compuesto')  String? sueldoMensualCompuesto, @JsonKey(name: 'sueldo_mensual_bruto')  String? sueldoMensualBruto, @JsonKey(name: 'sueldo_mensual_neto')  String? sueldoMensualNeto, @JsonKey(name: 'tipo_contrato_ofrecido')  int? tipoContratoOfrecido, @JsonKey(name: 'motivo_suspension')  String motivoSuspension, @JsonKey(name: 'fecha_suspension')  String? fechaSuspension, @JsonKey(name: 'autorizado_por_suspension')  String autorizadoPorSuspension,  List<Aprobacion> aprobaciones)?  $default,) {final _that = this;
switch (_that) {
case _Requisicion() when $default != null:
return $default(_that.id,_that.posicion,_that.posicionEtiqueta,_that.tipo,_that.estado,_that.creadoPor,_that.solicitante,_that.fechaSolicitud,_that.fechaACubrirVacante,_that.fechaEntregaACapitalHumano,_that.areaSolicitante,_that.justificacion,_that.horarioACubrir,_that.idiomasRequeridos,_that.disposicionViajar,_that.nivelTabulador,_that.sueldoMensualCompuesto,_that.sueldoMensualBruto,_that.sueldoMensualNeto,_that.tipoContratoOfrecido,_that.motivoSuspension,_that.fechaSuspension,_that.autorizadoPorSuspension,_that.aprobaciones);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Requisicion extends Requisicion {
  const _Requisicion({required this.id, required this.posicion, @JsonKey(name: 'posicion_etiqueta') this.posicionEtiqueta = '', required this.tipo, required this.estado, @JsonKey(name: 'creado_por') this.creadoPor, this.solicitante, @JsonKey(name: 'fecha_solicitud') required this.fechaSolicitud, @JsonKey(name: 'fecha_a_cubrir_vacante') this.fechaACubrirVacante, @JsonKey(name: 'fecha_entrega_a_capital_humano') this.fechaEntregaACapitalHumano, @JsonKey(name: 'area_solicitante') this.areaSolicitante = '', this.justificacion = '', @JsonKey(name: 'horario_a_cubrir') this.horarioACubrir, @JsonKey(name: 'idiomas_requeridos') this.idiomasRequeridos = '', @JsonKey(name: 'disposicion_viajar') this.disposicionViajar, @JsonKey(name: 'nivel_tabulador') this.nivelTabulador = '', @JsonKey(name: 'sueldo_mensual_compuesto') this.sueldoMensualCompuesto, @JsonKey(name: 'sueldo_mensual_bruto') this.sueldoMensualBruto, @JsonKey(name: 'sueldo_mensual_neto') this.sueldoMensualNeto, @JsonKey(name: 'tipo_contrato_ofrecido') this.tipoContratoOfrecido, @JsonKey(name: 'motivo_suspension') this.motivoSuspension = '', @JsonKey(name: 'fecha_suspension') this.fechaSuspension, @JsonKey(name: 'autorizado_por_suspension') this.autorizadoPorSuspension = '',  List<Aprobacion> aprobaciones = const <Aprobacion>[]}): _aprobaciones = aprobaciones,super._();
  factory _Requisicion.fromJson(Map<String, dynamic> json) => _$RequisicionFromJson(json);

@override final  String id;
@override final  String posicion;
@override@JsonKey(name: 'posicion_etiqueta') final  String posicionEtiqueta;
@override final  int tipo;
@override final  int estado;
@override@JsonKey(name: 'creado_por') final  String? creadoPor;
@override final  String? solicitante;
@override@JsonKey(name: 'fecha_solicitud') final  String fechaSolicitud;
@override@JsonKey(name: 'fecha_a_cubrir_vacante') final  String? fechaACubrirVacante;
@override@JsonKey(name: 'fecha_entrega_a_capital_humano') final  String? fechaEntregaACapitalHumano;
@override@JsonKey(name: 'area_solicitante') final  String areaSolicitante;
@override@JsonKey() final  String justificacion;
@override@JsonKey(name: 'horario_a_cubrir') final  int? horarioACubrir;
@override@JsonKey(name: 'idiomas_requeridos') final  String idiomasRequeridos;
@override@JsonKey(name: 'disposicion_viajar') final  bool? disposicionViajar;
@override@JsonKey(name: 'nivel_tabulador') final  String nivelTabulador;
@override@JsonKey(name: 'sueldo_mensual_compuesto') final  String? sueldoMensualCompuesto;
@override@JsonKey(name: 'sueldo_mensual_bruto') final  String? sueldoMensualBruto;
@override@JsonKey(name: 'sueldo_mensual_neto') final  String? sueldoMensualNeto;
@override@JsonKey(name: 'tipo_contrato_ofrecido') final  int? tipoContratoOfrecido;
@override@JsonKey(name: 'motivo_suspension') final  String motivoSuspension;
@override@JsonKey(name: 'fecha_suspension') final  String? fechaSuspension;
@override@JsonKey(name: 'autorizado_por_suspension') final  String autorizadoPorSuspension;
 final  List<Aprobacion> _aprobaciones;
@override@JsonKey() List<Aprobacion> get aprobaciones {
  if (_aprobaciones is EqualUnmodifiableListView) return _aprobaciones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aprobaciones);
}


/// Create a copy of Requisicion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequisicionCopyWith<_Requisicion> get copyWith => __$RequisicionCopyWithImpl<_Requisicion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequisicionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Requisicion&&(identical(other.id, id) || other.id == id)&&(identical(other.posicion, posicion) || other.posicion == posicion)&&(identical(other.posicionEtiqueta, posicionEtiqueta) || other.posicionEtiqueta == posicionEtiqueta)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.creadoPor, creadoPor) || other.creadoPor == creadoPor)&&(identical(other.solicitante, solicitante) || other.solicitante == solicitante)&&(identical(other.fechaSolicitud, fechaSolicitud) || other.fechaSolicitud == fechaSolicitud)&&(identical(other.fechaACubrirVacante, fechaACubrirVacante) || other.fechaACubrirVacante == fechaACubrirVacante)&&(identical(other.fechaEntregaACapitalHumano, fechaEntregaACapitalHumano) || other.fechaEntregaACapitalHumano == fechaEntregaACapitalHumano)&&(identical(other.areaSolicitante, areaSolicitante) || other.areaSolicitante == areaSolicitante)&&(identical(other.justificacion, justificacion) || other.justificacion == justificacion)&&(identical(other.horarioACubrir, horarioACubrir) || other.horarioACubrir == horarioACubrir)&&(identical(other.idiomasRequeridos, idiomasRequeridos) || other.idiomasRequeridos == idiomasRequeridos)&&(identical(other.disposicionViajar, disposicionViajar) || other.disposicionViajar == disposicionViajar)&&(identical(other.nivelTabulador, nivelTabulador) || other.nivelTabulador == nivelTabulador)&&(identical(other.sueldoMensualCompuesto, sueldoMensualCompuesto) || other.sueldoMensualCompuesto == sueldoMensualCompuesto)&&(identical(other.sueldoMensualBruto, sueldoMensualBruto) || other.sueldoMensualBruto == sueldoMensualBruto)&&(identical(other.sueldoMensualNeto, sueldoMensualNeto) || other.sueldoMensualNeto == sueldoMensualNeto)&&(identical(other.tipoContratoOfrecido, tipoContratoOfrecido) || other.tipoContratoOfrecido == tipoContratoOfrecido)&&(identical(other.motivoSuspension, motivoSuspension) || other.motivoSuspension == motivoSuspension)&&(identical(other.fechaSuspension, fechaSuspension) || other.fechaSuspension == fechaSuspension)&&(identical(other.autorizadoPorSuspension, autorizadoPorSuspension) || other.autorizadoPorSuspension == autorizadoPorSuspension)&&const DeepCollectionEquality().equals(other.aprobaciones, _aprobaciones));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,posicion,posicionEtiqueta,tipo,estado,creadoPor,solicitante,fechaSolicitud,fechaACubrirVacante,fechaEntregaACapitalHumano,areaSolicitante,justificacion,horarioACubrir,idiomasRequeridos,disposicionViajar,nivelTabulador,sueldoMensualCompuesto,sueldoMensualBruto,sueldoMensualNeto,tipoContratoOfrecido,motivoSuspension,fechaSuspension,autorizadoPorSuspension,const DeepCollectionEquality().hash(_aprobaciones)]);
}

@override
String toString() {
    return 'Requisicion(id: $id, posicion: $posicion, posicionEtiqueta: $posicionEtiqueta, tipo: $tipo, estado: $estado, creadoPor: $creadoPor, solicitante: $solicitante, fechaSolicitud: $fechaSolicitud, fechaACubrirVacante: $fechaACubrirVacante, fechaEntregaACapitalHumano: $fechaEntregaACapitalHumano, areaSolicitante: $areaSolicitante, justificacion: $justificacion, horarioACubrir: $horarioACubrir, idiomasRequeridos: $idiomasRequeridos, disposicionViajar: $disposicionViajar, nivelTabulador: $nivelTabulador, sueldoMensualCompuesto: $sueldoMensualCompuesto, sueldoMensualBruto: $sueldoMensualBruto, sueldoMensualNeto: $sueldoMensualNeto, tipoContratoOfrecido: $tipoContratoOfrecido, motivoSuspension: $motivoSuspension, fechaSuspension: $fechaSuspension, autorizadoPorSuspension: $autorizadoPorSuspension, aprobaciones: $aprobaciones)';
}


}

/// @nodoc
abstract mixin class _$RequisicionCopyWith<$Res> implements $RequisicionCopyWith<$Res> {
  factory _$RequisicionCopyWith(_Requisicion value, $Res Function(_Requisicion) _then) = __$RequisicionCopyWithImpl;
@override @useResult
$Res call({
 String id, String posicion,@JsonKey(name: 'posicion_etiqueta') String posicionEtiqueta, int tipo, int estado,@JsonKey(name: 'creado_por') String? creadoPor, String? solicitante,@JsonKey(name: 'fecha_solicitud') String fechaSolicitud,@JsonKey(name: 'fecha_a_cubrir_vacante') String? fechaACubrirVacante,@JsonKey(name: 'fecha_entrega_a_capital_humano') String? fechaEntregaACapitalHumano,@JsonKey(name: 'area_solicitante') String areaSolicitante, String justificacion,@JsonKey(name: 'horario_a_cubrir') int? horarioACubrir,@JsonKey(name: 'idiomas_requeridos') String idiomasRequeridos,@JsonKey(name: 'disposicion_viajar') bool? disposicionViajar,@JsonKey(name: 'nivel_tabulador') String nivelTabulador,@JsonKey(name: 'sueldo_mensual_compuesto') String? sueldoMensualCompuesto,@JsonKey(name: 'sueldo_mensual_bruto') String? sueldoMensualBruto,@JsonKey(name: 'sueldo_mensual_neto') String? sueldoMensualNeto,@JsonKey(name: 'tipo_contrato_ofrecido') int? tipoContratoOfrecido,@JsonKey(name: 'motivo_suspension') String motivoSuspension,@JsonKey(name: 'fecha_suspension') String? fechaSuspension,@JsonKey(name: 'autorizado_por_suspension') String autorizadoPorSuspension, List<Aprobacion> aprobaciones
});




}
/// @nodoc
class __$RequisicionCopyWithImpl<$Res>
    implements _$RequisicionCopyWith<$Res> {
  __$RequisicionCopyWithImpl(this._self, this._then);

  final _Requisicion _self;
  final $Res Function(_Requisicion) _then;

/// Create a copy of Requisicion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? posicion = null,Object? posicionEtiqueta = null,Object? tipo = null,Object? estado = null,Object? creadoPor = freezed,Object? solicitante = freezed,Object? fechaSolicitud = null,Object? fechaACubrirVacante = freezed,Object? fechaEntregaACapitalHumano = freezed,Object? areaSolicitante = null,Object? justificacion = null,Object? horarioACubrir = freezed,Object? idiomasRequeridos = null,Object? disposicionViajar = freezed,Object? nivelTabulador = null,Object? sueldoMensualCompuesto = freezed,Object? sueldoMensualBruto = freezed,Object? sueldoMensualNeto = freezed,Object? tipoContratoOfrecido = freezed,Object? motivoSuspension = null,Object? fechaSuspension = freezed,Object? autorizadoPorSuspension = null,Object? aprobaciones = null,}) {
  return _then(_Requisicion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,posicion: null == posicion ? _self.posicion : posicion // ignore: cast_nullable_to_non_nullable
as String,posicionEtiqueta: null == posicionEtiqueta ? _self.posicionEtiqueta : posicionEtiqueta // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as int,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as int,creadoPor: freezed == creadoPor ? _self.creadoPor : creadoPor // ignore: cast_nullable_to_non_nullable
as String?,solicitante: freezed == solicitante ? _self.solicitante : solicitante // ignore: cast_nullable_to_non_nullable
as String?,fechaSolicitud: null == fechaSolicitud ? _self.fechaSolicitud : fechaSolicitud // ignore: cast_nullable_to_non_nullable
as String,fechaACubrirVacante: freezed == fechaACubrirVacante ? _self.fechaACubrirVacante : fechaACubrirVacante // ignore: cast_nullable_to_non_nullable
as String?,fechaEntregaACapitalHumano: freezed == fechaEntregaACapitalHumano ? _self.fechaEntregaACapitalHumano : fechaEntregaACapitalHumano // ignore: cast_nullable_to_non_nullable
as String?,areaSolicitante: null == areaSolicitante ? _self.areaSolicitante : areaSolicitante // ignore: cast_nullable_to_non_nullable
as String,justificacion: null == justificacion ? _self.justificacion : justificacion // ignore: cast_nullable_to_non_nullable
as String,horarioACubrir: freezed == horarioACubrir ? _self.horarioACubrir : horarioACubrir // ignore: cast_nullable_to_non_nullable
as int?,idiomasRequeridos: null == idiomasRequeridos ? _self.idiomasRequeridos : idiomasRequeridos // ignore: cast_nullable_to_non_nullable
as String,disposicionViajar: freezed == disposicionViajar ? _self.disposicionViajar : disposicionViajar // ignore: cast_nullable_to_non_nullable
as bool?,nivelTabulador: null == nivelTabulador ? _self.nivelTabulador : nivelTabulador // ignore: cast_nullable_to_non_nullable
as String,sueldoMensualCompuesto: freezed == sueldoMensualCompuesto ? _self.sueldoMensualCompuesto : sueldoMensualCompuesto // ignore: cast_nullable_to_non_nullable
as String?,sueldoMensualBruto: freezed == sueldoMensualBruto ? _self.sueldoMensualBruto : sueldoMensualBruto // ignore: cast_nullable_to_non_nullable
as String?,sueldoMensualNeto: freezed == sueldoMensualNeto ? _self.sueldoMensualNeto : sueldoMensualNeto // ignore: cast_nullable_to_non_nullable
as String?,tipoContratoOfrecido: freezed == tipoContratoOfrecido ? _self.tipoContratoOfrecido : tipoContratoOfrecido // ignore: cast_nullable_to_non_nullable
as int?,motivoSuspension: null == motivoSuspension ? _self.motivoSuspension : motivoSuspension // ignore: cast_nullable_to_non_nullable
as String,fechaSuspension: freezed == fechaSuspension ? _self.fechaSuspension : fechaSuspension // ignore: cast_nullable_to_non_nullable
as String?,autorizadoPorSuspension: null == autorizadoPorSuspension ? _self.autorizadoPorSuspension : autorizadoPorSuspension // ignore: cast_nullable_to_non_nullable
as String,aprobaciones: null == aprobaciones ? _self._aprobaciones : aprobaciones // ignore: cast_nullable_to_non_nullable
as List<Aprobacion>,
  ));
}


}


/// @nodoc
mixin _$TextoNumerado {

 int get orden; String get texto;
/// Create a copy of TextoNumerado
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextoNumeradoCopyWith<TextoNumerado> get copyWith => _$TextoNumeradoCopyWithImpl<TextoNumerado>(this as TextoNumerado, _$identity);

  /// Serializes this TextoNumerado to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TextoNumerado;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextoNumerado&&(identical(other.orden, _this.orden) || other.orden == _this.orden)&&(identical(other.texto, _this.texto) || other.texto == _this.texto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TextoNumerado;
  return Object.hash(runtimeType,_this.orden,_this.texto);
}

@override
String toString() {
  final _this = this as TextoNumerado;
  return 'TextoNumerado(orden: ${_this.orden}, texto: ${_this.texto})';
}


}

/// @nodoc
abstract mixin class $TextoNumeradoCopyWith<$Res>  {
  factory $TextoNumeradoCopyWith(TextoNumerado value, $Res Function(TextoNumerado) _then) = _$TextoNumeradoCopyWithImpl;
@useResult
$Res call({
 int orden, String texto
});




}
/// @nodoc
class _$TextoNumeradoCopyWithImpl<$Res>
    implements $TextoNumeradoCopyWith<$Res> {
  _$TextoNumeradoCopyWithImpl(this._self, this._then);

  final TextoNumerado _self;
  final $Res Function(TextoNumerado) _then;

/// Create a copy of TextoNumerado
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orden = null,Object? texto = null,}) {
  return _then(TextoNumerado(
orden: null == orden ? _self.orden : orden // ignore: cast_nullable_to_non_nullable
as int,texto: null == texto ? _self.texto : texto // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TextoNumerado].
extension TextoNumeradoPatterns on TextoNumerado {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextoNumerado value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextoNumerado() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextoNumerado value)  $default,){
final _that = this;
switch (_that) {
case _TextoNumerado():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextoNumerado value)?  $default,){
final _that = this;
switch (_that) {
case _TextoNumerado() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int orden,  String texto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextoNumerado() when $default != null:
return $default(_that.orden,_that.texto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int orden,  String texto)  $default,) {final _that = this;
switch (_that) {
case _TextoNumerado():
return $default(_that.orden,_that.texto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int orden,  String texto)?  $default,) {final _that = this;
switch (_that) {
case _TextoNumerado() when $default != null:
return $default(_that.orden,_that.texto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextoNumerado implements TextoNumerado {
  const _TextoNumerado({required this.orden, required this.texto});
  factory _TextoNumerado.fromJson(Map<String, dynamic> json) => _$TextoNumeradoFromJson(json);

@override final  int orden;
@override final  String texto;

/// Create a copy of TextoNumerado
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextoNumeradoCopyWith<_TextoNumerado> get copyWith => __$TextoNumeradoCopyWithImpl<_TextoNumerado>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextoNumeradoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextoNumerado&&(identical(other.orden, orden) || other.orden == orden)&&(identical(other.texto, texto) || other.texto == texto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,orden,texto);
}

@override
String toString() {
    return 'TextoNumerado(orden: $orden, texto: $texto)';
}


}

/// @nodoc
abstract mixin class _$TextoNumeradoCopyWith<$Res> implements $TextoNumeradoCopyWith<$Res> {
  factory _$TextoNumeradoCopyWith(_TextoNumerado value, $Res Function(_TextoNumerado) _then) = __$TextoNumeradoCopyWithImpl;
@override @useResult
$Res call({
 int orden, String texto
});




}
/// @nodoc
class __$TextoNumeradoCopyWithImpl<$Res>
    implements _$TextoNumeradoCopyWith<$Res> {
  __$TextoNumeradoCopyWithImpl(this._self, this._then);

  final _TextoNumerado _self;
  final $Res Function(_TextoNumerado) _then;

/// Create a copy of TextoNumerado
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orden = null,Object? texto = null,}) {
  return _then(_TextoNumerado(
orden: null == orden ? _self.orden : orden // ignore: cast_nullable_to_non_nullable
as int,texto: null == texto ? _self.texto : texto // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Conformidad {

 String get id; String get descriptivo; int get rol; String? get persona;@JsonKey(name: 'persona_nombre') String? get personaNombre; String? get fecha; String? get usuario;@JsonKey(name: 'nombre_manual') String get nombreManual;
/// Create a copy of Conformidad
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConformidadCopyWith<Conformidad> get copyWith => _$ConformidadCopyWithImpl<Conformidad>(this as Conformidad, _$identity);

  /// Serializes this Conformidad to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Conformidad;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conformidad&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.descriptivo, _this.descriptivo) || other.descriptivo == _this.descriptivo)&&(identical(other.rol, _this.rol) || other.rol == _this.rol)&&(identical(other.persona, _this.persona) || other.persona == _this.persona)&&(identical(other.personaNombre, _this.personaNombre) || other.personaNombre == _this.personaNombre)&&(identical(other.fecha, _this.fecha) || other.fecha == _this.fecha)&&(identical(other.usuario, _this.usuario) || other.usuario == _this.usuario)&&(identical(other.nombreManual, _this.nombreManual) || other.nombreManual == _this.nombreManual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Conformidad;
  return Object.hash(runtimeType,_this.id,_this.descriptivo,_this.rol,_this.persona,_this.personaNombre,_this.fecha,_this.usuario,_this.nombreManual);
}

@override
String toString() {
  final _this = this as Conformidad;
  return 'Conformidad(id: ${_this.id}, descriptivo: ${_this.descriptivo}, rol: ${_this.rol}, persona: ${_this.persona}, personaNombre: ${_this.personaNombre}, fecha: ${_this.fecha}, usuario: ${_this.usuario}, nombreManual: ${_this.nombreManual})';
}


}

/// @nodoc
abstract mixin class $ConformidadCopyWith<$Res>  {
  factory $ConformidadCopyWith(Conformidad value, $Res Function(Conformidad) _then) = _$ConformidadCopyWithImpl;
@useResult
$Res call({
 String id, String descriptivo, int rol, String? persona,@JsonKey(name: 'persona_nombre') String? personaNombre, String? fecha, String? usuario,@JsonKey(name: 'nombre_manual') String nombreManual
});




}
/// @nodoc
class _$ConformidadCopyWithImpl<$Res>
    implements $ConformidadCopyWith<$Res> {
  _$ConformidadCopyWithImpl(this._self, this._then);

  final Conformidad _self;
  final $Res Function(Conformidad) _then;

/// Create a copy of Conformidad
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descriptivo = null,Object? rol = null,Object? persona = freezed,Object? personaNombre = freezed,Object? fecha = freezed,Object? usuario = freezed,Object? nombreManual = null,}) {
  return _then(Conformidad(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descriptivo: null == descriptivo ? _self.descriptivo : descriptivo // ignore: cast_nullable_to_non_nullable
as String,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as int,persona: freezed == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String?,personaNombre: freezed == personaNombre ? _self.personaNombre : personaNombre // ignore: cast_nullable_to_non_nullable
as String?,fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,usuario: freezed == usuario ? _self.usuario : usuario // ignore: cast_nullable_to_non_nullable
as String?,nombreManual: null == nombreManual ? _self.nombreManual : nombreManual // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Conformidad].
extension ConformidadPatterns on Conformidad {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conformidad value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conformidad() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conformidad value)  $default,){
final _that = this;
switch (_that) {
case _Conformidad():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conformidad value)?  $default,){
final _that = this;
switch (_that) {
case _Conformidad() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descriptivo,  int rol,  String? persona, @JsonKey(name: 'persona_nombre')  String? personaNombre,  String? fecha,  String? usuario, @JsonKey(name: 'nombre_manual')  String nombreManual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conformidad() when $default != null:
return $default(_that.id,_that.descriptivo,_that.rol,_that.persona,_that.personaNombre,_that.fecha,_that.usuario,_that.nombreManual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descriptivo,  int rol,  String? persona, @JsonKey(name: 'persona_nombre')  String? personaNombre,  String? fecha,  String? usuario, @JsonKey(name: 'nombre_manual')  String nombreManual)  $default,) {final _that = this;
switch (_that) {
case _Conformidad():
return $default(_that.id,_that.descriptivo,_that.rol,_that.persona,_that.personaNombre,_that.fecha,_that.usuario,_that.nombreManual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descriptivo,  int rol,  String? persona, @JsonKey(name: 'persona_nombre')  String? personaNombre,  String? fecha,  String? usuario, @JsonKey(name: 'nombre_manual')  String nombreManual)?  $default,) {final _that = this;
switch (_that) {
case _Conformidad() when $default != null:
return $default(_that.id,_that.descriptivo,_that.rol,_that.persona,_that.personaNombre,_that.fecha,_that.usuario,_that.nombreManual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conformidad implements Conformidad {
  const _Conformidad({required this.id, required this.descriptivo, required this.rol, this.persona, @JsonKey(name: 'persona_nombre') this.personaNombre, this.fecha, this.usuario, @JsonKey(name: 'nombre_manual') this.nombreManual = ''});
  factory _Conformidad.fromJson(Map<String, dynamic> json) => _$ConformidadFromJson(json);

@override final  String id;
@override final  String descriptivo;
@override final  int rol;
@override final  String? persona;
@override@JsonKey(name: 'persona_nombre') final  String? personaNombre;
@override final  String? fecha;
@override final  String? usuario;
@override@JsonKey(name: 'nombre_manual') final  String nombreManual;

/// Create a copy of Conformidad
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConformidadCopyWith<_Conformidad> get copyWith => __$ConformidadCopyWithImpl<_Conformidad>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConformidadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conformidad&&(identical(other.id, id) || other.id == id)&&(identical(other.descriptivo, descriptivo) || other.descriptivo == descriptivo)&&(identical(other.rol, rol) || other.rol == rol)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.personaNombre, personaNombre) || other.personaNombre == personaNombre)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.usuario, usuario) || other.usuario == usuario)&&(identical(other.nombreManual, nombreManual) || other.nombreManual == nombreManual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,descriptivo,rol,persona,personaNombre,fecha,usuario,nombreManual);
}

@override
String toString() {
    return 'Conformidad(id: $id, descriptivo: $descriptivo, rol: $rol, persona: $persona, personaNombre: $personaNombre, fecha: $fecha, usuario: $usuario, nombreManual: $nombreManual)';
}


}

/// @nodoc
abstract mixin class _$ConformidadCopyWith<$Res> implements $ConformidadCopyWith<$Res> {
  factory _$ConformidadCopyWith(_Conformidad value, $Res Function(_Conformidad) _then) = __$ConformidadCopyWithImpl;
@override @useResult
$Res call({
 String id, String descriptivo, int rol, String? persona,@JsonKey(name: 'persona_nombre') String? personaNombre, String? fecha, String? usuario,@JsonKey(name: 'nombre_manual') String nombreManual
});




}
/// @nodoc
class __$ConformidadCopyWithImpl<$Res>
    implements _$ConformidadCopyWith<$Res> {
  __$ConformidadCopyWithImpl(this._self, this._then);

  final _Conformidad _self;
  final $Res Function(_Conformidad) _then;

/// Create a copy of Conformidad
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descriptivo = null,Object? rol = null,Object? persona = freezed,Object? personaNombre = freezed,Object? fecha = freezed,Object? usuario = freezed,Object? nombreManual = null,}) {
  return _then(_Conformidad(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descriptivo: null == descriptivo ? _self.descriptivo : descriptivo // ignore: cast_nullable_to_non_nullable
as String,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as int,persona: freezed == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String?,personaNombre: freezed == personaNombre ? _self.personaNombre : personaNombre // ignore: cast_nullable_to_non_nullable
as String?,fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,usuario: freezed == usuario ? _self.usuario : usuario // ignore: cast_nullable_to_non_nullable
as String?,nombreManual: null == nombreManual ? _self.nombreManual : nombreManual // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Descriptivo {

 String get id; String get posicion;@JsonKey(name: 'posicion_etiqueta') String get posicionEtiqueta; int get version;@JsonKey(name: 'congelado_en') String? get congeladoEn;@JsonKey(name: 'esta_congelado') bool get estaCongelado;@JsonKey(name: 'nombre_puesto') String get nombrePuesto; String get empresa;@JsonKey(name: 'area_departamento') String get areaDepartamento;@JsonKey(name: 'reporta_a') String get reportaA;@JsonKey(name: 'supervisa_a') String get supervisaA;@JsonKey(name: 'fecha_elaboracion') String get fechaElaboracion; int? get edad;@JsonKey(name: 'edad_otro') String get edadOtro;@JsonKey(name: 'disponibilidad_viajar') bool? get disponibilidadViajar;@JsonKey(name: 'dias_por_laborar') int? get diasPorLaborar;@JsonKey(name: 'dias_por_laborar_otro') String get diasPorLaborarOtro; int? get horario;@JsonKey(name: 'horario_otro') String get horarioOtro; String get proposito;@JsonKey(name: 'decisiones_operativas') String get decisionesOperativas;@JsonKey(name: 'decisiones_funcionales') String get decisionesFuncionales;@JsonKey(name: 'decisiones_estrategicas') String get decisionesEstrategicas;@JsonKey(name: 'relaciones_internas') String get relacionesInternas;@JsonKey(name: 'relaciones_externas') String get relacionesExternas;@JsonKey(name: 'escolaridad_minima') String get escolaridadMinima;@JsonKey(name: 'experiencia_requerida') String get experienciaRequerida; String get idiomas;@JsonKey(name: 'competencias_tecnicas') String get competenciasTecnicas; List<int> get competencias;@JsonKey(name: 'competencias_otras') String get competenciasOtras; List<int> get recursos;@JsonKey(name: 'recursos_otro') String get recursosOtro; List<TextoNumerado> get funciones; List<TextoNumerado> get indicadores; List<Conformidad> get conformidades;
/// Create a copy of Descriptivo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DescriptivoCopyWith<Descriptivo> get copyWith => _$DescriptivoCopyWithImpl<Descriptivo>(this as Descriptivo, _$identity);

  /// Serializes this Descriptivo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Descriptivo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Descriptivo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.posicion, _this.posicion) || other.posicion == _this.posicion)&&(identical(other.posicionEtiqueta, _this.posicionEtiqueta) || other.posicionEtiqueta == _this.posicionEtiqueta)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.congeladoEn, _this.congeladoEn) || other.congeladoEn == _this.congeladoEn)&&(identical(other.estaCongelado, _this.estaCongelado) || other.estaCongelado == _this.estaCongelado)&&(identical(other.nombrePuesto, _this.nombrePuesto) || other.nombrePuesto == _this.nombrePuesto)&&(identical(other.empresa, _this.empresa) || other.empresa == _this.empresa)&&(identical(other.areaDepartamento, _this.areaDepartamento) || other.areaDepartamento == _this.areaDepartamento)&&(identical(other.reportaA, _this.reportaA) || other.reportaA == _this.reportaA)&&(identical(other.supervisaA, _this.supervisaA) || other.supervisaA == _this.supervisaA)&&(identical(other.fechaElaboracion, _this.fechaElaboracion) || other.fechaElaboracion == _this.fechaElaboracion)&&(identical(other.edad, _this.edad) || other.edad == _this.edad)&&(identical(other.edadOtro, _this.edadOtro) || other.edadOtro == _this.edadOtro)&&(identical(other.disponibilidadViajar, _this.disponibilidadViajar) || other.disponibilidadViajar == _this.disponibilidadViajar)&&(identical(other.diasPorLaborar, _this.diasPorLaborar) || other.diasPorLaborar == _this.diasPorLaborar)&&(identical(other.diasPorLaborarOtro, _this.diasPorLaborarOtro) || other.diasPorLaborarOtro == _this.diasPorLaborarOtro)&&(identical(other.horario, _this.horario) || other.horario == _this.horario)&&(identical(other.horarioOtro, _this.horarioOtro) || other.horarioOtro == _this.horarioOtro)&&(identical(other.proposito, _this.proposito) || other.proposito == _this.proposito)&&(identical(other.decisionesOperativas, _this.decisionesOperativas) || other.decisionesOperativas == _this.decisionesOperativas)&&(identical(other.decisionesFuncionales, _this.decisionesFuncionales) || other.decisionesFuncionales == _this.decisionesFuncionales)&&(identical(other.decisionesEstrategicas, _this.decisionesEstrategicas) || other.decisionesEstrategicas == _this.decisionesEstrategicas)&&(identical(other.relacionesInternas, _this.relacionesInternas) || other.relacionesInternas == _this.relacionesInternas)&&(identical(other.relacionesExternas, _this.relacionesExternas) || other.relacionesExternas == _this.relacionesExternas)&&(identical(other.escolaridadMinima, _this.escolaridadMinima) || other.escolaridadMinima == _this.escolaridadMinima)&&(identical(other.experienciaRequerida, _this.experienciaRequerida) || other.experienciaRequerida == _this.experienciaRequerida)&&(identical(other.idiomas, _this.idiomas) || other.idiomas == _this.idiomas)&&(identical(other.competenciasTecnicas, _this.competenciasTecnicas) || other.competenciasTecnicas == _this.competenciasTecnicas)&&const DeepCollectionEquality().equals(other.competencias, _this.competencias)&&(identical(other.competenciasOtras, _this.competenciasOtras) || other.competenciasOtras == _this.competenciasOtras)&&const DeepCollectionEquality().equals(other.recursos, _this.recursos)&&(identical(other.recursosOtro, _this.recursosOtro) || other.recursosOtro == _this.recursosOtro)&&const DeepCollectionEquality().equals(other.funciones, _this.funciones)&&const DeepCollectionEquality().equals(other.indicadores, _this.indicadores)&&const DeepCollectionEquality().equals(other.conformidades, _this.conformidades));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Descriptivo;
  return Object.hashAll([runtimeType,_this.id,_this.posicion,_this.posicionEtiqueta,_this.version,_this.congeladoEn,_this.estaCongelado,_this.nombrePuesto,_this.empresa,_this.areaDepartamento,_this.reportaA,_this.supervisaA,_this.fechaElaboracion,_this.edad,_this.edadOtro,_this.disponibilidadViajar,_this.diasPorLaborar,_this.diasPorLaborarOtro,_this.horario,_this.horarioOtro,_this.proposito,_this.decisionesOperativas,_this.decisionesFuncionales,_this.decisionesEstrategicas,_this.relacionesInternas,_this.relacionesExternas,_this.escolaridadMinima,_this.experienciaRequerida,_this.idiomas,_this.competenciasTecnicas,const DeepCollectionEquality().hash(_this.competencias),_this.competenciasOtras,const DeepCollectionEquality().hash(_this.recursos),_this.recursosOtro,const DeepCollectionEquality().hash(_this.funciones),const DeepCollectionEquality().hash(_this.indicadores),const DeepCollectionEquality().hash(_this.conformidades)]);
}

@override
String toString() {
  final _this = this as Descriptivo;
  return 'Descriptivo(id: ${_this.id}, posicion: ${_this.posicion}, posicionEtiqueta: ${_this.posicionEtiqueta}, version: ${_this.version}, congeladoEn: ${_this.congeladoEn}, estaCongelado: ${_this.estaCongelado}, nombrePuesto: ${_this.nombrePuesto}, empresa: ${_this.empresa}, areaDepartamento: ${_this.areaDepartamento}, reportaA: ${_this.reportaA}, supervisaA: ${_this.supervisaA}, fechaElaboracion: ${_this.fechaElaboracion}, edad: ${_this.edad}, edadOtro: ${_this.edadOtro}, disponibilidadViajar: ${_this.disponibilidadViajar}, diasPorLaborar: ${_this.diasPorLaborar}, diasPorLaborarOtro: ${_this.diasPorLaborarOtro}, horario: ${_this.horario}, horarioOtro: ${_this.horarioOtro}, proposito: ${_this.proposito}, decisionesOperativas: ${_this.decisionesOperativas}, decisionesFuncionales: ${_this.decisionesFuncionales}, decisionesEstrategicas: ${_this.decisionesEstrategicas}, relacionesInternas: ${_this.relacionesInternas}, relacionesExternas: ${_this.relacionesExternas}, escolaridadMinima: ${_this.escolaridadMinima}, experienciaRequerida: ${_this.experienciaRequerida}, idiomas: ${_this.idiomas}, competenciasTecnicas: ${_this.competenciasTecnicas}, competencias: ${_this.competencias}, competenciasOtras: ${_this.competenciasOtras}, recursos: ${_this.recursos}, recursosOtro: ${_this.recursosOtro}, funciones: ${_this.funciones}, indicadores: ${_this.indicadores}, conformidades: ${_this.conformidades})';
}


}

/// @nodoc
abstract mixin class $DescriptivoCopyWith<$Res>  {
  factory $DescriptivoCopyWith(Descriptivo value, $Res Function(Descriptivo) _then) = _$DescriptivoCopyWithImpl;
@useResult
$Res call({
 String id, String posicion,@JsonKey(name: 'posicion_etiqueta') String posicionEtiqueta, int version,@JsonKey(name: 'congelado_en') String? congeladoEn,@JsonKey(name: 'esta_congelado') bool estaCongelado,@JsonKey(name: 'nombre_puesto') String nombrePuesto, String empresa,@JsonKey(name: 'area_departamento') String areaDepartamento,@JsonKey(name: 'reporta_a') String reportaA,@JsonKey(name: 'supervisa_a') String supervisaA,@JsonKey(name: 'fecha_elaboracion') String fechaElaboracion, int? edad,@JsonKey(name: 'edad_otro') String edadOtro,@JsonKey(name: 'disponibilidad_viajar') bool? disponibilidadViajar,@JsonKey(name: 'dias_por_laborar') int? diasPorLaborar,@JsonKey(name: 'dias_por_laborar_otro') String diasPorLaborarOtro, int? horario,@JsonKey(name: 'horario_otro') String horarioOtro, String proposito,@JsonKey(name: 'decisiones_operativas') String decisionesOperativas,@JsonKey(name: 'decisiones_funcionales') String decisionesFuncionales,@JsonKey(name: 'decisiones_estrategicas') String decisionesEstrategicas,@JsonKey(name: 'relaciones_internas') String relacionesInternas,@JsonKey(name: 'relaciones_externas') String relacionesExternas,@JsonKey(name: 'escolaridad_minima') String escolaridadMinima,@JsonKey(name: 'experiencia_requerida') String experienciaRequerida, String idiomas,@JsonKey(name: 'competencias_tecnicas') String competenciasTecnicas, List<int> competencias,@JsonKey(name: 'competencias_otras') String competenciasOtras, List<int> recursos,@JsonKey(name: 'recursos_otro') String recursosOtro, List<TextoNumerado> funciones, List<TextoNumerado> indicadores, List<Conformidad> conformidades
});




}
/// @nodoc
class _$DescriptivoCopyWithImpl<$Res>
    implements $DescriptivoCopyWith<$Res> {
  _$DescriptivoCopyWithImpl(this._self, this._then);

  final Descriptivo _self;
  final $Res Function(Descriptivo) _then;

/// Create a copy of Descriptivo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? posicion = null,Object? posicionEtiqueta = null,Object? version = null,Object? congeladoEn = freezed,Object? estaCongelado = null,Object? nombrePuesto = null,Object? empresa = null,Object? areaDepartamento = null,Object? reportaA = null,Object? supervisaA = null,Object? fechaElaboracion = null,Object? edad = freezed,Object? edadOtro = null,Object? disponibilidadViajar = freezed,Object? diasPorLaborar = freezed,Object? diasPorLaborarOtro = null,Object? horario = freezed,Object? horarioOtro = null,Object? proposito = null,Object? decisionesOperativas = null,Object? decisionesFuncionales = null,Object? decisionesEstrategicas = null,Object? relacionesInternas = null,Object? relacionesExternas = null,Object? escolaridadMinima = null,Object? experienciaRequerida = null,Object? idiomas = null,Object? competenciasTecnicas = null,Object? competencias = null,Object? competenciasOtras = null,Object? recursos = null,Object? recursosOtro = null,Object? funciones = null,Object? indicadores = null,Object? conformidades = null,}) {
  return _then(Descriptivo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,posicion: null == posicion ? _self.posicion : posicion // ignore: cast_nullable_to_non_nullable
as String,posicionEtiqueta: null == posicionEtiqueta ? _self.posicionEtiqueta : posicionEtiqueta // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,congeladoEn: freezed == congeladoEn ? _self.congeladoEn : congeladoEn // ignore: cast_nullable_to_non_nullable
as String?,estaCongelado: null == estaCongelado ? _self.estaCongelado : estaCongelado // ignore: cast_nullable_to_non_nullable
as bool,nombrePuesto: null == nombrePuesto ? _self.nombrePuesto : nombrePuesto // ignore: cast_nullable_to_non_nullable
as String,empresa: null == empresa ? _self.empresa : empresa // ignore: cast_nullable_to_non_nullable
as String,areaDepartamento: null == areaDepartamento ? _self.areaDepartamento : areaDepartamento // ignore: cast_nullable_to_non_nullable
as String,reportaA: null == reportaA ? _self.reportaA : reportaA // ignore: cast_nullable_to_non_nullable
as String,supervisaA: null == supervisaA ? _self.supervisaA : supervisaA // ignore: cast_nullable_to_non_nullable
as String,fechaElaboracion: null == fechaElaboracion ? _self.fechaElaboracion : fechaElaboracion // ignore: cast_nullable_to_non_nullable
as String,edad: freezed == edad ? _self.edad : edad // ignore: cast_nullable_to_non_nullable
as int?,edadOtro: null == edadOtro ? _self.edadOtro : edadOtro // ignore: cast_nullable_to_non_nullable
as String,disponibilidadViajar: freezed == disponibilidadViajar ? _self.disponibilidadViajar : disponibilidadViajar // ignore: cast_nullable_to_non_nullable
as bool?,diasPorLaborar: freezed == diasPorLaborar ? _self.diasPorLaborar : diasPorLaborar // ignore: cast_nullable_to_non_nullable
as int?,diasPorLaborarOtro: null == diasPorLaborarOtro ? _self.diasPorLaborarOtro : diasPorLaborarOtro // ignore: cast_nullable_to_non_nullable
as String,horario: freezed == horario ? _self.horario : horario // ignore: cast_nullable_to_non_nullable
as int?,horarioOtro: null == horarioOtro ? _self.horarioOtro : horarioOtro // ignore: cast_nullable_to_non_nullable
as String,proposito: null == proposito ? _self.proposito : proposito // ignore: cast_nullable_to_non_nullable
as String,decisionesOperativas: null == decisionesOperativas ? _self.decisionesOperativas : decisionesOperativas // ignore: cast_nullable_to_non_nullable
as String,decisionesFuncionales: null == decisionesFuncionales ? _self.decisionesFuncionales : decisionesFuncionales // ignore: cast_nullable_to_non_nullable
as String,decisionesEstrategicas: null == decisionesEstrategicas ? _self.decisionesEstrategicas : decisionesEstrategicas // ignore: cast_nullable_to_non_nullable
as String,relacionesInternas: null == relacionesInternas ? _self.relacionesInternas : relacionesInternas // ignore: cast_nullable_to_non_nullable
as String,relacionesExternas: null == relacionesExternas ? _self.relacionesExternas : relacionesExternas // ignore: cast_nullable_to_non_nullable
as String,escolaridadMinima: null == escolaridadMinima ? _self.escolaridadMinima : escolaridadMinima // ignore: cast_nullable_to_non_nullable
as String,experienciaRequerida: null == experienciaRequerida ? _self.experienciaRequerida : experienciaRequerida // ignore: cast_nullable_to_non_nullable
as String,idiomas: null == idiomas ? _self.idiomas : idiomas // ignore: cast_nullable_to_non_nullable
as String,competenciasTecnicas: null == competenciasTecnicas ? _self.competenciasTecnicas : competenciasTecnicas // ignore: cast_nullable_to_non_nullable
as String,competencias: null == competencias ? _self.competencias : competencias // ignore: cast_nullable_to_non_nullable
as List<int>,competenciasOtras: null == competenciasOtras ? _self.competenciasOtras : competenciasOtras // ignore: cast_nullable_to_non_nullable
as String,recursos: null == recursos ? _self.recursos : recursos // ignore: cast_nullable_to_non_nullable
as List<int>,recursosOtro: null == recursosOtro ? _self.recursosOtro : recursosOtro // ignore: cast_nullable_to_non_nullable
as String,funciones: null == funciones ? _self.funciones : funciones // ignore: cast_nullable_to_non_nullable
as List<TextoNumerado>,indicadores: null == indicadores ? _self.indicadores : indicadores // ignore: cast_nullable_to_non_nullable
as List<TextoNumerado>,conformidades: null == conformidades ? _self.conformidades : conformidades // ignore: cast_nullable_to_non_nullable
as List<Conformidad>,
  ));
}

}


/// Adds pattern-matching-related methods to [Descriptivo].
extension DescriptivoPatterns on Descriptivo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Descriptivo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Descriptivo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Descriptivo value)  $default,){
final _that = this;
switch (_that) {
case _Descriptivo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Descriptivo value)?  $default,){
final _that = this;
switch (_that) {
case _Descriptivo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String posicion, @JsonKey(name: 'posicion_etiqueta')  String posicionEtiqueta,  int version, @JsonKey(name: 'congelado_en')  String? congeladoEn, @JsonKey(name: 'esta_congelado')  bool estaCongelado, @JsonKey(name: 'nombre_puesto')  String nombrePuesto,  String empresa, @JsonKey(name: 'area_departamento')  String areaDepartamento, @JsonKey(name: 'reporta_a')  String reportaA, @JsonKey(name: 'supervisa_a')  String supervisaA, @JsonKey(name: 'fecha_elaboracion')  String fechaElaboracion,  int? edad, @JsonKey(name: 'edad_otro')  String edadOtro, @JsonKey(name: 'disponibilidad_viajar')  bool? disponibilidadViajar, @JsonKey(name: 'dias_por_laborar')  int? diasPorLaborar, @JsonKey(name: 'dias_por_laborar_otro')  String diasPorLaborarOtro,  int? horario, @JsonKey(name: 'horario_otro')  String horarioOtro,  String proposito, @JsonKey(name: 'decisiones_operativas')  String decisionesOperativas, @JsonKey(name: 'decisiones_funcionales')  String decisionesFuncionales, @JsonKey(name: 'decisiones_estrategicas')  String decisionesEstrategicas, @JsonKey(name: 'relaciones_internas')  String relacionesInternas, @JsonKey(name: 'relaciones_externas')  String relacionesExternas, @JsonKey(name: 'escolaridad_minima')  String escolaridadMinima, @JsonKey(name: 'experiencia_requerida')  String experienciaRequerida,  String idiomas, @JsonKey(name: 'competencias_tecnicas')  String competenciasTecnicas,  List<int> competencias, @JsonKey(name: 'competencias_otras')  String competenciasOtras,  List<int> recursos, @JsonKey(name: 'recursos_otro')  String recursosOtro,  List<TextoNumerado> funciones,  List<TextoNumerado> indicadores,  List<Conformidad> conformidades)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Descriptivo() when $default != null:
return $default(_that.id,_that.posicion,_that.posicionEtiqueta,_that.version,_that.congeladoEn,_that.estaCongelado,_that.nombrePuesto,_that.empresa,_that.areaDepartamento,_that.reportaA,_that.supervisaA,_that.fechaElaboracion,_that.edad,_that.edadOtro,_that.disponibilidadViajar,_that.diasPorLaborar,_that.diasPorLaborarOtro,_that.horario,_that.horarioOtro,_that.proposito,_that.decisionesOperativas,_that.decisionesFuncionales,_that.decisionesEstrategicas,_that.relacionesInternas,_that.relacionesExternas,_that.escolaridadMinima,_that.experienciaRequerida,_that.idiomas,_that.competenciasTecnicas,_that.competencias,_that.competenciasOtras,_that.recursos,_that.recursosOtro,_that.funciones,_that.indicadores,_that.conformidades);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String posicion, @JsonKey(name: 'posicion_etiqueta')  String posicionEtiqueta,  int version, @JsonKey(name: 'congelado_en')  String? congeladoEn, @JsonKey(name: 'esta_congelado')  bool estaCongelado, @JsonKey(name: 'nombre_puesto')  String nombrePuesto,  String empresa, @JsonKey(name: 'area_departamento')  String areaDepartamento, @JsonKey(name: 'reporta_a')  String reportaA, @JsonKey(name: 'supervisa_a')  String supervisaA, @JsonKey(name: 'fecha_elaboracion')  String fechaElaboracion,  int? edad, @JsonKey(name: 'edad_otro')  String edadOtro, @JsonKey(name: 'disponibilidad_viajar')  bool? disponibilidadViajar, @JsonKey(name: 'dias_por_laborar')  int? diasPorLaborar, @JsonKey(name: 'dias_por_laborar_otro')  String diasPorLaborarOtro,  int? horario, @JsonKey(name: 'horario_otro')  String horarioOtro,  String proposito, @JsonKey(name: 'decisiones_operativas')  String decisionesOperativas, @JsonKey(name: 'decisiones_funcionales')  String decisionesFuncionales, @JsonKey(name: 'decisiones_estrategicas')  String decisionesEstrategicas, @JsonKey(name: 'relaciones_internas')  String relacionesInternas, @JsonKey(name: 'relaciones_externas')  String relacionesExternas, @JsonKey(name: 'escolaridad_minima')  String escolaridadMinima, @JsonKey(name: 'experiencia_requerida')  String experienciaRequerida,  String idiomas, @JsonKey(name: 'competencias_tecnicas')  String competenciasTecnicas,  List<int> competencias, @JsonKey(name: 'competencias_otras')  String competenciasOtras,  List<int> recursos, @JsonKey(name: 'recursos_otro')  String recursosOtro,  List<TextoNumerado> funciones,  List<TextoNumerado> indicadores,  List<Conformidad> conformidades)  $default,) {final _that = this;
switch (_that) {
case _Descriptivo():
return $default(_that.id,_that.posicion,_that.posicionEtiqueta,_that.version,_that.congeladoEn,_that.estaCongelado,_that.nombrePuesto,_that.empresa,_that.areaDepartamento,_that.reportaA,_that.supervisaA,_that.fechaElaboracion,_that.edad,_that.edadOtro,_that.disponibilidadViajar,_that.diasPorLaborar,_that.diasPorLaborarOtro,_that.horario,_that.horarioOtro,_that.proposito,_that.decisionesOperativas,_that.decisionesFuncionales,_that.decisionesEstrategicas,_that.relacionesInternas,_that.relacionesExternas,_that.escolaridadMinima,_that.experienciaRequerida,_that.idiomas,_that.competenciasTecnicas,_that.competencias,_that.competenciasOtras,_that.recursos,_that.recursosOtro,_that.funciones,_that.indicadores,_that.conformidades);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String posicion, @JsonKey(name: 'posicion_etiqueta')  String posicionEtiqueta,  int version, @JsonKey(name: 'congelado_en')  String? congeladoEn, @JsonKey(name: 'esta_congelado')  bool estaCongelado, @JsonKey(name: 'nombre_puesto')  String nombrePuesto,  String empresa, @JsonKey(name: 'area_departamento')  String areaDepartamento, @JsonKey(name: 'reporta_a')  String reportaA, @JsonKey(name: 'supervisa_a')  String supervisaA, @JsonKey(name: 'fecha_elaboracion')  String fechaElaboracion,  int? edad, @JsonKey(name: 'edad_otro')  String edadOtro, @JsonKey(name: 'disponibilidad_viajar')  bool? disponibilidadViajar, @JsonKey(name: 'dias_por_laborar')  int? diasPorLaborar, @JsonKey(name: 'dias_por_laborar_otro')  String diasPorLaborarOtro,  int? horario, @JsonKey(name: 'horario_otro')  String horarioOtro,  String proposito, @JsonKey(name: 'decisiones_operativas')  String decisionesOperativas, @JsonKey(name: 'decisiones_funcionales')  String decisionesFuncionales, @JsonKey(name: 'decisiones_estrategicas')  String decisionesEstrategicas, @JsonKey(name: 'relaciones_internas')  String relacionesInternas, @JsonKey(name: 'relaciones_externas')  String relacionesExternas, @JsonKey(name: 'escolaridad_minima')  String escolaridadMinima, @JsonKey(name: 'experiencia_requerida')  String experienciaRequerida,  String idiomas, @JsonKey(name: 'competencias_tecnicas')  String competenciasTecnicas,  List<int> competencias, @JsonKey(name: 'competencias_otras')  String competenciasOtras,  List<int> recursos, @JsonKey(name: 'recursos_otro')  String recursosOtro,  List<TextoNumerado> funciones,  List<TextoNumerado> indicadores,  List<Conformidad> conformidades)?  $default,) {final _that = this;
switch (_that) {
case _Descriptivo() when $default != null:
return $default(_that.id,_that.posicion,_that.posicionEtiqueta,_that.version,_that.congeladoEn,_that.estaCongelado,_that.nombrePuesto,_that.empresa,_that.areaDepartamento,_that.reportaA,_that.supervisaA,_that.fechaElaboracion,_that.edad,_that.edadOtro,_that.disponibilidadViajar,_that.diasPorLaborar,_that.diasPorLaborarOtro,_that.horario,_that.horarioOtro,_that.proposito,_that.decisionesOperativas,_that.decisionesFuncionales,_that.decisionesEstrategicas,_that.relacionesInternas,_that.relacionesExternas,_that.escolaridadMinima,_that.experienciaRequerida,_that.idiomas,_that.competenciasTecnicas,_that.competencias,_that.competenciasOtras,_that.recursos,_that.recursosOtro,_that.funciones,_that.indicadores,_that.conformidades);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Descriptivo implements Descriptivo {
  const _Descriptivo({required this.id, required this.posicion, @JsonKey(name: 'posicion_etiqueta') this.posicionEtiqueta = '', required this.version, @JsonKey(name: 'congelado_en') this.congeladoEn, @JsonKey(name: 'esta_congelado') this.estaCongelado = false, @JsonKey(name: 'nombre_puesto') this.nombrePuesto = '', this.empresa = '', @JsonKey(name: 'area_departamento') this.areaDepartamento = '', @JsonKey(name: 'reporta_a') this.reportaA = '', @JsonKey(name: 'supervisa_a') this.supervisaA = '', @JsonKey(name: 'fecha_elaboracion') required this.fechaElaboracion, this.edad, @JsonKey(name: 'edad_otro') this.edadOtro = '', @JsonKey(name: 'disponibilidad_viajar') this.disponibilidadViajar, @JsonKey(name: 'dias_por_laborar') this.diasPorLaborar, @JsonKey(name: 'dias_por_laborar_otro') this.diasPorLaborarOtro = '', this.horario, @JsonKey(name: 'horario_otro') this.horarioOtro = '', this.proposito = '', @JsonKey(name: 'decisiones_operativas') this.decisionesOperativas = '', @JsonKey(name: 'decisiones_funcionales') this.decisionesFuncionales = '', @JsonKey(name: 'decisiones_estrategicas') this.decisionesEstrategicas = '', @JsonKey(name: 'relaciones_internas') this.relacionesInternas = '', @JsonKey(name: 'relaciones_externas') this.relacionesExternas = '', @JsonKey(name: 'escolaridad_minima') this.escolaridadMinima = '', @JsonKey(name: 'experiencia_requerida') this.experienciaRequerida = '', this.idiomas = '', @JsonKey(name: 'competencias_tecnicas') this.competenciasTecnicas = '',  List<int> competencias = const <int>[], @JsonKey(name: 'competencias_otras') this.competenciasOtras = '',  List<int> recursos = const <int>[], @JsonKey(name: 'recursos_otro') this.recursosOtro = '',  List<TextoNumerado> funciones = const <TextoNumerado>[],  List<TextoNumerado> indicadores = const <TextoNumerado>[],  List<Conformidad> conformidades = const <Conformidad>[]}): _competencias = competencias,_recursos = recursos,_funciones = funciones,_indicadores = indicadores,_conformidades = conformidades;
  factory _Descriptivo.fromJson(Map<String, dynamic> json) => _$DescriptivoFromJson(json);

@override final  String id;
@override final  String posicion;
@override@JsonKey(name: 'posicion_etiqueta') final  String posicionEtiqueta;
@override final  int version;
@override@JsonKey(name: 'congelado_en') final  String? congeladoEn;
@override@JsonKey(name: 'esta_congelado') final  bool estaCongelado;
@override@JsonKey(name: 'nombre_puesto') final  String nombrePuesto;
@override@JsonKey() final  String empresa;
@override@JsonKey(name: 'area_departamento') final  String areaDepartamento;
@override@JsonKey(name: 'reporta_a') final  String reportaA;
@override@JsonKey(name: 'supervisa_a') final  String supervisaA;
@override@JsonKey(name: 'fecha_elaboracion') final  String fechaElaboracion;
@override final  int? edad;
@override@JsonKey(name: 'edad_otro') final  String edadOtro;
@override@JsonKey(name: 'disponibilidad_viajar') final  bool? disponibilidadViajar;
@override@JsonKey(name: 'dias_por_laborar') final  int? diasPorLaborar;
@override@JsonKey(name: 'dias_por_laborar_otro') final  String diasPorLaborarOtro;
@override final  int? horario;
@override@JsonKey(name: 'horario_otro') final  String horarioOtro;
@override@JsonKey() final  String proposito;
@override@JsonKey(name: 'decisiones_operativas') final  String decisionesOperativas;
@override@JsonKey(name: 'decisiones_funcionales') final  String decisionesFuncionales;
@override@JsonKey(name: 'decisiones_estrategicas') final  String decisionesEstrategicas;
@override@JsonKey(name: 'relaciones_internas') final  String relacionesInternas;
@override@JsonKey(name: 'relaciones_externas') final  String relacionesExternas;
@override@JsonKey(name: 'escolaridad_minima') final  String escolaridadMinima;
@override@JsonKey(name: 'experiencia_requerida') final  String experienciaRequerida;
@override@JsonKey() final  String idiomas;
@override@JsonKey(name: 'competencias_tecnicas') final  String competenciasTecnicas;
 final  List<int> _competencias;
@override@JsonKey() List<int> get competencias {
  if (_competencias is EqualUnmodifiableListView) return _competencias;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_competencias);
}

@override@JsonKey(name: 'competencias_otras') final  String competenciasOtras;
 final  List<int> _recursos;
@override@JsonKey() List<int> get recursos {
  if (_recursos is EqualUnmodifiableListView) return _recursos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recursos);
}

@override@JsonKey(name: 'recursos_otro') final  String recursosOtro;
 final  List<TextoNumerado> _funciones;
@override@JsonKey() List<TextoNumerado> get funciones {
  if (_funciones is EqualUnmodifiableListView) return _funciones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_funciones);
}

 final  List<TextoNumerado> _indicadores;
@override@JsonKey() List<TextoNumerado> get indicadores {
  if (_indicadores is EqualUnmodifiableListView) return _indicadores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_indicadores);
}

 final  List<Conformidad> _conformidades;
@override@JsonKey() List<Conformidad> get conformidades {
  if (_conformidades is EqualUnmodifiableListView) return _conformidades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conformidades);
}


/// Create a copy of Descriptivo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DescriptivoCopyWith<_Descriptivo> get copyWith => __$DescriptivoCopyWithImpl<_Descriptivo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DescriptivoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Descriptivo&&(identical(other.id, id) || other.id == id)&&(identical(other.posicion, posicion) || other.posicion == posicion)&&(identical(other.posicionEtiqueta, posicionEtiqueta) || other.posicionEtiqueta == posicionEtiqueta)&&(identical(other.version, version) || other.version == version)&&(identical(other.congeladoEn, congeladoEn) || other.congeladoEn == congeladoEn)&&(identical(other.estaCongelado, estaCongelado) || other.estaCongelado == estaCongelado)&&(identical(other.nombrePuesto, nombrePuesto) || other.nombrePuesto == nombrePuesto)&&(identical(other.empresa, empresa) || other.empresa == empresa)&&(identical(other.areaDepartamento, areaDepartamento) || other.areaDepartamento == areaDepartamento)&&(identical(other.reportaA, reportaA) || other.reportaA == reportaA)&&(identical(other.supervisaA, supervisaA) || other.supervisaA == supervisaA)&&(identical(other.fechaElaboracion, fechaElaboracion) || other.fechaElaboracion == fechaElaboracion)&&(identical(other.edad, edad) || other.edad == edad)&&(identical(other.edadOtro, edadOtro) || other.edadOtro == edadOtro)&&(identical(other.disponibilidadViajar, disponibilidadViajar) || other.disponibilidadViajar == disponibilidadViajar)&&(identical(other.diasPorLaborar, diasPorLaborar) || other.diasPorLaborar == diasPorLaborar)&&(identical(other.diasPorLaborarOtro, diasPorLaborarOtro) || other.diasPorLaborarOtro == diasPorLaborarOtro)&&(identical(other.horario, horario) || other.horario == horario)&&(identical(other.horarioOtro, horarioOtro) || other.horarioOtro == horarioOtro)&&(identical(other.proposito, proposito) || other.proposito == proposito)&&(identical(other.decisionesOperativas, decisionesOperativas) || other.decisionesOperativas == decisionesOperativas)&&(identical(other.decisionesFuncionales, decisionesFuncionales) || other.decisionesFuncionales == decisionesFuncionales)&&(identical(other.decisionesEstrategicas, decisionesEstrategicas) || other.decisionesEstrategicas == decisionesEstrategicas)&&(identical(other.relacionesInternas, relacionesInternas) || other.relacionesInternas == relacionesInternas)&&(identical(other.relacionesExternas, relacionesExternas) || other.relacionesExternas == relacionesExternas)&&(identical(other.escolaridadMinima, escolaridadMinima) || other.escolaridadMinima == escolaridadMinima)&&(identical(other.experienciaRequerida, experienciaRequerida) || other.experienciaRequerida == experienciaRequerida)&&(identical(other.idiomas, idiomas) || other.idiomas == idiomas)&&(identical(other.competenciasTecnicas, competenciasTecnicas) || other.competenciasTecnicas == competenciasTecnicas)&&const DeepCollectionEquality().equals(other.competencias, _competencias)&&(identical(other.competenciasOtras, competenciasOtras) || other.competenciasOtras == competenciasOtras)&&const DeepCollectionEquality().equals(other.recursos, _recursos)&&(identical(other.recursosOtro, recursosOtro) || other.recursosOtro == recursosOtro)&&const DeepCollectionEquality().equals(other.funciones, _funciones)&&const DeepCollectionEquality().equals(other.indicadores, _indicadores)&&const DeepCollectionEquality().equals(other.conformidades, _conformidades));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,posicion,posicionEtiqueta,version,congeladoEn,estaCongelado,nombrePuesto,empresa,areaDepartamento,reportaA,supervisaA,fechaElaboracion,edad,edadOtro,disponibilidadViajar,diasPorLaborar,diasPorLaborarOtro,horario,horarioOtro,proposito,decisionesOperativas,decisionesFuncionales,decisionesEstrategicas,relacionesInternas,relacionesExternas,escolaridadMinima,experienciaRequerida,idiomas,competenciasTecnicas,const DeepCollectionEquality().hash(_competencias),competenciasOtras,const DeepCollectionEquality().hash(_recursos),recursosOtro,const DeepCollectionEquality().hash(_funciones),const DeepCollectionEquality().hash(_indicadores),const DeepCollectionEquality().hash(_conformidades)]);
}

@override
String toString() {
    return 'Descriptivo(id: $id, posicion: $posicion, posicionEtiqueta: $posicionEtiqueta, version: $version, congeladoEn: $congeladoEn, estaCongelado: $estaCongelado, nombrePuesto: $nombrePuesto, empresa: $empresa, areaDepartamento: $areaDepartamento, reportaA: $reportaA, supervisaA: $supervisaA, fechaElaboracion: $fechaElaboracion, edad: $edad, edadOtro: $edadOtro, disponibilidadViajar: $disponibilidadViajar, diasPorLaborar: $diasPorLaborar, diasPorLaborarOtro: $diasPorLaborarOtro, horario: $horario, horarioOtro: $horarioOtro, proposito: $proposito, decisionesOperativas: $decisionesOperativas, decisionesFuncionales: $decisionesFuncionales, decisionesEstrategicas: $decisionesEstrategicas, relacionesInternas: $relacionesInternas, relacionesExternas: $relacionesExternas, escolaridadMinima: $escolaridadMinima, experienciaRequerida: $experienciaRequerida, idiomas: $idiomas, competenciasTecnicas: $competenciasTecnicas, competencias: $competencias, competenciasOtras: $competenciasOtras, recursos: $recursos, recursosOtro: $recursosOtro, funciones: $funciones, indicadores: $indicadores, conformidades: $conformidades)';
}


}

/// @nodoc
abstract mixin class _$DescriptivoCopyWith<$Res> implements $DescriptivoCopyWith<$Res> {
  factory _$DescriptivoCopyWith(_Descriptivo value, $Res Function(_Descriptivo) _then) = __$DescriptivoCopyWithImpl;
@override @useResult
$Res call({
 String id, String posicion,@JsonKey(name: 'posicion_etiqueta') String posicionEtiqueta, int version,@JsonKey(name: 'congelado_en') String? congeladoEn,@JsonKey(name: 'esta_congelado') bool estaCongelado,@JsonKey(name: 'nombre_puesto') String nombrePuesto, String empresa,@JsonKey(name: 'area_departamento') String areaDepartamento,@JsonKey(name: 'reporta_a') String reportaA,@JsonKey(name: 'supervisa_a') String supervisaA,@JsonKey(name: 'fecha_elaboracion') String fechaElaboracion, int? edad,@JsonKey(name: 'edad_otro') String edadOtro,@JsonKey(name: 'disponibilidad_viajar') bool? disponibilidadViajar,@JsonKey(name: 'dias_por_laborar') int? diasPorLaborar,@JsonKey(name: 'dias_por_laborar_otro') String diasPorLaborarOtro, int? horario,@JsonKey(name: 'horario_otro') String horarioOtro, String proposito,@JsonKey(name: 'decisiones_operativas') String decisionesOperativas,@JsonKey(name: 'decisiones_funcionales') String decisionesFuncionales,@JsonKey(name: 'decisiones_estrategicas') String decisionesEstrategicas,@JsonKey(name: 'relaciones_internas') String relacionesInternas,@JsonKey(name: 'relaciones_externas') String relacionesExternas,@JsonKey(name: 'escolaridad_minima') String escolaridadMinima,@JsonKey(name: 'experiencia_requerida') String experienciaRequerida, String idiomas,@JsonKey(name: 'competencias_tecnicas') String competenciasTecnicas, List<int> competencias,@JsonKey(name: 'competencias_otras') String competenciasOtras, List<int> recursos,@JsonKey(name: 'recursos_otro') String recursosOtro, List<TextoNumerado> funciones, List<TextoNumerado> indicadores, List<Conformidad> conformidades
});




}
/// @nodoc
class __$DescriptivoCopyWithImpl<$Res>
    implements _$DescriptivoCopyWith<$Res> {
  __$DescriptivoCopyWithImpl(this._self, this._then);

  final _Descriptivo _self;
  final $Res Function(_Descriptivo) _then;

/// Create a copy of Descriptivo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? posicion = null,Object? posicionEtiqueta = null,Object? version = null,Object? congeladoEn = freezed,Object? estaCongelado = null,Object? nombrePuesto = null,Object? empresa = null,Object? areaDepartamento = null,Object? reportaA = null,Object? supervisaA = null,Object? fechaElaboracion = null,Object? edad = freezed,Object? edadOtro = null,Object? disponibilidadViajar = freezed,Object? diasPorLaborar = freezed,Object? diasPorLaborarOtro = null,Object? horario = freezed,Object? horarioOtro = null,Object? proposito = null,Object? decisionesOperativas = null,Object? decisionesFuncionales = null,Object? decisionesEstrategicas = null,Object? relacionesInternas = null,Object? relacionesExternas = null,Object? escolaridadMinima = null,Object? experienciaRequerida = null,Object? idiomas = null,Object? competenciasTecnicas = null,Object? competencias = null,Object? competenciasOtras = null,Object? recursos = null,Object? recursosOtro = null,Object? funciones = null,Object? indicadores = null,Object? conformidades = null,}) {
  return _then(_Descriptivo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,posicion: null == posicion ? _self.posicion : posicion // ignore: cast_nullable_to_non_nullable
as String,posicionEtiqueta: null == posicionEtiqueta ? _self.posicionEtiqueta : posicionEtiqueta // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,congeladoEn: freezed == congeladoEn ? _self.congeladoEn : congeladoEn // ignore: cast_nullable_to_non_nullable
as String?,estaCongelado: null == estaCongelado ? _self.estaCongelado : estaCongelado // ignore: cast_nullable_to_non_nullable
as bool,nombrePuesto: null == nombrePuesto ? _self.nombrePuesto : nombrePuesto // ignore: cast_nullable_to_non_nullable
as String,empresa: null == empresa ? _self.empresa : empresa // ignore: cast_nullable_to_non_nullable
as String,areaDepartamento: null == areaDepartamento ? _self.areaDepartamento : areaDepartamento // ignore: cast_nullable_to_non_nullable
as String,reportaA: null == reportaA ? _self.reportaA : reportaA // ignore: cast_nullable_to_non_nullable
as String,supervisaA: null == supervisaA ? _self.supervisaA : supervisaA // ignore: cast_nullable_to_non_nullable
as String,fechaElaboracion: null == fechaElaboracion ? _self.fechaElaboracion : fechaElaboracion // ignore: cast_nullable_to_non_nullable
as String,edad: freezed == edad ? _self.edad : edad // ignore: cast_nullable_to_non_nullable
as int?,edadOtro: null == edadOtro ? _self.edadOtro : edadOtro // ignore: cast_nullable_to_non_nullable
as String,disponibilidadViajar: freezed == disponibilidadViajar ? _self.disponibilidadViajar : disponibilidadViajar // ignore: cast_nullable_to_non_nullable
as bool?,diasPorLaborar: freezed == diasPorLaborar ? _self.diasPorLaborar : diasPorLaborar // ignore: cast_nullable_to_non_nullable
as int?,diasPorLaborarOtro: null == diasPorLaborarOtro ? _self.diasPorLaborarOtro : diasPorLaborarOtro // ignore: cast_nullable_to_non_nullable
as String,horario: freezed == horario ? _self.horario : horario // ignore: cast_nullable_to_non_nullable
as int?,horarioOtro: null == horarioOtro ? _self.horarioOtro : horarioOtro // ignore: cast_nullable_to_non_nullable
as String,proposito: null == proposito ? _self.proposito : proposito // ignore: cast_nullable_to_non_nullable
as String,decisionesOperativas: null == decisionesOperativas ? _self.decisionesOperativas : decisionesOperativas // ignore: cast_nullable_to_non_nullable
as String,decisionesFuncionales: null == decisionesFuncionales ? _self.decisionesFuncionales : decisionesFuncionales // ignore: cast_nullable_to_non_nullable
as String,decisionesEstrategicas: null == decisionesEstrategicas ? _self.decisionesEstrategicas : decisionesEstrategicas // ignore: cast_nullable_to_non_nullable
as String,relacionesInternas: null == relacionesInternas ? _self.relacionesInternas : relacionesInternas // ignore: cast_nullable_to_non_nullable
as String,relacionesExternas: null == relacionesExternas ? _self.relacionesExternas : relacionesExternas // ignore: cast_nullable_to_non_nullable
as String,escolaridadMinima: null == escolaridadMinima ? _self.escolaridadMinima : escolaridadMinima // ignore: cast_nullable_to_non_nullable
as String,experienciaRequerida: null == experienciaRequerida ? _self.experienciaRequerida : experienciaRequerida // ignore: cast_nullable_to_non_nullable
as String,idiomas: null == idiomas ? _self.idiomas : idiomas // ignore: cast_nullable_to_non_nullable
as String,competenciasTecnicas: null == competenciasTecnicas ? _self.competenciasTecnicas : competenciasTecnicas // ignore: cast_nullable_to_non_nullable
as String,competencias: null == competencias ? _self._competencias : competencias // ignore: cast_nullable_to_non_nullable
as List<int>,competenciasOtras: null == competenciasOtras ? _self.competenciasOtras : competenciasOtras // ignore: cast_nullable_to_non_nullable
as String,recursos: null == recursos ? _self._recursos : recursos // ignore: cast_nullable_to_non_nullable
as List<int>,recursosOtro: null == recursosOtro ? _self.recursosOtro : recursosOtro // ignore: cast_nullable_to_non_nullable
as String,funciones: null == funciones ? _self._funciones : funciones // ignore: cast_nullable_to_non_nullable
as List<TextoNumerado>,indicadores: null == indicadores ? _self._indicadores : indicadores // ignore: cast_nullable_to_non_nullable
as List<TextoNumerado>,conformidades: null == conformidades ? _self._conformidades : conformidades // ignore: cast_nullable_to_non_nullable
as List<Conformidad>,
  ));
}


}

// dart format on
