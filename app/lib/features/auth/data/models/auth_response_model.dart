class AuthResponseModel {
  final String token;
  final bool isNewUser;
  final String phone;
  final String? username;
  final String? displayName;
  final String? profilePhotoUrl;
  final bool onboardingComplete;

  AuthResponseModel({
    required this.token,
    required this.isNewUser,
    required this.phone,
    this.username,
    this.displayName,
    this.profilePhotoUrl,
    this.onboardingComplete = false,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      isNewUser: json['isNewUser'] ?? false,
      phone: json['phone'] ?? '',
      username: json['username'],
      displayName: json['displayName'],
      profilePhotoUrl: json['profilePhotoUrl'],
      onboardingComplete: json['onboardingComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'isNewUser': isNewUser,
      'phone': phone,
      'username': username,
      'displayName': displayName,
      'profilePhotoUrl': profilePhotoUrl,
      'onboardingComplete': onboardingComplete,
    };
  }
}
