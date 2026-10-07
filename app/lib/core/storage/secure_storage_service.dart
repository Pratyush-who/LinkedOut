import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const String _keyAuthToken = 'olympus_auth_token';
  static const String _keyUserPhone = 'olympus_user_phone';
  static const String _keyUsername = 'olympus_username';
  static const String _keyDisplayName = 'olympus_display_name';
  static const String _keyProfilePhotoUrl = 'olympus_profile_photo_url';
  static const String _keyOnboardingComplete = 'olympus_onboarding_complete';
  static const String _keyBaseUrl = 'olympus_base_url';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveAuthToken(String token) async {
    await init();
    await _prefs?.setString(_keyAuthToken, token);
  }

  static String? getAuthToken() {
    return _prefs?.getString(_keyAuthToken);
  }

  static Future<void> saveUserDetails({
    required String phone,
    String? username,
    String? displayName,
    String? profilePhotoUrl,
    bool? onboardingComplete,
  }) async {
    await init();
    await _prefs?.setString(_keyUserPhone, phone);
    if (username != null) await _prefs?.setString(_keyUsername, username);
    if (displayName != null) await _prefs?.setString(_keyDisplayName, displayName);
    if (profilePhotoUrl != null) await _prefs?.setString(_keyProfilePhotoUrl, profilePhotoUrl);
    if (onboardingComplete != null) await _prefs?.setBool(_keyOnboardingComplete, onboardingComplete);
  }

  static String? getUserPhone() => _prefs?.getString(_keyUserPhone);
  static String? getUsername() => _prefs?.getString(_keyUsername);
  static String? getDisplayName() => _prefs?.getString(_keyDisplayName);
  static String? getProfilePhotoUrl() => _prefs?.getString(_keyProfilePhotoUrl);
  static bool isOnboardingComplete() => _prefs?.getBool(_keyOnboardingComplete) ?? false;

  static Future<void> setBaseUrl(String url) async {
    await init();
    await _prefs?.setString(_keyBaseUrl, url);
  }

  static String? getBaseUrl() => _prefs?.getString(_keyBaseUrl);

  static Future<void> clearAuth() async {
    await init();
    await _prefs?.remove(_keyAuthToken);
    await _prefs?.remove(_keyUserPhone);
    await _prefs?.remove(_keyUsername);
    await _prefs?.remove(_keyDisplayName);
    await _prefs?.remove(_keyProfilePhotoUrl);
    await _prefs?.remove(_keyOnboardingComplete);
  }
}
