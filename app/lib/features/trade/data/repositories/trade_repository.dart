import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/trade_request_model.dart';
import '../models/trade_response_model.dart';

class TradeRepository {
  final ApiClient apiClient;

  TradeRepository({required this.apiClient});

  Future<TradeResponseModel> buyAsset(TradeRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.tradeBuy,
      data: request.toJson(),
    );

    if (response is Map<String, dynamic>) {
      return TradeResponseModel.fromJson(response);
    }
    throw Exception('Invalid response format from buy order');
  }

  Future<TradeResponseModel> sellAsset(TradeRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.tradeSell,
      data: request.toJson(),
    );

    if (response is Map<String, dynamic>) {
      return TradeResponseModel.fromJson(response);
    }
    throw Exception('Invalid response format from sell order');
  }
}
