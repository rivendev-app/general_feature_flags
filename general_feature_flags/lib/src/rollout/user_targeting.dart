import 'rollout_strategy.dart';

class UserTargeting extends RolloutStrategy {
  final Map<String, List<dynamic>> targetingRules;
  final dynamic targetValue;

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
