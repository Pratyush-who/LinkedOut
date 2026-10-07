class UserProfileModel {
  final String phone;
  final String? username;
  final String? displayName;
  final String? profilePhotoUrl;
  final bool onboardingComplete;

  UserProfileModel({
    required this.phone,
    this.username,
    this.displayName,
    this.profilePhotoUrl,
    this.onboardingComplete = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      phone: json['phone'] ?? '',
      username: json['username'],
      displayName: json['displayName'],
      profilePhotoUrl: json['profilePhotoUrl'],
      onboardingComplete: json['onboardingComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'username': username,
      'displayName': displayName,
      'profilePhotoUrl': profilePhotoUrl,
      'onboardingComplete': onboardingComplete,
    };
  }

  UserProfileModel copyWith({
    String? phone,
    String? username,
    String? displayName,
    String? profilePhotoUrl,
    bool? onboardingComplete,
  }) {
    return UserProfileModel(
      phone: phone ?? this.phone,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
