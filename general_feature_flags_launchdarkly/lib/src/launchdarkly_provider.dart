import 'dart:convert';
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:http/http.dart' as http;

class LaunchDarklyProvider extends BaseFeatureFlagProvider {
  final String mobileKey;
  final String? _userId;
  final Map<String, dynamic> _flags = {};

  LaunchDarklyProvider({required this.mobileKey, String? userId}) : _userId = userId;

  @override
  String get name => 'LaunchDarkly';

  @override
  Future<void> initialize({String? userId, Map<String, dynamic>? attributes}) async {
    await fetch();
  }

  Future<void> fetch() async {
    final userBase64 = base64Url.encode(utf8.encode(jsonEncode({'key': _userId ?? 'anonymous'})));
    final response = await http.get(
      Uri.parse('https://app.launchdarkly.com/msdk/evalx/users/$userBase64'),
      headers: {'Authorization': mobileKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _flags.clear();
      _flags.addAll(data);
    }
  }

  @override
  Future<FeatureFlag<T>?> getFlag<T>(String key) async {
    final flagData = _flags[key];
    if (flagData == null) return null;

    return FeatureFlag<T>(
      key: key,
      value: flagData['value'] as T,
      metadata: {'version': flagData['version'], 'variation': flagData['variation']},
    );
  }

  @override
  Future<Map<String, FeatureFlag>> getAllFlags() async {
    return _flags.map((key, value) => MapEntry(
          key,
          FeatureFlag(key: key, value: value['value']),
        ));
  }

  @override
  Future<void> refresh() => fetch();
}
