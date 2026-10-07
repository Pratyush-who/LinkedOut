import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  final Color? valueColor;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
    this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: AppColors.grey400,
                ),
              ),
              if (icon != null) ...[
                Icon(icon, size: 16, color: AppColors.grey500),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.white,
                ),
              ),
              ?trailing,
            ],
          ),
        ],
      ),
    );
  }
}
