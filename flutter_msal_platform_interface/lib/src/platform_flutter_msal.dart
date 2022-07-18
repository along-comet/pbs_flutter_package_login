import 'package:flutter_msal_platform_interface/flutter_msal_platform_interface.dart';
import 'package:flutter_msal_platform_interface/src/types/types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of `flutter_msal` must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `flutter_msal` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added [MsalPlatform]
/// methods.
abstract class MsalPlatform extends PlatformInterface {
  /// Constructs a [MsalPlatform].
  MsalPlatform() : super(token: _token);

  static final Object _token = Object();

  static MsalPlatform _instance = MethodChannelMsal();

  /// The default instance of [MsalPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [MsalPlatform] when they register
  /// themselves.
  ///
  /// Defaults to [MethodChannelMsal].
  static MsalPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MsalPlatform] when they register themselves.
  static set instance(final MsalPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the plugin with the application's unique configuration.
  /// You _must_ call this method before calling other methods.
  ///
  /// The [clientId] is the unique application (client) ID assigned to your app
  /// by Azure AD when the app was registered.
  ///
  /// The [redirectUri] is the URI location the identity provider will redirect
  /// a user's client back to and send the security tokens after authentication.
  ///
  /// The [authority] is a URL that indicates a directory that MSAL can request
  /// tokens from.
  ///
  /// The [clientSecret] is the application password that app can use in place
  /// of a certificate to identify itself.
  ///
  /// See:
  /// https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-client-application-configuration
  Future<void> init({
    required final String clientId,
    required final String redirectUri,
    final String? authority,
    final String? clientSecret,
  }) async {
    throw UnimplementedError(
      'init() has not been implemented for the current platform.',
    );
  }

  /// Signs in the user by presenting the interactive page to input credentials.
  ///
  /// The list of [scopes] are OAuth 2.0 scope codes that can be requested from
  /// the user. Learn more about permissions and consent in the Microsoft
  /// identity platform [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
  Future<MsalResult> signIn({
    required final List<String> scopes,
  }) async {
    throw UnimplementedError(
      'signIn() has not been implemented for the current platform.',
    );
  }

  /// Attempts to sign in user without user interaction, by reusing pre-existing
  /// credentials.
  ///
  /// The list of [scopes] are OAuth scope codes that can be requested from the
  /// user. Learn more about permissions and consent in the Microsoft identity
  /// platform [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
  Future<MsalResult> signInSilent({
    required final List<String> scopes,
  }) async {
    throw UnimplementedError(
      'signInSilent() has not been implemented for the current platform.',
    );
  }

  /// Signs out the current account from the application.
  Future<void> signOut() async {
    throw UnimplementedError(
      'signOut() has not been implemented for the current platform.',
    );
  }
}
