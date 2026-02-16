# general_feature_flags_redis

Redis adapter for `general_feature_flags` using REST API (e.g., Upstash).

## Usage

```dart
import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_redis/general_feature_flags_redis.dart';

final flags = FeatureFlagsClient();

await flags.initialize(
  providers: [
    RedisProvider(url: "https://your-redis-rest-url.com", token: "YOUR_TOKEN"),
  ],
);
```
