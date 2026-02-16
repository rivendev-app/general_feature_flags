import 'package:meta/meta.dart';

/// Represents a single feature flag value and its metadata.
@immutable
class FeatureFlag<T> {
  /// The unique identifier for the feature flag.
  final String key;
  
  /// The current value of the feature flag.
  final T value;
  
  /// Optional metadata associated with the flag (e.g., variation names).
  final Map<String, dynamic>? metadata;

  /// Creates a new [FeatureFlag].
  const FeatureFlag({
    required this.key,
    required this.value,
    this.metadata,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureFlag &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => key.hashCode ^ value.hashCode;

  @override
  String toString() => 'FeatureFlag(key: $key, value: $value)';
}
