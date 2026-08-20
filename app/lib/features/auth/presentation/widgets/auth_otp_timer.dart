import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: Text(
          resendSeconds > 0
              ? 'Resend OTP in ${resendSeconds}s'
              : 'Resend OTP',
          style: GoogleFonts.inter(
            color: resendSeconds == 0
                ? const Color(0xFFB398EB)
                : Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
