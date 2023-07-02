import 'dart:convert';

import 'package:http/http.dart';
import 'package:knowby_api/src/models/models.dart';

class KnowbyApiClient {
  KnowbyApiClient(this.host);

  final String host;

  Future<Knowby> createKnowby(String name) async {
    final Response response;
    try {
      response = await post(
        Uri.parse('$host/knowbys'),
        body: jsonEncode({'name': name}),
      );
    } on Exception catch (e) {
      throw KnowbyNetworkRequestException(e);
    }
    final statusCode = response.statusCode;
    final body = response.body;
    try {
      return switch (statusCode) {
        200 => Knowby.fromJson(body.toJsonMap()),
        _ => throw KnowbyUnexpectedResponseException(statusCode, body),
      };
    } on Exception catch (e) {
      throw KnowbyParseResponseException(body, e);
    }
  }

  Future<List<Knowby>> getKnowbys() async {
    final Response response;
    try {
      response = await get(Uri.parse('$host/knowbys'));
    } on Exception catch (e) {
      throw KnowbyNetworkRequestException(e);
    }
    final statusCode = response.statusCode;
    final body = response.body;
    try {
      return switch (statusCode) {
        200 => body.toJsonList().map(Knowby.fromJson).toList(),
        _ => throw KnowbyUnexpectedResponseException(statusCode, body),
      };
    } on Exception catch (e) {
      throw KnowbyParseResponseException(body, e);
    }
  }

  Future<Knowby> getKnowby(String id) async {
    final Response response;
    try {
      response = await get(Uri.parse('$host/knowbys/$id'));
    } on Exception catch (e) {
      throw KnowbyNetworkRequestException(e);
    }
    final statusCode = response.statusCode;
    final body = response.body;
    try {
      return switch (statusCode) {
        200 => Knowby.fromJson(body.toJsonMap()),
        404 => throw KnowbyNotFoundException(body),
        _ => throw KnowbyUnexpectedResponseException(statusCode, body),
      };
    } on Exception catch (e) {
      throw KnowbyParseResponseException(body, e);
    }
  }

  Future<Knowby> updateKnowby(String id, {String? name}) async {
    final Response response;
    try {
      response = await patch(
        Uri.parse('$host/knowbys/$id'),
        body: jsonEncode({
          if (name != null) 'name': name,
        }),
      );
    } on Exception catch (e) {
      throw KnowbyNetworkRequestException(e);
    }
    final statusCode = response.statusCode;
    final body = response.body;
    try {
      return switch (statusCode) {
        200 => Knowby.fromJson(body.toJsonMap()),
        _ => throw KnowbyUnexpectedResponseException(statusCode, body),
      };
    } on Exception catch (e) {
      throw KnowbyParseResponseException(body, e);
    }
  }

  Future<Knowby> deleteKnowby(String id) async {
    final Response response;
    try {
      response = await delete(Uri.parse('$host/knowbys/$id'));
    } on Exception catch (e) {
      throw KnowbyNetworkRequestException(e);
    }
    final statusCode = response.statusCode;
    final body = response.body;
    try {
      return switch (statusCode) {
        200 => Knowby.fromJson(body.toJsonMap()),
        _ => throw KnowbyUnexpectedResponseException(statusCode, body),
      };
    } on Exception catch (e) {
      throw KnowbyParseResponseException(body, e);
    }
  }
}

abstract class KnowbyClientException implements Exception {
  KnowbyClientException(this.message);

  final String message;
}

class KnowbyNetworkRequestException extends KnowbyClientException {
  KnowbyNetworkRequestException(this.originalError)
      : super('Failed to make network request');

  final Exception originalError;
}

class KnowbyUnexpectedResponseException extends KnowbyClientException {
  KnowbyUnexpectedResponseException(this.statusCode, this.body)
      : super('Failed to receive expected status code');

  final int statusCode;
  final String body;
}

class KnowbyParseResponseException extends KnowbyClientException {
  KnowbyParseResponseException(this.body, this.originalError)
      : super('Failed to parse response');

  final String body;
  final Exception originalError;
}

class KnowbyNotFoundException extends KnowbyClientException {
  KnowbyNotFoundException(super.message);
}

extension StringToJson on String {
  Iterable<Map<String, dynamic>> toJsonList() =>
      (jsonDecode(this) as List<dynamic>).whereType<Map<String, dynamic>>();
  Map<String, dynamic> toJsonMap() => jsonDecode(this) as Map<String, dynamic>;
}
