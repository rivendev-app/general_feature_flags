import 'dart:convert';
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:http/http.dart' as http;

class RedisProvider extends BaseFeatureFlagProvider {
  final String url;
  final String? token;
  final Map<String, FeatureFlag> _cache = {};

  RedisProvider({required this.url, this.token});

  @override
  String get name => 'Redis';

  @override
  Future<void> initialize({String? userId, Map<String, dynamic>? attributes}) async {
    await refresh();
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    final flag = _cache[key];
    if (flag is FeatureFlag<T>) return flag;

    // Optional: Fetch individually if not in cache
    try {
      final response = await http.get(
        Uri.parse('$url/get/$key'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final value = data['result'];
        if (value == null) return null;

        final newFlag = FeatureFlag<T>(
          key: key,
          value: _parseValue<T>(value),
          metadata: {'source': 'redis'},
        );
        _cache[key] = newFlag;
        return newFlag;
      }
    } catch (e) {
      FFLogger.error('Redis fetch failed for $key: $e');
    }
    return null;
  }

  T _parseValue<T>(dynamic value) {
    if (value is T) return value;
    if (T == bool) {
      if (value is String) return (value.toLowerCase() == 'true') as T;
      if (value is num) return (value != 0) as T;
    }
    if (T == int && value is String) return int.parse(value) as T;
    if (T == double && value is String) return double.parse(value) as T;
    if (T == String) return value.toString() as T;
    
    // Attempt JSON decode for Map/List
    if (value is String && (T == Map || T == List)) {
      try {
        return jsonDecode(value) as T;
      } catch (_) {}
    }

    return value as T;
  }

  @override
  Future<Map<String, FeatureFlag>> getAllFlags() async {
    return _cache;
  }

  @override
  Future<void> refresh() async {
    // Note: Redis usually doesn't have a "get all" that is safe for prod without keys/scan.
    // This implementation assumes individual fetches or a pre-populated list.
    // For simplicity, we'll leave it as is.
  }
}
