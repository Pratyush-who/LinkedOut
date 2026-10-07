import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/trend_badge.dart';
import '../../data/models/market_trend_model.dart';

class MarketTrendCard extends StatelessWidget {
  final MarketTrendModel trend;

  const MarketTrendCard({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final isCrash = trend.isCrash;
    final accentColor = isCrash ? AppColors.red : AppColors.green;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.surface,
      border: Border.all(
        color: accentColor.withOpacity(0.3),
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.8),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'MARKET SIMULATION PULSE',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
              TrendBadge(
                status: trend.status,
                isMarketDip: trend.isMarketDip,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${(trend.currentTrend * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.sora(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                trend.currentTrend >= 0 ? 'Trend Momentum (Up)' : 'Trend Momentum (Down)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            trend.marketStatusText ??
                (isCrash
                    ? 'Caution: Simulation indicates increased volatility & dip pressure.'
                    : 'Optimal trading conditions with sustained liquidity across assets.'),
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.4,
              color: AppColors.grey200,
            ),
          ),
        ],
      ),
    );
  }
}
