// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bike_command_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BikeCommandEntity {

 String get bikeId; CommandType get type; String? get payload; DateTime get issuedAt; CommandStatus get status;
/// Create a copy of BikeCommandEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BikeCommandEntityCopyWith<BikeCommandEntity> get copyWith => _$BikeCommandEntityCopyWithImpl<BikeCommandEntity>(this as BikeCommandEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BikeCommandEntity&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,bikeId,type,payload,issuedAt,status);

@override
String toString() {
  return 'BikeCommandEntity(bikeId: $bikeId, type: $type, payload: $payload, issuedAt: $issuedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $BikeCommandEntityCopyWith<$Res>  {
  factory $BikeCommandEntityCopyWith(BikeCommandEntity value, $Res Function(BikeCommandEntity) _then) = _$BikeCommandEntityCopyWithImpl;
@useResult
$Res call({
 String bikeId, CommandType type, String? payload, DateTime issuedAt, CommandStatus status
});




}
/// @nodoc
class _$BikeCommandEntityCopyWithImpl<$Res>
    implements $BikeCommandEntityCopyWith<$Res> {
  _$BikeCommandEntityCopyWithImpl(this._self, this._then);

  final BikeCommandEntity _self;
  final $Res Function(BikeCommandEntity) _then;

/// Create a copy of BikeCommandEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bikeId = null,Object? type = null,Object? payload = freezed,Object? issuedAt = null,Object? status = null,}) {
  return _then(_self.copyWith(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CommandType,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommandStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [BikeCommandEntity].
extension BikeCommandEntityPatterns on BikeCommandEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BikeCommandEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BikeCommandEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BikeCommandEntity value)  $default,){
final _that = this;
switch (_that) {
case _BikeCommandEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BikeCommandEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BikeCommandEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bikeId,  CommandType type,  String? payload,  DateTime issuedAt,  CommandStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BikeCommandEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bikeId,  CommandType type,  String? payload,  DateTime issuedAt,  CommandStatus status)  $default,) {final _that = this;
switch (_that) {
case _BikeCommandEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bikeId,  CommandType type,  String? payload,  DateTime issuedAt,  CommandStatus status)?  $default,) {final _that = this;
switch (_that) {
case _BikeCommandEntity() when $default != null:
return $default(_that.bikeId,_that.type,_that.payload,_that.issuedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BikeCommandEntity implements BikeCommandEntity {
  const _BikeCommandEntity({required this.bikeId, required this.type, this.payload, required this.issuedAt, required this.status});
  

@override final  String bikeId;
@override final  CommandType type;
@override final  String? payload;
@override final  DateTime issuedAt;
@override final  CommandStatus status;

/// Create a copy of BikeCommandEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BikeCommandEntityCopyWith<_BikeCommandEntity> get copyWith => __$BikeCommandEntityCopyWithImpl<_BikeCommandEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BikeCommandEntity&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,bikeId,type,payload,issuedAt,status);

@override
String toString() {
  return 'BikeCommandEntity(bikeId: $bikeId, type: $type, payload: $payload, issuedAt: $issuedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BikeCommandEntityCopyWith<$Res> implements $BikeCommandEntityCopyWith<$Res> {
  factory _$BikeCommandEntityCopyWith(_BikeCommandEntity value, $Res Function(_BikeCommandEntity) _then) = __$BikeCommandEntityCopyWithImpl;
@override @useResult
$Res call({
 String bikeId, CommandType type, String? payload, DateTime issuedAt, CommandStatus status
});




}
/// @nodoc
class __$BikeCommandEntityCopyWithImpl<$Res>
    implements _$BikeCommandEntityCopyWith<$Res> {
  __$BikeCommandEntityCopyWithImpl(this._self, this._then);

  final _BikeCommandEntity _self;
  final $Res Function(_BikeCommandEntity) _then;

/// Create a copy of BikeCommandEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bikeId = null,Object? type = null,Object? payload = freezed,Object? issuedAt = null,Object? status = null,}) {
  return _then(_BikeCommandEntity(
bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CommandType,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommandStatus,
  ));
}


}

// dart format on
