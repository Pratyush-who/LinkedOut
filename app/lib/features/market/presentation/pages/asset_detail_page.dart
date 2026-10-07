import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/asset_avatar.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/interactive_chart.dart';
import '../../../../core/widgets/price_change_badge.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../trade/presentation/widgets/trade_bottom_sheet.dart';
import '../../data/models/asset_model.dart';

class AssetDetailPage extends StatefulWidget {
  final AssetModel asset;

  const AssetDetailPage({super.key, required this.asset});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  String _selectedTimeframe = '1D';

  List<double> _getAdjustedChartData() {
    final baseData = widget.asset.sparkline;
    if (_selectedTimeframe == '1D') return baseData;
    if (_selectedTimeframe == '1W') {
      return baseData.map((e) => e * (1 + (e.hashCode % 10 - 5) / 100)).toList();
    }
    if (_selectedTimeframe == '1M') {
      return baseData.map((e) => e * (1 + (e.hashCode % 20 - 10) / 100)).toList();
    }
    return baseData;
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.asset.change24hPercentage >= 0;
    final chartData = _getAdjustedChartData();

    final low = widget.asset.low24h ?? (widget.asset.currentPrice * 0.95);
    final high = widget.asset.high24h ?? (widget.asset.currentPrice * 1.05);
    final current = widget.asset.currentPrice;
    final rangeFraction = (high > low) ? ((current - low) / (high - low)).clamp(0.0, 1.0) : 0.5;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            AssetAvatar(symbol: widget.asset.symbol, iconUrl: widget.asset.iconUrl, size: 32),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.asset.symbol,
                  style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.asset.name,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.grey400),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Price & 24h Change
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(widget.asset.currentPrice),
                  style: GoogleFonts.sora(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: PriceChangeBadge(
                    changePercentage: widget.asset.change24hPercentage,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Timeframe Selector Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['1D', '1W', '1M', '1Y', 'ALL'].map((tf) {
                final isSelected = _selectedTimeframe == tf;
                return InkWell(
                  onTap: () => setState(() => _selectedTimeframe = tf),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surfaceElevated : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryLight : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tf,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppColors.primaryLight : AppColors.grey400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Interactive Chart
            InteractiveChart(
              dataPoints: chartData,
              isPositive: isPositive,
              height: 220,
            ),
            const SizedBox(height: 24),

            // 24H Price Range Bar
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24H PRICE RANGE',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.grey400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Low: ${CurrencyFormatter.format(low)}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey300),
                      ),
                      Text(
                        'High: ${CurrencyFormatter.format(high)}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: rangeFraction,
                      backgroundColor: AppColors.surfaceLight,
                      color: AppColors.primaryLight,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Market Stats
            Text(
              'MARKET STATISTICS',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Market Cap',
                    value: CurrencyFormatter.formatCompact(widget.asset.marketCap ?? 1500000000),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: '24h Volume',
                    value: CurrencyFormatter.formatCompact(widget.asset.volume24h ?? 45000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // About Asset Card
            if (widget.asset.description != null && widget.asset.description!.isNotEmpty) ...[
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABOUT ${widget.asset.name.toUpperCase()}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.grey400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.asset.description!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.grey300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: Color(0xFF262C3A), width: 1)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => TradeBottomSheet.show(context, asset: widget.asset, isBuy: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('BUY'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => TradeBottomSheet.show(context, asset: widget.asset, isBuy: false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('SELL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
