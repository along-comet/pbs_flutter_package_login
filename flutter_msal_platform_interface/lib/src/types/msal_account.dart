import 'package:json_annotation/json_annotation.dart';

part 'msal_account.g.dart';

/// An authenticated user account in the Microsoft identity platform.
@JsonSerializable(createToJson: false, anyMap: true, checked: false)
class MsalAccount {
  /// Creates an authenticated user account in the Microsoft identity platform.
  ///
  /// NOTE: [MsalAccount] should be never created directly by an application.
  const MsalAccount({
    required final this.homeAccountId,
  });

  /// Creates an authenticated user account in the Microsoft identity platform
  /// with values from the [json] object.
  factory MsalAccount.fromJson(final Map<String, dynamic> json) =>
      _$MsalAccountFromJson(json);

  // MARK: Getting information about account in different AAD tenants

  /// The unique identifier of the account in the home tenant.
  final MsalAccountId? homeAccountId;
}

/// An account identifier in the Azure Active Directory.
@JsonSerializable(createToJson: false, anyMap: true, checked: false)
class MsalAccountId {
  /// Creates an account identifier in the Azure Active Directory.
  const MsalAccountId({
    required final this.identifier,
    required final this.objectId,
    required final this.tenantId,
  });

  /// Creates an account identifier in the Azure Active Directory with values
  /// from the [json] object.
  factory MsalAccountId.fromJson(final Map<String, dynamic> json) =>
      _$MsalAccountIdFromJson(json);

  /// The unique account identifier.
  ///
  /// This is a **non-displayable** identifier and its format is not guaranteed.
  /// You should not make any assumptions about components or format of this
  /// identifier.
  final String identifier;

  /// The object identifier of the account in the tenant.
  ///
  /// This identifier uniquely identifies the user account across applications.
  final String? objectId;

  /// The identifier for the Azure Active Directory tenant that the account
  /// was acquired from.
  final String? tenantId;
}
