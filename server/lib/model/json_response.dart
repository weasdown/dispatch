import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../config/constants.dart';

class JsonResponse extends Response {
  JsonResponse(
    super.statusCode, {
    super.body,
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super(headers: headers?.addHeader(Constants.contentTypeJSON));

  JsonResponse.badRequest(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super.badRequest(
         body: json.encode(body),
         headers: headers?.addHeader(Constants.contentTypeJSON),
       );

  JsonResponse.notFound(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super.notFound(
         json.encode(body),
         headers: headers?.addHeader(Constants.contentTypeJSON),
       );

  JsonResponse.notImplemented(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    Map<String, Object>? context,
  }) : this(
         HttpStatus.notImplemented,
         body: json.encode(body),
         headers: headers,
         context: context,
       );

  JsonResponse.ok(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super.ok(
         json.encode(body),
         headers: headers?.addHeader(Constants.contentTypeJSON),
       );

  JsonResponse.unauthorized(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super.unauthorized(
         body,
         headers: headers?.addHeader(Constants.contentTypeJSON),
       );
}

extension AddHeader on Map<String, /* String | List<String> */ Object> {
  Map<String, /* String | List<String> */ Object> addHeader(
    Map<String, /* String | List<String> */ Object> newHeader,
  ) {
    for (final entry in newHeader.entries) {
      final key = entry.key;
      if (containsKey(key)) {
        continue;
      }
      this[key] = entry.value;
    }
    return this;
  }
}
