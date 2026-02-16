# general_feature_flags_firebase

Firebase Remote Config adapter for `general_feature_flags`.

## Usage

```dart
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_firebase/general_feature_flags_firebase.dart';

final flags = FeatureFlagsClient();

await flags.initialize(
  providers: [
    FirebaseRemoteConfigProvider(),
  ],
);
```
