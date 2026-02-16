import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_firebase/general_feature_flags_firebase.dart';

void main() async {
  final flags = FeatureFlagsClient();

  await flags.initialize(
    providers: [
      FirebaseRemoteConfigProvider(),
    ],
  );

  if (flags.isEnabled('new_feature')) {
    // ignore: avoid_print
    print('Feature enabled!');
  }
}
