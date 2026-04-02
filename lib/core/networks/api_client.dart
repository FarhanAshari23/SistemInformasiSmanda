import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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

  Future<ApiResponse<dynamic>> postMultipart(
    String endpoint, {
    required File file,
    String fieldName = 'image',
    Map<String, String>? fields,
  }) async {
    final uri = Uri.parse("$baseUrl$endpoint");

    try {
      if (kDebugMode) {
        debugPrint("🚀 [MULTIPART POST] $uri");
        debugPrint("📁 File: ${file.path}");
      }

      final request = http.MultipartRequest("POST", uri);

      request.headers.addAll(_headers());

      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          filename: basename(file.path),
        ),
      );

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw ApiException(message: "Timeout: Server tidak merespon.");
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
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

      const timeoutDuration = Duration(seconds: 15);

      switch (method) {
        case "GET":
          response = await http
              .get(uri, headers: _headers(contentType: contentType))
              .timeout(timeoutDuration);
          break;
        case "POST":
          response = await http
              .post(
                uri,
                headers: _headers(contentType: contentType),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case "PUT":
          response = await http
              .put(
                uri,
                headers: _headers(contentType: contentType),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case "DELETE":
          response = await http
              .delete(
                uri,
                headers: _headers(contentType: contentType),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        default:
          throw ApiException(message: "Unsupported HTTP method");
      }

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: "Tidak ada koneksi internet.");
    } on TimeoutException {
      throw ApiException(message: "Waktu koneksi habis. Silakan coba lagi.");
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
      String errorMessage = "Unknown error";

      if (decodedBody != null && decodedBody["data"] != null) {
        if (decodedBody["data"] is Map) {
          errorMessage =
              decodedBody["data"]["Message"] ?? response.reasonPhrase;
        } else {
          errorMessage = decodedBody["data"].toString();
        }
      }

      throw ApiException(
        statusCode: statusCode,
        message: errorMessage,
      );
    }
  }
}
