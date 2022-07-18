// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msal_tenant_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsalTenantProfile _$MsalTenantProfileFromJson(Map json) => MsalTenantProfile(
      identifier: json['identifier'] as String?,
      environment: json['environment'] as String?,
      tenantId: json['tenantId'] as String?,
      claims: (json['claims'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e),
      ),
    );
