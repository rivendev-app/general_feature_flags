import '../rollout/rollout_strategy.dart';
import 'feature_flag_provider.dart';

abstract class FeatureFlagResolver {
  Future<T> resolve<T>({
    required String key,
    required T defaultValue,
    required List<FeatureFlagProvider> providers,
    String? userId,
    Map<String, dynamic>? attributes,
    List<RolloutStrategy>? strategies,
  });
}

class DefaultFeatureFlagResolver implements FeatureFlagResolver {
  @override
  Future<T> resolve<T>({
    required String key,
    required T defaultValue,
    required List<FeatureFlagProvider> providers,
    String? userId,
    Map<String, dynamic>? attributes,
    List<RolloutStrategy>? strategies,
  }) async {
    // 1. Check strategies
    if (strategies != null) {
      for (final strategy in strategies) {
        if (strategy.appliesTo(key)) {
          final rolloutValue = strategy.evaluate<T>(
            key: key,
            userId: userId,
            attributes: attributes,
          );
          if (rolloutValue != null) return rolloutValue;
        }
      }
    }

    // 2. Check providers in order
    for (final provider in providers) {
      final flag = await provider.getFlag<T>(key);
      if (flag != null) {
        return flag.value;
      }
    }

    return defaultValue;
  }
}
