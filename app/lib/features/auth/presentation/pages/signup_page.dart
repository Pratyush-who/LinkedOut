import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
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
    _phoneController.text = '+1234567890'; // Helpful default for testing
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      UiHelpers.showSnackBar(context, 'Please enter your phone number.', isError: true);
      return;
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
    // For demo instant access
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const AuthRequestOtpEvent('+1987654321'));
    Future.delayed(const Duration(milliseconds: 200), () {
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
            'OTP ($otp) generated for ${state.phone ?? _phoneController.text.trim()}',
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
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Opacity(
                  opacity: 0.35,
                  child: Image.asset(
                    'assets/auth_bg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.85),
                        Colors.white.withOpacity(0.98),
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/logo_favicon.png',
                                height: 44,
                                width: 44,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'OLYMPUS',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 4.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          // Vertical Greeting Flip
                          Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF7C3AED).withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return ClipRect(
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 1),
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
                                    color: const Color(0xFF7C3AED),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // The Main Headline
                      RichText(
                        text: TextSpan(
                          text: 'Welcome',
                          style: GoogleFonts.sora(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.1,
                          ),
                          children: [
                            TextSpan(
                              text: '.',
                              style: GoogleFonts.sora(
                                color: const Color(0xFF7C3AED),
                              ),
                            ),
                            const TextSpan(text: '\nStart Trading'),
                            TextSpan(
                              text: '.',
                              style: GoogleFonts.sora(
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),
                      Text(
                        'Access decentralized assets, real-time market simulations, and high-frequency order execution.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _showPhoneInput
                            ? _buildPhoneInputSection(authState)
                            : _buildInitialButtons(),
                      ),

                      const SizedBox(height: 24),
                    ],
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
          title: 'Continue with Phone Number',
          iconWidget: const Icon(
            Icons.phone_outlined,
            size: 20,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              _showPhoneInput = true;
            });
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'or',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        AuthWhiteButton(
          title: 'Instant Trader Demo Access',
          iconWidget: Image.asset(
            'assets/google.webp',
            height: 20,
            width: 20,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.flash_on_rounded, color: Color(0xFF7C3AED)),
          ),
          onTap: _continueWithGoogle,
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection(AuthState authState) {
    return Column(
      key: const ValueKey('phone_input'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: _phoneController,
          hint: 'Enter your phone number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          enabled: !_otpRequested && !authState.isLoading,
        ),
        const SizedBox(height: 14),
        if (_otpRequested) ...[
          AuthTextField(
            controller: _otpController,
            hint: 'Enter 6-digit OTP',
            icon: Icons.lock_outline,
            keyboardType: TextInputType.number,
            enabled: !authState.isLoading,
          ),
          const SizedBox(height: 8),
          AuthOtpTimer(resendSeconds: _resendSeconds, onResend: _sendOtp),
          const SizedBox(height: 14),
        ],
        AuthBlackButton(
          title: authState.isLoading
              ? 'Please wait...'
              : (_otpRequested ? 'Verify & Continue' : 'Request OTP'),
          iconWidget: authState.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.white,
                ),
          onTap: authState.isLoading ? () {} : _continue,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            setState(() {
              _showPhoneInput = false;
              _otpRequested = false;
              _resendTimer?.cancel();
            });
          },
          child: Text(
            'Back to options',
            style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
