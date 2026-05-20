// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RideSessionModel {

 String get id; String get riderId; String get bikeId; String get startTime; String? get endTime; double get distanceKm; double get avgSpeedKmh; double get maxSpeedKmh; double get energyConsumedKwh; double get avgBatteryDrain;
/// Create a copy of RideSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideSessionModelCopyWith<RideSessionModel> get copyWith => _$RideSessionModelCopyWithImpl<RideSessionModel>(this as RideSessionModel, _$identity);

  /// Serializes this RideSessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideSessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.avgSpeedKmh, avgSpeedKmh) || other.avgSpeedKmh == avgSpeedKmh)&&(identical(other.maxSpeedKmh, maxSpeedKmh) || other.maxSpeedKmh == maxSpeedKmh)&&(identical(other.energyConsumedKwh, energyConsumedKwh) || other.energyConsumedKwh == energyConsumedKwh)&&(identical(other.avgBatteryDrain, avgBatteryDrain) || other.avgBatteryDrain == avgBatteryDrain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riderId,bikeId,startTime,endTime,distanceKm,avgSpeedKmh,maxSpeedKmh,energyConsumedKwh,avgBatteryDrain);

@override
String toString() {
  return 'RideSessionModel(id: $id, riderId: $riderId, bikeId: $bikeId, startTime: $startTime, endTime: $endTime, distanceKm: $distanceKm, avgSpeedKmh: $avgSpeedKmh, maxSpeedKmh: $maxSpeedKmh, energyConsumedKwh: $energyConsumedKwh, avgBatteryDrain: $avgBatteryDrain)';
}


}

/// @nodoc
abstract mixin class $RideSessionModelCopyWith<$Res>  {
  factory $RideSessionModelCopyWith(RideSessionModel value, $Res Function(RideSessionModel) _then) = _$RideSessionModelCopyWithImpl;
@useResult
$Res call({
 String id, String riderId, String bikeId, String startTime, String? endTime, double distanceKm, double avgSpeedKmh, double maxSpeedKmh, double energyConsumedKwh, double avgBatteryDrain
});




}
/// @nodoc
class _$RideSessionModelCopyWithImpl<$Res>
    implements $RideSessionModelCopyWith<$Res> {
  _$RideSessionModelCopyWithImpl(this._self, this._then);

  final RideSessionModel _self;
  final $Res Function(RideSessionModel) _then;

/// Create a copy of RideSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? riderId = null,Object? bikeId = null,Object? startTime = null,Object? endTime = freezed,Object? distanceKm = null,Object? avgSpeedKmh = null,Object? maxSpeedKmh = null,Object? energyConsumedKwh = null,Object? avgBatteryDrain = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,avgSpeedKmh: null == avgSpeedKmh ? _self.avgSpeedKmh : avgSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,maxSpeedKmh: null == maxSpeedKmh ? _self.maxSpeedKmh : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,energyConsumedKwh: null == energyConsumedKwh ? _self.energyConsumedKwh : energyConsumedKwh // ignore: cast_nullable_to_non_nullable
as double,avgBatteryDrain: null == avgBatteryDrain ? _self.avgBatteryDrain : avgBatteryDrain // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RideSessionModel].
extension RideSessionModelPatterns on RideSessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideSessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _RideSessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _RideSessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String riderId,  String bikeId,  String startTime,  String? endTime,  double distanceKm,  double avgSpeedKmh,  double maxSpeedKmh,  double energyConsumedKwh,  double avgBatteryDrain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideSessionModel() when $default != null:
return $default(_that.id,_that.riderId,_that.bikeId,_that.startTime,_that.endTime,_that.distanceKm,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.energyConsumedKwh,_that.avgBatteryDrain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String riderId,  String bikeId,  String startTime,  String? endTime,  double distanceKm,  double avgSpeedKmh,  double maxSpeedKmh,  double energyConsumedKwh,  double avgBatteryDrain)  $default,) {final _that = this;
switch (_that) {
case _RideSessionModel():
return $default(_that.id,_that.riderId,_that.bikeId,_that.startTime,_that.endTime,_that.distanceKm,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.energyConsumedKwh,_that.avgBatteryDrain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String riderId,  String bikeId,  String startTime,  String? endTime,  double distanceKm,  double avgSpeedKmh,  double maxSpeedKmh,  double energyConsumedKwh,  double avgBatteryDrain)?  $default,) {final _that = this;
switch (_that) {
case _RideSessionModel() when $default != null:
return $default(_that.id,_that.riderId,_that.bikeId,_that.startTime,_that.endTime,_that.distanceKm,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.energyConsumedKwh,_that.avgBatteryDrain);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RideSessionModel implements RideSessionModel {
  const _RideSessionModel({required this.id, required this.riderId, required this.bikeId, required this.startTime, this.endTime, this.distanceKm = 0.0, this.avgSpeedKmh = 0.0, this.maxSpeedKmh = 0.0, this.energyConsumedKwh = 0.0, this.avgBatteryDrain = 0.0});
  factory _RideSessionModel.fromJson(Map<String, dynamic> json) => _$RideSessionModelFromJson(json);

@override final  String id;
@override final  String riderId;
@override final  String bikeId;
@override final  String startTime;
@override final  String? endTime;
@override@JsonKey() final  double distanceKm;
@override@JsonKey() final  double avgSpeedKmh;
@override@JsonKey() final  double maxSpeedKmh;
@override@JsonKey() final  double energyConsumedKwh;
@override@JsonKey() final  double avgBatteryDrain;

/// Create a copy of RideSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideSessionModelCopyWith<_RideSessionModel> get copyWith => __$RideSessionModelCopyWithImpl<_RideSessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideSessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideSessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.avgSpeedKmh, avgSpeedKmh) || other.avgSpeedKmh == avgSpeedKmh)&&(identical(other.maxSpeedKmh, maxSpeedKmh) || other.maxSpeedKmh == maxSpeedKmh)&&(identical(other.energyConsumedKwh, energyConsumedKwh) || other.energyConsumedKwh == energyConsumedKwh)&&(identical(other.avgBatteryDrain, avgBatteryDrain) || other.avgBatteryDrain == avgBatteryDrain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,riderId,bikeId,startTime,endTime,distanceKm,avgSpeedKmh,maxSpeedKmh,energyConsumedKwh,avgBatteryDrain);

@override
String toString() {
  return 'RideSessionModel(id: $id, riderId: $riderId, bikeId: $bikeId, startTime: $startTime, endTime: $endTime, distanceKm: $distanceKm, avgSpeedKmh: $avgSpeedKmh, maxSpeedKmh: $maxSpeedKmh, energyConsumedKwh: $energyConsumedKwh, avgBatteryDrain: $avgBatteryDrain)';
}


}

/// @nodoc
abstract mixin class _$RideSessionModelCopyWith<$Res> implements $RideSessionModelCopyWith<$Res> {
  factory _$RideSessionModelCopyWith(_RideSessionModel value, $Res Function(_RideSessionModel) _then) = __$RideSessionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String riderId, String bikeId, String startTime, String? endTime, double distanceKm, double avgSpeedKmh, double maxSpeedKmh, double energyConsumedKwh, double avgBatteryDrain
});




}
/// @nodoc
class __$RideSessionModelCopyWithImpl<$Res>
    implements _$RideSessionModelCopyWith<$Res> {
  __$RideSessionModelCopyWithImpl(this._self, this._then);

  final _RideSessionModel _self;
  final $Res Function(_RideSessionModel) _then;

/// Create a copy of RideSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? riderId = null,Object? bikeId = null,Object? startTime = null,Object? endTime = freezed,Object? distanceKm = null,Object? avgSpeedKmh = null,Object? maxSpeedKmh = null,Object? energyConsumedKwh = null,Object? avgBatteryDrain = null,}) {
  return _then(_RideSessionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,avgSpeedKmh: null == avgSpeedKmh ? _self.avgSpeedKmh : avgSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,maxSpeedKmh: null == maxSpeedKmh ? _self.maxSpeedKmh : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,energyConsumedKwh: null == energyConsumedKwh ? _self.energyConsumedKwh : energyConsumedKwh // ignore: cast_nullable_to_non_nullable
as double,avgBatteryDrain: null == avgBatteryDrain ? _self.avgBatteryDrain : avgBatteryDrain // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
