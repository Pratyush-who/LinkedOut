class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.message = 'Session expired. Please log in again.', super.statusCode = 401});
}

class BadRequestException extends ApiException {
  BadRequestException({required super.message, super.statusCode = 400, super.data});
}

class NetworkException extends ApiException {
  NetworkException({super.message = 'Network error. Please check your internet connection.', super.statusCode});
}

class ServerException extends ApiException {
  ServerException({super.message = 'Internal server error. Please try again later.', super.statusCode = 500});
}
