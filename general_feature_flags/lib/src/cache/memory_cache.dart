import '../core/feature_flag.dart';
import '../core/feature_flag_store.dart';

/// A memory-based cache for feature flags with optional TTL.
class MemoryCache extends MemoryFeatureFlagStore {
  /// Time-to-live for cached flags.
  final Duration? ttl;
  final Map<String, DateTime> _timestamps = {};

  /// Creates a [MemoryCache] with an optional [ttl].
  MemoryCache({this.ttl});

  @override
  Future<void> saveFlag(FeatureFlag flag) async {
    await super.saveFlag(flag);
    _timestamps[flag.key] = DateTime.now();
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    if (ttl != null) {
      final timestamp = _timestamps[key];
      if (timestamp != null && DateTime.now().difference(timestamp) > ttl!) {
        await removeFlag(key);
        return null;
      }
    }
    return super.getFlag<T>(key);
  }

  @override
  Future<void> removeFlag(String key) async {
    await super.removeFlag(key);
    _timestamps.remove(key);
  }
}
