import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkedout/core/routes/app_routes.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/intro-bg.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay to make text readable
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  
                  // Brand/Title Section
                  Text(
                    'RENMA',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Scroll Less.\nKnow More.',
                    style: GoogleFonts.sora(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Your swipes may not get you matches,\nbut they can get you knowledge.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signup);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB398EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
