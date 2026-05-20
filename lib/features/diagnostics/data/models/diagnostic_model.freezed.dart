// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnostic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FaultCodeModel {

 String get code; String get description; String get severity; String get detectedAt; bool get isActive;
/// Create a copy of FaultCodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaultCodeModelCopyWith<FaultCodeModel> get copyWith => _$FaultCodeModelCopyWithImpl<FaultCodeModel>(this as FaultCodeModel, _$identity);

  /// Serializes this FaultCodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaultCodeModel&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,description,severity,detectedAt,isActive);

@override
String toString() {
  return 'FaultCodeModel(code: $code, description: $description, severity: $severity, detectedAt: $detectedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $FaultCodeModelCopyWith<$Res>  {
  factory $FaultCodeModelCopyWith(FaultCodeModel value, $Res Function(FaultCodeModel) _then) = _$FaultCodeModelCopyWithImpl;
@useResult
$Res call({
 String code, String description, String severity, String detectedAt, bool isActive
});




}
/// @nodoc
class _$FaultCodeModelCopyWithImpl<$Res>
    implements $FaultCodeModelCopyWith<$Res> {
  _$FaultCodeModelCopyWithImpl(this._self, this._then);

  final FaultCodeModel _self;
  final $Res Function(FaultCodeModel) _then;

/// Create a copy of FaultCodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? description = null,Object? severity = null,Object? detectedAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FaultCodeModel].
extension FaultCodeModelPatterns on FaultCodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaultCodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaultCodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaultCodeModel value)  $default,){
final _that = this;
switch (_that) {
case _FaultCodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaultCodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _FaultCodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String description,  String severity,  String detectedAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaultCodeModel() when $default != null:
return $default(_that.code,_that.description,_that.severity,_that.detectedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String description,  String severity,  String detectedAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _FaultCodeModel():
return $default(_that.code,_that.description,_that.severity,_that.detectedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String description,  String severity,  String detectedAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _FaultCodeModel() when $default != null:
return $default(_that.code,_that.description,_that.severity,_that.detectedAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FaultCodeModel implements FaultCodeModel {
  const _FaultCodeModel({required this.code, required this.description, required this.severity, required this.detectedAt, required this.isActive});
  factory _FaultCodeModel.fromJson(Map<String, dynamic> json) => _$FaultCodeModelFromJson(json);

@override final  String code;
@override final  String description;
@override final  String severity;
@override final  String detectedAt;
@override final  bool isActive;

/// Create a copy of FaultCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaultCodeModelCopyWith<_FaultCodeModel> get copyWith => __$FaultCodeModelCopyWithImpl<_FaultCodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FaultCodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaultCodeModel&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,description,severity,detectedAt,isActive);

@override
String toString() {
  return 'FaultCodeModel(code: $code, description: $description, severity: $severity, detectedAt: $detectedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$FaultCodeModelCopyWith<$Res> implements $FaultCodeModelCopyWith<$Res> {
  factory _$FaultCodeModelCopyWith(_FaultCodeModel value, $Res Function(_FaultCodeModel) _then) = __$FaultCodeModelCopyWithImpl;
@override @useResult
$Res call({
 String code, String description, String severity, String detectedAt, bool isActive
});




}
/// @nodoc
class __$FaultCodeModelCopyWithImpl<$Res>
    implements _$FaultCodeModelCopyWith<$Res> {
  __$FaultCodeModelCopyWithImpl(this._self, this._then);

  final _FaultCodeModel _self;
  final $Res Function(_FaultCodeModel) _then;

/// Create a copy of FaultCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? description = null,Object? severity = null,Object? detectedAt = null,Object? isActive = null,}) {
  return _then(_FaultCodeModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DiagnosticModel {

 String get id; String get bikeId; int get healthScore; List<FaultCodeModel> get faultCodes; String get lastDiagnosticAt; String get maintenanceStatus;
/// Create a copy of DiagnosticModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosticModelCopyWith<DiagnosticModel> get copyWith => _$DiagnosticModelCopyWithImpl<DiagnosticModel>(this as DiagnosticModel, _$identity);

  /// Serializes this DiagnosticModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosticModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore)&&const DeepCollectionEquality().equals(other.faultCodes, faultCodes)&&(identical(other.lastDiagnosticAt, lastDiagnosticAt) || other.lastDiagnosticAt == lastDiagnosticAt)&&(identical(other.maintenanceStatus, maintenanceStatus) || other.maintenanceStatus == maintenanceStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bikeId,healthScore,const DeepCollectionEquality().hash(faultCodes),lastDiagnosticAt,maintenanceStatus);

@override
String toString() {
  return 'DiagnosticModel(id: $id, bikeId: $bikeId, healthScore: $healthScore, faultCodes: $faultCodes, lastDiagnosticAt: $lastDiagnosticAt, maintenanceStatus: $maintenanceStatus)';
}


}

/// @nodoc
abstract mixin class $DiagnosticModelCopyWith<$Res>  {
  factory $DiagnosticModelCopyWith(DiagnosticModel value, $Res Function(DiagnosticModel) _then) = _$DiagnosticModelCopyWithImpl;
@useResult
$Res call({
 String id, String bikeId, int healthScore, List<FaultCodeModel> faultCodes, String lastDiagnosticAt, String maintenanceStatus
});




}
/// @nodoc
class _$DiagnosticModelCopyWithImpl<$Res>
    implements $DiagnosticModelCopyWith<$Res> {
  _$DiagnosticModelCopyWithImpl(this._self, this._then);

  final DiagnosticModel _self;
  final $Res Function(DiagnosticModel) _then;

/// Create a copy of DiagnosticModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bikeId = null,Object? healthScore = null,Object? faultCodes = null,Object? lastDiagnosticAt = null,Object? maintenanceStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as int,faultCodes: null == faultCodes ? _self.faultCodes : faultCodes // ignore: cast_nullable_to_non_nullable
as List<FaultCodeModel>,lastDiagnosticAt: null == lastDiagnosticAt ? _self.lastDiagnosticAt : lastDiagnosticAt // ignore: cast_nullable_to_non_nullable
as String,maintenanceStatus: null == maintenanceStatus ? _self.maintenanceStatus : maintenanceStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosticModel].
extension DiagnosticModelPatterns on DiagnosticModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosticModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosticModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosticModel value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosticModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosticModel value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosticModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bikeId,  int healthScore,  List<FaultCodeModel> faultCodes,  String lastDiagnosticAt,  String maintenanceStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosticModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bikeId,  int healthScore,  List<FaultCodeModel> faultCodes,  String lastDiagnosticAt,  String maintenanceStatus)  $default,) {final _that = this;
switch (_that) {
case _DiagnosticModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bikeId,  int healthScore,  List<FaultCodeModel> faultCodes,  String lastDiagnosticAt,  String maintenanceStatus)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosticModel() when $default != null:
return $default(_that.id,_that.bikeId,_that.healthScore,_that.faultCodes,_that.lastDiagnosticAt,_that.maintenanceStatus);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DiagnosticModel implements DiagnosticModel {
  const _DiagnosticModel({required this.id, required this.bikeId, required this.healthScore, required final  List<FaultCodeModel> faultCodes, required this.lastDiagnosticAt, required this.maintenanceStatus}): _faultCodes = faultCodes;
  factory _DiagnosticModel.fromJson(Map<String, dynamic> json) => _$DiagnosticModelFromJson(json);

@override final  String id;
@override final  String bikeId;
@override final  int healthScore;
 final  List<FaultCodeModel> _faultCodes;
@override List<FaultCodeModel> get faultCodes {
  if (_faultCodes is EqualUnmodifiableListView) return _faultCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faultCodes);
}

@override final  String lastDiagnosticAt;
@override final  String maintenanceStatus;

/// Create a copy of DiagnosticModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosticModelCopyWith<_DiagnosticModel> get copyWith => __$DiagnosticModelCopyWithImpl<_DiagnosticModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiagnosticModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosticModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bikeId, bikeId) || other.bikeId == bikeId)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore)&&const DeepCollectionEquality().equals(other._faultCodes, _faultCodes)&&(identical(other.lastDiagnosticAt, lastDiagnosticAt) || other.lastDiagnosticAt == lastDiagnosticAt)&&(identical(other.maintenanceStatus, maintenanceStatus) || other.maintenanceStatus == maintenanceStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bikeId,healthScore,const DeepCollectionEquality().hash(_faultCodes),lastDiagnosticAt,maintenanceStatus);

@override
String toString() {
  return 'DiagnosticModel(id: $id, bikeId: $bikeId, healthScore: $healthScore, faultCodes: $faultCodes, lastDiagnosticAt: $lastDiagnosticAt, maintenanceStatus: $maintenanceStatus)';
}


}

/// @nodoc
abstract mixin class _$DiagnosticModelCopyWith<$Res> implements $DiagnosticModelCopyWith<$Res> {
  factory _$DiagnosticModelCopyWith(_DiagnosticModel value, $Res Function(_DiagnosticModel) _then) = __$DiagnosticModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bikeId, int healthScore, List<FaultCodeModel> faultCodes, String lastDiagnosticAt, String maintenanceStatus
});




}
/// @nodoc
class __$DiagnosticModelCopyWithImpl<$Res>
    implements _$DiagnosticModelCopyWith<$Res> {
  __$DiagnosticModelCopyWithImpl(this._self, this._then);

  final _DiagnosticModel _self;
  final $Res Function(_DiagnosticModel) _then;

/// Create a copy of DiagnosticModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bikeId = null,Object? healthScore = null,Object? faultCodes = null,Object? lastDiagnosticAt = null,Object? maintenanceStatus = null,}) {
  return _then(_DiagnosticModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bikeId: null == bikeId ? _self.bikeId : bikeId // ignore: cast_nullable_to_non_nullable
as String,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as int,faultCodes: null == faultCodes ? _self._faultCodes : faultCodes // ignore: cast_nullable_to_non_nullable
as List<FaultCodeModel>,lastDiagnosticAt: null == lastDiagnosticAt ? _self.lastDiagnosticAt : lastDiagnosticAt // ignore: cast_nullable_to_non_nullable
as String,maintenanceStatus: null == maintenanceStatus ? _self.maintenanceStatus : maintenanceStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
