// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bike_command_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BikeCommandModel {

 String get bikeId; String get type; String? get payload; String get issuedAt; String get status;
/// Create a copy of BikeCommandModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BikeCommandModelCopyWith<BikeCommandModel> get copyWith => _$BikeCommandModelCopyWithImpl<BikeCommandModel>(this as BikeCommandModel, _$identity);

  /// Serializes this BikeCommandModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BikeCommandModel&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bikeId,type,payload,issuedAt,status);

@override
String toString() {
  return 'BikeCommandModel(bikeId: $bikeId, type: $type, payload: $payload, issuedAt: $issuedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $BikeCommandModelCopyWith<$Res>  {
  factory $BikeCommandModelCopyWith(BikeCommandModel value, $Res Function(BikeCommandModel) _then) = _$BikeCommandModelCopyWithImpl;
@useResult
$Res call({
 String bikeId, String type, String? payload, String issuedAt, String status
});




}
/// @nodoc
class _$BikeCommandModelCopyWithImpl<$Res>
    implements $BikeCommandModelCopyWith<$Res> {
  _$BikeCommandModelCopyWithImpl(this._self, this._then);

  final BikeCommandModel _self;
  final $Res Function(BikeCommandModel) _then;

/// Create a copy of BikeCommandModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bikeId = null,Object? type = null,Object? payload = freezed,Object? issuedAt = null,Object? status = null,}) {
  return _then(_self.copyWith(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BikeCommandModel].
extension BikeCommandModelPatterns on BikeCommandModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BikeCommandModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BikeCommandModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BikeCommandModel value)  $default,){
final _that = this;
switch (_that) {
case _BikeCommandModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BikeCommandModel value)?  $default,){
final _that = this;
switch (_that) {
case _BikeCommandModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bikeId,  String type,  String? payload,  String issuedAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BikeCommandModel() when $default != null:
return $default(_that.bikeId,_that.type,_that.payload,_that.issuedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bikeId,  String type,  String? payload,  String issuedAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _BikeCommandModel():
return $default(_that.bikeId,_that.type,_that.payload,_that.issuedAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bikeId,  String type,  String? payload,  String issuedAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BikeCommandModel() when $default != null:
return $default(_that.bikeId,_that.type,_that.payload,_that.issuedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BikeCommandModel implements BikeCommandModel {
  const _BikeCommandModel({required this.bikeId, required this.type, this.payload, required this.issuedAt, required this.status});
  factory _BikeCommandModel.fromJson(Map<String, dynamic> json) => _$BikeCommandModelFromJson(json);

@override final  String bikeId;
@override final  String type;
@override final  String? payload;
@override final  String issuedAt;
@override final  String status;

/// Create a copy of BikeCommandModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BikeCommandModelCopyWith<_BikeCommandModel> get copyWith => __$BikeCommandModelCopyWithImpl<_BikeCommandModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BikeCommandModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BikeCommandModel&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bikeId,type,payload,issuedAt,status);

@override
String toString() {
  return 'BikeCommandModel(bikeId: $bikeId, type: $type, payload: $payload, issuedAt: $issuedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BikeCommandModelCopyWith<$Res> implements $BikeCommandModelCopyWith<$Res> {
  factory _$BikeCommandModelCopyWith(_BikeCommandModel value, $Res Function(_BikeCommandModel) _then) = __$BikeCommandModelCopyWithImpl;
@override @useResult
$Res call({
 String bikeId, String type, String? payload, String issuedAt, String status
});




}
/// @nodoc
class __$BikeCommandModelCopyWithImpl<$Res>
    implements _$BikeCommandModelCopyWith<$Res> {
  __$BikeCommandModelCopyWithImpl(this._self, this._then);

  final _BikeCommandModel _self;
  final $Res Function(_BikeCommandModel) _then;

/// Create a copy of BikeCommandModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bikeId = null,Object? type = null,Object? payload = freezed,Object? issuedAt = null,Object? status = null,}) {
  return _then(_BikeCommandModel(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
