class AppConfig {
  static const String appName = 'Renma Olympus';
  
  // Default base URL. Can be adjusted for Android emulator (10.0.2.2:8080), localhost, or remote server.
  static String baseUrl = 'http://10.0.2.2:8080';
  
  // When the real backend is unreachable or during offline testing, fallback seamlessly to high-fidelity mock data.
  static bool enableMockFallback = true;
  
  // Configurable timeout in seconds
  static const int connectTimeout = 15;
  static const int receiveTimeout = 15;
}
