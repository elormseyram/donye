// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fault_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaultCode {

 String get code; String get description; FaultSeverity get severity; DateTime get detectedAt; bool get isActive;
/// Create a copy of FaultCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaultCodeCopyWith<FaultCode> get copyWith => _$FaultCodeCopyWithImpl<FaultCode>(this as FaultCode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaultCode&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,code,description,severity,detectedAt,isActive);

@override
String toString() {
  return 'FaultCode(code: $code, description: $description, severity: $severity, detectedAt: $detectedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $FaultCodeCopyWith<$Res>  {
  factory $FaultCodeCopyWith(FaultCode value, $Res Function(FaultCode) _then) = _$FaultCodeCopyWithImpl;
@useResult
$Res call({
 String code, String description, FaultSeverity severity, DateTime detectedAt, bool isActive
});




}
/// @nodoc
class _$FaultCodeCopyWithImpl<$Res>
    implements $FaultCodeCopyWith<$Res> {
  _$FaultCodeCopyWithImpl(this._self, this._then);

  final FaultCode _self;
  final $Res Function(FaultCode) _then;

/// Create a copy of FaultCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? description = null,Object? severity = null,Object? detectedAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as FaultSeverity,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FaultCode].
extension FaultCodePatterns on FaultCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaultCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaultCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaultCode value)  $default,){
final _that = this;
switch (_that) {
case _FaultCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaultCode value)?  $default,){
final _that = this;
switch (_that) {
case _FaultCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String description,  FaultSeverity severity,  DateTime detectedAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaultCode() when $default != null:
return $default(_that.code,_that.description,_that.severity,_that.detectedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String description,  FaultSeverity severity,  DateTime detectedAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _FaultCode():
return $default(_that.code,_that.description,_that.severity,_that.detectedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String description,  FaultSeverity severity,  DateTime detectedAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _FaultCode() when $default != null:
return $default(_that.code,_that.description,_that.severity,_that.detectedAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _FaultCode implements FaultCode {
  const _FaultCode({required this.code, required this.description, required this.severity, required this.detectedAt, required this.isActive});
  

@override final  String code;
@override final  String description;
@override final  FaultSeverity severity;
@override final  DateTime detectedAt;
@override final  bool isActive;

/// Create a copy of FaultCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaultCodeCopyWith<_FaultCode> get copyWith => __$FaultCodeCopyWithImpl<_FaultCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaultCode&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,code,description,severity,detectedAt,isActive);

@override
String toString() {
  return 'FaultCode(code: $code, description: $description, severity: $severity, detectedAt: $detectedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$FaultCodeCopyWith<$Res> implements $FaultCodeCopyWith<$Res> {
  factory _$FaultCodeCopyWith(_FaultCode value, $Res Function(_FaultCode) _then) = __$FaultCodeCopyWithImpl;
@override @useResult
$Res call({
 String code, String description, FaultSeverity severity, DateTime detectedAt, bool isActive
});




}
/// @nodoc
class __$FaultCodeCopyWithImpl<$Res>
    implements _$FaultCodeCopyWith<$Res> {
  __$FaultCodeCopyWithImpl(this._self, this._then);

  final _FaultCode _self;
  final $Res Function(_FaultCode) _then;

/// Create a copy of FaultCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? description = null,Object? severity = null,Object? detectedAt = null,Object? isActive = null,}) {
  return _then(_FaultCode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as FaultSeverity,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
