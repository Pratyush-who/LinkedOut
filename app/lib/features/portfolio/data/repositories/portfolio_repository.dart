import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/portfolio_model.dart';

class PortfolioRepository {
  final ApiClient apiClient;

  PortfolioRepository({required this.apiClient});

  Future<PortfolioSnapshotModel> getPortfolioSnapshot() async {
    final response = await apiClient.get(ApiEndpoints.portfolio);

    if (response is Map<String, dynamic>) {
      return PortfolioSnapshotModel.fromJson(response);
    }
    throw Exception('Invalid response format for portfolio snapshot');
  }
}
