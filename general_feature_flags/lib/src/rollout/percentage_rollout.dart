import '../utils/hashing.dart';
import 'rollout_strategy.dart';

class PercentageRollout extends RolloutStrategy {
  final double percentage;
  final List<String>? keys;

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
