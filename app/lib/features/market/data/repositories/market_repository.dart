import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/asset_model.dart';
import '../models/market_trend_model.dart';

class MarketRepository {
  final ApiClient apiClient;

  MarketRepository({required this.apiClient});

  Future<List<AssetModel>> getAssets() async {
    dynamic response;
    try {
      response = await apiClient.get(ApiEndpoints.marketAssets);
    } catch (_) {
      response = await apiClient.get(ApiEndpoints.allAssets);
    }

    if (response is List) {
      return response.map((item) => AssetModel.fromJson(item as Map<String, dynamic>)).toList();
    } else if (response is Map<String, dynamic>) {
      if (response.containsKey('assets') && response['assets'] is List) {
        return (response['assets'] as List)
            .map((item) => AssetModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  Future<AssetModel> getAssetBySymbol(String symbol) async {
    final response = await apiClient.get(ApiEndpoints.assetBySymbol(symbol));
    if (response is Map<String, dynamic>) {
      return AssetModel.fromJson(response);
    }
    throw Exception('Invalid response format for asset $symbol');
  }

  Future<MarketTrendModel> getMarketTrend() async {
    final response = await apiClient.get(ApiEndpoints.marketTrend);
    if (response is Map<String, dynamic>) {
      return MarketTrendModel.fromJson(response);
    }
    throw Exception('Invalid response format for market trend');
  }
}
