// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_payload_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationPayloadModel {

 String get bikeId; double get latitude; double get longitude; double get headingDegrees; double get speedKmh; double get accuracyM; String get timestamp;
/// Create a copy of LocationPayloadModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationPayloadModelCopyWith<LocationPayloadModel> get copyWith => _$LocationPayloadModelCopyWithImpl<LocationPayloadModel>(this as LocationPayloadModel, _$identity);

  /// Serializes this LocationPayloadModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationPayloadModel&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.headingDegrees, headingDegrees) || other.headingDegrees == headingDegrees)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bikeId,latitude,longitude,headingDegrees,speedKmh,accuracyM,timestamp);

@override
String toString() {
  return 'LocationPayloadModel(bikeId: $bikeId, latitude: $latitude, longitude: $longitude, headingDegrees: $headingDegrees, speedKmh: $speedKmh, accuracyM: $accuracyM, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $LocationPayloadModelCopyWith<$Res>  {
  factory $LocationPayloadModelCopyWith(LocationPayloadModel value, $Res Function(LocationPayloadModel) _then) = _$LocationPayloadModelCopyWithImpl;
@useResult
$Res call({
 String bikeId, double latitude, double longitude, double headingDegrees, double speedKmh, double accuracyM, String timestamp
});




}
/// @nodoc
class _$LocationPayloadModelCopyWithImpl<$Res>
    implements $LocationPayloadModelCopyWith<$Res> {
  _$LocationPayloadModelCopyWithImpl(this._self, this._then);

  final LocationPayloadModel _self;
  final $Res Function(LocationPayloadModel) _then;

/// Create a copy of LocationPayloadModel
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
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationPayloadModel].
extension LocationPayloadModelPatterns on LocationPayloadModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationPayloadModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationPayloadModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationPayloadModel value)  $default,){
final _that = this;
switch (_that) {
case _LocationPayloadModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationPayloadModel value)?  $default,){
final _that = this;
switch (_that) {
case _LocationPayloadModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bikeId,  double latitude,  double longitude,  double headingDegrees,  double speedKmh,  double accuracyM,  String timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationPayloadModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bikeId,  double latitude,  double longitude,  double headingDegrees,  double speedKmh,  double accuracyM,  String timestamp)  $default,) {final _that = this;
switch (_that) {
case _LocationPayloadModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bikeId,  double latitude,  double longitude,  double headingDegrees,  double speedKmh,  double accuracyM,  String timestamp)?  $default,) {final _that = this;
switch (_that) {
case _LocationPayloadModel() when $default != null:
return $default(_that.bikeId,_that.latitude,_that.longitude,_that.headingDegrees,_that.speedKmh,_that.accuracyM,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LocationPayloadModel implements LocationPayloadModel {
  const _LocationPayloadModel({required this.bikeId, required this.latitude, required this.longitude, required this.headingDegrees, required this.speedKmh, required this.accuracyM, required this.timestamp});
  factory _LocationPayloadModel.fromJson(Map<String, dynamic> json) => _$LocationPayloadModelFromJson(json);

@override final  String bikeId;
@override final  double latitude;
@override final  double longitude;
@override final  double headingDegrees;
@override final  double speedKmh;
@override final  double accuracyM;
@override final  String timestamp;

/// Create a copy of LocationPayloadModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationPayloadModelCopyWith<_LocationPayloadModel> get copyWith => __$LocationPayloadModelCopyWithImpl<_LocationPayloadModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationPayloadModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationPayloadModel&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.headingDegrees, headingDegrees) || other.headingDegrees == headingDegrees)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bikeId,latitude,longitude,headingDegrees,speedKmh,accuracyM,timestamp);

@override
String toString() {
  return 'LocationPayloadModel(bikeId: $bikeId, latitude: $latitude, longitude: $longitude, headingDegrees: $headingDegrees, speedKmh: $speedKmh, accuracyM: $accuracyM, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$LocationPayloadModelCopyWith<$Res> implements $LocationPayloadModelCopyWith<$Res> {
  factory _$LocationPayloadModelCopyWith(_LocationPayloadModel value, $Res Function(_LocationPayloadModel) _then) = __$LocationPayloadModelCopyWithImpl;
@override @useResult
$Res call({
 String bikeId, double latitude, double longitude, double headingDegrees, double speedKmh, double accuracyM, String timestamp
});




}
/// @nodoc
class __$LocationPayloadModelCopyWithImpl<$Res>
    implements _$LocationPayloadModelCopyWith<$Res> {
  __$LocationPayloadModelCopyWithImpl(this._self, this._then);

  final _LocationPayloadModel _self;
  final $Res Function(_LocationPayloadModel) _then;

/// Create a copy of LocationPayloadModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bikeId = null,Object? latitude = null,Object? longitude = null,Object? headingDegrees = null,Object? speedKmh = null,Object? accuracyM = null,Object? timestamp = null,}) {
  return _then(_LocationPayloadModel(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,headingDegrees: null == headingDegrees ? _self.headingDegrees : headingDegrees // ignore: cast_nullable_to_non_nullable
as double,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
