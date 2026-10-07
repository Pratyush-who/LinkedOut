import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_profile_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<Map<String, dynamic>> requestOtp({required String phone}) async {
    final response = await apiClient.post(
      ApiEndpoints.requestOtp,
      data: {'phone': phone},
    );
    if (response is Map<String, dynamic>) {
      return response;
    }
    return {'message': 'OTP sent successfully', 'phone': phone};
  }

  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {
        'phone': phone,
        'otp': otp,
      },
    );

    if (response is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response);
    }
    throw Exception('Invalid response format from verify-otp');
  }

  Future<AuthResponseModel> onboard({
    required String phone,
    required String username,
    required String displayName,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.onboard,
      data: {
        'phone': phone,
        'username': username,
        'displayName': displayName,
      },
    );

    if (response is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(response);
    }
    throw Exception('Invalid response format from onboard');
  }

  Future<UserProfileModel> getProfile({required String phone}) async {
    final response = await apiClient.get(
      ApiEndpoints.profile,
      queryParameters: {'phone': phone},
    );

    if (response is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response);
    }
    throw Exception('Invalid response format from get profile');
  }

  Future<UserProfileModel> updateProfile({
    required String phone,
    String? displayName,
    String? profilePhotoUrl,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['displayName'] = displayName;
    if (profilePhotoUrl != null) body['profilePhotoUrl'] = profilePhotoUrl;

    final response = await apiClient.patch(
      ApiEndpoints.profile,
      queryParameters: {'phone': phone},
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response);
    }
    throw Exception('Invalid response format from update profile');
  }
}
