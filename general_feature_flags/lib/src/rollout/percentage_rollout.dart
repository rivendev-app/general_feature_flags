import '../utils/hashing.dart';
import 'rollout_strategy.dart';

/// A strategy that rolls out a feature to a specific percentage of users.
///
/// The rollout is sticky based on the [userId].
class PercentageRollout extends RolloutStrategy {
  /// The percentage of users that should see the feature (0.0 to 100.0).
  final double percentage;
  
  /// Optional list of specific flag keys this strategy applies to.
  final List<String>? keys;

  /// Creates a [PercentageRollout].
  PercentageRollout({
    required this.percentage,
    this.keys,
  }) : assert(percentage >= 0 && percentage <= 100);

  @override
  bool appliesTo(String key) {
    if (keys == null) return true;
    return keys!.contains(key);
  }

  @override
  T? evaluate<T>({
    required String key,
    String? userId,
    Map<String, dynamic>? attributes,
  }) {
    if (userId == null) return null;

    final hash = FFHashing.hashString('$key:$userId');
    final normalizedHash = hash % 100;

    if (normalizedHash < percentage) {
      // Typically used for booleans
      if (T == bool) return true as T;
    } else {
      if (T == bool) return false as T;
    }

    return null;
  }
}
