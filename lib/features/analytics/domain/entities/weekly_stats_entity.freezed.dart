// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeeklyStatsEntity {

 double get totalDistanceKm; double get totalEnergyKwh; double get avgSpeedKmh; double get maxSpeedKmh; int get totalRides; Duration get totalRideTime; List<DailyDistanceStat> get dailyDistance;
/// Create a copy of WeeklyStatsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyStatsEntityCopyWith<WeeklyStatsEntity> get copyWith => _$WeeklyStatsEntityCopyWithImpl<WeeklyStatsEntity>(this as WeeklyStatsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyStatsEntity&&(identical(other.totalDistanceKm, totalDistanceKm) || other.totalDistanceKm == totalDistanceKm)&&(identical(other.totalEnergyKwh, totalEnergyKwh) || other.totalEnergyKwh == totalEnergyKwh)&&(identical(other.avgSpeedKmh, avgSpeedKmh) || other.avgSpeedKmh == avgSpeedKmh)&&(identical(other.maxSpeedKmh, maxSpeedKmh) || other.maxSpeedKmh == maxSpeedKmh)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.totalRideTime, totalRideTime) || other.totalRideTime == totalRideTime)&&const DeepCollectionEquality().equals(other.dailyDistance, dailyDistance));
}


@override
int get hashCode => Object.hash(runtimeType,totalDistanceKm,totalEnergyKwh,avgSpeedKmh,maxSpeedKmh,totalRides,totalRideTime,const DeepCollectionEquality().hash(dailyDistance));

@override
String toString() {
  return 'WeeklyStatsEntity(totalDistanceKm: $totalDistanceKm, totalEnergyKwh: $totalEnergyKwh, avgSpeedKmh: $avgSpeedKmh, maxSpeedKmh: $maxSpeedKmh, totalRides: $totalRides, totalRideTime: $totalRideTime, dailyDistance: $dailyDistance)';
}


}

/// @nodoc
abstract mixin class $WeeklyStatsEntityCopyWith<$Res>  {
  factory $WeeklyStatsEntityCopyWith(WeeklyStatsEntity value, $Res Function(WeeklyStatsEntity) _then) = _$WeeklyStatsEntityCopyWithImpl;
@useResult
$Res call({
 double totalDistanceKm, double totalEnergyKwh, double avgSpeedKmh, double maxSpeedKmh, int totalRides, Duration totalRideTime, List<DailyDistanceStat> dailyDistance
});




}
/// @nodoc
class _$WeeklyStatsEntityCopyWithImpl<$Res>
    implements $WeeklyStatsEntityCopyWith<$Res> {
  _$WeeklyStatsEntityCopyWithImpl(this._self, this._then);

  final WeeklyStatsEntity _self;
  final $Res Function(WeeklyStatsEntity) _then;

/// Create a copy of WeeklyStatsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalDistanceKm = null,Object? totalEnergyKwh = null,Object? avgSpeedKmh = null,Object? maxSpeedKmh = null,Object? totalRides = null,Object? totalRideTime = null,Object? dailyDistance = null,}) {
  return _then(_self.copyWith(
totalDistanceKm: null == totalDistanceKm ? _self.totalDistanceKm : totalDistanceKm // ignore: cast_nullable_to_non_nullable
as double,totalEnergyKwh: null == totalEnergyKwh ? _self.totalEnergyKwh : totalEnergyKwh // ignore: cast_nullable_to_non_nullable
as double,avgSpeedKmh: null == avgSpeedKmh ? _self.avgSpeedKmh : avgSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,maxSpeedKmh: null == maxSpeedKmh ? _self.maxSpeedKmh : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as int,totalRideTime: null == totalRideTime ? _self.totalRideTime : totalRideTime // ignore: cast_nullable_to_non_nullable
as Duration,dailyDistance: null == dailyDistance ? _self.dailyDistance : dailyDistance // ignore: cast_nullable_to_non_nullable
as List<DailyDistanceStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyStatsEntity].
extension WeeklyStatsEntityPatterns on WeeklyStatsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyStatsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyStatsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyStatsEntity value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyStatsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyStatsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyStatsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalDistanceKm,  double totalEnergyKwh,  double avgSpeedKmh,  double maxSpeedKmh,  int totalRides,  Duration totalRideTime,  List<DailyDistanceStat> dailyDistance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyStatsEntity() when $default != null:
return $default(_that.totalDistanceKm,_that.totalEnergyKwh,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.totalRides,_that.totalRideTime,_that.dailyDistance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalDistanceKm,  double totalEnergyKwh,  double avgSpeedKmh,  double maxSpeedKmh,  int totalRides,  Duration totalRideTime,  List<DailyDistanceStat> dailyDistance)  $default,) {final _that = this;
switch (_that) {
case _WeeklyStatsEntity():
return $default(_that.totalDistanceKm,_that.totalEnergyKwh,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.totalRides,_that.totalRideTime,_that.dailyDistance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalDistanceKm,  double totalEnergyKwh,  double avgSpeedKmh,  double maxSpeedKmh,  int totalRides,  Duration totalRideTime,  List<DailyDistanceStat> dailyDistance)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyStatsEntity() when $default != null:
return $default(_that.totalDistanceKm,_that.totalEnergyKwh,_that.avgSpeedKmh,_that.maxSpeedKmh,_that.totalRides,_that.totalRideTime,_that.dailyDistance);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyStatsEntity implements WeeklyStatsEntity {
  const _WeeklyStatsEntity({required this.totalDistanceKm, required this.totalEnergyKwh, required this.avgSpeedKmh, required this.maxSpeedKmh, required this.totalRides, required this.totalRideTime, required final  List<DailyDistanceStat> dailyDistance}): _dailyDistance = dailyDistance;
  

@override final  double totalDistanceKm;
@override final  double totalEnergyKwh;
@override final  double avgSpeedKmh;
@override final  double maxSpeedKmh;
@override final  int totalRides;
@override final  Duration totalRideTime;
 final  List<DailyDistanceStat> _dailyDistance;
@override List<DailyDistanceStat> get dailyDistance {
  if (_dailyDistance is EqualUnmodifiableListView) return _dailyDistance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyDistance);
}


/// Create a copy of WeeklyStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyStatsEntityCopyWith<_WeeklyStatsEntity> get copyWith => __$WeeklyStatsEntityCopyWithImpl<_WeeklyStatsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyStatsEntity&&(identical(other.totalDistanceKm, totalDistanceKm) || other.totalDistanceKm == totalDistanceKm)&&(identical(other.totalEnergyKwh, totalEnergyKwh) || other.totalEnergyKwh == totalEnergyKwh)&&(identical(other.avgSpeedKmh, avgSpeedKmh) || other.avgSpeedKmh == avgSpeedKmh)&&(identical(other.maxSpeedKmh, maxSpeedKmh) || other.maxSpeedKmh == maxSpeedKmh)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.totalRideTime, totalRideTime) || other.totalRideTime == totalRideTime)&&const DeepCollectionEquality().equals(other._dailyDistance, _dailyDistance));
}


@override
int get hashCode => Object.hash(runtimeType,totalDistanceKm,totalEnergyKwh,avgSpeedKmh,maxSpeedKmh,totalRides,totalRideTime,const DeepCollectionEquality().hash(_dailyDistance));

@override
String toString() {
  return 'WeeklyStatsEntity(totalDistanceKm: $totalDistanceKm, totalEnergyKwh: $totalEnergyKwh, avgSpeedKmh: $avgSpeedKmh, maxSpeedKmh: $maxSpeedKmh, totalRides: $totalRides, totalRideTime: $totalRideTime, dailyDistance: $dailyDistance)';
}


}

/// @nodoc
abstract mixin class _$WeeklyStatsEntityCopyWith<$Res> implements $WeeklyStatsEntityCopyWith<$Res> {
  factory _$WeeklyStatsEntityCopyWith(_WeeklyStatsEntity value, $Res Function(_WeeklyStatsEntity) _then) = __$WeeklyStatsEntityCopyWithImpl;
@override @useResult
$Res call({
 double totalDistanceKm, double totalEnergyKwh, double avgSpeedKmh, double maxSpeedKmh, int totalRides, Duration totalRideTime, List<DailyDistanceStat> dailyDistance
});




}
/// @nodoc
class __$WeeklyStatsEntityCopyWithImpl<$Res>
    implements _$WeeklyStatsEntityCopyWith<$Res> {
  __$WeeklyStatsEntityCopyWithImpl(this._self, this._then);

  final _WeeklyStatsEntity _self;
  final $Res Function(_WeeklyStatsEntity) _then;

/// Create a copy of WeeklyStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalDistanceKm = null,Object? totalEnergyKwh = null,Object? avgSpeedKmh = null,Object? maxSpeedKmh = null,Object? totalRides = null,Object? totalRideTime = null,Object? dailyDistance = null,}) {
  return _then(_WeeklyStatsEntity(
totalDistanceKm: null == totalDistanceKm ? _self.totalDistanceKm : totalDistanceKm // ignore: cast_nullable_to_non_nullable
as double,totalEnergyKwh: null == totalEnergyKwh ? _self.totalEnergyKwh : totalEnergyKwh // ignore: cast_nullable_to_non_nullable
as double,avgSpeedKmh: null == avgSpeedKmh ? _self.avgSpeedKmh : avgSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,maxSpeedKmh: null == maxSpeedKmh ? _self.maxSpeedKmh : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
as double,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as int,totalRideTime: null == totalRideTime ? _self.totalRideTime : totalRideTime // ignore: cast_nullable_to_non_nullable
as Duration,dailyDistance: null == dailyDistance ? _self._dailyDistance : dailyDistance // ignore: cast_nullable_to_non_nullable
as List<DailyDistanceStat>,
  ));
}


}

/// @nodoc
mixin _$DailyDistanceStat {

 DateTime get date; double get distanceKm; double get energyKwh;
/// Create a copy of DailyDistanceStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyDistanceStatCopyWith<DailyDistanceStat> get copyWith => _$DailyDistanceStatCopyWithImpl<DailyDistanceStat>(this as DailyDistanceStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyDistanceStat&&(identical(other.date, date) || other.date == date)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.energyKwh, energyKwh) || other.energyKwh == energyKwh));
}


@override
int get hashCode => Object.hash(runtimeType,date,distanceKm,energyKwh);

@override
String toString() {
  return 'DailyDistanceStat(date: $date, distanceKm: $distanceKm, energyKwh: $energyKwh)';
}


}

/// @nodoc
abstract mixin class $DailyDistanceStatCopyWith<$Res>  {
  factory $DailyDistanceStatCopyWith(DailyDistanceStat value, $Res Function(DailyDistanceStat) _then) = _$DailyDistanceStatCopyWithImpl;
@useResult
$Res call({
 DateTime date, double distanceKm, double energyKwh
});




}
/// @nodoc
class _$DailyDistanceStatCopyWithImpl<$Res>
    implements $DailyDistanceStatCopyWith<$Res> {
  _$DailyDistanceStatCopyWithImpl(this._self, this._then);

  final DailyDistanceStat _self;
  final $Res Function(DailyDistanceStat) _then;

/// Create a copy of DailyDistanceStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? distanceKm = null,Object? energyKwh = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,energyKwh: null == energyKwh ? _self.energyKwh : energyKwh // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyDistanceStat].
extension DailyDistanceStatPatterns on DailyDistanceStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyDistanceStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyDistanceStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyDistanceStat value)  $default,){
final _that = this;
switch (_that) {
case _DailyDistanceStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyDistanceStat value)?  $default,){
final _that = this;
switch (_that) {
case _DailyDistanceStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double distanceKm,  double energyKwh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyDistanceStat() when $default != null:
return $default(_that.date,_that.distanceKm,_that.energyKwh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double distanceKm,  double energyKwh)  $default,) {final _that = this;
switch (_that) {
case _DailyDistanceStat():
return $default(_that.date,_that.distanceKm,_that.energyKwh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double distanceKm,  double energyKwh)?  $default,) {final _that = this;
switch (_that) {
case _DailyDistanceStat() when $default != null:
return $default(_that.date,_that.distanceKm,_that.energyKwh);case _:
  return null;

}
}

}

/// @nodoc


class _DailyDistanceStat implements DailyDistanceStat {
  const _DailyDistanceStat({required this.date, required this.distanceKm, required this.energyKwh});
  

@override final  DateTime date;
@override final  double distanceKm;
@override final  double energyKwh;

/// Create a copy of DailyDistanceStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyDistanceStatCopyWith<_DailyDistanceStat> get copyWith => __$DailyDistanceStatCopyWithImpl<_DailyDistanceStat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyDistanceStat&&(identical(other.date, date) || other.date == date)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.energyKwh, energyKwh) || other.energyKwh == energyKwh));
}


@override
int get hashCode => Object.hash(runtimeType,date,distanceKm,energyKwh);

@override
String toString() {
  return 'DailyDistanceStat(date: $date, distanceKm: $distanceKm, energyKwh: $energyKwh)';
}


}

/// @nodoc
abstract mixin class _$DailyDistanceStatCopyWith<$Res> implements $DailyDistanceStatCopyWith<$Res> {
  factory _$DailyDistanceStatCopyWith(_DailyDistanceStat value, $Res Function(_DailyDistanceStat) _then) = __$DailyDistanceStatCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double distanceKm, double energyKwh
});




}
/// @nodoc
class __$DailyDistanceStatCopyWithImpl<$Res>
    implements _$DailyDistanceStatCopyWith<$Res> {
  __$DailyDistanceStatCopyWithImpl(this._self, this._then);

  final _DailyDistanceStat _self;
  final $Res Function(_DailyDistanceStat) _then;

/// Create a copy of DailyDistanceStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? distanceKm = null,Object? energyKwh = null,}) {
  return _then(_DailyDistanceStat(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,energyKwh: null == energyKwh ? _self.energyKwh : energyKwh // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
