import '../utils/hashing.dart';
import 'rollout_strategy.dart';

class Experiment<T> extends RolloutStrategy {
  final String experimentId;
  final Map<T, double> variants; // Variant value to percentage
  final List<String> keys;

  Experiment({
    required this.experimentId,
    required this.variants,
    required this.keys,
  }) : assert(variants.values.reduce((a, b) => a + b) <= 100);

  @override
  bool appliesTo(String key) => keys.contains(key);

  @override
  V? evaluate<V>({
    required String key,
    String? userId,
    Map<String, dynamic>? attributes,
  }) {
    if (userId == null) return null;

    final hash = FFHashing.hashString('$experimentId:$userId');
    final normalizedHash = hash % 100;

    double cumulative = 0;
    for (final entry in variants.entries) {
      cumulative += entry.value;
      if (normalizedHash < cumulative) {
        if (entry.key is V) return entry.key as V;
      }
    }

    return null;
  }
}
