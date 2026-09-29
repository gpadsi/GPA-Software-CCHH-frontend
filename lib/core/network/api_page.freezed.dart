// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiPage<T> {

 int get count; String? get next; String? get previous; List<T> get results;
/// Create a copy of ApiPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiPageCopyWith<T, ApiPage<T>> get copyWith => _$ApiPageCopyWithImpl<T, ApiPage<T>>(this as ApiPage<T>, _$identity);

  /// Serializes this ApiPage to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  final _this = this as ApiPage<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiPage<T>&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.previous, _this.previous) || other.previous == _this.previous)&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApiPage<T>;
  return Object.hash(runtimeType,_this.count,_this.next,_this.previous,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as ApiPage<T>;
  return 'ApiPage<$T>(count: ${_this.count}, next: ${_this.next}, previous: ${_this.previous}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $ApiPageCopyWith<T,$Res>  {
  factory $ApiPageCopyWith(ApiPage<T> value, $Res Function(ApiPage<T>) _then) = _$ApiPageCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<T> results
});




}
/// @nodoc
class _$ApiPageCopyWithImpl<T,$Res>
    implements $ApiPageCopyWith<T, $Res> {
  _$ApiPageCopyWithImpl(this._self, this._then);

  final ApiPage<T> _self;
  final $Res Function(ApiPage<T>) _then;

/// Create a copy of ApiPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(ApiPage(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiPage].
extension ApiPagePatterns<T> on ApiPage<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiPage<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiPage<T> value)  $default,){
final _that = this;
switch (_that) {
case _ApiPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiPage<T> value)?  $default,){
final _that = this;
switch (_that) {
case _ApiPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<T> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiPage() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<T> results)  $default,) {final _that = this;
switch (_that) {
case _ApiPage():
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<T> results)?  $default,) {final _that = this;
switch (_that) {
case _ApiPage() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _ApiPage<T> implements ApiPage<T> {
  const _ApiPage({required this.count, this.next, this.previous, required  List<T> results}): _results = results;
  factory _ApiPage.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$ApiPageFromJson(json,fromJsonT);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<T> _results;
@override List<T> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ApiPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiPageCopyWith<T, _ApiPage<T>> get copyWith => __$ApiPageCopyWithImpl<T, _ApiPage<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$ApiPageToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiPage<T>&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'ApiPage<$T>(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ApiPageCopyWith<T,$Res> implements $ApiPageCopyWith<T, $Res> {
  factory _$ApiPageCopyWith(_ApiPage<T> value, $Res Function(_ApiPage<T>) _then) = __$ApiPageCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<T> results
});




}
/// @nodoc
class __$ApiPageCopyWithImpl<T,$Res>
    implements _$ApiPageCopyWith<T, $Res> {
  __$ApiPageCopyWithImpl(this._self, this._then);

  final _ApiPage<T> _self;
  final $Res Function(_ApiPage<T>) _then;

/// Create a copy of ApiPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_ApiPage<T>(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

// dart format on
