// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTAccessToken _$JWTAccessTokenFromJson(Map<String, dynamic> json) =>
    JWTAccessToken(
      audience: json['aud'] as String,
      clientID: json['client_id'] as String,
      issuedAt: (json['iat'] as num).toInt(),
      issuer: json['iss'] as String,
      jwtID: json['jti'] as String,
      expirationTime: (json['exp'] as num).toInt(),
      scope: json['scope'] as String,
      sub: json['sub'] as String,
    );

Map<String, dynamic> _$JWTAccessTokenToJson(JWTAccessToken instance) =>
    <String, dynamic>{
      'aud': instance.audience,
      'client_id': instance.clientID,
      'iat': instance.issuedAt,
      'iss': instance.issuer,
      'jti': instance.jwtID,
      'exp': instance.expirationTime,
      'scope': instance.scope,
      'sub': instance.sub,
    };

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshToken: json['refresh_token'] as String?,
      scope: json['scope'] as String?,
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
  AccessTokenResponse instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'expires_in': instance.expiresIn,
  'refresh_token': ?instance.refreshToken,
  'scope': ?instance.scope,
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
