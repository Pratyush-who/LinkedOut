class ApiEndpoints {
  // Auth endpoints
  static const String requestOtp = '/api/auth/request-otp';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String onboard = '/api/auth/onboard';
  static const String profile = '/api/auth/profile';

  // Wallet endpoints
  static const String wallet = '/api/v1/wallet/';

  // Trading endpoints
  static const String tradeBuy = '/api/v1/trade/buy';
  static const String tradeSell = '/api/v1/trade/sell';

  // Portfolio endpoints
  static const String portfolio = '/api/v1/portfolio/';

  // Market & Assets endpoints
  static const String marketAssets = '/api/v1/market/assets';
  static const String allAssets = '/api/v1/assets';
  static const String marketTrend = '/api/v1/market/trend';
  
  static String assetBySymbol(String symbol) => '/api/v1/market/assets/$symbol';
}
