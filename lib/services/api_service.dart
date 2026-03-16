import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'token_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

/// Base URL for the Django backend.
/// Use 10.0.2.2 for Android emulator, or change for physical device / staging.
const String kBaseUrl = 'http://10.0.2.2:8000/api';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  final _tokenService = TokenService();

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await _tokenService.readAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body.isEmpty) return null;
      return jsonDecode(body);
    }
    String message;
    try {
      final decoded = jsonDecode(body);
      message = decoded['detail'] ??
          decoded['message'] ??
          decoded.toString();
    } catch (_) {
      message = body;
    }
    throw ApiException(response.statusCode, message);
  }

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$kBaseUrl$path');
    final response = await http.get(uri, headers: await _headers());
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final uri = Uri.parse('$kBaseUrl$path');
    final response = await http.post(
      uri,
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$kBaseUrl$path');
    final response = await http.patch(
      uri,
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$kBaseUrl$path');
    final response = await http.delete(uri, headers: await _headers());
    return _handleResponse(response);
  }
}
