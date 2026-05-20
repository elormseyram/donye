// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationEntity {

 String get bikeId; double get latitude; double get longitude; double get headingDegrees; double get speedKmh; double get accuracyM; DateTime get timestamp;
/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationEntityCopyWith<LocationEntity> get copyWith => _$LocationEntityCopyWithImpl<LocationEntity>(this as LocationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationEntity&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.headingDegrees, headingDegrees) || other.headingDegrees == headingDegrees)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,bikeId,latitude,longitude,headingDegrees,speedKmh,accuracyM,timestamp);

@override
String toString() {
  return 'LocationEntity(bikeId: $bikeId, latitude: $latitude, longitude: $longitude, headingDegrees: $headingDegrees, speedKmh: $speedKmh, accuracyM: $accuracyM, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $LocationEntityCopyWith<$Res>  {
  factory $LocationEntityCopyWith(LocationEntity value, $Res Function(LocationEntity) _then) = _$LocationEntityCopyWithImpl;
@useResult
$Res call({
 String bikeId, double latitude, double longitude, double headingDegrees, double speedKmh, double accuracyM, DateTime timestamp
});




}
/// @nodoc
class _$LocationEntityCopyWithImpl<$Res>
    implements $LocationEntityCopyWith<$Res> {
  _$LocationEntityCopyWithImpl(this._self, this._then);

  final LocationEntity _self;
  final $Res Function(LocationEntity) _then;

/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bikeId = null,Object? latitude = null,Object? longitude = null,Object? headingDegrees = null,Object? speedKmh = null,Object? accuracyM = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,headingDegrees: null == headingDegrees ? _self.headingDegrees : headingDegrees // ignore: cast_nullable_to_non_nullable
as double,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationEntity].
extension LocationEntityPatterns on LocationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationEntity value)  $default,){
final _that = this;
switch (_that) {
case _LocationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bikeId,  double latitude,  double longitude,  double headingDegrees,  double speedKmh,  double accuracyM,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
return $default(_that.bikeId,_that.latitude,_that.longitude,_that.headingDegrees,_that.speedKmh,_that.accuracyM,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bikeId,  double latitude,  double longitude,  double headingDegrees,  double speedKmh,  double accuracyM,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _LocationEntity():
return $default(_that.bikeId,_that.latitude,_that.longitude,_that.headingDegrees,_that.speedKmh,_that.accuracyM,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bikeId,  double latitude,  double longitude,  double headingDegrees,  double speedKmh,  double accuracyM,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
return $default(_that.bikeId,_that.latitude,_that.longitude,_that.headingDegrees,_that.speedKmh,_that.accuracyM,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _LocationEntity implements LocationEntity {
  const _LocationEntity({required this.bikeId, required this.latitude, required this.longitude, required this.headingDegrees, required this.speedKmh, required this.accuracyM, required this.timestamp});
  

@override final  String bikeId;
@override final  double latitude;
@override final  double longitude;
@override final  double headingDegrees;
@override final  double speedKmh;
@override final  double accuracyM;
@override final  DateTime timestamp;

/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationEntityCopyWith<_LocationEntity> get copyWith => __$LocationEntityCopyWithImpl<_LocationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationEntity&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.headingDegrees, headingDegrees) || other.headingDegrees == headingDegrees)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,bikeId,latitude,longitude,headingDegrees,speedKmh,accuracyM,timestamp);

@override
String toString() {
  return 'LocationEntity(bikeId: $bikeId, latitude: $latitude, longitude: $longitude, headingDegrees: $headingDegrees, speedKmh: $speedKmh, accuracyM: $accuracyM, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$LocationEntityCopyWith<$Res> implements $LocationEntityCopyWith<$Res> {
  factory _$LocationEntityCopyWith(_LocationEntity value, $Res Function(_LocationEntity) _then) = __$LocationEntityCopyWithImpl;
@override @useResult
$Res call({
 String bikeId, double latitude, double longitude, double headingDegrees, double speedKmh, double accuracyM, DateTime timestamp
});




}
/// @nodoc
class __$LocationEntityCopyWithImpl<$Res>
    implements _$LocationEntityCopyWith<$Res> {
  __$LocationEntityCopyWithImpl(this._self, this._then);

  final _LocationEntity _self;
  final $Res Function(_LocationEntity) _then;

/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bikeId = null,Object? latitude = null,Object? longitude = null,Object? headingDegrees = null,Object? speedKmh = null,Object? accuracyM = null,Object? timestamp = null,}) {
  return _then(_LocationEntity(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,headingDegrees: null == headingDegrees ? _self.headingDegrees : headingDegrees // ignore: cast_nullable_to_non_nullable
as double,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
