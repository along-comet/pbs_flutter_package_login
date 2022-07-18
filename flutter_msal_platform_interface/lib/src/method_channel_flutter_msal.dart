import 'package:flutter/services.dart';
import 'package:flutter_msal_platform_interface/flutter_msal_platform_interface.dart';
import 'package:flutter_msal_platform_interface/src/types/types.dart';
import 'package:meta/meta.dart';

/// An implementation of [MsalPlatform]  that uses a `MethodChannel` to
/// communicate with the native code.
///
/// The `flutter_msal` plugin code itself never talks to the native code
/// directly. It delegates all calls to an instance of a class that extends the
/// [MsalPlatform].
///
/// The architecture above allows for platforms that communicate differently
/// with the native side (like web) to have a common interface to extend.
///
/// This is the instance that runs when the native side talks
/// to your Flutter app through MethodChannels (Android and iOS platforms).
class MethodChannelMsal extends MsalPlatform {
  /// The method channel used to interact with the native platform.
  ///
  /// This is only exposed for test purposes. It shouldn't be used
  /// by clients of the plugin as it may break or change at any time.
  @visibleForTesting
  MethodChannel channel = const MethodChannel(
    'com.shareitsolutions.flutter_msal',
  );

  @override
  Future<void> init({
    required final String clientId,
    required final String redirectUri,
    final String? authority,
    final String? clientSecret,
  }) {
    return channel.invokeMethod<void>('initialize', <String, dynamic>{
      'clientId': clientId,
      'redirectUri': redirectUri,
      'authority': authority,
      'clientSecret': clientSecret,
    });
  }

  @override
  Future<MsalResult> signIn({required final List<String> scopes}) async {
    final data = await channel.invokeMapMethod<String, dynamic>(
      'signIn',
      <String, dynamic>{'scopes': scopes},
    );

    assert(data != null, 'Method signIn() completed with empty data.');

    return MsalResult.fromJson(data!);
  }

  @override
  Future<MsalResult> signInSilent({required final List<String> scopes}) async {
    final data = await channel.invokeMapMethod<String, dynamic>(
      'signInSilent',
      <String, dynamic>{'scopes': scopes},
    );

    assert(data != null, 'Method signInSilent() completed with empty data.');

    return MsalResult.fromJson(data!);
  }

  @override
  Future<void> signOut() {
    return channel.invokeMethod('signOut');
  }
}
