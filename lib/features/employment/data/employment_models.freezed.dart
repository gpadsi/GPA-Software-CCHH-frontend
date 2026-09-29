// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Empleado {

 String get id; String get persona; String? get user;@JsonKey(name: 'work_number') String? get workNumber;
/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmpleadoCopyWith<Empleado> get copyWith => _$EmpleadoCopyWithImpl<Empleado>(this as Empleado, _$identity);

  /// Serializes this Empleado to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Empleado;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Empleado&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.persona, _this.persona) || other.persona == _this.persona)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.workNumber, _this.workNumber) || other.workNumber == _this.workNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Empleado;
  return Object.hash(runtimeType,_this.id,_this.persona,_this.user,_this.workNumber);
}

@override
String toString() {
  final _this = this as Empleado;
  return 'Empleado(id: ${_this.id}, persona: ${_this.persona}, user: ${_this.user}, workNumber: ${_this.workNumber})';
}


}

/// @nodoc
abstract mixin class $EmpleadoCopyWith<$Res>  {
  factory $EmpleadoCopyWith(Empleado value, $Res Function(Empleado) _then) = _$EmpleadoCopyWithImpl;
@useResult
$Res call({
 String id, String persona, String? user,@JsonKey(name: 'work_number') String? workNumber
});




}
/// @nodoc
class _$EmpleadoCopyWithImpl<$Res>
    implements $EmpleadoCopyWith<$Res> {
  _$EmpleadoCopyWithImpl(this._self, this._then);

  final Empleado _self;
  final $Res Function(Empleado) _then;

/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? persona = null,Object? user = freezed,Object? workNumber = freezed,}) {
  return _then(Empleado(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,workNumber: freezed == workNumber ? _self.workNumber : workNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Empleado].
extension EmpleadoPatterns on Empleado {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Empleado value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Empleado() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Empleado value)  $default,){
final _that = this;
switch (_that) {
case _Empleado():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Empleado value)?  $default,){
final _that = this;
switch (_that) {
case _Empleado() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String persona,  String? user, @JsonKey(name: 'work_number')  String? workNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Empleado() when $default != null:
return $default(_that.id,_that.persona,_that.user,_that.workNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String persona,  String? user, @JsonKey(name: 'work_number')  String? workNumber)  $default,) {final _that = this;
switch (_that) {
case _Empleado():
return $default(_that.id,_that.persona,_that.user,_that.workNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String persona,  String? user, @JsonKey(name: 'work_number')  String? workNumber)?  $default,) {final _that = this;
switch (_that) {
case _Empleado() when $default != null:
return $default(_that.id,_that.persona,_that.user,_that.workNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Empleado implements Empleado {
  const _Empleado({required this.id, required this.persona, this.user, @JsonKey(name: 'work_number') this.workNumber});
  factory _Empleado.fromJson(Map<String, dynamic> json) => _$EmpleadoFromJson(json);

@override final  String id;
@override final  String persona;
@override final  String? user;
@override@JsonKey(name: 'work_number') final  String? workNumber;

/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmpleadoCopyWith<_Empleado> get copyWith => __$EmpleadoCopyWithImpl<_Empleado>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmpleadoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empleado&&(identical(other.id, id) || other.id == id)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.user, user) || other.user == user)&&(identical(other.workNumber, workNumber) || other.workNumber == workNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,persona,user,workNumber);
}

@override
String toString() {
    return 'Empleado(id: $id, persona: $persona, user: $user, workNumber: $workNumber)';
}


}

/// @nodoc
abstract mixin class _$EmpleadoCopyWith<$Res> implements $EmpleadoCopyWith<$Res> {
  factory _$EmpleadoCopyWith(_Empleado value, $Res Function(_Empleado) _then) = __$EmpleadoCopyWithImpl;
@override @useResult
$Res call({
 String id, String persona, String? user,@JsonKey(name: 'work_number') String? workNumber
});




}
/// @nodoc
class __$EmpleadoCopyWithImpl<$Res>
    implements _$EmpleadoCopyWith<$Res> {
  __$EmpleadoCopyWithImpl(this._self, this._then);

  final _Empleado _self;
  final $Res Function(_Empleado) _then;

/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? persona = null,Object? user = freezed,Object? workNumber = freezed,}) {
  return _then(_Empleado(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,workNumber: freezed == workNumber ? _self.workNumber : workNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Contrato {

 String get id; String get empleado; String get posicion;@JsonKey(name: 'fecha_ingreso') String? get fechaIngreso;@JsonKey(name: 'fecha_alta') String? get fechaAlta;@JsonKey(name: 'fecha_reingreso') String? get fechaReingreso;@JsonKey(name: 'fecha_baja') String? get fechaBaja;
/// Create a copy of Contrato
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContratoCopyWith<Contrato> get copyWith => _$ContratoCopyWithImpl<Contrato>(this as Contrato, _$identity);

  /// Serializes this Contrato to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Contrato;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contrato&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.empleado, _this.empleado) || other.empleado == _this.empleado)&&(identical(other.posicion, _this.posicion) || other.posicion == _this.posicion)&&(identical(other.fechaIngreso, _this.fechaIngreso) || other.fechaIngreso == _this.fechaIngreso)&&(identical(other.fechaAlta, _this.fechaAlta) || other.fechaAlta == _this.fechaAlta)&&(identical(other.fechaReingreso, _this.fechaReingreso) || other.fechaReingreso == _this.fechaReingreso)&&(identical(other.fechaBaja, _this.fechaBaja) || other.fechaBaja == _this.fechaBaja));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Contrato;
  return Object.hash(runtimeType,_this.id,_this.empleado,_this.posicion,_this.fechaIngreso,_this.fechaAlta,_this.fechaReingreso,_this.fechaBaja);
}

@override
String toString() {
  final _this = this as Contrato;
  return 'Contrato(id: ${_this.id}, empleado: ${_this.empleado}, posicion: ${_this.posicion}, fechaIngreso: ${_this.fechaIngreso}, fechaAlta: ${_this.fechaAlta}, fechaReingreso: ${_this.fechaReingreso}, fechaBaja: ${_this.fechaBaja})';
}


}

/// @nodoc
abstract mixin class $ContratoCopyWith<$Res>  {
  factory $ContratoCopyWith(Contrato value, $Res Function(Contrato) _then) = _$ContratoCopyWithImpl;
@useResult
$Res call({
 String id, String empleado, String posicion,@JsonKey(name: 'fecha_ingreso') String? fechaIngreso,@JsonKey(name: 'fecha_alta') String? fechaAlta,@JsonKey(name: 'fecha_reingreso') String? fechaReingreso,@JsonKey(name: 'fecha_baja') String? fechaBaja
});




}
/// @nodoc
class _$ContratoCopyWithImpl<$Res>
    implements $ContratoCopyWith<$Res> {
  _$ContratoCopyWithImpl(this._self, this._then);

  final Contrato _self;
  final $Res Function(Contrato) _then;

/// Create a copy of Contrato
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? empleado = null,Object? posicion = null,Object? fechaIngreso = freezed,Object? fechaAlta = freezed,Object? fechaReingreso = freezed,Object? fechaBaja = freezed,}) {
  return _then(Contrato(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,empleado: null == empleado ? _self.empleado : empleado // ignore: cast_nullable_to_non_nullable
as String,posicion: null == posicion ? _self.posicion : posicion // ignore: cast_nullable_to_non_nullable
as String,fechaIngreso: freezed == fechaIngreso ? _self.fechaIngreso : fechaIngreso // ignore: cast_nullable_to_non_nullable
as String?,fechaAlta: freezed == fechaAlta ? _self.fechaAlta : fechaAlta // ignore: cast_nullable_to_non_nullable
as String?,fechaReingreso: freezed == fechaReingreso ? _self.fechaReingreso : fechaReingreso // ignore: cast_nullable_to_non_nullable
as String?,fechaBaja: freezed == fechaBaja ? _self.fechaBaja : fechaBaja // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Contrato].
extension ContratoPatterns on Contrato {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contrato value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contrato() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contrato value)  $default,){
final _that = this;
switch (_that) {
case _Contrato():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contrato value)?  $default,){
final _that = this;
switch (_that) {
case _Contrato() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String empleado,  String posicion, @JsonKey(name: 'fecha_ingreso')  String? fechaIngreso, @JsonKey(name: 'fecha_alta')  String? fechaAlta, @JsonKey(name: 'fecha_reingreso')  String? fechaReingreso, @JsonKey(name: 'fecha_baja')  String? fechaBaja)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contrato() when $default != null:
return $default(_that.id,_that.empleado,_that.posicion,_that.fechaIngreso,_that.fechaAlta,_that.fechaReingreso,_that.fechaBaja);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String empleado,  String posicion, @JsonKey(name: 'fecha_ingreso')  String? fechaIngreso, @JsonKey(name: 'fecha_alta')  String? fechaAlta, @JsonKey(name: 'fecha_reingreso')  String? fechaReingreso, @JsonKey(name: 'fecha_baja')  String? fechaBaja)  $default,) {final _that = this;
switch (_that) {
case _Contrato():
return $default(_that.id,_that.empleado,_that.posicion,_that.fechaIngreso,_that.fechaAlta,_that.fechaReingreso,_that.fechaBaja);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String empleado,  String posicion, @JsonKey(name: 'fecha_ingreso')  String? fechaIngreso, @JsonKey(name: 'fecha_alta')  String? fechaAlta, @JsonKey(name: 'fecha_reingreso')  String? fechaReingreso, @JsonKey(name: 'fecha_baja')  String? fechaBaja)?  $default,) {final _that = this;
switch (_that) {
case _Contrato() when $default != null:
return $default(_that.id,_that.empleado,_that.posicion,_that.fechaIngreso,_that.fechaAlta,_that.fechaReingreso,_that.fechaBaja);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Contrato implements Contrato {
  const _Contrato({required this.id, required this.empleado, required this.posicion, @JsonKey(name: 'fecha_ingreso') this.fechaIngreso, @JsonKey(name: 'fecha_alta') this.fechaAlta, @JsonKey(name: 'fecha_reingreso') this.fechaReingreso, @JsonKey(name: 'fecha_baja') this.fechaBaja});
  factory _Contrato.fromJson(Map<String, dynamic> json) => _$ContratoFromJson(json);

@override final  String id;
@override final  String empleado;
@override final  String posicion;
@override@JsonKey(name: 'fecha_ingreso') final  String? fechaIngreso;
@override@JsonKey(name: 'fecha_alta') final  String? fechaAlta;
@override@JsonKey(name: 'fecha_reingreso') final  String? fechaReingreso;
@override@JsonKey(name: 'fecha_baja') final  String? fechaBaja;

/// Create a copy of Contrato
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContratoCopyWith<_Contrato> get copyWith => __$ContratoCopyWithImpl<_Contrato>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContratoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contrato&&(identical(other.id, id) || other.id == id)&&(identical(other.empleado, empleado) || other.empleado == empleado)&&(identical(other.posicion, posicion) || other.posicion == posicion)&&(identical(other.fechaIngreso, fechaIngreso) || other.fechaIngreso == fechaIngreso)&&(identical(other.fechaAlta, fechaAlta) || other.fechaAlta == fechaAlta)&&(identical(other.fechaReingreso, fechaReingreso) || other.fechaReingreso == fechaReingreso)&&(identical(other.fechaBaja, fechaBaja) || other.fechaBaja == fechaBaja));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,empleado,posicion,fechaIngreso,fechaAlta,fechaReingreso,fechaBaja);
}

@override
String toString() {
    return 'Contrato(id: $id, empleado: $empleado, posicion: $posicion, fechaIngreso: $fechaIngreso, fechaAlta: $fechaAlta, fechaReingreso: $fechaReingreso, fechaBaja: $fechaBaja)';
}


}

/// @nodoc
abstract mixin class _$ContratoCopyWith<$Res> implements $ContratoCopyWith<$Res> {
  factory _$ContratoCopyWith(_Contrato value, $Res Function(_Contrato) _then) = __$ContratoCopyWithImpl;
@override @useResult
$Res call({
 String id, String empleado, String posicion,@JsonKey(name: 'fecha_ingreso') String? fechaIngreso,@JsonKey(name: 'fecha_alta') String? fechaAlta,@JsonKey(name: 'fecha_reingreso') String? fechaReingreso,@JsonKey(name: 'fecha_baja') String? fechaBaja
});




}
/// @nodoc
class __$ContratoCopyWithImpl<$Res>
    implements _$ContratoCopyWith<$Res> {
  __$ContratoCopyWithImpl(this._self, this._then);

  final _Contrato _self;
  final $Res Function(_Contrato) _then;

/// Create a copy of Contrato
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? empleado = null,Object? posicion = null,Object? fechaIngreso = freezed,Object? fechaAlta = freezed,Object? fechaReingreso = freezed,Object? fechaBaja = freezed,}) {
  return _then(_Contrato(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,empleado: null == empleado ? _self.empleado : empleado // ignore: cast_nullable_to_non_nullable
as String,posicion: null == posicion ? _self.posicion : posicion // ignore: cast_nullable_to_non_nullable
as String,fechaIngreso: freezed == fechaIngreso ? _self.fechaIngreso : fechaIngreso // ignore: cast_nullable_to_non_nullable
as String?,fechaAlta: freezed == fechaAlta ? _self.fechaAlta : fechaAlta // ignore: cast_nullable_to_non_nullable
as String?,fechaReingreso: freezed == fechaReingreso ? _self.fechaReingreso : fechaReingreso // ignore: cast_nullable_to_non_nullable
as String?,fechaBaja: freezed == fechaBaja ? _self.fechaBaja : fechaBaja // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PersonSummary {

 String get id;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name_paternal') String get lastNamePaternal;@JsonKey(name: 'last_name_maternal') String get lastNameMaternal;@JsonKey(name: 'personal_email') String get personalEmail; String get phone;
/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<PersonSummary> get copyWith => _$PersonSummaryCopyWithImpl<PersonSummary>(this as PersonSummary, _$identity);

  /// Serializes this PersonSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastNamePaternal, _this.lastNamePaternal) || other.lastNamePaternal == _this.lastNamePaternal)&&(identical(other.lastNameMaternal, _this.lastNameMaternal) || other.lastNameMaternal == _this.lastNameMaternal)&&(identical(other.personalEmail, _this.personalEmail) || other.personalEmail == _this.personalEmail)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonSummary;
  return Object.hash(runtimeType,_this.id,_this.firstName,_this.lastNamePaternal,_this.lastNameMaternal,_this.personalEmail,_this.phone);
}

@override
String toString() {
  final _this = this as PersonSummary;
  return 'PersonSummary(id: ${_this.id}, firstName: ${_this.firstName}, lastNamePaternal: ${_this.lastNamePaternal}, lastNameMaternal: ${_this.lastNameMaternal}, personalEmail: ${_this.personalEmail}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $PersonSummaryCopyWith<$Res>  {
  factory $PersonSummaryCopyWith(PersonSummary value, $Res Function(PersonSummary) _then) = _$PersonSummaryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name_paternal') String lastNamePaternal,@JsonKey(name: 'last_name_maternal') String lastNameMaternal,@JsonKey(name: 'personal_email') String personalEmail, String phone
});




}
/// @nodoc
class _$PersonSummaryCopyWithImpl<$Res>
    implements $PersonSummaryCopyWith<$Res> {
  _$PersonSummaryCopyWithImpl(this._self, this._then);

  final PersonSummary _self;
  final $Res Function(PersonSummary) _then;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastNamePaternal = null,Object? lastNameMaternal = null,Object? personalEmail = null,Object? phone = null,}) {
  return _then(PersonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastNamePaternal: null == lastNamePaternal ? _self.lastNamePaternal : lastNamePaternal // ignore: cast_nullable_to_non_nullable
as String,lastNameMaternal: null == lastNameMaternal ? _self.lastNameMaternal : lastNameMaternal // ignore: cast_nullable_to_non_nullable
as String,personalEmail: null == personalEmail ? _self.personalEmail : personalEmail // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonSummary].
extension PersonSummaryPatterns on PersonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonSummary value)  $default,){
final _that = this;
switch (_that) {
case _PersonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name_paternal')  String lastNamePaternal, @JsonKey(name: 'last_name_maternal')  String lastNameMaternal, @JsonKey(name: 'personal_email')  String personalEmail,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
return $default(_that.id,_that.firstName,_that.lastNamePaternal,_that.lastNameMaternal,_that.personalEmail,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name_paternal')  String lastNamePaternal, @JsonKey(name: 'last_name_maternal')  String lastNameMaternal, @JsonKey(name: 'personal_email')  String personalEmail,  String phone)  $default,) {final _that = this;
switch (_that) {
case _PersonSummary():
return $default(_that.id,_that.firstName,_that.lastNamePaternal,_that.lastNameMaternal,_that.personalEmail,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name_paternal')  String lastNamePaternal, @JsonKey(name: 'last_name_maternal')  String lastNameMaternal, @JsonKey(name: 'personal_email')  String personalEmail,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
return $default(_that.id,_that.firstName,_that.lastNamePaternal,_that.lastNameMaternal,_that.personalEmail,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonSummary extends PersonSummary {
  const _PersonSummary({required this.id, @JsonKey(name: 'first_name') this.firstName = '', @JsonKey(name: 'last_name_paternal') this.lastNamePaternal = '', @JsonKey(name: 'last_name_maternal') this.lastNameMaternal = '', @JsonKey(name: 'personal_email') this.personalEmail = '', this.phone = ''}): super._();
  factory _PersonSummary.fromJson(Map<String, dynamic> json) => _$PersonSummaryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name_paternal') final  String lastNamePaternal;
@override@JsonKey(name: 'last_name_maternal') final  String lastNameMaternal;
@override@JsonKey(name: 'personal_email') final  String personalEmail;
@override@JsonKey() final  String phone;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonSummaryCopyWith<_PersonSummary> get copyWith => __$PersonSummaryCopyWithImpl<_PersonSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastNamePaternal, lastNamePaternal) || other.lastNamePaternal == lastNamePaternal)&&(identical(other.lastNameMaternal, lastNameMaternal) || other.lastNameMaternal == lastNameMaternal)&&(identical(other.personalEmail, personalEmail) || other.personalEmail == personalEmail)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,firstName,lastNamePaternal,lastNameMaternal,personalEmail,phone);
}

@override
String toString() {
    return 'PersonSummary(id: $id, firstName: $firstName, lastNamePaternal: $lastNamePaternal, lastNameMaternal: $lastNameMaternal, personalEmail: $personalEmail, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$PersonSummaryCopyWith<$Res> implements $PersonSummaryCopyWith<$Res> {
  factory _$PersonSummaryCopyWith(_PersonSummary value, $Res Function(_PersonSummary) _then) = __$PersonSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name_paternal') String lastNamePaternal,@JsonKey(name: 'last_name_maternal') String lastNameMaternal,@JsonKey(name: 'personal_email') String personalEmail, String phone
});




}
/// @nodoc
class __$PersonSummaryCopyWithImpl<$Res>
    implements _$PersonSummaryCopyWith<$Res> {
  __$PersonSummaryCopyWithImpl(this._self, this._then);

  final _PersonSummary _self;
  final $Res Function(_PersonSummary) _then;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastNamePaternal = null,Object? lastNameMaternal = null,Object? personalEmail = null,Object? phone = null,}) {
  return _then(_PersonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastNamePaternal: null == lastNamePaternal ? _self.lastNamePaternal : lastNamePaternal // ignore: cast_nullable_to_non_nullable
as String,lastNameMaternal: null == lastNameMaternal ? _self.lastNameMaternal : lastNameMaternal // ignore: cast_nullable_to_non_nullable
as String,personalEmail: null == personalEmail ? _self.personalEmail : personalEmail // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NamedRef {

 int get id; String get name;
/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NamedRefCopyWith<NamedRef> get copyWith => _$NamedRefCopyWithImpl<NamedRef>(this as NamedRef, _$identity);

  /// Serializes this NamedRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NamedRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NamedRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NamedRef;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as NamedRef;
  return 'NamedRef(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $NamedRefCopyWith<$Res>  {
  factory $NamedRefCopyWith(NamedRef value, $Res Function(NamedRef) _then) = _$NamedRefCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$NamedRefCopyWithImpl<$Res>
    implements $NamedRefCopyWith<$Res> {
  _$NamedRefCopyWithImpl(this._self, this._then);

  final NamedRef _self;
  final $Res Function(NamedRef) _then;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(NamedRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NamedRef].
extension NamedRefPatterns on NamedRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NamedRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NamedRef value)  $default,){
final _that = this;
switch (_that) {
case _NamedRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NamedRef value)?  $default,){
final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _NamedRef():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _NamedRef() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NamedRef implements NamedRef {
  const _NamedRef({required this.id, required this.name});
  factory _NamedRef.fromJson(Map<String, dynamic> json) => _$NamedRefFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NamedRefCopyWith<_NamedRef> get copyWith => __$NamedRefCopyWithImpl<_NamedRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NamedRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NamedRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'NamedRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NamedRefCopyWith<$Res> implements $NamedRefCopyWith<$Res> {
  factory _$NamedRefCopyWith(_NamedRef value, $Res Function(_NamedRef) _then) = __$NamedRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$NamedRefCopyWithImpl<$Res>
    implements _$NamedRefCopyWith<$Res> {
  __$NamedRefCopyWithImpl(this._self, this._then);

  final _NamedRef _self;
  final $Res Function(_NamedRef) _then;

/// Create a copy of NamedRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_NamedRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PosicionSummary {

 String get id; int? get puesto; int get estatus;
/// Create a copy of PosicionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosicionSummaryCopyWith<PosicionSummary> get copyWith => _$PosicionSummaryCopyWithImpl<PosicionSummary>(this as PosicionSummary, _$identity);

  /// Serializes this PosicionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PosicionSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosicionSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.puesto, _this.puesto) || other.puesto == _this.puesto)&&(identical(other.estatus, _this.estatus) || other.estatus == _this.estatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PosicionSummary;
  return Object.hash(runtimeType,_this.id,_this.puesto,_this.estatus);
}

@override
String toString() {
  final _this = this as PosicionSummary;
  return 'PosicionSummary(id: ${_this.id}, puesto: ${_this.puesto}, estatus: ${_this.estatus})';
}


}

/// @nodoc
abstract mixin class $PosicionSummaryCopyWith<$Res>  {
  factory $PosicionSummaryCopyWith(PosicionSummary value, $Res Function(PosicionSummary) _then) = _$PosicionSummaryCopyWithImpl;
@useResult
$Res call({
 String id, int? puesto, int estatus
});




}
/// @nodoc
class _$PosicionSummaryCopyWithImpl<$Res>
    implements $PosicionSummaryCopyWith<$Res> {
  _$PosicionSummaryCopyWithImpl(this._self, this._then);

  final PosicionSummary _self;
  final $Res Function(PosicionSummary) _then;

/// Create a copy of PosicionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? puesto = freezed,Object? estatus = null,}) {
  return _then(PosicionSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as int?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PosicionSummary].
extension PosicionSummaryPatterns on PosicionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosicionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosicionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosicionSummary value)  $default,){
final _that = this;
switch (_that) {
case _PosicionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosicionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PosicionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int? puesto,  int estatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosicionSummary() when $default != null:
return $default(_that.id,_that.puesto,_that.estatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int? puesto,  int estatus)  $default,) {final _that = this;
switch (_that) {
case _PosicionSummary():
return $default(_that.id,_that.puesto,_that.estatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int? puesto,  int estatus)?  $default,) {final _that = this;
switch (_that) {
case _PosicionSummary() when $default != null:
return $default(_that.id,_that.puesto,_that.estatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PosicionSummary implements PosicionSummary {
  const _PosicionSummary({required this.id, this.puesto, required this.estatus});
  factory _PosicionSummary.fromJson(Map<String, dynamic> json) => _$PosicionSummaryFromJson(json);

@override final  String id;
@override final  int? puesto;
@override final  int estatus;

/// Create a copy of PosicionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosicionSummaryCopyWith<_PosicionSummary> get copyWith => __$PosicionSummaryCopyWithImpl<_PosicionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PosicionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosicionSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.puesto, puesto) || other.puesto == puesto)&&(identical(other.estatus, estatus) || other.estatus == estatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,puesto,estatus);
}

@override
String toString() {
    return 'PosicionSummary(id: $id, puesto: $puesto, estatus: $estatus)';
}


}

/// @nodoc
abstract mixin class _$PosicionSummaryCopyWith<$Res> implements $PosicionSummaryCopyWith<$Res> {
  factory _$PosicionSummaryCopyWith(_PosicionSummary value, $Res Function(_PosicionSummary) _then) = __$PosicionSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, int? puesto, int estatus
});




}
/// @nodoc
class __$PosicionSummaryCopyWithImpl<$Res>
    implements _$PosicionSummaryCopyWith<$Res> {
  __$PosicionSummaryCopyWithImpl(this._self, this._then);

  final _PosicionSummary _self;
  final $Res Function(_PosicionSummary) _then;

/// Create a copy of PosicionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? puesto = freezed,Object? estatus = null,}) {
  return _then(_PosicionSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,puesto: freezed == puesto ? _self.puesto : puesto // ignore: cast_nullable_to_non_nullable
as int?,estatus: null == estatus ? _self.estatus : estatus // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
