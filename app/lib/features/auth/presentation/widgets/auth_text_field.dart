import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool enabled;
  final double borderRadius;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.borderRadius = 12,
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
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade500, size: 20) : null,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
