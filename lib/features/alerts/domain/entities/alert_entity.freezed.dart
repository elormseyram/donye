// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertEntity {

 String get id; String get bikeId; AlertSeverity get severity; AlertType get type; String get title; String get message; bool get isRead; bool get isResolved; DateTime get createdAt;
/// Create a copy of AlertEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertEntityCopyWith<AlertEntity> get copyWith => _$AlertEntityCopyWithImpl<AlertEntity>(this as AlertEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bikeId,severity,type,title,message,isRead,isResolved,createdAt);

@override
String toString() {
  return 'AlertEntity(id: $id, bikeId: $bikeId, severity: $severity, type: $type, title: $title, message: $message, isRead: $isRead, isResolved: $isResolved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AlertEntityCopyWith<$Res>  {
  factory $AlertEntityCopyWith(AlertEntity value, $Res Function(AlertEntity) _then) = _$AlertEntityCopyWithImpl;
@useResult
$Res call({
 String id, String bikeId, AlertSeverity severity, AlertType type, String title, String message, bool isRead, bool isResolved, DateTime createdAt
});




}
/// @nodoc
class _$AlertEntityCopyWithImpl<$Res>
    implements $AlertEntityCopyWith<$Res> {
  _$AlertEntityCopyWithImpl(this._self, this._then);

  final AlertEntity _self;
  final $Res Function(AlertEntity) _then;

/// Create a copy of AlertEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bikeId = null,Object? severity = null,Object? type = null,Object? title = null,Object? message = null,Object? isRead = null,Object? isResolved = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertEntity].
extension AlertEntityPatterns on AlertEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertEntity value)  $default,){
final _that = this;
switch (_that) {
case _AlertEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AlertEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bikeId,  AlertSeverity severity,  AlertType type,  String title,  String message,  bool isRead,  bool isResolved,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertEntity() when $default != null:
return $default(_that.id,_that.bikeId,_that.severity,_that.type,_that.title,_that.message,_that.isRead,_that.isResolved,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bikeId,  AlertSeverity severity,  AlertType type,  String title,  String message,  bool isRead,  bool isResolved,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AlertEntity():
return $default(_that.id,_that.bikeId,_that.severity,_that.type,_that.title,_that.message,_that.isRead,_that.isResolved,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bikeId,  AlertSeverity severity,  AlertType type,  String title,  String message,  bool isRead,  bool isResolved,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AlertEntity() when $default != null:
return $default(_that.id,_that.bikeId,_that.severity,_that.type,_that.title,_that.message,_that.isRead,_that.isResolved,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AlertEntity implements AlertEntity {
  const _AlertEntity({required this.id, required this.bikeId, required this.severity, required this.type, required this.title, required this.message, required this.isRead, required this.isResolved, required this.createdAt});
  

@override final  String id;
@override final  String bikeId;
@override final  AlertSeverity severity;
@override final  AlertType type;
@override final  String title;
@override final  String message;
@override final  bool isRead;
@override final  bool isResolved;
@override final  DateTime createdAt;

/// Create a copy of AlertEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertEntityCopyWith<_AlertEntity> get copyWith => __$AlertEntityCopyWithImpl<_AlertEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bikeId,severity,type,title,message,isRead,isResolved,createdAt);

@override
String toString() {
  return 'AlertEntity(id: $id, bikeId: $bikeId, severity: $severity, type: $type, title: $title, message: $message, isRead: $isRead, isResolved: $isResolved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AlertEntityCopyWith<$Res> implements $AlertEntityCopyWith<$Res> {
  factory _$AlertEntityCopyWith(_AlertEntity value, $Res Function(_AlertEntity) _then) = __$AlertEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String bikeId, AlertSeverity severity, AlertType type, String title, String message, bool isRead, bool isResolved, DateTime createdAt
});




}
/// @nodoc
class __$AlertEntityCopyWithImpl<$Res>
    implements _$AlertEntityCopyWith<$Res> {
  __$AlertEntityCopyWithImpl(this._self, this._then);

  final _AlertEntity _self;
  final $Res Function(_AlertEntity) _then;

/// Create a copy of AlertEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bikeId = null,Object? severity = null,Object? type = null,Object? title = null,Object? message = null,Object? isRead = null,Object? isResolved = null,Object? createdAt = null,}) {
  return _then(_AlertEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
