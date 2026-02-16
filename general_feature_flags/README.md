# General Feature Flags

A robust, multi-provider feature flag system for Flutter. Professional, extensible, and corporate-ready.

## Overview

`general_feature_flags` is a highly modular feature flagging solution designed for large-scale Flutter applications. It supports multiple providers, rollout strategies, user targeting, and experiments.

## Motivation

Most feature flag solutions are tied to a single vendor (like Firebase Remote Config or LaunchDarkly). `general_feature_flags` provides a unified interface to use multiple providers simultaneously, with priority-based resolution and a clean 3-layer architecture.

## Architecture

1. **CORE**: The engine, logic, and interfaces (`general_feature_flags`).
2. **ADAPTERS**: Vendor-specific implementations (Firebase, LaunchDarkly, Redis, HTTP).
3. **EXTENSIONS**: Custom implementations for your specific needs.

## Comparison

| Feature | Firebase Remote Config | LaunchDarkly | general_feature_flags |
| --- | --- | --- | --- |
| Multi-provider | No | No | **Yes** |
| Fallback logic | Limited | Yes | **Advanced** |
| Offline-first | Yes | Yes | **Yes** |
| A/B Testing | Yes | Yes | **Yes** |
| Custom API | No | No | **Yes** |

## Quick Start

```dart
final flags = FeatureFlagsClient();

await flags.initialize(
  providers: [
    FirebaseRemoteConfigProvider(...),
    HttpProvider(url: "https://api.myapp.com/flags"),
  ],
  userId: "user_123",
);

if (flags.isEnabled("new_feature")) {
  // Show new feature
}
```

## Features

- **Multi Provider**: Merge flags from different sources.
- **Priority**: Define which provider takes precedence.
- **Rollout**: Percentage-based releases.
- **Targeting**: Target specific users based on attributes.
- **Experiments**: A/B testing support.
- **Cache**: Memory and persistent cache support.
- **Debug**: Override flags during development.

## Documentation

For detailed documentation, visit [rivendev.app](https://rivendev.app).

## Roadmap

- [ ] Supabase Adapter
- [ ] ConfigCat Adapter
- [ ] GraphQL Provider
- [ ] Admin Dashboard UI (Flutter)

## License

MIT - Rivendev.app
