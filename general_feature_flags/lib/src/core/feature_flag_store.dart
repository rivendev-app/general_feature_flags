import 'feature_flag.dart';

abstract class FeatureFlagStore {
  Future<void> saveFlag(FeatureFlag flag);
  Future<FeatureFlag<T>?> getFlag<T>(String key);
  Future<void> removeFlag(String key);
  Future<void> clear();
  Future<Map<String, FeatureFlag>> getAllFlags();
}

class MemoryFeatureFlagStore implements FeatureFlagStore {
  final Map<String, FeatureFlag> _flags = {};

  @override
  Future<void> saveFlag(FeatureFlag flag) async {
    _flags[flag.key] = flag;
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    final flag = _flags[key];
    if (flag is FeatureFlag<T>) return flag;
    return null;
  }

  @override
  Future<void> removeFlag(String key) async {
    _flags.remove(key);
  }

  @override
  Future<void> clear() async {
    _flags.clear();
  }

  @override
  Future<Map<String, FeatureFlag>> getAllFlags() async {
    return Map.unmodifiable(_flags);
  }
}
