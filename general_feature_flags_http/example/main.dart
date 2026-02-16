import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_http/general_feature_flags_http.dart';

void main() async {
  final flags = FeatureFlagsClient();

  await flags.initialize(
    providers: [
      HttpProvider(url: 'https://your-api.com/flags'),
    ],
  );

  if (flags.isEnabled('new_feature')) {
    // ignore: avoid_print
    print('Feature enabled!');
  }
}
