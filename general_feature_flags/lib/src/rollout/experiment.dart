import '../utils/hashing.dart';
import 'rollout_strategy.dart';

/// A strategy for A/B testing or experimentation.
///
/// Distributes users across multiple variations ([variants]) based on their [userId].
class Experiment<T> extends RolloutStrategy {
  /// Unique identifier for this experiment.
  final String experimentId;
  
  /// A map of variant values to their rollout percentage.
  final Map<T, double> variants; // Variant value to percentage
  
  /// The list of flag keys this experiment applies to.
  final List<String> keys;

  /// Creates an [Experiment].
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
