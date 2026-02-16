import 'rollout_strategy.dart';

/// A strategy that targets specific users based on their ID or attributes.
class UserTargeting extends RolloutStrategy {
  /// A map of attribute keys to lists of allowed values.
  final Map<String, List<dynamic>> targetingRules;
  
  /// The value to return if all rules match.
  final dynamic targetValue;

  /// Creates a [UserTargeting] strategy.
  UserTargeting({
    required this.targetingRules,
    required this.targetValue,
  });

  @override
  bool appliesTo(String key) => true;

  @override
  T? evaluate<T>({
    required String key,
    String? userId,
    Map<String, dynamic>? attributes,
  }) {
    if (userId == null && attributes == null) return null;

    bool allRulesMatch = true;

    targetingRules.forEach((attrKey, allowedValues) {
      final userValue = attrKey == 'userId' ? userId : attributes?[attrKey];
      if (!allowedValues.contains(userValue)) {
        allRulesMatch = false;
      }
    });

    if (allRulesMatch) {
      if (targetValue is T) return targetValue as T;
    }

    return null;
  }
}
