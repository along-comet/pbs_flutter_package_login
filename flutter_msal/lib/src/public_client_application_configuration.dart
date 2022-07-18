/// A set of configuration options used to customize the behavior of MSAL
/// authentication flows.
class PublicClientApplicationConfiguration {
  /// Creates a new instance of the [PublicClientApplicationConfiguration].
  const PublicClientApplicationConfiguration({
    required final this.clientId,
    required final this.redirectUri,
    required final this.authority,
  });

  /// The unique application (client) ID assigned to your app by Azure AD when
  /// the app was registered.
  final String clientId;

  /// The  URI location the identity provider will redirect a user's client
  /// back to and send the security tokens after authentication.
  final String redirectUri;

  /// The URL that indicates a directory that MSAL can request tokens from.
  final String? authority;
}
