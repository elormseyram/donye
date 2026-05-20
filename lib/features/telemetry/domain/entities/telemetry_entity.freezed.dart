// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelemetryEntity {

 String get bikeId; double get batteryPercentage; double get voltageV; double get currentA; double get speedKmh; double get temperatureCelsius; double get odometer; int get motorRpm; TelemetryStatus get status; DateTime get timestamp;
/// Create a copy of TelemetryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelemetryEntityCopyWith<TelemetryEntity> get copyWith => _$TelemetryEntityCopyWithImpl<TelemetryEntity>(this as TelemetryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelemetryEntity&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.batteryPercentage, batteryPercentage) || other.batteryPercentage == batteryPercentage)&&(identical(other.voltageV, voltageV) || other.voltageV == voltageV)&&(identical(other.currentA, currentA) || other.currentA == currentA)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.motorRpm, motorRpm) || other.motorRpm == motorRpm)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,bikeId,batteryPercentage,voltageV,currentA,speedKmh,temperatureCelsius,odometer,motorRpm,status,timestamp);

@override
String toString() {
  return 'TelemetryEntity(bikeId: $bikeId, batteryPercentage: $batteryPercentage, voltageV: $voltageV, currentA: $currentA, speedKmh: $speedKmh, temperatureCelsius: $temperatureCelsius, odometer: $odometer, motorRpm: $motorRpm, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $TelemetryEntityCopyWith<$Res>  {
  factory $TelemetryEntityCopyWith(TelemetryEntity value, $Res Function(TelemetryEntity) _then) = _$TelemetryEntityCopyWithImpl;
@useResult
$Res call({
 String bikeId, double batteryPercentage, double voltageV, double currentA, double speedKmh, double temperatureCelsius, double odometer, int motorRpm, TelemetryStatus status, DateTime timestamp
});




}
/// @nodoc
class _$TelemetryEntityCopyWithImpl<$Res>
    implements $TelemetryEntityCopyWith<$Res> {
  _$TelemetryEntityCopyWithImpl(this._self, this._then);

  final TelemetryEntity _self;
  final $Res Function(TelemetryEntity) _then;

/// Create a copy of TelemetryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bikeId = null,Object? batteryPercentage = null,Object? voltageV = null,Object? currentA = null,Object? speedKmh = null,Object? temperatureCelsius = null,Object? odometer = null,Object? motorRpm = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,batteryPercentage: null == batteryPercentage ? _self.batteryPercentage : batteryPercentage // ignore: cast_nullable_to_non_nullable
as double,voltageV: null == voltageV ? _self.voltageV : voltageV // ignore: cast_nullable_to_non_nullable
as double,currentA: null == currentA ? _self.currentA : currentA // ignore: cast_nullable_to_non_nullable
as double,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double,motorRpm: null == motorRpm ? _self.motorRpm : motorRpm // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TelemetryStatus,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TelemetryEntity].
extension TelemetryEntityPatterns on TelemetryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelemetryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelemetryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelemetryEntity value)  $default,){
final _that = this;
switch (_that) {
case _TelemetryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelemetryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TelemetryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bikeId,  double batteryPercentage,  double voltageV,  double currentA,  double speedKmh,  double temperatureCelsius,  double odometer,  int motorRpm,  TelemetryStatus status,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelemetryEntity() when $default != null:
return $default(_that.bikeId,_that.batteryPercentage,_that.voltageV,_that.currentA,_that.speedKmh,_that.temperatureCelsius,_that.odometer,_that.motorRpm,_that.status,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bikeId,  double batteryPercentage,  double voltageV,  double currentA,  double speedKmh,  double temperatureCelsius,  double odometer,  int motorRpm,  TelemetryStatus status,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _TelemetryEntity():
return $default(_that.bikeId,_that.batteryPercentage,_that.voltageV,_that.currentA,_that.speedKmh,_that.temperatureCelsius,_that.odometer,_that.motorRpm,_that.status,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bikeId,  double batteryPercentage,  double voltageV,  double currentA,  double speedKmh,  double temperatureCelsius,  double odometer,  int motorRpm,  TelemetryStatus status,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _TelemetryEntity() when $default != null:
return $default(_that.bikeId,_that.batteryPercentage,_that.voltageV,_that.currentA,_that.speedKmh,_that.temperatureCelsius,_that.odometer,_that.motorRpm,_that.status,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _TelemetryEntity implements TelemetryEntity {
  const _TelemetryEntity({required this.bikeId, required this.batteryPercentage, required this.voltageV, required this.currentA, required this.speedKmh, required this.temperatureCelsius, required this.odometer, required this.motorRpm, required this.status, required this.timestamp});
  

@override final  String bikeId;
@override final  double batteryPercentage;
@override final  double voltageV;
@override final  double currentA;
@override final  double speedKmh;
@override final  double temperatureCelsius;
@override final  double odometer;
@override final  int motorRpm;
@override final  TelemetryStatus status;
@override final  DateTime timestamp;

/// Create a copy of TelemetryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelemetryEntityCopyWith<_TelemetryEntity> get copyWith => __$TelemetryEntityCopyWithImpl<_TelemetryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelemetryEntity&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.batteryPercentage, batteryPercentage) || other.batteryPercentage == batteryPercentage)&&(identical(other.voltageV, voltageV) || other.voltageV == voltageV)&&(identical(other.currentA, currentA) || other.currentA == currentA)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.motorRpm, motorRpm) || other.motorRpm == motorRpm)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,bikeId,batteryPercentage,voltageV,currentA,speedKmh,temperatureCelsius,odometer,motorRpm,status,timestamp);

@override
String toString() {
  return 'TelemetryEntity(bikeId: $bikeId, batteryPercentage: $batteryPercentage, voltageV: $voltageV, currentA: $currentA, speedKmh: $speedKmh, temperatureCelsius: $temperatureCelsius, odometer: $odometer, motorRpm: $motorRpm, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$TelemetryEntityCopyWith<$Res> implements $TelemetryEntityCopyWith<$Res> {
  factory _$TelemetryEntityCopyWith(_TelemetryEntity value, $Res Function(_TelemetryEntity) _then) = __$TelemetryEntityCopyWithImpl;
@override @useResult
$Res call({
 String bikeId, double batteryPercentage, double voltageV, double currentA, double speedKmh, double temperatureCelsius, double odometer, int motorRpm, TelemetryStatus status, DateTime timestamp
});




}
/// @nodoc
class __$TelemetryEntityCopyWithImpl<$Res>
    implements _$TelemetryEntityCopyWith<$Res> {
  __$TelemetryEntityCopyWithImpl(this._self, this._then);

  final _TelemetryEntity _self;
  final $Res Function(_TelemetryEntity) _then;

/// Create a copy of TelemetryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bikeId = null,Object? batteryPercentage = null,Object? voltageV = null,Object? currentA = null,Object? speedKmh = null,Object? temperatureCelsius = null,Object? odometer = null,Object? motorRpm = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_TelemetryEntity(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,batteryPercentage: null == batteryPercentage ? _self.batteryPercentage : batteryPercentage // ignore: cast_nullable_to_non_nullable
as double,voltageV: null == voltageV ? _self.voltageV : voltageV // ignore: cast_nullable_to_non_nullable
as double,currentA: null == currentA ? _self.currentA : currentA // ignore: cast_nullable_to_non_nullable
as double,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double,motorRpm: null == motorRpm ? _self.motorRpm : motorRpm // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TelemetryStatus,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
