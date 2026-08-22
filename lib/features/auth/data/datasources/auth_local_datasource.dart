import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class IAuthLocalDataSource {
  Future<void> cacheRiderJson(Map<String, dynamic> json);
  Map<String, dynamic>? getCachedRiderJson();
  Future<void> clearRiderCache();
  Future<void> cachePortalSession(Map<String, dynamic> json);
  Map<String, dynamic>? getPortalSession();
  Future<void> clearPortalSession();
}

@LazySingleton(as: IAuthLocalDataSource)
class AuthLocalDataSource implements IAuthLocalDataSource {
  AuthLocalDataSource(@Named('riderBox') this._box);
  final Box _box;

  static const _key = 'cached_rider';
  static const _portalKey = 'portal_session';

  @override
  Future<void> cacheRiderJson(Map<String, dynamic> json) =>
      _box.put(_key, json);

  @override
  Map<String, dynamic>? getCachedRiderJson() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  @override
  Future<void> clearRiderCache() => _box.delete(_key);

  @override
  Future<void> cachePortalSession(Map<String, dynamic> json) =>
      _box.put(_portalKey, json);

  @override
  Map<String, dynamic>? getPortalSession() {
    final raw = _box.get(_portalKey);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  @override
  Future<void> clearPortalSession() => _box.delete(_portalKey);
}
