# general_feature_flags_launchdarkly

LaunchDarkly adapter for `general_feature_flags`.

## Usage

```dart
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_launchdarkly/general_feature_flags_launchdarkly.dart';

final flags = FeatureFlagsClient();

await flags.initialize(
  providers: [
    LaunchDarklyProvider(mobileKey: "YOUR_MOBILE_KEY"),
  ],
);
```
