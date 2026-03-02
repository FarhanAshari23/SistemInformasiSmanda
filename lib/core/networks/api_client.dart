import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_exception.dart';
import 'api_response.dart';

class ApiClient {
  final String baseUrl;
  final String apiKey;

  ApiClient({
    required this.baseUrl,
    required this.apiKey,
  });

  Map<String, String> _headers({String? contentType}) {
    final headers = <String, String>{
      "Accept": "application/json",
      "x-api-key": apiKey,
    };

    if (contentType != null) {
      headers["Content-Type"] = contentType;
    }

    return headers;
  }

  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    String? contentType,
  }) async {
    return _request(
      method: "GET",
      endpoint: endpoint,
      contentType: contentType,
    );
  }

  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? contentType = "application/json",
  }) async {
    return _request(
      method: "POST",
      endpoint: endpoint,
      body: body,
      contentType: contentType,
    );
  }

  Future<ApiResponse<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? contentType = "application/json",
  }) async {
    return _request(
      method: "PUT",
      endpoint: endpoint,
      body: body,
      contentType: contentType,
    );
  }

  Future<ApiResponse<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    String? contentType = "application/json",
  }) async {
    return _request(
      method: "DELETE",
      endpoint: endpoint,
      body: body,
      contentType: contentType,
    );
  }

  Future<ApiResponse<dynamic>> _request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    String? contentType,
  }) async {
    final uri = Uri.parse("$baseUrl$endpoint");

    try {
      if (kDebugMode) {
        debugPrint("🌍 [$method] $uri");
        if (body != null) debugPrint("📦 Body: $body");
      }

      late http.Response response;

      switch (method) {
        case "GET":
          response =
              await http.get(uri, headers: _headers(contentType: contentType));
          break;
        case "POST":
          response = await http.post(
            uri,
            headers: _headers(contentType: contentType),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case "PUT":
          response = await http.put(
            uri,
            headers: _headers(contentType: contentType),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case "DELETE":
          response = await http.delete(
            uri,
            headers: _headers(contentType: contentType),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          throw ApiException(message: "Unsupported HTTP method");
      }

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  ApiResponse<dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    dynamic decodedBody;
    if (response.body.isNotEmpty) {
      decodedBody = jsonDecode(response.body);
    }

    if (kDebugMode) {
      debugPrint("📥 Response [$statusCode]: ${response.body}");
    }

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse(
        statusCode: statusCode,
        data: decodedBody,
      );
    } else {
      throw ApiException(
        statusCode: statusCode,
        message:
            decodedBody?["message"] ?? response.reasonPhrase ?? "Unknown error",
      );
    }
  }
}
