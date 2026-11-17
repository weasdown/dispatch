// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      refreshToken: json['refresh_token'] as String?,
      scope: json['scope'] as String?,
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
  AccessTokenResponse instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'expires_in': instance.expiresIn,
  'refresh_token': instance.refreshToken,
  'scope': instance.scope,
  'token_type': instance.tokenType,
};

AuthErrorResponse _$AuthErrorResponseFromJson(Map<String, dynamic> json) =>
    AuthErrorResponse(
      statusCode:
          (json['status_code'] as num?)?.toInt() ?? HttpStatus.badRequest,
      error: ErrorParameter.fromJson(json['error'] as String),
      errorDescription: json['error_description'] as String?,
      errorUri: json['error_uri'] as String?,
    );

Map<String, dynamic> _$AuthErrorResponseToJson(AuthErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_description': instance.errorDescription,
      'error_uri': instance.errorUri,
      'status_code': instance.statusCode,
    };
