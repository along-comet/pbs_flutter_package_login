import 'package:flutter_msal/flutter_msal.dart';
import 'package:flutter_msal_platform_interface/flutter_msal_platform_interface.dart';

/// A class that provides access to MSAL public client applications.
class PublicClientApplication {
  /// Creates a new instance of [PublicClientApplication] with the specified
  /// [configuration].
  PublicClientApplication({
    required final this.configuration,
  }) {
    MsalPlatform.instance.init(
      clientId: configuration.clientId,
      redirectUri: configuration.redirectUri,
      authority: configuration.authority,
    );
  }

  /// The configuration of the application.
  final PublicClientApplicationConfiguration configuration;

  /// Signs in the user by presenting the interactive page to input credentials.
  ///
  /// The list of [scopes] are OAuth 2.0 scope codes that can be requested from
  /// the user. Learn more about permissions and consent in the Microsoft
  /// identity platform [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
  Future<MsalResult> signIn({required final List<String> scopes}) {
    return MsalPlatform.instance.signIn(scopes: scopes);
  }

  /// Attempts to sign in user without user interaction, by reusing pre-existing
  /// credentials.
  ///
  /// The list of [scopes] are OAuth 2.0 scope codes that can be requested from
  /// the user. Learn more about permissions and consent in the Microsoft
  /// identity platform [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
  Future<MsalResult> signInSilent({required final List<String> scopes}) {
    return MsalPlatform.instance.signInSilent(scopes: scopes);
  }

  /// Signs out the user and invalidates the current access token.
  Future<void> signOut() {
    return MsalPlatform.instance.signOut();
  }
}
