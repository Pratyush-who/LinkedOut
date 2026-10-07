import 'package:equatable/equatable.dart';
import '../../data/models/user_profile_model.dart';

enum AuthStatus { initial, unauthenticated, otpSent, authenticated, onboardingRequired }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfileModel? currentUser;
  final String? phone;
  final String? token;
  final bool isLoading;
  final String? errorMessage;
  final String? lastGeneratedOtp;

  const AuthState({
    this.status = AuthStatus.initial,
    this.currentUser,
    this.phone,
    this.token,
    this.isLoading = false,
    this.errorMessage,
    this.lastGeneratedOtp,
  });

  bool get isAuthenticated =>
      token != null &&
      token!.isNotEmpty &&
      currentUser != null &&
      currentUser!.onboardingComplete;

  AuthState copyWith({
    AuthStatus? status,
    UserProfileModel? currentUser,
    String? phone,
    String? token,
    bool? isLoading,
    String? errorMessage,
    String? lastGeneratedOtp,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      phone: clearUser ? null : (phone ?? this.phone),
      token: clearUser ? null : (token ?? this.token),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastGeneratedOtp: lastGeneratedOtp ?? this.lastGeneratedOtp,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentUser,
        phone,
        token,
        isLoading,
        errorMessage,
        lastGeneratedOtp,
      ];
}
