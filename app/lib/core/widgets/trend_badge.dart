import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class TrendBadge extends StatelessWidget {
  final String status; // 'NORMAL' or 'CRASH'
  final bool isMarketDip;

  const TrendBadge({
    super.key,
    required this.status,
    required this.isMarketDip,
  });

  @override
  Widget build(BuildContext context) {
    final isCrash = status.toUpperCase() == 'CRASH' || isMarketDip;
    final color = isCrash ? AppColors.red : AppColors.green;
    final label = isCrash ? 'MARKET DIP' : 'HEALTHY MARKET';
    final icon = isCrash ? Icons.warning_amber_rounded : Icons.trending_up_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
