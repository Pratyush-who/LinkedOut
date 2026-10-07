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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _photoSelected ? AppColors.greenLight : AppColors.offWhite,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 1.2),
              ),
              alignment: Alignment.center,
              child: Icon(
                _photoSelected ? Icons.check_rounded : Icons.add_a_photo_outlined,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile avatar',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Personalize your trading presence.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.grey,
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
          backgroundColor: AppColors.offWhite,
          body: Stack(
            children: [
              Positioned(
                top: -100,
                left: -70,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryLight.withOpacity(0.45),
                        AppColors.primaryLight.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'OLYMPUS ONBOARDING',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Set up your Trader Profile.',
                            style: GoogleFonts.sora(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Choose a unique trader handle and your display name to begin trading on Olympus.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.45,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.95),
                              border: Border.all(
                                color: AppColors.black.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.04),
                                  blurRadius: 24,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _photoCard(),
                                const SizedBox(height: 20),
                                AuthTextField(
                                  label: 'USERNAME',
                                  controller: _usernameController,
                                  hint: 'e.g. crypto_bull',
                                  borderRadius: 0,
                                ),
                                const SizedBox(height: 18),
                                AuthTextField(
                                  label: 'DISPLAY NAME',
                                  controller: _displayNameController,
                                  hint: 'e.g. Alex Vance',
                                  borderRadius: 0,
                                ),
                                const SizedBox(height: 24),
                                AuthBlackButton(
                                  title: authState.isLoading
                                      ? 'Setting up...'
                                      : 'Complete Profile & Trade',
                                  iconWidget: authState.isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Icon(Icons.arrow_forward_rounded,
                                          color: Colors.white, size: 20),
                                  onTap: authState.isLoading ? () {} : _completeProfile,
                                  borderRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
