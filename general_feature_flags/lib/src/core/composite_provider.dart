import 'feature_flag.dart';
import 'feature_flag_provider.dart';

class CompositeFeatureFlagProvider extends BaseFeatureFlagProvider {
  final List<FeatureFlagProvider> providers;
  final String _name;

  CompositeFeatureFlagProvider(this.providers, {String name = 'CompositeProvider'})
      : _name = name;

  @override
  String get name => _name;

  @override
  Future<void> initialize({String? userId, Map<String, dynamic>? attributes}) async {
    await Future.wait(providers.map((p) => p.initialize(userId: userId, attributes: attributes)));
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    for (final provider in providers) {
      final flag = await provider.getFlag<T>(key);
      if (flag != null) return flag;
    }
    return null;
  }

  @override
  Future<Map<String, FeatureFlag>> getAllFlags() async {
    final Map<String, FeatureFlag> allFlags = {};
    for (final provider in providers.reversed) {
      allFlags.addAll(await provider.getAllFlags());
    }
    return allFlags;
  }

  @override
  Future<void> refresh() async {
    await Future.wait(providers.map((p) => p.refresh()));
  }
}
