import 'feature_flag.dart';

/// Interface for feature flag providers (e.g., Firebase, LaunchDarkly, Redis).
abstract class FeatureFlagProvider {
  /// The unique name of the provider.
  String get name;

  /// Initializes the provider with user context.
  Future<void> initialize({String? userId, Map<String, dynamic>? attributes});

  /// Fetches a single feature flag by [key].
  Future<FeatureFlag<T>?> getFlag<T>(String key);

  /// Fetches all available feature flags from this provider.
  Future<Map<String, FeatureFlag>> getAllFlags();

  /// Returns a stream of changes for a specific flag.
  Stream<FeatureFlag> onFlagChanged(String key);

  /// Forces a refresh of the flag values from the remote source.
  Future<void> refresh();
}

/// A base implementation of [FeatureFlagProvider] that provides default empty behaviors.
abstract class BaseFeatureFlagProvider implements FeatureFlagProvider {
  @override
  Stream<FeatureFlag> onFlagChanged(String key) => const Stream.empty();

  @override
  Future<void> refresh() async {}
}
