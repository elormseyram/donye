// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceLogModel {

 String get id; String get bikeId; String get description; String get performedAt; String? get nextDueAt; String? get technician;
/// Create a copy of MaintenanceLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceLogModelCopyWith<MaintenanceLogModel> get copyWith => _$MaintenanceLogModelCopyWithImpl<MaintenanceLogModel>(this as MaintenanceLogModel, _$identity);

  /// Serializes this MaintenanceLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.performedAt, performedAt) || other.performedAt == performedAt)&&(identical(other.nextDueAt, nextDueAt) || other.nextDueAt == nextDueAt)&&(identical(other.technician, technician) || other.technician == technician));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bikeId,description,performedAt,nextDueAt,technician);

@override
String toString() {
  return 'MaintenanceLogModel(id: $id, bikeId: $bikeId, description: $description, performedAt: $performedAt, nextDueAt: $nextDueAt, technician: $technician)';
}


}

/// @nodoc
abstract mixin class $MaintenanceLogModelCopyWith<$Res>  {
  factory $MaintenanceLogModelCopyWith(MaintenanceLogModel value, $Res Function(MaintenanceLogModel) _then) = _$MaintenanceLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String bikeId, String description, String performedAt, String? nextDueAt, String? technician
});




}
/// @nodoc
class _$MaintenanceLogModelCopyWithImpl<$Res>
    implements $MaintenanceLogModelCopyWith<$Res> {
  _$MaintenanceLogModelCopyWithImpl(this._self, this._then);

  final MaintenanceLogModel _self;
  final $Res Function(MaintenanceLogModel) _then;

/// Create a copy of MaintenanceLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bikeId = null,Object? description = null,Object? performedAt = null,Object? nextDueAt = freezed,Object? technician = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,performedAt: null == performedAt ? _self.performedAt : performedAt // ignore: cast_nullable_to_non_nullable
as String,nextDueAt: freezed == nextDueAt ? _self.nextDueAt : nextDueAt // ignore: cast_nullable_to_non_nullable
as String?,technician: freezed == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceLogModel].
extension MaintenanceLogModelPatterns on MaintenanceLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceLogModel value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bikeId,  String description,  String performedAt,  String? nextDueAt,  String? technician)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceLogModel() when $default != null:
return $default(_that.id,_that.bikeId,_that.description,_that.performedAt,_that.nextDueAt,_that.technician);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bikeId,  String description,  String performedAt,  String? nextDueAt,  String? technician)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceLogModel():
return $default(_that.id,_that.bikeId,_that.description,_that.performedAt,_that.nextDueAt,_that.technician);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bikeId,  String description,  String performedAt,  String? nextDueAt,  String? technician)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceLogModel() when $default != null:
return $default(_that.id,_that.bikeId,_that.description,_that.performedAt,_that.nextDueAt,_that.technician);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MaintenanceLogModel implements MaintenanceLogModel {
  const _MaintenanceLogModel({required this.id, required this.bikeId, required this.description, required this.performedAt, this.nextDueAt, this.technician});
  factory _MaintenanceLogModel.fromJson(Map<String, dynamic> json) => _$MaintenanceLogModelFromJson(json);

@override final  String id;
@override final  String bikeId;
@override final  String description;
@override final  String performedAt;
@override final  String? nextDueAt;
@override final  String? technician;

/// Create a copy of MaintenanceLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceLogModelCopyWith<_MaintenanceLogModel> get copyWith => __$MaintenanceLogModelCopyWithImpl<_MaintenanceLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.performedAt, performedAt) || other.performedAt == performedAt)&&(identical(other.nextDueAt, nextDueAt) || other.nextDueAt == nextDueAt)&&(identical(other.technician, technician) || other.technician == technician));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bikeId,description,performedAt,nextDueAt,technician);

@override
String toString() {
  return 'MaintenanceLogModel(id: $id, bikeId: $bikeId, description: $description, performedAt: $performedAt, nextDueAt: $nextDueAt, technician: $technician)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceLogModelCopyWith<$Res> implements $MaintenanceLogModelCopyWith<$Res> {
  factory _$MaintenanceLogModelCopyWith(_MaintenanceLogModel value, $Res Function(_MaintenanceLogModel) _then) = __$MaintenanceLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bikeId, String description, String performedAt, String? nextDueAt, String? technician
});




}
/// @nodoc
class __$MaintenanceLogModelCopyWithImpl<$Res>
    implements _$MaintenanceLogModelCopyWith<$Res> {
  __$MaintenanceLogModelCopyWithImpl(this._self, this._then);

  final _MaintenanceLogModel _self;
  final $Res Function(_MaintenanceLogModel) _then;

/// Create a copy of MaintenanceLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bikeId = null,Object? description = null,Object? performedAt = null,Object? nextDueAt = freezed,Object? technician = freezed,}) {
  return _then(_MaintenanceLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,performedAt: null == performedAt ? _self.performedAt : performedAt // ignore: cast_nullable_to_non_nullable
as String,nextDueAt: freezed == nextDueAt ? _self.nextDueAt : nextDueAt // ignore: cast_nullable_to_non_nullable
as String?,technician: freezed == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
