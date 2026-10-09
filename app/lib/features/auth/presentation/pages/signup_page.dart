import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_black_button.dart';
import '../widgets/auth_otp_timer.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_white_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final List<String> _greetings = const [
    'Hello',
    'Namaste',
    'Hola',
    'Bonjour',
    'Ciao',
    'Hallo',
    'Привет',
    '你好',
    'こんにちは',
    '안녕하세요',
    'Merhaba',
    'Olá',
  ];
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _resendTimer;
  int _resendSeconds = 30;

  bool _otpRequested = false;
  bool _showPhoneInput = false;

  @override
  void initState() {
    super.initState();
    // Do not prefill mock numbers so users have a clean field with an Indian hint format
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _greetings.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _resendTimer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendSeconds = 30;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _resendTimer?.cancel();
        }
      });
    });
  }

  void _sendOtp() {
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      UiHelpers.showSnackBar(context, 'Please enter your mobile number.', isError: true);
      return;
    }

    // Auto prepend Indian country code +91 if user entered a standard 10-digit number
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (!phoneNumber.startsWith('+')) {
      if (phoneNumber.length == 10) {
        phoneNumber = '+91$phoneNumber';
      } else if (phoneNumber.startsWith('91') && phoneNumber.length == 12) {
        phoneNumber = '+$phoneNumber';
      } else {
        phoneNumber = '+91$phoneNumber';
      }
    }

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(AuthRequestOtpEvent(phoneNumber));
  }

  void _continue() {
    if (!_otpRequested) {
      _sendOtp();
      return;
    }

    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      UiHelpers.showSnackBar(context, 'Enter the OTP to continue.', isError: true);
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(AuthVerifyOtpEvent(otp));
  }

  void _continueWithGoogle() {
    // Instant simulation trader demo access
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const AuthRequestOtpEvent('+919876543210'));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        authBloc.add(const AuthVerifyOtpEvent('123456'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          UiHelpers.showSnackBar(context, state.errorMessage!, isError: true);
        } else if (state.status == AuthStatus.otpSent && !_otpRequested) {
          setState(() {
            _otpRequested = true;
          });
          _startResendTimer();
          final otp = state.lastGeneratedOtp ?? '123456';
          _otpController.text = otp;
          UiHelpers.showSnackBar(
            context,
            'OTP ($otp) sent for verification',
            isSuccess: true,
          );
        } else if (state.status == AuthStatus.onboardingRequired) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      builder: (context, authState) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Dark Cyber Background
              Positioned.fill(
                child: Opacity(
                  opacity: 0.18,
                  child: Image.asset(
                    'assets/auth_bg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/intro-bg.png', fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => const SizedBox()),
                  ),
                ),
              ),

              // Ambient Radial Lights
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondary.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 32,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Top Brand Header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.surface,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFF2E3646)),
                                            ),
                                            child: Image.asset(
                                              'assets/logo_favicon.png',
                                              height: 26,
                                              width: 26,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'OLYMPUS',
                                                style: GoogleFonts.sora(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 4.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'INSTITUTIONAL SIMULATION',
                                                style: GoogleFonts.inter(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.5,
                                                  color: AppColors.grey400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.green.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: AppColors.green.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: AppColors.green,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'LIVE',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.green,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 36),

                                  // Main Headline
                                  RichText(
                                    text: TextSpan(
                                      text: 'Welcome',
                                      style: GoogleFonts.sora(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        height: 1.15,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '.',
                                          style: GoogleFonts.sora(
                                            color: AppColors.primaryLight,
                                          ),
                                        ),
                                        const TextSpan(text: '\nStart Trading'),
                                        TextSpan(
                                          text: '.',
                                          style: GoogleFonts.sora(
                                            color: AppColors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Subtitle description
                                  Text(
                                    'Access decentralized assets, real-time market simulations, and high-frequency order execution.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.grey400,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Dynamic Language Greeting Pill - Positioned below description as requested
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceElevated,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(0.35),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.translate_rounded,
                                            size: 15,
                                            color: AppColors.primaryLight,
                                          ),
                                          const SizedBox(width: 8),
                                          AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 350),
                                            transitionBuilder: (Widget child, Animation<double> animation) {
                                              return ClipRect(
                                                child: SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin: const Offset(0, 0.8),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              _greetings[_currentIndex],
                                              key: ValueKey<String>(_greetings[_currentIndex]),
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryLight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const Spacer(),
                                  const SizedBox(height: 28),

                                  // Form or Option Buttons
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: _showPhoneInput
                                        ? _buildPhoneInputSection(authState)
                                        : _buildInitialButtons(),
                                  ),

                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInitialButtons() {
    return Column(
      key: const ValueKey('buttons'),
      children: [
        AuthBlackButton(
          title: 'Continue with Mobile Number',
          iconWidget: const Icon(
            Icons.phone_iphone_rounded,
            size: 20,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              _showPhoneInput = true;
            });
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: Divider(color: const Color(0xFF2E3646), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'or',
                style: GoogleFonts.inter(
                  color: AppColors.grey500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: const Color(0xFF2E3646), thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),
        AuthWhiteButton(
          title: 'Instant Trader Demo Access',
          iconWidget: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flash_on_rounded,
              color: AppColors.primaryLight,
              size: 16,
            ),
          ),
          onTap: _continueWithGoogle,
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection(AuthState authState) {
    return Container(
      key: const ValueKey('phone_input'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E3646), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: _phoneController,
            label: 'PHONE NUMBER',
            hint: '98765 43210',
            keyboardType: TextInputType.phone,
            prefixWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    '+91',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 18,
                    color: const Color(0xFF2E3646),
                  ),
                ],
              ),
            ),
            enabled: !_otpRequested && !authState.isLoading,
          ),
          if (_otpRequested) ...[
            const SizedBox(height: 16),
            AuthTextField(
              controller: _otpController,
              label: '6-DIGIT VERIFICATION CODE',
              hint: '1 2 3 4 5 6',
              icon: Icons.lock_outline_rounded,
              keyboardType: TextInputType.number,
              maxLength: 6,
              enabled: !authState.isLoading,
            ),
            const SizedBox(height: 6),
            AuthOtpTimer(resendSeconds: _resendSeconds, onResend: _sendOtp),
          ],
          const SizedBox(height: 18),
          AuthBlackButton(
            title: authState.isLoading
                ? 'Processing...'
                : (_otpRequested ? 'Verify & Enter Market' : 'Request OTP'),
            iconWidget: authState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(
                    Icons.arrow_forward_rounded,
                    size: 19,
                    color: Colors.white,
                  ),
            onTap: authState.isLoading ? () {} : _continue,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: authState.isLoading
                ? null
                : () {
                    setState(() {
                      _showPhoneInput = false;
                      _otpRequested = false;
                      _resendTimer?.cancel();
                    });
                  },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              '← Choose another sign in method',
              style: GoogleFonts.inter(
                color: AppColors.grey400,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
