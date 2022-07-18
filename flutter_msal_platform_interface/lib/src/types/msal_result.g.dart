// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msal_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsalResult _$MsalResultFromJson(Map json) => MsalResult(
      accessToken: json['accessToken'] as String,
      expiresOn: json['expiresOn'] == null
          ? null
          : DateTime.parse(json['expiresOn'] as String),
      scopes:
          (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
      idToken: json['idToken'] as String?,
      tenantId: json['tenantId'] as String?,
      account: MsalAccount.fromJson(
          Map<String, dynamic>.from(json['account'] as Map)),
      correlationId: json['correlationId'] as String,
      authorizationHeader: json['authorizationHeader'] as String,
      authenticationScheme: json['authenticationScheme'] as String,
    );
