// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnostic_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiagnosticEntity {

 String get id; String get bikeId; int get healthScore; List<FaultCode> get faultCodes; DateTime get lastDiagnosticAt; MaintenanceStatus get maintenanceStatus;
/// Create a copy of DiagnosticEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosticEntityCopyWith<DiagnosticEntity> get copyWith => _$DiagnosticEntityCopyWithImpl<DiagnosticEntity>(this as DiagnosticEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosticEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore)&&const DeepCollectionEquality().equals(other.faultCodes, faultCodes)&&(identical(other.lastDiagnosticAt, lastDiagnosticAt) || other.lastDiagnosticAt == lastDiagnosticAt)&&(identical(other.maintenanceStatus, maintenanceStatus) || other.maintenanceStatus == maintenanceStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,bikeId,healthScore,const DeepCollectionEquality().hash(faultCodes),lastDiagnosticAt,maintenanceStatus);

@override
String toString() {
  return 'DiagnosticEntity(id: $id, bikeId: $bikeId, healthScore: $healthScore, faultCodes: $faultCodes, lastDiagnosticAt: $lastDiagnosticAt, maintenanceStatus: $maintenanceStatus)';
}


}

/// @nodoc
abstract mixin class $DiagnosticEntityCopyWith<$Res>  {
  factory $DiagnosticEntityCopyWith(DiagnosticEntity value, $Res Function(DiagnosticEntity) _then) = _$DiagnosticEntityCopyWithImpl;
@useResult
$Res call({
 String id, String bikeId, int healthScore, List<FaultCode> faultCodes, DateTime lastDiagnosticAt, MaintenanceStatus maintenanceStatus
});




}
/// @nodoc
class _$DiagnosticEntityCopyWithImpl<$Res>
    implements $DiagnosticEntityCopyWith<$Res> {
  _$DiagnosticEntityCopyWithImpl(this._self, this._then);

  final DiagnosticEntity _self;
  final $Res Function(DiagnosticEntity) _then;

/// Create a copy of DiagnosticEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bikeId = null,Object? healthScore = null,Object? faultCodes = null,Object? lastDiagnosticAt = null,Object? maintenanceStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as int,faultCodes: null == faultCodes ? _self.faultCodes : faultCodes // ignore: cast_nullable_to_non_nullable
as List<FaultCode>,lastDiagnosticAt: null == lastDiagnosticAt ? _self.lastDiagnosticAt : lastDiagnosticAt // ignore: cast_nullable_to_non_nullable
as DateTime,maintenanceStatus: null == maintenanceStatus ? _self.maintenanceStatus : maintenanceStatus // ignore: cast_nullable_to_non_nullable
as MaintenanceStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosticEntity].
extension DiagnosticEntityPatterns on DiagnosticEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosticEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosticEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosticEntity value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosticEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosticEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosticEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bikeId,  int healthScore,  List<FaultCode> faultCodes,  DateTime lastDiagnosticAt,  MaintenanceStatus maintenanceStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosticEntity() when $default != null:
return $default(_that.id,_that.bikeId,_that.healthScore,_that.faultCodes,_that.lastDiagnosticAt,_that.maintenanceStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bikeId,  int healthScore,  List<FaultCode> faultCodes,  DateTime lastDiagnosticAt,  MaintenanceStatus maintenanceStatus)  $default,) {final _that = this;
switch (_that) {
case _DiagnosticEntity():
return $default(_that.id,_that.bikeId,_that.healthScore,_that.faultCodes,_that.lastDiagnosticAt,_that.maintenanceStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bikeId,  int healthScore,  List<FaultCode> faultCodes,  DateTime lastDiagnosticAt,  MaintenanceStatus maintenanceStatus)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosticEntity() when $default != null:
return $default(_that.id,_that.bikeId,_that.healthScore,_that.faultCodes,_that.lastDiagnosticAt,_that.maintenanceStatus);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosticEntity implements DiagnosticEntity {
  const _DiagnosticEntity({required this.id, required this.bikeId, required this.healthScore, required final  List<FaultCode> faultCodes, required this.lastDiagnosticAt, required this.maintenanceStatus}): _faultCodes = faultCodes;
  

@override final  String id;
@override final  String bikeId;
@override final  int healthScore;
 final  List<FaultCode> _faultCodes;
@override List<FaultCode> get faultCodes {
  if (_faultCodes is EqualUnmodifiableListView) return _faultCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faultCodes);
}

@override final  DateTime lastDiagnosticAt;
@override final  MaintenanceStatus maintenanceStatus;

/// Create a copy of DiagnosticEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosticEntityCopyWith<_DiagnosticEntity> get copyWith => __$DiagnosticEntityCopyWithImpl<_DiagnosticEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosticEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore)&&const DeepCollectionEquality().equals(other._faultCodes, _faultCodes)&&(identical(other.lastDiagnosticAt, lastDiagnosticAt) || other.lastDiagnosticAt == lastDiagnosticAt)&&(identical(other.maintenanceStatus, maintenanceStatus) || other.maintenanceStatus == maintenanceStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,bikeId,healthScore,const DeepCollectionEquality().hash(_faultCodes),lastDiagnosticAt,maintenanceStatus);

@override
String toString() {
  return 'DiagnosticEntity(id: $id, bikeId: $bikeId, healthScore: $healthScore, faultCodes: $faultCodes, lastDiagnosticAt: $lastDiagnosticAt, maintenanceStatus: $maintenanceStatus)';
}


}

/// @nodoc
abstract mixin class _$DiagnosticEntityCopyWith<$Res> implements $DiagnosticEntityCopyWith<$Res> {
  factory _$DiagnosticEntityCopyWith(_DiagnosticEntity value, $Res Function(_DiagnosticEntity) _then) = __$DiagnosticEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String bikeId, int healthScore, List<FaultCode> faultCodes, DateTime lastDiagnosticAt, MaintenanceStatus maintenanceStatus
});




}
/// @nodoc
class __$DiagnosticEntityCopyWithImpl<$Res>
    implements _$DiagnosticEntityCopyWith<$Res> {
  __$DiagnosticEntityCopyWithImpl(this._self, this._then);

  final _DiagnosticEntity _self;
  final $Res Function(_DiagnosticEntity) _then;

/// Create a copy of DiagnosticEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bikeId = null,Object? healthScore = null,Object? faultCodes = null,Object? lastDiagnosticAt = null,Object? maintenanceStatus = null,}) {
  return _then(_DiagnosticEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as int,faultCodes: null == faultCodes ? _self._faultCodes : faultCodes // ignore: cast_nullable_to_non_nullable
as List<FaultCode>,lastDiagnosticAt: null == lastDiagnosticAt ? _self.lastDiagnosticAt : lastDiagnosticAt // ignore: cast_nullable_to_non_nullable
as DateTime,maintenanceStatus: null == maintenanceStatus ? _self.maintenanceStatus : maintenanceStatus // ignore: cast_nullable_to_non_nullable
as MaintenanceStatus,
  ));
}


}

// dart format on
