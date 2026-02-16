import 'package:meta/meta.dart';

@immutable
class FeatureFlag<T> {
  final String key;
  final T value;
  final Map<String, dynamic>? metadata;

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
