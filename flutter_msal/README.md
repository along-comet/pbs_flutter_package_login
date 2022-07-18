# flutter_msal

A Flutter plugin that provides an interface for Microsoft Authentication Library (MSAL).

This plugin provides a common interface that communicates with the supported platforms'
implementation of MSAL library.

The aim of the library is the token acquisition from the Microsoft Identity platform,
it does not implement various supported features of the native libraries for now.

## Usage

Add `flutter_msal` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  flutter_msal:
    git: git@ssh.dev.azure.com:v3/shareitdoo/flutter_msal/flutter_msal
    path: flutter_msal
    ref: 0.0.3
```

Depending on the platforms you are targeting, see the coresponding sections for additional setup steps.
