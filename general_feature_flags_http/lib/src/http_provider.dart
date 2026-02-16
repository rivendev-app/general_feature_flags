import 'dart:async';
import 'dart:convert';
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:http/http.dart' as http;

/// A feature flag provider that fetches flags from a generic JSON HTTP endpoint.
class HttpProvider extends BaseFeatureFlagProvider {
  final String url;
  final Map<String, String>? headers;
  final Map<String, FeatureFlag> _flags = {};
  final Duration? pollingInterval;
  Timer? _timer;

  /// Creates an [HttpProvider].
  ///
  /// [url] is the endpoint that returns a JSON map of flags.
  /// [headers] are optional HTTP headers for the request.
  /// [pollingInterval] enables automatic background refreshing.
  HttpProvider({
    required this.url,
    this.headers,
    this.pollingInterval,
  });

  @override
  String get name => 'HTTP';

  @override
  Future<void> initialize({String? userId, Map<String, dynamic>? attributes}) async {
    await refresh();
    if (pollingInterval != null) {
      _timer = Timer.periodic(pollingInterval!, (_) => refresh());
    }
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    final flag = _flags[key];
    if (flag is FeatureFlag<T>) return flag;
    return null;
  }

  @override
  Future<Map<String, FeatureFlag>> getAllFlags() async {
    return _flags;
  }

  @override
  Future<void> refresh() async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _flags.clear();
        data.forEach((key, value) {
          _flags[key] = FeatureFlag(
            key: key,
            value: value,
            metadata: {'source': 'http'},
          );
        });
        FFLogger.info('HTTP flags refreshed from $url');
      }
    } catch (e) {
      FFLogger.error('HTTP refresh failed: $e');
    }
  }

  /// Stops the polling timer.
  void dispose() {
    _timer?.cancel();
  }
}
