import '../core/feature_flag_store.dart';

abstract class PersistentCache extends FeatureFlagStore {
  Future<bool> isExpired(String key);
}
