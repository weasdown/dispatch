import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'config/constants.dart';

class JsonResponse extends Response {
  JsonResponse.notFound(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super.notFound(
         json.encode(body),
         headers: headers?.addHeader(Constants.contentTypeJSON),
       );

  JsonResponse.ok(
    Object? body, {
    Map<String, /* String | List<String> */ Object>? headers,
    super.context,
  }) : super.ok(
         json.encode(body),
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
