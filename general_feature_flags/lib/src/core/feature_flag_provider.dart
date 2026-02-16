import 'feature_flag.dart';

abstract class FeatureFlagProvider {
  String get name;

  Future<void> initialize({String? userId, Map<String, dynamic>? attributes});

  Future<FeatureFlag<T>?> getFlag<T>(String key);

  Future<Map<String, FeatureFlag>> getAllFlags();

  Stream<FeatureFlag> onFlagChanged(String key);

  Future<void> refresh();
}

abstract class BaseFeatureFlagProvider implements FeatureFlagProvider {
  @override
  Stream<FeatureFlag> onFlagChanged(String key) => const Stream.empty();

  @override
  Future<void> refresh() async {}
}
