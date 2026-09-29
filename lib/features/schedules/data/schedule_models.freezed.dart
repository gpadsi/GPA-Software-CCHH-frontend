// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Catorcena {

 String get id; int get numero; int get anio;@JsonKey(name: 'fecha_inicio') String get fechaInicio;@JsonKey(name: 'fecha_fin') String get fechaFin;
/// Create a copy of Catorcena
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatorcenaCopyWith<Catorcena> get copyWith => _$CatorcenaCopyWithImpl<Catorcena>(this as Catorcena, _$identity);

  /// Serializes this Catorcena to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Catorcena;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Catorcena&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numero, _this.numero) || other.numero == _this.numero)&&(identical(other.anio, _this.anio) || other.anio == _this.anio)&&(identical(other.fechaInicio, _this.fechaInicio) || other.fechaInicio == _this.fechaInicio)&&(identical(other.fechaFin, _this.fechaFin) || other.fechaFin == _this.fechaFin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Catorcena;
  return Object.hash(runtimeType,_this.id,_this.numero,_this.anio,_this.fechaInicio,_this.fechaFin);
}

@override
String toString() {
  final _this = this as Catorcena;
  return 'Catorcena(id: ${_this.id}, numero: ${_this.numero}, anio: ${_this.anio}, fechaInicio: ${_this.fechaInicio}, fechaFin: ${_this.fechaFin})';
}


}

/// @nodoc
abstract mixin class $CatorcenaCopyWith<$Res>  {
  factory $CatorcenaCopyWith(Catorcena value, $Res Function(Catorcena) _then) = _$CatorcenaCopyWithImpl;
@useResult
$Res call({
 String id, int numero, int anio,@JsonKey(name: 'fecha_inicio') String fechaInicio,@JsonKey(name: 'fecha_fin') String fechaFin
});




}
/// @nodoc
class _$CatorcenaCopyWithImpl<$Res>
    implements $CatorcenaCopyWith<$Res> {
  _$CatorcenaCopyWithImpl(this._self, this._then);

  final Catorcena _self;
  final $Res Function(Catorcena) _then;

/// Create a copy of Catorcena
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numero = null,Object? anio = null,Object? fechaInicio = null,Object? fechaFin = null,}) {
  return _then(Catorcena(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,anio: null == anio ? _self.anio : anio // ignore: cast_nullable_to_non_nullable
as int,fechaInicio: null == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String,fechaFin: null == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Catorcena].
extension CatorcenaPatterns on Catorcena {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Catorcena value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Catorcena() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Catorcena value)  $default,){
final _that = this;
switch (_that) {
case _Catorcena():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Catorcena value)?  $default,){
final _that = this;
switch (_that) {
case _Catorcena() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int numero,  int anio, @JsonKey(name: 'fecha_inicio')  String fechaInicio, @JsonKey(name: 'fecha_fin')  String fechaFin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Catorcena() when $default != null:
return $default(_that.id,_that.numero,_that.anio,_that.fechaInicio,_that.fechaFin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int numero,  int anio, @JsonKey(name: 'fecha_inicio')  String fechaInicio, @JsonKey(name: 'fecha_fin')  String fechaFin)  $default,) {final _that = this;
switch (_that) {
case _Catorcena():
return $default(_that.id,_that.numero,_that.anio,_that.fechaInicio,_that.fechaFin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int numero,  int anio, @JsonKey(name: 'fecha_inicio')  String fechaInicio, @JsonKey(name: 'fecha_fin')  String fechaFin)?  $default,) {final _that = this;
switch (_that) {
case _Catorcena() when $default != null:
return $default(_that.id,_that.numero,_that.anio,_that.fechaInicio,_that.fechaFin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Catorcena implements Catorcena {
  const _Catorcena({required this.id, required this.numero, required this.anio, @JsonKey(name: 'fecha_inicio') required this.fechaInicio, @JsonKey(name: 'fecha_fin') required this.fechaFin});
  factory _Catorcena.fromJson(Map<String, dynamic> json) => _$CatorcenaFromJson(json);

@override final  String id;
@override final  int numero;
@override final  int anio;
@override@JsonKey(name: 'fecha_inicio') final  String fechaInicio;
@override@JsonKey(name: 'fecha_fin') final  String fechaFin;

/// Create a copy of Catorcena
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatorcenaCopyWith<_Catorcena> get copyWith => __$CatorcenaCopyWithImpl<_Catorcena>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatorcenaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Catorcena&&(identical(other.id, id) || other.id == id)&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.anio, anio) || other.anio == anio)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numero,anio,fechaInicio,fechaFin);
}

@override
String toString() {
    return 'Catorcena(id: $id, numero: $numero, anio: $anio, fechaInicio: $fechaInicio, fechaFin: $fechaFin)';
}


}

/// @nodoc
abstract mixin class _$CatorcenaCopyWith<$Res> implements $CatorcenaCopyWith<$Res> {
  factory _$CatorcenaCopyWith(_Catorcena value, $Res Function(_Catorcena) _then) = __$CatorcenaCopyWithImpl;
@override @useResult
$Res call({
 String id, int numero, int anio,@JsonKey(name: 'fecha_inicio') String fechaInicio,@JsonKey(name: 'fecha_fin') String fechaFin
});




}
/// @nodoc
class __$CatorcenaCopyWithImpl<$Res>
    implements _$CatorcenaCopyWith<$Res> {
  __$CatorcenaCopyWithImpl(this._self, this._then);

  final _Catorcena _self;
  final $Res Function(_Catorcena) _then;

/// Create a copy of Catorcena
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numero = null,Object? anio = null,Object? fechaInicio = null,Object? fechaFin = null,}) {
  return _then(_Catorcena(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,anio: null == anio ? _self.anio : anio // ignore: cast_nullable_to_non_nullable
as int,fechaInicio: null == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String,fechaFin: null == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TipoHorarioRef {

 int get id; String get code; String get name; String get descripcion;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of TipoHorarioRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TipoHorarioRefCopyWith<TipoHorarioRef> get copyWith => _$TipoHorarioRefCopyWithImpl<TipoHorarioRef>(this as TipoHorarioRef, _$identity);

  /// Serializes this TipoHorarioRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TipoHorarioRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TipoHorarioRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.descripcion, _this.descripcion) || other.descripcion == _this.descripcion)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TipoHorarioRef;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.descripcion,_this.isActive);
}

@override
String toString() {
  final _this = this as TipoHorarioRef;
  return 'TipoHorarioRef(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, descripcion: ${_this.descripcion}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $TipoHorarioRefCopyWith<$Res>  {
  factory $TipoHorarioRefCopyWith(TipoHorarioRef value, $Res Function(TipoHorarioRef) _then) = _$TipoHorarioRefCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name, String descripcion,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$TipoHorarioRefCopyWithImpl<$Res>
    implements $TipoHorarioRefCopyWith<$Res> {
  _$TipoHorarioRefCopyWithImpl(this._self, this._then);

  final TipoHorarioRef _self;
  final $Res Function(TipoHorarioRef) _then;

/// Create a copy of TipoHorarioRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? descripcion = null,Object? isActive = null,}) {
  return _then(TipoHorarioRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,descripcion: null == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TipoHorarioRef].
extension TipoHorarioRefPatterns on TipoHorarioRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TipoHorarioRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TipoHorarioRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TipoHorarioRef value)  $default,){
final _that = this;
switch (_that) {
case _TipoHorarioRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TipoHorarioRef value)?  $default,){
final _that = this;
switch (_that) {
case _TipoHorarioRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String descripcion, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TipoHorarioRef() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.descripcion,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String descripcion, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _TipoHorarioRef():
return $default(_that.id,_that.code,_that.name,_that.descripcion,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name,  String descripcion, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _TipoHorarioRef() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.descripcion,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TipoHorarioRef implements TipoHorarioRef {
  const _TipoHorarioRef({required this.id, required this.code, required this.name, this.descripcion = '', @JsonKey(name: 'is_active') required this.isActive});
  factory _TipoHorarioRef.fromJson(Map<String, dynamic> json) => _$TipoHorarioRefFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override@JsonKey() final  String descripcion;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of TipoHorarioRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TipoHorarioRefCopyWith<_TipoHorarioRef> get copyWith => __$TipoHorarioRefCopyWithImpl<_TipoHorarioRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TipoHorarioRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TipoHorarioRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,descripcion,isActive);
}

@override
String toString() {
    return 'TipoHorarioRef(id: $id, code: $code, name: $name, descripcion: $descripcion, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TipoHorarioRefCopyWith<$Res> implements $TipoHorarioRefCopyWith<$Res> {
  factory _$TipoHorarioRefCopyWith(_TipoHorarioRef value, $Res Function(_TipoHorarioRef) _then) = __$TipoHorarioRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name, String descripcion,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$TipoHorarioRefCopyWithImpl<$Res>
    implements _$TipoHorarioRefCopyWith<$Res> {
  __$TipoHorarioRefCopyWithImpl(this._self, this._then);

  final _TipoHorarioRef _self;
  final $Res Function(_TipoHorarioRef) _then;

/// Create a copy of TipoHorarioRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? descripcion = null,Object? isActive = null,}) {
  return _then(_TipoHorarioRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,descripcion: null == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EmpleadoRef {

 String get id;@JsonKey(name: 'work_number') String? get workNumber;
/// Create a copy of EmpleadoRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmpleadoRefCopyWith<EmpleadoRef> get copyWith => _$EmpleadoRefCopyWithImpl<EmpleadoRef>(this as EmpleadoRef, _$identity);

  /// Serializes this EmpleadoRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EmpleadoRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmpleadoRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.workNumber, _this.workNumber) || other.workNumber == _this.workNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EmpleadoRef;
  return Object.hash(runtimeType,_this.id,_this.workNumber);
}

@override
String toString() {
  final _this = this as EmpleadoRef;
  return 'EmpleadoRef(id: ${_this.id}, workNumber: ${_this.workNumber})';
}


}

/// @nodoc
abstract mixin class $EmpleadoRefCopyWith<$Res>  {
  factory $EmpleadoRefCopyWith(EmpleadoRef value, $Res Function(EmpleadoRef) _then) = _$EmpleadoRefCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'work_number') String? workNumber
});




}
/// @nodoc
class _$EmpleadoRefCopyWithImpl<$Res>
    implements $EmpleadoRefCopyWith<$Res> {
  _$EmpleadoRefCopyWithImpl(this._self, this._then);

  final EmpleadoRef _self;
  final $Res Function(EmpleadoRef) _then;

/// Create a copy of EmpleadoRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workNumber = freezed,}) {
  return _then(EmpleadoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workNumber: freezed == workNumber ? _self.workNumber : workNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmpleadoRef].
extension EmpleadoRefPatterns on EmpleadoRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmpleadoRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmpleadoRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmpleadoRef value)  $default,){
final _that = this;
switch (_that) {
case _EmpleadoRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmpleadoRef value)?  $default,){
final _that = this;
switch (_that) {
case _EmpleadoRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'work_number')  String? workNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmpleadoRef() when $default != null:
return $default(_that.id,_that.workNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'work_number')  String? workNumber)  $default,) {final _that = this;
switch (_that) {
case _EmpleadoRef():
return $default(_that.id,_that.workNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'work_number')  String? workNumber)?  $default,) {final _that = this;
switch (_that) {
case _EmpleadoRef() when $default != null:
return $default(_that.id,_that.workNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmpleadoRef implements EmpleadoRef {
  const _EmpleadoRef({required this.id, @JsonKey(name: 'work_number') this.workNumber});
  factory _EmpleadoRef.fromJson(Map<String, dynamic> json) => _$EmpleadoRefFromJson(json);

@override final  String id;
@override@JsonKey(name: 'work_number') final  String? workNumber;

/// Create a copy of EmpleadoRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmpleadoRefCopyWith<_EmpleadoRef> get copyWith => __$EmpleadoRefCopyWithImpl<_EmpleadoRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmpleadoRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmpleadoRef&&(identical(other.id, id) || other.id == id)&&(identical(other.workNumber, workNumber) || other.workNumber == workNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,workNumber);
}

@override
String toString() {
    return 'EmpleadoRef(id: $id, workNumber: $workNumber)';
}


}

/// @nodoc
abstract mixin class _$EmpleadoRefCopyWith<$Res> implements $EmpleadoRefCopyWith<$Res> {
  factory _$EmpleadoRefCopyWith(_EmpleadoRef value, $Res Function(_EmpleadoRef) _then) = __$EmpleadoRefCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'work_number') String? workNumber
});




}
/// @nodoc
class __$EmpleadoRefCopyWithImpl<$Res>
    implements _$EmpleadoRefCopyWith<$Res> {
  __$EmpleadoRefCopyWithImpl(this._self, this._then);

  final _EmpleadoRef _self;
  final $Res Function(_EmpleadoRef) _then;

/// Create a copy of EmpleadoRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workNumber = freezed,}) {
  return _then(_EmpleadoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workNumber: freezed == workNumber ? _self.workNumber : workNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AreaRef {

 String get id; String get code; String get name;
/// Create a copy of AreaRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaRefCopyWith<AreaRef> get copyWith => _$AreaRefCopyWithImpl<AreaRef>(this as AreaRef, _$identity);

  /// Serializes this AreaRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AreaRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AreaRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AreaRef;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as AreaRef;
  return 'AreaRef(id: ${_this.id}, code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $AreaRefCopyWith<$Res>  {
  factory $AreaRefCopyWith(AreaRef value, $Res Function(AreaRef) _then) = _$AreaRefCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class _$AreaRefCopyWithImpl<$Res>
    implements $AreaRefCopyWith<$Res> {
  _$AreaRefCopyWithImpl(this._self, this._then);

  final AreaRef _self;
  final $Res Function(AreaRef) _then;

/// Create a copy of AreaRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(AreaRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AreaRef].
extension AreaRefPatterns on AreaRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AreaRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AreaRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AreaRef value)  $default,){
final _that = this;
switch (_that) {
case _AreaRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AreaRef value)?  $default,){
final _that = this;
switch (_that) {
case _AreaRef() when $default != null:
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
case _AreaRef() when $default != null:
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
case _AreaRef():
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
case _AreaRef() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AreaRef implements AreaRef {
  const _AreaRef({required this.id, required this.code, required this.name});
  factory _AreaRef.fromJson(Map<String, dynamic> json) => _$AreaRefFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;

/// Create a copy of AreaRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AreaRefCopyWith<_AreaRef> get copyWith => __$AreaRefCopyWithImpl<_AreaRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AreaRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AreaRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name);
}

@override
String toString() {
    return 'AreaRef(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AreaRefCopyWith<$Res> implements $AreaRefCopyWith<$Res> {
  factory _$AreaRefCopyWith(_AreaRef value, $Res Function(_AreaRef) _then) = __$AreaRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class __$AreaRefCopyWithImpl<$Res>
    implements _$AreaRefCopyWith<$Res> {
  __$AreaRefCopyWithImpl(this._self, this._then);

  final _AreaRef _self;
  final $Res Function(_AreaRef) _then;

/// Create a copy of AreaRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_AreaRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AsignacionHorario {

 String get id; String get empleado; String? get catorcena;@JsonKey(name: 'fecha_referencia') String get fechaReferencia;@JsonKey(name: 'tipo_horario') int get tipoHorario;
/// Create a copy of AsignacionHorario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsignacionHorarioCopyWith<AsignacionHorario> get copyWith => _$AsignacionHorarioCopyWithImpl<AsignacionHorario>(this as AsignacionHorario, _$identity);

  /// Serializes this AsignacionHorario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AsignacionHorario;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsignacionHorario&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.empleado, _this.empleado) || other.empleado == _this.empleado)&&(identical(other.catorcena, _this.catorcena) || other.catorcena == _this.catorcena)&&(identical(other.fechaReferencia, _this.fechaReferencia) || other.fechaReferencia == _this.fechaReferencia)&&(identical(other.tipoHorario, _this.tipoHorario) || other.tipoHorario == _this.tipoHorario));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AsignacionHorario;
  return Object.hash(runtimeType,_this.id,_this.empleado,_this.catorcena,_this.fechaReferencia,_this.tipoHorario);
}

@override
String toString() {
  final _this = this as AsignacionHorario;
  return 'AsignacionHorario(id: ${_this.id}, empleado: ${_this.empleado}, catorcena: ${_this.catorcena}, fechaReferencia: ${_this.fechaReferencia}, tipoHorario: ${_this.tipoHorario})';
}


}

/// @nodoc
abstract mixin class $AsignacionHorarioCopyWith<$Res>  {
  factory $AsignacionHorarioCopyWith(AsignacionHorario value, $Res Function(AsignacionHorario) _then) = _$AsignacionHorarioCopyWithImpl;
@useResult
$Res call({
 String id, String empleado, String? catorcena,@JsonKey(name: 'fecha_referencia') String fechaReferencia,@JsonKey(name: 'tipo_horario') int tipoHorario
});




}
/// @nodoc
class _$AsignacionHorarioCopyWithImpl<$Res>
    implements $AsignacionHorarioCopyWith<$Res> {
  _$AsignacionHorarioCopyWithImpl(this._self, this._then);

  final AsignacionHorario _self;
  final $Res Function(AsignacionHorario) _then;

/// Create a copy of AsignacionHorario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? empleado = null,Object? catorcena = freezed,Object? fechaReferencia = null,Object? tipoHorario = null,}) {
  return _then(AsignacionHorario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,empleado: null == empleado ? _self.empleado : empleado // ignore: cast_nullable_to_non_nullable
as String,catorcena: freezed == catorcena ? _self.catorcena : catorcena // ignore: cast_nullable_to_non_nullable
as String?,fechaReferencia: null == fechaReferencia ? _self.fechaReferencia : fechaReferencia // ignore: cast_nullable_to_non_nullable
as String,tipoHorario: null == tipoHorario ? _self.tipoHorario : tipoHorario // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AsignacionHorario].
extension AsignacionHorarioPatterns on AsignacionHorario {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AsignacionHorario value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AsignacionHorario() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AsignacionHorario value)  $default,){
final _that = this;
switch (_that) {
case _AsignacionHorario():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AsignacionHorario value)?  $default,){
final _that = this;
switch (_that) {
case _AsignacionHorario() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String empleado,  String? catorcena, @JsonKey(name: 'fecha_referencia')  String fechaReferencia, @JsonKey(name: 'tipo_horario')  int tipoHorario)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AsignacionHorario() when $default != null:
return $default(_that.id,_that.empleado,_that.catorcena,_that.fechaReferencia,_that.tipoHorario);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String empleado,  String? catorcena, @JsonKey(name: 'fecha_referencia')  String fechaReferencia, @JsonKey(name: 'tipo_horario')  int tipoHorario)  $default,) {final _that = this;
switch (_that) {
case _AsignacionHorario():
return $default(_that.id,_that.empleado,_that.catorcena,_that.fechaReferencia,_that.tipoHorario);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String empleado,  String? catorcena, @JsonKey(name: 'fecha_referencia')  String fechaReferencia, @JsonKey(name: 'tipo_horario')  int tipoHorario)?  $default,) {final _that = this;
switch (_that) {
case _AsignacionHorario() when $default != null:
return $default(_that.id,_that.empleado,_that.catorcena,_that.fechaReferencia,_that.tipoHorario);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AsignacionHorario implements AsignacionHorario {
  const _AsignacionHorario({required this.id, required this.empleado, this.catorcena, @JsonKey(name: 'fecha_referencia') required this.fechaReferencia, @JsonKey(name: 'tipo_horario') required this.tipoHorario});
  factory _AsignacionHorario.fromJson(Map<String, dynamic> json) => _$AsignacionHorarioFromJson(json);

@override final  String id;
@override final  String empleado;
@override final  String? catorcena;
@override@JsonKey(name: 'fecha_referencia') final  String fechaReferencia;
@override@JsonKey(name: 'tipo_horario') final  int tipoHorario;

/// Create a copy of AsignacionHorario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AsignacionHorarioCopyWith<_AsignacionHorario> get copyWith => __$AsignacionHorarioCopyWithImpl<_AsignacionHorario>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AsignacionHorarioToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsignacionHorario&&(identical(other.id, id) || other.id == id)&&(identical(other.empleado, empleado) || other.empleado == empleado)&&(identical(other.catorcena, catorcena) || other.catorcena == catorcena)&&(identical(other.fechaReferencia, fechaReferencia) || other.fechaReferencia == fechaReferencia)&&(identical(other.tipoHorario, tipoHorario) || other.tipoHorario == tipoHorario));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,empleado,catorcena,fechaReferencia,tipoHorario);
}

@override
String toString() {
    return 'AsignacionHorario(id: $id, empleado: $empleado, catorcena: $catorcena, fechaReferencia: $fechaReferencia, tipoHorario: $tipoHorario)';
}


}

/// @nodoc
abstract mixin class _$AsignacionHorarioCopyWith<$Res> implements $AsignacionHorarioCopyWith<$Res> {
  factory _$AsignacionHorarioCopyWith(_AsignacionHorario value, $Res Function(_AsignacionHorario) _then) = __$AsignacionHorarioCopyWithImpl;
@override @useResult
$Res call({
 String id, String empleado, String? catorcena,@JsonKey(name: 'fecha_referencia') String fechaReferencia,@JsonKey(name: 'tipo_horario') int tipoHorario
});




}
/// @nodoc
class __$AsignacionHorarioCopyWithImpl<$Res>
    implements _$AsignacionHorarioCopyWith<$Res> {
  __$AsignacionHorarioCopyWithImpl(this._self, this._then);

  final _AsignacionHorario _self;
  final $Res Function(_AsignacionHorario) _then;

/// Create a copy of AsignacionHorario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? empleado = null,Object? catorcena = freezed,Object? fechaReferencia = null,Object? tipoHorario = null,}) {
  return _then(_AsignacionHorario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,empleado: null == empleado ? _self.empleado : empleado // ignore: cast_nullable_to_non_nullable
as String,catorcena: freezed == catorcena ? _self.catorcena : catorcena // ignore: cast_nullable_to_non_nullable
as String?,fechaReferencia: null == fechaReferencia ? _self.fechaReferencia : fechaReferencia // ignore: cast_nullable_to_non_nullable
as String,tipoHorario: null == tipoHorario ? _self.tipoHorario : tipoHorario // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AsignacionUbicacion {

 String get id; String get empleado; String? get catorcena;@JsonKey(name: 'fecha_referencia') String get fechaReferencia; String get area;
/// Create a copy of AsignacionUbicacion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsignacionUbicacionCopyWith<AsignacionUbicacion> get copyWith => _$AsignacionUbicacionCopyWithImpl<AsignacionUbicacion>(this as AsignacionUbicacion, _$identity);

  /// Serializes this AsignacionUbicacion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AsignacionUbicacion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsignacionUbicacion&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.empleado, _this.empleado) || other.empleado == _this.empleado)&&(identical(other.catorcena, _this.catorcena) || other.catorcena == _this.catorcena)&&(identical(other.fechaReferencia, _this.fechaReferencia) || other.fechaReferencia == _this.fechaReferencia)&&(identical(other.area, _this.area) || other.area == _this.area));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AsignacionUbicacion;
  return Object.hash(runtimeType,_this.id,_this.empleado,_this.catorcena,_this.fechaReferencia,_this.area);
}

@override
String toString() {
  final _this = this as AsignacionUbicacion;
  return 'AsignacionUbicacion(id: ${_this.id}, empleado: ${_this.empleado}, catorcena: ${_this.catorcena}, fechaReferencia: ${_this.fechaReferencia}, area: ${_this.area})';
}


}

/// @nodoc
abstract mixin class $AsignacionUbicacionCopyWith<$Res>  {
  factory $AsignacionUbicacionCopyWith(AsignacionUbicacion value, $Res Function(AsignacionUbicacion) _then) = _$AsignacionUbicacionCopyWithImpl;
@useResult
$Res call({
 String id, String empleado, String? catorcena,@JsonKey(name: 'fecha_referencia') String fechaReferencia, String area
});




}
/// @nodoc
class _$AsignacionUbicacionCopyWithImpl<$Res>
    implements $AsignacionUbicacionCopyWith<$Res> {
  _$AsignacionUbicacionCopyWithImpl(this._self, this._then);

  final AsignacionUbicacion _self;
  final $Res Function(AsignacionUbicacion) _then;

/// Create a copy of AsignacionUbicacion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? empleado = null,Object? catorcena = freezed,Object? fechaReferencia = null,Object? area = null,}) {
  return _then(AsignacionUbicacion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,empleado: null == empleado ? _self.empleado : empleado // ignore: cast_nullable_to_non_nullable
as String,catorcena: freezed == catorcena ? _self.catorcena : catorcena // ignore: cast_nullable_to_non_nullable
as String?,fechaReferencia: null == fechaReferencia ? _self.fechaReferencia : fechaReferencia // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AsignacionUbicacion].
extension AsignacionUbicacionPatterns on AsignacionUbicacion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AsignacionUbicacion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AsignacionUbicacion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AsignacionUbicacion value)  $default,){
final _that = this;
switch (_that) {
case _AsignacionUbicacion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AsignacionUbicacion value)?  $default,){
final _that = this;
switch (_that) {
case _AsignacionUbicacion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String empleado,  String? catorcena, @JsonKey(name: 'fecha_referencia')  String fechaReferencia,  String area)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AsignacionUbicacion() when $default != null:
return $default(_that.id,_that.empleado,_that.catorcena,_that.fechaReferencia,_that.area);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String empleado,  String? catorcena, @JsonKey(name: 'fecha_referencia')  String fechaReferencia,  String area)  $default,) {final _that = this;
switch (_that) {
case _AsignacionUbicacion():
return $default(_that.id,_that.empleado,_that.catorcena,_that.fechaReferencia,_that.area);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String empleado,  String? catorcena, @JsonKey(name: 'fecha_referencia')  String fechaReferencia,  String area)?  $default,) {final _that = this;
switch (_that) {
case _AsignacionUbicacion() when $default != null:
return $default(_that.id,_that.empleado,_that.catorcena,_that.fechaReferencia,_that.area);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AsignacionUbicacion implements AsignacionUbicacion {
  const _AsignacionUbicacion({required this.id, required this.empleado, this.catorcena, @JsonKey(name: 'fecha_referencia') required this.fechaReferencia, required this.area});
  factory _AsignacionUbicacion.fromJson(Map<String, dynamic> json) => _$AsignacionUbicacionFromJson(json);

@override final  String id;
@override final  String empleado;
@override final  String? catorcena;
@override@JsonKey(name: 'fecha_referencia') final  String fechaReferencia;
@override final  String area;

/// Create a copy of AsignacionUbicacion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AsignacionUbicacionCopyWith<_AsignacionUbicacion> get copyWith => __$AsignacionUbicacionCopyWithImpl<_AsignacionUbicacion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AsignacionUbicacionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsignacionUbicacion&&(identical(other.id, id) || other.id == id)&&(identical(other.empleado, empleado) || other.empleado == empleado)&&(identical(other.catorcena, catorcena) || other.catorcena == catorcena)&&(identical(other.fechaReferencia, fechaReferencia) || other.fechaReferencia == fechaReferencia)&&(identical(other.area, area) || other.area == area));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,empleado,catorcena,fechaReferencia,area);
}

@override
String toString() {
    return 'AsignacionUbicacion(id: $id, empleado: $empleado, catorcena: $catorcena, fechaReferencia: $fechaReferencia, area: $area)';
}


}

/// @nodoc
abstract mixin class _$AsignacionUbicacionCopyWith<$Res> implements $AsignacionUbicacionCopyWith<$Res> {
  factory _$AsignacionUbicacionCopyWith(_AsignacionUbicacion value, $Res Function(_AsignacionUbicacion) _then) = __$AsignacionUbicacionCopyWithImpl;
@override @useResult
$Res call({
 String id, String empleado, String? catorcena,@JsonKey(name: 'fecha_referencia') String fechaReferencia, String area
});




}
/// @nodoc
class __$AsignacionUbicacionCopyWithImpl<$Res>
    implements _$AsignacionUbicacionCopyWith<$Res> {
  __$AsignacionUbicacionCopyWithImpl(this._self, this._then);

  final _AsignacionUbicacion _self;
  final $Res Function(_AsignacionUbicacion) _then;

/// Create a copy of AsignacionUbicacion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? empleado = null,Object? catorcena = freezed,Object? fechaReferencia = null,Object? area = null,}) {
  return _then(_AsignacionUbicacion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,empleado: null == empleado ? _self.empleado : empleado // ignore: cast_nullable_to_non_nullable
as String,catorcena: freezed == catorcena ? _self.catorcena : catorcena // ignore: cast_nullable_to_non_nullable
as String?,fechaReferencia: null == fechaReferencia ? _self.fechaReferencia : fechaReferencia // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
