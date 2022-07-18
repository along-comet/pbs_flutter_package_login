import 'package:flutter_msal_platform_interface/src/types/msal_account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'msal_result.g.dart';

/// A result of the token acquisition request.
@JsonSerializable(createToJson: false, anyMap: true, checked: false)
class MsalResult {
  /// Creates a result of the token acquisition request.
  const MsalResult({
    required final this.accessToken,
    required final this.expiresOn,
    required final this.scopes,
    required final this.idToken,
    required final this.tenantId,
    required final this.account,
    required final this.correlationId,
    required final this.authorizationHeader,
    required final this.authenticationScheme,
  });

  /// Creates a result of the token acquisition request with values from the
  /// [json] object.
  factory MsalResult.fromJson(final Map<String, dynamic> json) {
    // json['account'] = Map<String, dynamic>.from(json['account'] as Map);
    return _$MsalResultFromJson(json);
  }

  // MARK: Token response

  /// The access token requested.
  ///
  /// Returns an empty string if access token is not found in token response.
  final String accessToken;

  /// The time that [accessToken] stops being valid.
  ///
  /// This value is calculated based on the local UTC time at the time of
  /// receiving the response.
  final DateTime? expiresOn;

  /// The scope codes of the issued [accessToken].
  final List<String> scopes;

  /// The raw id token if returned by the service.
  final String? idToken;

  // MARK: Account information

  /// The identifier of tenant profile associated with this response.
  final String? tenantId;

  /// The user account associated with this response.
  final MsalAccount account;

  // MARK: Request information

  /// The unique identifier of the request.
  final String correlationId;

  /// The authorization header for the specific authentication scheme.
  final String authorizationHeader;

  /// The authentication scheme for the issued tokens.
  final String authenticationScheme;
}
