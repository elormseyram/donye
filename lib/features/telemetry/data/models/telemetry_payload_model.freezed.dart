// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry_payload_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TelemetryPayloadModel {

 String get bikeId; double get batteryPercentage; double get voltageV; double get currentA; double get speedKmh; double get temperatureCelsius; double get odometer; int get motorRpm; String get status; String get timestamp;
/// Create a copy of TelemetryPayloadModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelemetryPayloadModelCopyWith<TelemetryPayloadModel> get copyWith => _$TelemetryPayloadModelCopyWithImpl<TelemetryPayloadModel>(this as TelemetryPayloadModel, _$identity);

  /// Serializes this TelemetryPayloadModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelemetryPayloadModel&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.batteryPercentage, batteryPercentage) || other.batteryPercentage == batteryPercentage)&&(identical(other.voltageV, voltageV) || other.voltageV == voltageV)&&(identical(other.currentA, currentA) || other.currentA == currentA)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.motorRpm, motorRpm) || other.motorRpm == motorRpm)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bikeId,batteryPercentage,voltageV,currentA,speedKmh,temperatureCelsius,odometer,motorRpm,status,timestamp);

@override
String toString() {
  return 'TelemetryPayloadModel(bikeId: $bikeId, batteryPercentage: $batteryPercentage, voltageV: $voltageV, currentA: $currentA, speedKmh: $speedKmh, temperatureCelsius: $temperatureCelsius, odometer: $odometer, motorRpm: $motorRpm, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $TelemetryPayloadModelCopyWith<$Res>  {
  factory $TelemetryPayloadModelCopyWith(TelemetryPayloadModel value, $Res Function(TelemetryPayloadModel) _then) = _$TelemetryPayloadModelCopyWithImpl;
@useResult
$Res call({
 String bikeId, double batteryPercentage, double voltageV, double currentA, double speedKmh, double temperatureCelsius, double odometer, int motorRpm, String status, String timestamp
});




}
/// @nodoc
class _$TelemetryPayloadModelCopyWithImpl<$Res>
    implements $TelemetryPayloadModelCopyWith<$Res> {
  _$TelemetryPayloadModelCopyWithImpl(this._self, this._then);

  final TelemetryPayloadModel _self;
  final $Res Function(TelemetryPayloadModel) _then;

/// Create a copy of TelemetryPayloadModel
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
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TelemetryPayloadModel].
extension TelemetryPayloadModelPatterns on TelemetryPayloadModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelemetryPayloadModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelemetryPayloadModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelemetryPayloadModel value)  $default,){
final _that = this;
switch (_that) {
case _TelemetryPayloadModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelemetryPayloadModel value)?  $default,){
final _that = this;
switch (_that) {
case _TelemetryPayloadModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bikeId,  double batteryPercentage,  double voltageV,  double currentA,  double speedKmh,  double temperatureCelsius,  double odometer,  int motorRpm,  String status,  String timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelemetryPayloadModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bikeId,  double batteryPercentage,  double voltageV,  double currentA,  double speedKmh,  double temperatureCelsius,  double odometer,  int motorRpm,  String status,  String timestamp)  $default,) {final _that = this;
switch (_that) {
case _TelemetryPayloadModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bikeId,  double batteryPercentage,  double voltageV,  double currentA,  double speedKmh,  double temperatureCelsius,  double odometer,  int motorRpm,  String status,  String timestamp)?  $default,) {final _that = this;
switch (_that) {
case _TelemetryPayloadModel() when $default != null:
return $default(_that.bikeId,_that.batteryPercentage,_that.voltageV,_that.currentA,_that.speedKmh,_that.temperatureCelsius,_that.odometer,_that.motorRpm,_that.status,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TelemetryPayloadModel implements TelemetryPayloadModel {
  const _TelemetryPayloadModel({required this.bikeId, required this.batteryPercentage, required this.voltageV, required this.currentA, required this.speedKmh, required this.temperatureCelsius, required this.odometer, required this.motorRpm, required this.status, required this.timestamp});
  factory _TelemetryPayloadModel.fromJson(Map<String, dynamic> json) => _$TelemetryPayloadModelFromJson(json);

@override final  String bikeId;
@override final  double batteryPercentage;
@override final  double voltageV;
@override final  double currentA;
@override final  double speedKmh;
@override final  double temperatureCelsius;
@override final  double odometer;
@override final  int motorRpm;
@override final  String status;
@override final  String timestamp;

/// Create a copy of TelemetryPayloadModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelemetryPayloadModelCopyWith<_TelemetryPayloadModel> get copyWith => __$TelemetryPayloadModelCopyWithImpl<_TelemetryPayloadModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TelemetryPayloadModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelemetryPayloadModel&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.batteryPercentage, batteryPercentage) || other.batteryPercentage == batteryPercentage)&&(identical(other.voltageV, voltageV) || other.voltageV == voltageV)&&(identical(other.currentA, currentA) || other.currentA == currentA)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.motorRpm, motorRpm) || other.motorRpm == motorRpm)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bikeId,batteryPercentage,voltageV,currentA,speedKmh,temperatureCelsius,odometer,motorRpm,status,timestamp);

@override
String toString() {
  return 'TelemetryPayloadModel(bikeId: $bikeId, batteryPercentage: $batteryPercentage, voltageV: $voltageV, currentA: $currentA, speedKmh: $speedKmh, temperatureCelsius: $temperatureCelsius, odometer: $odometer, motorRpm: $motorRpm, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$TelemetryPayloadModelCopyWith<$Res> implements $TelemetryPayloadModelCopyWith<$Res> {
  factory _$TelemetryPayloadModelCopyWith(_TelemetryPayloadModel value, $Res Function(_TelemetryPayloadModel) _then) = __$TelemetryPayloadModelCopyWithImpl;
@override @useResult
$Res call({
 String bikeId, double batteryPercentage, double voltageV, double currentA, double speedKmh, double temperatureCelsius, double odometer, int motorRpm, String status, String timestamp
});




}
/// @nodoc
class __$TelemetryPayloadModelCopyWithImpl<$Res>
    implements _$TelemetryPayloadModelCopyWith<$Res> {
  __$TelemetryPayloadModelCopyWithImpl(this._self, this._then);

  final _TelemetryPayloadModel _self;
  final $Res Function(_TelemetryPayloadModel) _then;

/// Create a copy of TelemetryPayloadModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bikeId = null,Object? batteryPercentage = null,Object? voltageV = null,Object? currentA = null,Object? speedKmh = null,Object? temperatureCelsius = null,Object? odometer = null,Object? motorRpm = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_TelemetryPayloadModel(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,batteryPercentage: null == batteryPercentage ? _self.batteryPercentage : batteryPercentage // ignore: cast_nullable_to_non_nullable
as double,voltageV: null == voltageV ? _self.voltageV : voltageV // ignore: cast_nullable_to_non_nullable
as double,currentA: null == currentA ? _self.currentA : currentA // ignore: cast_nullable_to_non_nullable
as double,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double,motorRpm: null == motorRpm ? _self.motorRpm : motorRpm // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
