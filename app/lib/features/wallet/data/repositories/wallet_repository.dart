import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';

class WalletRepository {
  final ApiClient apiClient;

  WalletRepository({required this.apiClient});

  Future<WalletResponseModel> getWalletDetails() async {
    final response = await apiClient.get(ApiEndpoints.wallet);

    if (response is Map<String, dynamic>) {
      return WalletResponseModel.fromJson(response);
    }
    throw Exception('Invalid response format for wallet');
  }
}
