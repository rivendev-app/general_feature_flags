import 'package:general_feature_flags/general_feature_flags.dart';
import 'package:general_feature_flags_redis/general_feature_flags_redis.dart';

void main() async {
  final flags = FeatureFlagsClient();

  await flags.initialize(
    providers: [
      RedisProvider(url: 'https://your-redis-url.com', token: 'YOUR_TOKEN'),
    ],
  );

  if (flags.isEnabled('new_feature')) {
    // ignore: avoid_print
    print('Feature enabled!');
  }
}
