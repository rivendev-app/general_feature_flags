class OverrideStore {
  final Map<String, dynamic> _overrides = {};

  void setOverride(String key, dynamic value) {
    _overrides[key] = value;
  }

  T? getOverride<T>(String key) {
    final value = _overrides[key];
    if (value is T) return value;
    return null;
  }

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
