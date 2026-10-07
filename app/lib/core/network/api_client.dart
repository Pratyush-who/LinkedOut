import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'api_exceptions.dart';
import 'mock_data_interceptor.dart';

typedef OnUnauthorizedCallback = void Function();

class ApiClient {
  late final Dio dio;
  static OnUnauthorizedCallback? onUnauthorized;

  ApiClient({String? baseUrl}) {
    final effectiveBaseUrl = baseUrl ?? SecureStorageService.getBaseUrl() ?? AppConfig.baseUrl;

    dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: AppConfig.connectTimeout),
        receiveTimeout: const Duration(seconds: AppConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Auth & Logging interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = SecureStorageService.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('🚀 [API Request] [${options.method}] ${options.uri}');
            if (options.data != null) {
              debugPrint('📦 [Payload]: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('✅ [API Response] [${response.statusCode}] ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            debugPrint('❌ [API Error] [${e.response?.statusCode}] ${e.requestOptions.uri} : ${e.message}');
          }

          if (e.response?.statusCode == 401) {
            if (onUnauthorized != null) {
              onUnauthorized!();
            }
          }

          // If backend connection fails and mock fallback is enabled, return realistic mock data
          if (AppConfig.enableMockFallback && _isConnectionFailure(e)) {
            if (kDebugMode) {
              debugPrint('⚡ [Mock Fallback Activated] Generating mock data for ${e.requestOptions.path}');
            }
            final mockData = MockDataInterceptor.generateMockResponse(e.requestOptions);
            return handler.resolve(
              Response(
                requestOptions: e.requestOptions,
                data: mockData,
                statusCode: 200,
                statusMessage: 'OK (Mock Fallback)',
              ),
            );
          }

          return handler.next(e);
        },
      ),
    );
  }

  bool _isConnectionFailure(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.error.toString().contains('SocketException') ||
        e.response == null;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      String message = 'Something went wrong';

      if (data is Map && data.containsKey('message')) {
        message = data['message'].toString();
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      switch (statusCode) {
        case 400:
          return BadRequestException(message: message, data: data);
        case 401:
          return UnauthorizedException(message: message);
        case 500:
        case 502:
        case 503:
          return ServerException(message: message, statusCode: statusCode);
        default:
          return ApiException(message: message, statusCode: statusCode, data: data);
      }
    }

    return NetworkException(
      message: error.message ?? 'Unable to connect to Olympus server. Please verify backend is running.',
    );
  }
}
