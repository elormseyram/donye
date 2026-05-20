// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rider_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RiderEntity {

 String get id; String get email; String get fullName; String get phoneNumber; String? get avatarUrl; String? get assignedBikeId; DateTime get createdAt; bool get isActive;
/// Create a copy of RiderEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderEntityCopyWith<RiderEntity> get copyWith => _$RiderEntityCopyWithImpl<RiderEntity>(this as RiderEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.assignedBikeId, assignedBikeId) || other.assignedBikeId == assignedBikeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phoneNumber,avatarUrl,assignedBikeId,createdAt,isActive);

@override
String toString() {
  return 'RiderEntity(id: $id, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, assignedBikeId: $assignedBikeId, createdAt: $createdAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $RiderEntityCopyWith<$Res>  {
  factory $RiderEntityCopyWith(RiderEntity value, $Res Function(RiderEntity) _then) = _$RiderEntityCopyWithImpl;
@useResult
$Res call({
 String id, String email, String fullName, String phoneNumber, String? avatarUrl, String? assignedBikeId, DateTime createdAt, bool isActive
});




}
/// @nodoc
class _$RiderEntityCopyWithImpl<$Res>
    implements $RiderEntityCopyWith<$Res> {
  _$RiderEntityCopyWithImpl(this._self, this._then);

  final RiderEntity _self;
  final $Res Function(RiderEntity) _then;

/// Create a copy of RiderEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? phoneNumber = null,Object? avatarUrl = freezed,Object? assignedBikeId = freezed,Object? createdAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,assignedBikeId: freezed == assignedBikeId ? _self.assignedBikeId : assignedBikeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderEntity].
extension RiderEntityPatterns on RiderEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderEntity value)  $default,){
final _that = this;
switch (_that) {
case _RiderEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RiderEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String fullName,  String phoneNumber,  String? avatarUrl,  String? assignedBikeId,  DateTime createdAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderEntity() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phoneNumber,_that.avatarUrl,_that.assignedBikeId,_that.createdAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String fullName,  String phoneNumber,  String? avatarUrl,  String? assignedBikeId,  DateTime createdAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _RiderEntity():
return $default(_that.id,_that.email,_that.fullName,_that.phoneNumber,_that.avatarUrl,_that.assignedBikeId,_that.createdAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String fullName,  String phoneNumber,  String? avatarUrl,  String? assignedBikeId,  DateTime createdAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _RiderEntity() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phoneNumber,_that.avatarUrl,_that.assignedBikeId,_that.createdAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _RiderEntity implements RiderEntity {
  const _RiderEntity({required this.id, required this.email, required this.fullName, required this.phoneNumber, this.avatarUrl, this.assignedBikeId, required this.createdAt, this.isActive = true});
  

@override final  String id;
@override final  String email;
@override final  String fullName;
@override final  String phoneNumber;
@override final  String? avatarUrl;
@override final  String? assignedBikeId;
@override final  DateTime createdAt;
@override@JsonKey() final  bool isActive;

/// Create a copy of RiderEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderEntityCopyWith<_RiderEntity> get copyWith => __$RiderEntityCopyWithImpl<_RiderEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.assignedBikeId, assignedBikeId) || other.assignedBikeId == assignedBikeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phoneNumber,avatarUrl,assignedBikeId,createdAt,isActive);

@override
String toString() {
  return 'RiderEntity(id: $id, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, assignedBikeId: $assignedBikeId, createdAt: $createdAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$RiderEntityCopyWith<$Res> implements $RiderEntityCopyWith<$Res> {
  factory _$RiderEntityCopyWith(_RiderEntity value, $Res Function(_RiderEntity) _then) = __$RiderEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String fullName, String phoneNumber, String? avatarUrl, String? assignedBikeId, DateTime createdAt, bool isActive
});




}
/// @nodoc
class __$RiderEntityCopyWithImpl<$Res>
    implements _$RiderEntityCopyWith<$Res> {
  __$RiderEntityCopyWithImpl(this._self, this._then);

  final _RiderEntity _self;
  final $Res Function(_RiderEntity) _then;

/// Create a copy of RiderEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? phoneNumber = null,Object? avatarUrl = freezed,Object? assignedBikeId = freezed,Object? createdAt = null,Object? isActive = null,}) {
  return _then(_RiderEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,assignedBikeId: freezed == assignedBikeId ? _self.assignedBikeId : assignedBikeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
