import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthRequestOtpEvent>(_onRequestOtp);
    on<AuthVerifyOtpEvent>(_onVerifyOtp);
    on<AuthOnboardEvent>(_onOnboard);
    on<AuthUpdateProfileEvent>(_onUpdateProfile);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthProfileLoadedEvent>(_onProfileLoaded);
  }

  void _onProfileLoaded(
    AuthProfileLoadedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      currentUser: event.profile,
      phone: event.profile.phone,
    ));
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final token = SecureStorageService.getAuthToken();
    final phone = SecureStorageService.getUserPhone();
    final onboardingComplete = SecureStorageService.isOnboardingComplete();
    final username = SecureStorageService.getUsername();
    final displayName = SecureStorageService.getDisplayName();
    final photo = SecureStorageService.getProfilePhotoUrl();

    if (token != null && token.isNotEmpty && phone != null && phone.isNotEmpty) {
      if (onboardingComplete) {
        final user = UserProfileModel(
          phone: phone,
          username: username,
          displayName: displayName,
          profilePhotoUrl: photo,
          onboardingComplete: true,
        );
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          currentUser: user,
          phone: phone,
          token: token,
          clearError: true,
        ));
        _fetchFreshProfile(phone);
      } else {
        emit(state.copyWith(
          status: AuthStatus.onboardingRequired,
          phone: phone,
          token: token,
          clearError: true,
        ));
      }
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ));
    }
  }

  Future<void> _fetchFreshProfile(String phone) async {
    try {
      final profile = await authRepository.getProfile(phone: phone);
      await SecureStorageService.saveUserDetails(
        phone: profile.phone,
        username: profile.username,
        displayName: profile.displayName,
        profilePhotoUrl: profile.profilePhotoUrl,
        onboardingComplete: profile.onboardingComplete,
      );
      if (!isClosed) {
        add(AuthProfileLoadedEvent(profile));
      }
    } catch (_) {}
  }

  Future<void> _onRequestOtp(
    AuthRequestOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      phone: event.phoneNumber,
    ));

    try {
      final res = await authRepository.requestOtp(phone: event.phoneNumber);
      final otp = res['otp']?.toString() ?? '123456';
      emit(state.copyWith(
        isLoading: false,
        status: AuthStatus.otpSent,
        lastGeneratedOtp: otp,
        phone: event.phoneNumber,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onVerifyOtp(
    AuthVerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final phone = state.phone;
    if (phone == null || phone.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Phone number is required',
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      clearError: true,
    ));

    try {
      final response = await authRepository.verifyOtp(phone: phone, otp: event.otp);
      await SecureStorageService.saveAuthToken(response.token);
      await SecureStorageService.saveUserDetails(
        phone: response.phone,
        username: response.username,
        displayName: response.displayName,
        profilePhotoUrl: response.profilePhotoUrl,
        onboardingComplete: response.onboardingComplete,
      );

      final user = UserProfileModel(
        phone: response.phone,
        username: response.username,
        displayName: response.displayName,
        profilePhotoUrl: response.profilePhotoUrl,
        onboardingComplete: response.onboardingComplete,
      );

      final nextStatus = (response.isNewUser || !response.onboardingComplete)
          ? AuthStatus.onboardingRequired
          : AuthStatus.authenticated;

      emit(state.copyWith(
        isLoading: false,
        status: nextStatus,
        token: response.token,
        phone: response.phone,
        currentUser: user,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onOnboard(
    AuthOnboardEvent event,
    Emitter<AuthState> emit,
  ) async {
    final phone = state.phone;
    if (phone == null || phone.isEmpty) {
      emit(state.copyWith(errorMessage: 'Phone number missing'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final response = await authRepository.onboard(
        phone: phone,
        username: event.username,
        displayName: event.displayName,
      );

      if (response.token.isNotEmpty) {
        await SecureStorageService.saveAuthToken(response.token);
      }

      await SecureStorageService.saveUserDetails(
        phone: response.phone,
        username: response.username ?? event.username,
        displayName: response.displayName ?? event.displayName,
        profilePhotoUrl: response.profilePhotoUrl,
        onboardingComplete: true,
      );

      final user = UserProfileModel(
        phone: response.phone,
        username: response.username ?? event.username,
        displayName: response.displayName ?? event.displayName,
        profilePhotoUrl: response.profilePhotoUrl,
        onboardingComplete: true,
      );

      emit(state.copyWith(
        isLoading: false,
        status: AuthStatus.authenticated,
        token: response.token.isNotEmpty ? response.token : state.token,
        phone: response.phone,
        currentUser: user,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
    AuthUpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    final phone = state.phone;
    if (phone == null) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final updated = await authRepository.updateProfile(
        phone: phone,
        displayName: event.displayName,
        profilePhotoUrl: event.profilePhotoUrl,
      );

      await SecureStorageService.saveUserDetails(
        phone: updated.phone,
        username: updated.username,
        displayName: updated.displayName,
        profilePhotoUrl: updated.profilePhotoUrl,
        onboardingComplete: updated.onboardingComplete,
      );

      emit(state.copyWith(
        isLoading: false,
        currentUser: updated,
        phone: updated.phone,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await SecureStorageService.clearAuth();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
