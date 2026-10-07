import 'package:equatable/equatable.dart';
import '../../data/models/user_profile_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {
  const AuthCheckStatusEvent();
}

class AuthRequestOtpEvent extends AuthEvent {
  final String phoneNumber;

  const AuthRequestOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthVerifyOtpEvent extends AuthEvent {
  final String otp;

  const AuthVerifyOtpEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class AuthOnboardEvent extends AuthEvent {
  final String username;
  final String displayName;

  const AuthOnboardEvent({
    required this.username,
    required this.displayName,
  });

  @override
  List<Object?> get props => [username, displayName];
}

class AuthUpdateProfileEvent extends AuthEvent {
  final String? displayName;
  final String? profilePhotoUrl;

  const AuthUpdateProfileEvent({
    this.displayName,
    this.profilePhotoUrl,
  });

  @override
  List<Object?> get props => [displayName, profilePhotoUrl];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthProfileLoadedEvent extends AuthEvent {
  final UserProfileModel profile;

  const AuthProfileLoadedEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
