import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkedout/core/routes/app_routes.dart';
import 'package:linkedout/core/theme/app_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_black_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _photoSelected = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _completeProfile() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || email.isEmpty) {
      _showMessage('Add a username and email to continue.');
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  Widget _photoCard() {
    return InkWell(
      onTap: () {
        setState(() {
          _photoSelected = !_photoSelected;
        });
        _showMessage(
          _photoSelected ? 'Photo slot prepared.' : 'Photo cleared for now.',
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _photoSelected
                    ? AppColors.greenLight.withOpacity(0.65)
                    : AppColors.offWhite,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 1.2),
              ),
              alignment: Alignment.center,
              child: Icon(
                _photoSelected
                    ? Icons.check_rounded
                    : Icons.add_a_photo_outlined,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile photo',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optional. Tap to reserve a photo spot for later.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.45,
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
                    AppColors.purpleLight.withOpacity(0.45),
                    AppColors.purpleLight.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -90,
            bottom: -30,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.greenLight.withOpacity(0.3),
                    AppColors.greenLight.withOpacity(0.0),
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
                              color: AppColors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'NEWSREEL',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 4,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.78),
                          border: Border.all(
                            color: AppColors.black.withOpacity(0.08),
                          ),
                        ),
                        child: Text(
                          'ONBOARDING',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.4,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Finish your profile.',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 42,
                          height: 0.95,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'We only need a username, an email, and an optional photo to personalize your account.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.45,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.9),
                          border: Border.all(
                            color: AppColors.black.withOpacity(0.08),
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
                              hint: 'your_name_here',
                              borderRadius: 0,
                            ),
                            const SizedBox(height: 18),
                            AuthTextField(
                              label: 'EMAIL',
                              controller: _emailController,
                              hint: 'you@example.com',
                              keyboardType: TextInputType.emailAddress,
                              borderRadius: 0,
                            ),
                            const SizedBox(height: 22),
                            AuthBlackButton(
                              title: 'Complete Profile',
                              iconWidget: const SizedBox.shrink(),
                              onTap: _completeProfile,
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
  }
}
