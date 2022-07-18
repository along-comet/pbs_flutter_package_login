import 'package:json_annotation/json_annotation.dart';

part 'msal_tenant_profile.g.dart';

/// A tenant profile that represents information about the account record in
/// a particular Azure Active Directory tenant.
@JsonSerializable(createToJson: false, anyMap: true)
class MsalTenantProfile {
  /// Creates a tenant profile that represents information about the account
  /// record in a particular Azure Active Directory tenant.
  const MsalTenantProfile({
    required final this.identifier,
    required final this.environment,
    required final this.tenantId,
    required final this.claims,
  });

  /// Creates a tenant profile that represents information about the account
  /// record in a particular Azure Active Directory tenant with values from the
  /// [json] object.
  factory MsalTenantProfile.fromJson(final Map<String, dynamic> json) =>
      _$MsalTenantProfileFromJson(json);

  // MARK: Getting account identifiers

  /// The unique identifier for the tenant profile.
  final String? identifier;

  /// The host part of the authority.
  final String? environment;

  /// The identifier for the directory where account is locally represented.
  final String? tenantId;

  // MARK: Reading id_token claims

  /// The id token claims for the account in the specified tenant.
  final Map<String, dynamic>? claims;
}
