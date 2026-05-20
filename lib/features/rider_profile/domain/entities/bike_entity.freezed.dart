// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bike_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BikeEntity {

 String get id; String get serialNumber; String get model; String get registrationNumber; double get batteryCapacityKwh; DateTime get lastServiceDate; BikeStatus get status;
/// Create a copy of BikeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BikeEntityCopyWith<BikeEntity> get copyWith => _$BikeEntityCopyWithImpl<BikeEntity>(this as BikeEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BikeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.model, model) || other.model == model)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.batteryCapacityKwh, batteryCapacityKwh) || other.batteryCapacityKwh == batteryCapacityKwh)&&(identical(other.lastServiceDate, lastServiceDate) || other.lastServiceDate == lastServiceDate)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,model,registrationNumber,batteryCapacityKwh,lastServiceDate,status);

@override
String toString() {
  return 'BikeEntity(id: $id, serialNumber: $serialNumber, model: $model, registrationNumber: $registrationNumber, batteryCapacityKwh: $batteryCapacityKwh, lastServiceDate: $lastServiceDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $BikeEntityCopyWith<$Res>  {
  factory $BikeEntityCopyWith(BikeEntity value, $Res Function(BikeEntity) _then) = _$BikeEntityCopyWithImpl;
@useResult
$Res call({
 String id, String serialNumber, String model, String registrationNumber, double batteryCapacityKwh, DateTime lastServiceDate, BikeStatus status
});




}
/// @nodoc
class _$BikeEntityCopyWithImpl<$Res>
    implements $BikeEntityCopyWith<$Res> {
  _$BikeEntityCopyWithImpl(this._self, this._then);

  final BikeEntity _self;
  final $Res Function(BikeEntity) _then;

/// Create a copy of BikeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serialNumber = null,Object? model = null,Object? registrationNumber = null,Object? batteryCapacityKwh = null,Object? lastServiceDate = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,batteryCapacityKwh: null == batteryCapacityKwh ? _self.batteryCapacityKwh : batteryCapacityKwh // ignore: cast_nullable_to_non_nullable
as double,lastServiceDate: null == lastServiceDate ? _self.lastServiceDate : lastServiceDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BikeStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [BikeEntity].
extension BikeEntityPatterns on BikeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BikeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BikeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BikeEntity value)  $default,){
final _that = this;
switch (_that) {
case _BikeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BikeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BikeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String serialNumber,  String model,  String registrationNumber,  double batteryCapacityKwh,  DateTime lastServiceDate,  BikeStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BikeEntity() when $default != null:
return $default(_that.id,_that.serialNumber,_that.model,_that.registrationNumber,_that.batteryCapacityKwh,_that.lastServiceDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String serialNumber,  String model,  String registrationNumber,  double batteryCapacityKwh,  DateTime lastServiceDate,  BikeStatus status)  $default,) {final _that = this;
switch (_that) {
case _BikeEntity():
return $default(_that.id,_that.serialNumber,_that.model,_that.registrationNumber,_that.batteryCapacityKwh,_that.lastServiceDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String serialNumber,  String model,  String registrationNumber,  double batteryCapacityKwh,  DateTime lastServiceDate,  BikeStatus status)?  $default,) {final _that = this;
switch (_that) {
case _BikeEntity() when $default != null:
return $default(_that.id,_that.serialNumber,_that.model,_that.registrationNumber,_that.batteryCapacityKwh,_that.lastServiceDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BikeEntity implements BikeEntity {
  const _BikeEntity({required this.id, required this.serialNumber, required this.model, required this.registrationNumber, required this.batteryCapacityKwh, required this.lastServiceDate, required this.status});
  

@override final  String id;
@override final  String serialNumber;
@override final  String model;
@override final  String registrationNumber;
@override final  double batteryCapacityKwh;
@override final  DateTime lastServiceDate;
@override final  BikeStatus status;

/// Create a copy of BikeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BikeEntityCopyWith<_BikeEntity> get copyWith => __$BikeEntityCopyWithImpl<_BikeEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BikeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.model, model) || other.model == model)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.batteryCapacityKwh, batteryCapacityKwh) || other.batteryCapacityKwh == batteryCapacityKwh)&&(identical(other.lastServiceDate, lastServiceDate) || other.lastServiceDate == lastServiceDate)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,model,registrationNumber,batteryCapacityKwh,lastServiceDate,status);

@override
String toString() {
  return 'BikeEntity(id: $id, serialNumber: $serialNumber, model: $model, registrationNumber: $registrationNumber, batteryCapacityKwh: $batteryCapacityKwh, lastServiceDate: $lastServiceDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BikeEntityCopyWith<$Res> implements $BikeEntityCopyWith<$Res> {
  factory _$BikeEntityCopyWith(_BikeEntity value, $Res Function(_BikeEntity) _then) = __$BikeEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String serialNumber, String model, String registrationNumber, double batteryCapacityKwh, DateTime lastServiceDate, BikeStatus status
});




}
/// @nodoc
class __$BikeEntityCopyWithImpl<$Res>
    implements _$BikeEntityCopyWith<$Res> {
  __$BikeEntityCopyWithImpl(this._self, this._then);

  final _BikeEntity _self;
  final $Res Function(_BikeEntity) _then;

/// Create a copy of BikeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serialNumber = null,Object? model = null,Object? registrationNumber = null,Object? batteryCapacityKwh = null,Object? lastServiceDate = null,Object? status = null,}) {
  return _then(_BikeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,batteryCapacityKwh: null == batteryCapacityKwh ? _self.batteryCapacityKwh : batteryCapacityKwh // ignore: cast_nullable_to_non_nullable
as double,lastServiceDate: null == lastServiceDate ? _self.lastServiceDate : lastServiceDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BikeStatus,
  ));
}


}

// dart format on
