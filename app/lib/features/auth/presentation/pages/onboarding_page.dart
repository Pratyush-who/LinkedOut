import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_black_button.dart';
import '../widgets/auth_text_field.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  bool _photoSelected = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'trader_pro';
    _displayNameController.text = 'Alex Vance';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _completeProfile() {
    final username = _usernameController.text.trim();
    final displayName = _displayNameController.text.trim();

    if (username.isEmpty || displayName.isEmpty) {
      UiHelpers.showSnackBar(context, 'Please enter both username and display name.', isError: true);
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
          AuthOnboardEvent(
            username: username,
            displayName: displayName,
          ),
        );
  }

  Widget _photoCard() {
    return InkWell(
      onTap: () {
        setState(() {
          _photoSelected = !_photoSelected;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _photoSelected ? AppColors.primaryLight : const Color(0xFF2E3646),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _photoSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _photoSelected ? AppColors.primaryLight : const Color(0xFF2E3646),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                _photoSelected ? Icons.check_rounded : Icons.add_a_photo_outlined,
                color: _photoSelected ? AppColors.primaryLight : AppColors.grey400,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Avatar',
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _photoSelected ? 'Default avatar selected' : 'Tap to customize avatar',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          UiHelpers.showSnackBar(context, state.errorMessage!, isError: true);
        } else if (state.status == AuthStatus.authenticated) {
          UiHelpers.showSnackBar(
            context,
            'Welcome to Olympus, ${_displayNameController.text.trim()}!',
            isSuccess: true,
          );
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      builder: (context, authState) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Subtle background gradient lights
              Positioned(
                top: -80,
                left: -60,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                right: -50,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondary.withOpacity(0.15),
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
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 48,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Brand Pill
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryLight,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'OLYMPUS ONBOARDING',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2.5,
                                          color: AppColors.primaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Set up your Trader Profile.',
                                    style: GoogleFonts.sora(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Choose your unique trader handle and display name to begin trading simulation on Olympus.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: AppColors.grey400,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Card Container
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF2E3646),
                                        width: 1.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _photoCard(),
                                        const SizedBox(height: 20),
                                        AuthTextField(
                                          label: 'USERNAME',
                                          controller: _usernameController,
                                          hint: 'e.g. crypto_bull',
                                          icon: Icons.alternate_email_rounded,
                                        ),
                                        const SizedBox(height: 16),
                                        AuthTextField(
                                          label: 'DISPLAY NAME',
                                          controller: _displayNameController,
                                          hint: 'e.g. Alex Vance',
                                          icon: Icons.badge_outlined,
                                        ),
                                        const SizedBox(height: 24),
                                        AuthBlackButton(
                                          title: authState.isLoading
                                              ? 'Setting up...'
                                              : 'Complete Profile & Enter Market',
                                          iconWidget: authState.isLoading
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                      strokeWidth: 2, color: Colors.white),
                                                )
                                              : const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: Colors.white,
                                                  size: 19,
                                                ),
                                          onTap: authState.isLoading ? () {} : _completeProfile,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),
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
}
