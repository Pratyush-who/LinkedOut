import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../utils/currency_formatter.dart';

class PriceChangeBadge extends StatelessWidget {
  final num? changePercentage;
  final bool showArrow;
  final double fontSize;
  final EdgeInsets padding;

  const PriceChangeBadge({
    super.key,
    required this.changePercentage,
    this.showArrow = true,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final value = changePercentage ?? 0.0;
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.green : AppColors.red;
    final bgColor = isPositive ? AppColors.greenGlow : AppColors.redGlow;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showArrow) ...[
            Icon(
              isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: color,
              size: fontSize + 4,
            ),
          ],
          Text(
            CurrencyFormatter.formatPercentage(value),
            style: GoogleFonts.inter(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
