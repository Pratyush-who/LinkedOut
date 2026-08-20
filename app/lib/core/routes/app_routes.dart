import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/splash/presentation/pages/intro_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashPage(),
    intro: (context) => const IntroPage(),
    signup: (context) => const SignupPage(),
    onboarding: (context) => const OnboardingPage(),
    home: (context) => const HomePage(),
  };
}
