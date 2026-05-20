// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RideSessionEntity {

 String get id; String get riderId; String get bikeId; DateTime get startTime; DateTime? get endTime; double get distanceKm; double get avgSpeedKmh; double get maxSpeedKmh; double get energyConsumedKwh; double get avgBatteryDrain;
/// Create a copy of RideSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideSessionEntityCopyWith<RideSessionEntity> get copyWith => _$RideSessionEntityCopyWithImpl<RideSessionEntity>(this as RideSessionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.avgSpeedKmh, avgSpeedKmh) || other.avgSpeedKmh == avgSpeedKmh)&&(identical(other.maxSpeedKmh, maxSpeedKmh) || other.maxSpeedKmh == maxSpeedKmh)&&(identical(other.energyConsumedKwh, energyConsumedKwh) || other.energyConsumedKwh == energyConsumedKwh)&&(identical(other.avgBatteryDrain, avgBatteryDrain) || other.avgBatteryDrain == avgBatteryDrain));
}


@override
int get hashCode => Object.hash(runtimeType,id,riderId,bikeId,startTime,endTime,distanceKm,avgSpeedKmh,maxSpeedKmh,energyConsumedKwh,avgBatteryDrain);

@override
String toString() {
  return 'RideSessionEntity(id: $id, riderId: $riderId, bikeId: $bikeId, startTime: $startTime, endTime: $endTime, distanceKm: $distanceKm, avgSpeedKmh: $avgSpeedKmh, maxSpeedKmh: $maxSpeedKmh, energyConsumedKwh: $energyConsumedKwh, avgBatteryDrain: $avgBatteryDrain)';
}


}

/// @nodoc
abstract mixin class $RideSessionEntityCopyWith<$Res>  {
  factory $RideSessionEntityCopyWith(RideSessionEntity value, $Res Function(RideSessionEntity) _then) = _$RideSessionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String riderId, String bikeId, DateTime startTime, DateTime? endTime, double distanceKm, double avgSpeedKmh, double maxSpeedKmh, double energyConsumedKwh, double avgBatteryDrain
});




}
/// @nodoc
class _$RideSessionEntityCopyWithImpl<$Res>
    implements $RideSessionEntityCopyWith<$Res> {
  _$RideSessionEntityCopyWithImpl(this._self, this._then);

  final RideSessionEntity _self;
  final $Res Function(RideSessionEntity) _then;

/// Create a copy of RideSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? riderId = null,Object? bikeId = null,Object? startTime = null,Object? endTime = freezed,Object? distanceKm = null,Object? avgSpeedKmh = null,Object? maxSpeedKmh = null,Object? energyConsumedKwh = null,Object? avgBatteryDrain = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,avgSpeedKmh: null == avgSpeedKmh ? _self.avgSpeedKmh : avgSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,maxSpeedKmh: null == maxSpeedKmh ? _self.maxSpeedKmh : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,energyConsumedKwh: null == energyConsumedKwh ? _self.energyConsumedKwh : energyConsumedKwh // ignore: cast_nullable_to_non_nullable
as double,avgBatteryDrain: null == avgBatteryDrain ? _self.avgBatteryDrain : avgBatteryDrain // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RideSessionEntity].
extension RideSessionEntityPatterns on RideSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _RideSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RideSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String riderId,  String bikeId,  DateTime startTime,  DateTime? endTime,  double distanceKm,  double avgSpeedKmh,  double maxSpeedKmh,  double energyConsumedKwh,  double avgBatteryDrain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideSessionEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String riderId,  String bikeId,  DateTime startTime,  DateTime? endTime,  double distanceKm,  double avgSpeedKmh,  double maxSpeedKmh,  double energyConsumedKwh,  double avgBatteryDrain)  $default,) {final _that = this;
switch (_that) {
case _RideSessionEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String riderId,  String bikeId,  DateTime startTime,  DateTime? endTime,  double distanceKm,  double avgSpeedKmh,  double maxSpeedKmh,  double energyConsumedKwh,  double avgBatteryDrain)?  $default,) {final _that = this;
switch (_that) {
case _RideSessionEntity() when $default != null:
return $default(_that.id,_that.riderId,_that.bikeId,_that.startTime,_that.endTime,_that.distanceKm,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.energyConsumedKwh,_that.avgBatteryDrain);case _:
  return null;

}
}

}

/// @nodoc


class _RideSessionEntity implements RideSessionEntity {
  const _RideSessionEntity({required this.id, required this.riderId, required this.bikeId, required this.startTime, this.endTime, required this.distanceKm, required this.avgSpeedKmh, required this.maxSpeedKmh, required this.energyConsumedKwh, required this.avgBatteryDrain});
  

@override final  String id;
@override final  String riderId;
@override final  String bikeId;
@override final  DateTime startTime;
@override final  DateTime? endTime;
@override final  double distanceKm;
@override final  double avgSpeedKmh;
@override final  double maxSpeedKmh;
@override final  double energyConsumedKwh;
@override final  double avgBatteryDrain;

/// Create a copy of RideSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideSessionEntityCopyWith<_RideSessionEntity> get copyWith => __$RideSessionEntityCopyWithImpl<_RideSessionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.riderId, riderId) || other.riderId == riderId)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.avgSpeedKmh, avgSpeedKmh) || other.avgSpeedKmh == avgSpeedKmh)&&(identical(other.maxSpeedKmh, maxSpeedKmh) || other.maxSpeedKmh == maxSpeedKmh)&&(identical(other.energyConsumedKwh, energyConsumedKwh) || other.energyConsumedKwh == energyConsumedKwh)&&(identical(other.avgBatteryDrain, avgBatteryDrain) || other.avgBatteryDrain == avgBatteryDrain));
}


@override
int get hashCode => Object.hash(runtimeType,id,riderId,bikeId,startTime,endTime,distanceKm,avgSpeedKmh,maxSpeedKmh,energyConsumedKwh,avgBatteryDrain);

@override
String toString() {
  return 'RideSessionEntity(id: $id, riderId: $riderId, bikeId: $bikeId, startTime: $startTime, endTime: $endTime, distanceKm: $distanceKm, avgSpeedKmh: $avgSpeedKmh, maxSpeedKmh: $maxSpeedKmh, energyConsumedKwh: $energyConsumedKwh, avgBatteryDrain: $avgBatteryDrain)';
}


}

/// @nodoc
abstract mixin class _$RideSessionEntityCopyWith<$Res> implements $RideSessionEntityCopyWith<$Res> {
  factory _$RideSessionEntityCopyWith(_RideSessionEntity value, $Res Function(_RideSessionEntity) _then) = __$RideSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String riderId, String bikeId, DateTime startTime, DateTime? endTime, double distanceKm, double avgSpeedKmh, double maxSpeedKmh, double energyConsumedKwh, double avgBatteryDrain
});




}
/// @nodoc
class __$RideSessionEntityCopyWithImpl<$Res>
    implements _$RideSessionEntityCopyWith<$Res> {
  __$RideSessionEntityCopyWithImpl(this._self, this._then);

  final _RideSessionEntity _self;
  final $Res Function(_RideSessionEntity) _then;

/// Create a copy of RideSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? riderId = null,Object? bikeId = null,Object? startTime = null,Object? endTime = freezed,Object? distanceKm = null,Object? avgSpeedKmh = null,Object? maxSpeedKmh = null,Object? energyConsumedKwh = null,Object? avgBatteryDrain = null,}) {
  return _then(_RideSessionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,riderId: null == riderId ? _self.riderId : riderId // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,avgSpeedKmh: null == avgSpeedKmh ? _self.avgSpeedKmh : avgSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,maxSpeedKmh: null == maxSpeedKmh ? _self.maxSpeedKmh : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,energyConsumedKwh: null == energyConsumedKwh ? _self.energyConsumedKwh : energyConsumedKwh // ignore: cast_nullable_to_non_nullable
as double,avgBatteryDrain: null == avgBatteryDrain ? _self.avgBatteryDrain : avgBatteryDrain // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
