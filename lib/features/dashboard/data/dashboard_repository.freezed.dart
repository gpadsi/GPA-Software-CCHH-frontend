// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResourceCount {

 int get count;
/// Create a copy of ResourceCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceCountCopyWith<ResourceCount> get copyWith => _$ResourceCountCopyWithImpl<ResourceCount>(this as ResourceCount, _$identity);

  /// Serializes this ResourceCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResourceCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceCount&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResourceCount;
  return Object.hash(runtimeType,_this.count);
}

@override
String toString() {
  final _this = this as ResourceCount;
  return 'ResourceCount(count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $ResourceCountCopyWith<$Res>  {
  factory $ResourceCountCopyWith(ResourceCount value, $Res Function(ResourceCount) _then) = _$ResourceCountCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$ResourceCountCopyWithImpl<$Res>
    implements $ResourceCountCopyWith<$Res> {
  _$ResourceCountCopyWithImpl(this._self, this._then);

  final ResourceCount _self;
  final $Res Function(ResourceCount) _then;

/// Create a copy of ResourceCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,}) {
  return _then(ResourceCount(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceCount].
extension ResourceCountPatterns on ResourceCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceCount value)  $default,){
final _that = this;
switch (_that) {
case _ResourceCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceCount value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceCount() when $default != null:
return $default(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count)  $default,) {final _that = this;
switch (_that) {
case _ResourceCount():
return $default(_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count)?  $default,) {final _that = this;
switch (_that) {
case _ResourceCount() when $default != null:
return $default(_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResourceCount implements ResourceCount {
  const _ResourceCount({required this.count});
  factory _ResourceCount.fromJson(Map<String, dynamic> json) => _$ResourceCountFromJson(json);

@override final  int count;

/// Create a copy of ResourceCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceCountCopyWith<_ResourceCount> get copyWith => __$ResourceCountCopyWithImpl<_ResourceCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourceCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceCount&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,count);
}

@override
String toString() {
    return 'ResourceCount(count: $count)';
}


}

/// @nodoc
abstract mixin class _$ResourceCountCopyWith<$Res> implements $ResourceCountCopyWith<$Res> {
  factory _$ResourceCountCopyWith(_ResourceCount value, $Res Function(_ResourceCount) _then) = __$ResourceCountCopyWithImpl;
@override @useResult
$Res call({
 int count
});




}
/// @nodoc
class __$ResourceCountCopyWithImpl<$Res>
    implements _$ResourceCountCopyWith<$Res> {
  __$ResourceCountCopyWithImpl(this._self, this._then);

  final _ResourceCount _self;
  final $Res Function(_ResourceCount) _then;

/// Create a copy of ResourceCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(_ResourceCount(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
