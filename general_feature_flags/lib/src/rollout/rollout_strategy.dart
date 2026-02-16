/// Interface for defining how a feature flag should be rolled out to users.
abstract class RolloutStrategy {
  /// Returns whether this strategy applies to the given [key].
  bool appliesTo(String key);
  
  /// Evaluates the strategy for the given [key] and [userId].
  ///
  /// Returns the resolved value or null if the strategy doesn't result in a value.
  T? evaluate<T>({
    required String key,
    String? userId,
    Map<String, dynamic>? attributes,
  });
}
