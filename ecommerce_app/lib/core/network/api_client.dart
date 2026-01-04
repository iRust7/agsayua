import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Configuration
class ApiConfig {
  // Using PC's local network IP so Android device can connect via WiFi
  // PC IP: 192.168.100.14
  static const String baseUrl = 'http://192.168.100.14:8080/api';
  
  static const Duration timeout = Duration(seconds: 30);
}

/// API Response
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? errors;
  final int statusCode;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
    required this.statusCode,
  });
  
  factory ApiResponse.fromJson(Map<String, dynamic> json, int statusCode, {T Function(dynamic)? fromJson}) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: fromJson != null && json['data'] != null ? fromJson(json['data']) : json['data'],
      message: json['message'],
      errors: json['errors'],
      statusCode: statusCode,
    );
  }
}

/// API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  
  ApiException(this.message, {this.statusCode, this.errors});
  
  @override
  String toString() => message;
}

/// API Client
class ApiClient {
  final http.Client _client = http.Client();
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  /// GET Request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response, fromJson: fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST Request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response, fromJson: fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT Request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      
      final response = await _client
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response, fromJson: fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE Request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      
      final response = await _client
          .delete(uri, headers: _headers)
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response, fromJson: fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Build URI with query parameters
  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final url = '${ApiConfig.baseUrl}/$endpoint';
    final uri = Uri.parse(url);
    
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    
    return uri;
  }
  
  /// Handle HTTP Response
  ApiResponse<T> _handleResponse<T>(
    http.Response response, {
    T Function(dynamic)? fromJson,
  }) {
    final statusCode = response.statusCode;
    
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse<T>.fromJson(json, statusCode, fromJson: fromJson);
      } else {
        throw ApiException(
          json['message'] ?? 'Request failed',
          statusCode: statusCode,
          errors: json['errors'],
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      
      throw ApiException(
        'Failed to parse response',
        statusCode: statusCode,
      );
    }
  }
  
  /// Handle errors
  ApiException _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is http.ClientException) {
      return ApiException('Network error. Please check your connection.');
    } else if (error.toString().contains('TimeoutException')) {
      return ApiException('Request timeout. Please try again.');
    } else {
      return ApiException('An unexpected error occurred: ${error.toString()}');
    }
  }
  
  /// Dispose client
  void dispose() {
    _client.close();
  }
}

/// Singleton instance
final apiClient = ApiClient();
