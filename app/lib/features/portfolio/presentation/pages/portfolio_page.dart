import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/asset_avatar.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/interactive_chart.dart';
import '../../../../core/widgets/price_change_badge.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../market/data/models/asset_model.dart';
import '../../../market/presentation/bloc/market_bloc.dart';
import '../../../market/presentation/pages/asset_detail_page.dart';
import '../../../trade/presentation/widgets/trade_bottom_sheet.dart';
import '../bloc/portfolio_bloc.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioBloc>().add(const PortfolioFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, portfolioState) {
        final marketState = context.watch<MarketBloc>().state;
        final isProfit = portfolioState.totalGainLoss >= 0;

        // Synthetic portfolio trajectory data
        final chartPoints = [
          portfolioState.totalInvested * 0.96,
          portfolioState.totalInvested * 0.98,
          portfolioState.totalInvested * 1.01,
          portfolioState.totalInvested * 0.99,
          portfolioState.totalInvested * 1.03,
          portfolioState.totalValue,
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'PORTFOLIO',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.grey300),
                onPressed: () => context
                    .read<PortfolioBloc>()
                    .add(const PortfolioFetchEvent(isRefresh: true)),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline_rounded, color: AppColors.grey300),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<PortfolioBloc>().add(const PortfolioFetchEvent(isRefresh: true));
            },
            color: AppColors.primaryLight,
            backgroundColor: AppColors.surface,
            child: portfolioState.isLoading && portfolioState.snapshot == null
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryLight))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    children: [
                      // Portfolio Net Worth Card
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppColors.surface,
                        border: Border.all(
                            color: AppColors.primaryLight.withOpacity(0.2), width: 1.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL PORTFOLIO VALUE',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppColors.grey400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  CurrencyFormatter.format(portfolioState.totalValue),
                                  style: GoogleFonts.sora(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                PriceChangeBadge(
                                  changePercentage: portfolioState.totalGainLossPercentage,
                                  fontSize: 12,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${isProfit ? "+" : ""}${CurrencyFormatter.format(portfolioState.totalGainLoss)} all time',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isProfit ? AppColors.green : AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Mini Stats
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Total Invested',
                              value: CurrencyFormatter.format(portfolioState.totalInvested),
                              icon: Icons.account_balance_wallet_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              label: 'Holdings Count',
                              value: '${portfolioState.holdings.length} Assets',
                              icon: Icons.pie_chart_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Performance Trend Chart
                      Text(
                        'PERFORMANCE OVERVIEW',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.grey400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: InteractiveChart(
                          dataPoints: chartPoints,
                          isPositive: isProfit,
                          height: 160,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Holdings List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'YOUR ASSETS (${portfolioState.holdings.length})',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (portfolioState.holdings.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Icon(Icons.pie_chart_outline,
                                  size: 48, color: AppColors.grey600),
                              const SizedBox(height: 12),
                              Text(
                                'You don\'t have any holdings yet.\nStart trading from the Market tab!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(color: AppColors.grey400),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        ...portfolioState.holdings.map((h) {
                          final isHoldingProfit = h.gainLoss >= 0;
                          return GlassContainer(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            onTap: () {
                              // Find matching asset from market
                              final matchingAsset = marketState.assets.firstWhere(
                                (a) =>
                                    a.id == h.assetId ||
                                    a.symbol.toUpperCase() == h.symbol.toUpperCase(),
                                orElse: () => AssetModel(
                                  id: h.assetId,
                                  symbol: h.symbol,
                                  name: h.name,
                                  currentPrice: h.currentPrice,
                                  category: h.category,
                                  iconUrl: h.iconUrl,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssetDetailPage(asset: matchingAsset),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AssetAvatar(symbol: h.symbol, iconUrl: h.iconUrl, size: 40),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            h.symbol,
                                            style: GoogleFonts.sora(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${CurrencyFormatter.formatCrypto(h.quantity)} ${h.symbol}',
                                            style: GoogleFonts.inter(
                                                fontSize: 12, color: AppColors.grey400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          CurrencyFormatter.format(h.currentValue),
                                          style: GoogleFonts.sora(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${isHoldingProfit ? "+" : ""}${CurrencyFormatter.formatPercentage(h.gainLossPercentage)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isHoldingProfit
                                                ? AppColors.green
                                                : AppColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(color: Color(0xFF262C3A), height: 1),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Avg Buy: ${CurrencyFormatter.format(h.avgBuyPrice)}',
                                      style: GoogleFonts.inter(
                                          fontSize: 11, color: AppColors.grey500),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            final asset = marketState.assets.firstWhere(
                                              (a) =>
                                                  a.id == h.assetId ||
                                                  a.symbol.toUpperCase() ==
                                                      h.symbol.toUpperCase(),
                                              orElse: () => AssetModel(
                                                id: h.assetId,
                                                symbol: h.symbol,
                                                name: h.name,
                                                currentPrice: h.currentPrice,
                                              ),
                                            );
                                            TradeBottomSheet.show(context,
                                                asset: asset, isBuy: true);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Buy More',
                                            style: GoogleFonts.inter(
                                              color: AppColors.primaryLight,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () {
                                            final asset = marketState.assets.firstWhere(
                                              (a) =>
                                                  a.id == h.assetId ||
                                                  a.symbol.toUpperCase() ==
                                                      h.symbol.toUpperCase(),
                                              orElse: () => AssetModel(
                                                id: h.assetId,
                                                symbol: h.symbol,
                                                name: h.name,
                                                currentPrice: h.currentPrice,
                                              ),
                                            );
                                            TradeBottomSheet.show(context,
                                                asset: asset, isBuy: false);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Sell',
                                            style: GoogleFonts.inter(
                                              color: AppColors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
