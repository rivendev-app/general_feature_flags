abstract class RolloutStrategy {
  bool appliesTo(String key);
  
  T? evaluate<T>({
    required String key,
    String? userId,
    Map<String, dynamic>? attributes,
  });
}
