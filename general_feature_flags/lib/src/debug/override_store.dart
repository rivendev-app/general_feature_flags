/// A store for local development overrides.
class OverrideStore {
  final Map<String, dynamic> _overrides = {};

  /// Sets a local override for a key.
  void setOverride(String key, dynamic value) {
    _overrides[key] = value;
  }

  /// Retrieves a local override for a key.
  T? getOverride<T>(String key) {
    final value = _overrides[key];
    if (value is T) return value;
    return null;
  }

  /// Removes a specific override.
  void removeOverride(String key) {
    _overrides.remove(key);
  }

  void clear() {
    _overrides.clear();
  }

  Map<String, dynamic> getAllOverrides() {
    return Map.unmodifiable(_overrides);
  }
}
