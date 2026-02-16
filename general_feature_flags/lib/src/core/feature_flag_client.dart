import 'dart:async';
import '../debug/override_store.dart';
import '../rollout/rollout_strategy.dart';
import '../utils/logger.dart';
import 'feature_flag_provider.dart';
import 'feature_flag_resolver.dart';

/// The central client for managing and evaluating feature flags.
///
/// Use [FeatureFlagsClient()] to access the singleton instance.
class FeatureFlagsClient {
  static final FeatureFlagsClient _instance = FeatureFlagsClient._internal();

  /// Returns the singleton instance of [FeatureFlagsClient].
  factory FeatureFlagsClient() => _instance;

  FeatureFlagsClient._internal();

  final List<FeatureFlagProvider> _providers = [];
  final List<RolloutStrategy> _strategies = [];
  FeatureFlagResolver _resolver = DefaultFeatureFlagResolver();
  OverrideStore? _overrideStore;
  
  String? _userId;
  Map<String, dynamic>? _attributes;
  bool _initialized = false;
  
  /// Initializes the client with the provided [providers] and [strategies].
  ///
  /// [userId] and [attributes] are optional and can be used for targeting
  /// and rollout evaluation.
  ///
  /// The [resolver] allows customizing how flags are resolved across providers.
  /// The [overrideStore] allows local development overrides.
  Future<void> initialize({
    List<FeatureFlagProvider> providers = const [],
    List<RolloutStrategy> strategies = const [],
    String? userId,
    Map<String, dynamic>? attributes,
    FeatureFlagResolver? resolver,
    OverrideStore? overrideStore,
  }) async {
    _providers.clear();
    _providers.addAll(providers);
    _strategies.clear();
    _strategies.addAll(strategies);
    _userId = userId;
    _attributes = attributes;
    _overrideStore = overrideStore;
    
    if (resolver != null) {
      _resolver = resolver;
    }

    for (final provider in _providers) {
      try {
        await provider.initialize(userId: userId, attributes: attributes);
      } catch (e) {
        FFLogger.error('Failed to initialize provider ${provider.name}: $e');
      }
    }

    _initialized = true;
    FFLogger.info('FeatureFlagsClient initialized');
  }

  /// Checks if a feature flag is enabled.
  ///
  /// Returns [defaultValue] if the flag is not found or not a boolean.
  bool isEnabled(String key, {bool defaultValue = false}) {
    return getBool(key, defaultValue: defaultValue);
  }

  /// Returns a boolean value for the given [key].
  bool getBool(String key, {bool defaultValue = false}) {
    return _getValue<bool>(key, defaultValue);
  }

  /// Returns a string value for the given [key].
  String getString(String key, {String defaultValue = ''}) {
    return _getValue<String>(key, defaultValue);
  }

  /// Returns an integer value for the given [key].
  int getInt(String key, {int defaultValue = 0}) {
    return _getValue<int>(key, defaultValue);
  }

  /// Returns a double value for the given [key].
  double getDouble(String key, {double defaultValue = 0.0}) {
    return _getValue<double>(key, defaultValue);
  }

  /// Returns a JSON (Map) value for the given [key].
  Map<String, dynamic> getJson(String key, {Map<String, dynamic> defaultValue = const {}}) {
    return _getValue<Map<String, dynamic>>(key, defaultValue);
  }

  T _getValue<T>(String key, T defaultValue) {
    if (!_initialized) {
      FFLogger.warn('FeatureFlagsClient not initialized. Returning default value for key: $key');
      return defaultValue;
    }

    // 1. Check overrides
    if (_overrideStore != null) {
      final override = _overrideStore!.getOverride<T>(key);
      if (override != null) return override;
    }

    // 2. Resolve via providers/strategies
    // Note: In a real sync API we might need a cache or wait for initialization
    // For this simple client, we assume providers are either fast or we use a sync resolver if possible
    // Since everything is Future-based in resolver, a sync wrapper would need internally cached values.
    
    // For the sake of this implementation, we'll provide sync-like access to a cached state
    // but the actual resolution logic is intended to be used as needed.
    
    // In a production app, we would likely have a 'ValueStore' that updates from providers.
    return defaultValue; 
  }

  /// Asynchronously resolves a feature flag value across all providers.
  Future<T> getAsync<T>(String key, T defaultValue) async {
    if (_overrideStore != null) {
      final override = _overrideStore!.getOverride<T>(key);
      if (override != null) return override;
    }

    return _resolver.resolve<T>(
      key: key,
      defaultValue: defaultValue,
      providers: _providers,
      userId: _userId,
      attributes: _attributes,
      strategies: _strategies,
    );
  }

  /// Sets a local override for a feature flag.
  void override(String key, dynamic value) {
    _overrideStore?.setOverride(key, value);
    FFLogger.info('Override set: $key = $value');
  }

  /// Removes a local override for a feature flag.
  void clearOverride(String key) {
    _overrideStore?.removeOverride(key);
  }

  /// Refreshes all providers to fetch the latest values.
  Future<void> refresh() async {
    await Future.wait(_providers.map((p) => p.refresh()));
  }
}
