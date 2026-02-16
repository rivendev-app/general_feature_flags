import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:general_feature_flags/general_feature_flags.dart';

class FirebaseRemoteConfigProvider extends BaseFeatureFlagProvider {
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigProvider({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  @override
  String get name => 'FirebaseRemoteConfig';

  @override
  Future<void> initialize({String? userId, Map<String, dynamic>? attributes}) async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    final value = _remoteConfig.getValue(key);
    
    if (value.source == ValueSource.valueStatic) return null;

    dynamic finalValue;
    if (T == bool) {
      finalValue = value.asBool();
    } else if (T == String) {
      finalValue = value.asString();
    } else if (T == int) {
      finalValue = value.asInt();
    } else if (T == double) {
      finalValue = value.asDouble();
    } else {
      finalValue = value.asString(); // Fallback to string for JSON etc.
    }

    return FeatureFlag<T>(
      key: key,
      value: finalValue as T,
      metadata: {'source': 'firebase', 'source_type': value.source.toString()},
    );
  }

  @override
  Future<Map<String, FeatureFlag>> getAllFlags() async {
    final params = _remoteConfig.getAll();
    final Map<String, FeatureFlag> flags = {};
    
    params.forEach((key, value) {
      flags[key] = FeatureFlag(
        key: key,
        value: value.asString(),
        metadata: {'source': 'firebase'},
      );
    });
    
    return flags;
  }

  @override
  Future<void> refresh() async {
    await _remoteConfig.fetchAndActivate();
  }
}
