import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AuthBlackButton extends StatelessWidget {
  const AuthBlackButton({
    super.key,
    required this.title,
    required this.iconWidget,
    required this.onTap,
    this.borderRadius = 14,
    this.useGradient = true,
  });

  final String title;
  final Widget iconWidget;
  final VoidCallback onTap;
  final double borderRadius;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: useGradient ? AppColors.primaryGradient : null,
        color: useGradient ? null : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: useGradient
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
        border: useGradient
            ? null
            : Border.all(color: const Color(0xFF2E3646), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconWidget,
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
