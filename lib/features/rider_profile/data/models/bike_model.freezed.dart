// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bike_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BikeModel {

 String get id; String get serialNumber; String get model; String get registrationNumber; double get batteryCapacityKwh; String get lastServiceDate; String get status;
/// Create a copy of BikeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BikeModelCopyWith<BikeModel> get copyWith => _$BikeModelCopyWithImpl<BikeModel>(this as BikeModel, _$identity);

  /// Serializes this BikeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BikeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.model, model) || other.model == model)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.batteryCapacityKwh, batteryCapacityKwh) || other.batteryCapacityKwh == batteryCapacityKwh)&&(identical(other.lastServiceDate, lastServiceDate) || other.lastServiceDate == lastServiceDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,model,registrationNumber,batteryCapacityKwh,lastServiceDate,status);

@override
String toString() {
  return 'BikeModel(id: $id, serialNumber: $serialNumber, model: $model, registrationNumber: $registrationNumber, batteryCapacityKwh: $batteryCapacityKwh, lastServiceDate: $lastServiceDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $BikeModelCopyWith<$Res>  {
  factory $BikeModelCopyWith(BikeModel value, $Res Function(BikeModel) _then) = _$BikeModelCopyWithImpl;
@useResult
$Res call({
 String id, String serialNumber, String model, String registrationNumber, double batteryCapacityKwh, String lastServiceDate, String status
});




}
/// @nodoc
class _$BikeModelCopyWithImpl<$Res>
    implements $BikeModelCopyWith<$Res> {
  _$BikeModelCopyWithImpl(this._self, this._then);

  final BikeModel _self;
  final $Res Function(BikeModel) _then;

/// Create a copy of BikeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serialNumber = null,Object? model = null,Object? registrationNumber = null,Object? batteryCapacityKwh = null,Object? lastServiceDate = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,batteryCapacityKwh: null == batteryCapacityKwh ? _self.batteryCapacityKwh : batteryCapacityKwh // ignore: cast_nullable_to_non_nullable
as double,lastServiceDate: null == lastServiceDate ? _self.lastServiceDate : lastServiceDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BikeModel].
extension BikeModelPatterns on BikeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BikeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BikeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BikeModel value)  $default,){
final _that = this;
switch (_that) {
case _BikeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BikeModel value)?  $default,){
final _that = this;
switch (_that) {
case _BikeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String serialNumber,  String model,  String registrationNumber,  double batteryCapacityKwh,  String lastServiceDate,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BikeModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String serialNumber,  String model,  String registrationNumber,  double batteryCapacityKwh,  String lastServiceDate,  String status)  $default,) {final _that = this;
switch (_that) {
case _BikeModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String serialNumber,  String model,  String registrationNumber,  double batteryCapacityKwh,  String lastServiceDate,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BikeModel() when $default != null:
return $default(_that.id,_that.serialNumber,_that.model,_that.registrationNumber,_that.batteryCapacityKwh,_that.lastServiceDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BikeModel implements BikeModel {
  const _BikeModel({required this.id, required this.serialNumber, required this.model, required this.registrationNumber, this.batteryCapacityKwh = 0.0, required this.lastServiceDate, this.status = 'active'});
  factory _BikeModel.fromJson(Map<String, dynamic> json) => _$BikeModelFromJson(json);

@override final  String id;
@override final  String serialNumber;
@override final  String model;
@override final  String registrationNumber;
@override@JsonKey() final  double batteryCapacityKwh;
@override final  String lastServiceDate;
@override@JsonKey() final  String status;

/// Create a copy of BikeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BikeModelCopyWith<_BikeModel> get copyWith => __$BikeModelCopyWithImpl<_BikeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BikeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BikeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.model, model) || other.model == model)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.batteryCapacityKwh, batteryCapacityKwh) || other.batteryCapacityKwh == batteryCapacityKwh)&&(identical(other.lastServiceDate, lastServiceDate) || other.lastServiceDate == lastServiceDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,model,registrationNumber,batteryCapacityKwh,lastServiceDate,status);

@override
String toString() {
  return 'BikeModel(id: $id, serialNumber: $serialNumber, model: $model, registrationNumber: $registrationNumber, batteryCapacityKwh: $batteryCapacityKwh, lastServiceDate: $lastServiceDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BikeModelCopyWith<$Res> implements $BikeModelCopyWith<$Res> {
  factory _$BikeModelCopyWith(_BikeModel value, $Res Function(_BikeModel) _then) = __$BikeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String serialNumber, String model, String registrationNumber, double batteryCapacityKwh, String lastServiceDate, String status
});




}
/// @nodoc
class __$BikeModelCopyWithImpl<$Res>
    implements _$BikeModelCopyWith<$Res> {
  __$BikeModelCopyWithImpl(this._self, this._then);

  final _BikeModel _self;
  final $Res Function(_BikeModel) _then;

/// Create a copy of BikeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serialNumber = null,Object? model = null,Object? registrationNumber = null,Object? batteryCapacityKwh = null,Object? lastServiceDate = null,Object? status = null,}) {
  return _then(_BikeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: null == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String,batteryCapacityKwh: null == batteryCapacityKwh ? _self.batteryCapacityKwh : batteryCapacityKwh // ignore: cast_nullable_to_non_nullable
as double,lastServiceDate: null == lastServiceDate ? _self.lastServiceDate : lastServiceDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
