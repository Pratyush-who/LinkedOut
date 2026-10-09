import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? icon;
  final Widget? prefixWidget;
  final String? prefixText;
  final TextInputType keyboardType;
  final bool enabled;
  final double borderRadius;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.icon,
    this.prefixWidget,
    this.prefixText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.borderRadius = 14,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLength: maxLength,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: enabled ? Colors.white : AppColors.grey500,
          ),
          cursorColor: AppColors.primaryLight,
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: AppColors.grey500,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixWidget ??
                (icon != null
                    ? Icon(icon, color: AppColors.primaryLight, size: 20)
                    : null),
            prefixText: prefixText,
            prefixStyle: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: enabled ? AppColors.surfaceLight : AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Color(0xFF2E3646), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Color(0xFF2E3646), width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Color(0xFF1F242F), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
