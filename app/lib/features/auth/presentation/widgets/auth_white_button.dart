import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthWhiteButton extends StatelessWidget {
  const AuthWhiteButton({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.black,
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
