// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msal_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsalAccount _$MsalAccountFromJson(Map json) => MsalAccount(
      homeAccountId: json['homeAccountId'] == null
          ? null
          : MsalAccountId.fromJson(
              Map<String, dynamic>.from(json['homeAccountId'] as Map)),
    );

MsalAccountId _$MsalAccountIdFromJson(Map json) => MsalAccountId(
      identifier: json['identifier'] as String,
      objectId: json['objectId'] as String?,
      tenantId: json['tenantId'] as String?,
    );
