# flutter_msal_platform_interface

A common platform interface for the [`flutter_msal`][1] plugin.

This interface allows platform-specific implementations of the `flutter_msal` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

## Usage

To implement a new platform-specific implementation of `flutter_msal`, extend [`MsalPlatform`][2] with an implementation that performs the platform-specific behavior, and when you register your plugin, set the default `MsalPlatform` by calling `MsalPlatform.instance = MyPlatformMsal()`.

## Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See [here][breaking_changes_discussion_link] for a discussion on why a less-clean interface is preferable to a breaking change.

[1]: ../flutter_msal
[2]: lib/flutter_msal_platform_interface.dart
[breaking_changes_discussion_link]: https://flutter.dev/go/platform-interface-breaking-changes
