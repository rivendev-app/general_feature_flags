# general_feature_flags_http

Generic HTTP JSON adapter for `general_feature_flags`.

## Usage

```dart
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_http/general_feature_flags_http.dart';

final flags = FeatureFlagsClient();

await flags.initialize(
  providers: [
    HttpProvider(
      url: "https://your-api.com/feature-flags",
      headers: {"Authorization": "Bearer ..."},
      pollingInterval: Duration(minutes: 5),
    ),
  ],
);
```
