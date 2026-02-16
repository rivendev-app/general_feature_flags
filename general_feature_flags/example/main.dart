import 'package:flutter/material.dart';
import 'package:general_feature_flags/general_feature_flags.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flags = FeatureFlagsClient();

  // Initialize with a simple local provider
  await flags.initialize(
    providers: [
      LocalMapProvider({
        'new_feature': true,
        'header_color': '#FF5733',
        'items_count': 5,
      }),
    ],
    userId: 'user_123',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final flags = FeatureFlagsClient();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Feature Flags Example'),
          backgroundColor: Color(int.parse(
            flags.getString('header_color', defaultValue: '#2196F3').replaceAll('#', '0xFF'),
          )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (flags.isEnabled('new_feature'))
                const Text('New Feature is Enabled! ✅')
              else
                const Text('New Feature is Disabled. ❌'),
              const SizedBox(height: 20),
              Text('Items to show: ${flags.getInt('items_count', defaultValue: 0)}'),
            ],
          ),
        ),
      ),
    );
  }
}
