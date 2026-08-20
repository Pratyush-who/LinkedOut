import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthBlackButton extends StatelessWidget {
  const AuthBlackButton({
    super.key,
    required this.title,
    required this.iconWidget,
    required this.onTap,
    this.borderRadius = 12,
  });

  final String title;
  final Widget iconWidget;
  final VoidCallback onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
