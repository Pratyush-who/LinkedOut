import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AuthOtpTimer extends StatelessWidget {
  final int resendSeconds;
  final VoidCallback onResend;

  const AuthOtpTimer({
    super.key,
    required this.resendSeconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: resendSeconds == 0 ? onResend : null,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          resendSeconds > 0
              ? 'Resend code in ${resendSeconds}s'
              : 'Resend code',
          style: GoogleFonts.inter(
            color: resendSeconds == 0
                ? AppColors.primaryLight
                : AppColors.grey500,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
