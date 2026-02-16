import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_launchdarkly/general_feature_flags_launchdarkly.dart';

void main() async {
  final flags = FeatureFlagsClient();

  await flags.initialize(
    providers: [
      LaunchDarklyProvider(mobileKey: 'YOUR_MOBILE_KEY'),
    ],
  );

  if (flags.isEnabled('new_feature')) {
    // ignore: avoid_print
    print('Feature enabled!');
  }
}
