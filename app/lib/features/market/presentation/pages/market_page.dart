import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/asset_avatar.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/price_change_badge.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/market_bloc.dart';
import '../widgets/asset_list_item.dart';
import '../widgets/market_category_chips.dart';
import '../widgets/market_trend_card.dart';
import 'asset_detail_page.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketBloc>().add(const MarketFetchDataEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.currentUser;

        return BlocBuilder<MarketBloc, MarketState>(
          builder: (context, marketState) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/logo_favicon.png', height: 24, width: 24),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OLYMPUS',
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          user?.displayName != null ? 'Hello, ${user!.displayName}' : 'Market Overview',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.grey300),
                    onPressed: () =>
                        context.read<MarketBloc>().add(const MarketFetchDataEvent(isRefresh: true)),
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
                  context.read<MarketBloc>().add(const MarketFetchDataEvent(isRefresh: true));
                },
                color: AppColors.primaryLight,
                backgroundColor: AppColors.surface,
                child: marketState.isLoading && marketState.assets.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryLight))
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                        children: [
                          // Market Simulation Pulse Card
                          if (marketState.marketTrend != null) ...[
                            MarketTrendCard(trend: marketState.marketTrend!),
                            const SizedBox(height: 20),
                          ],

                          // Search Bar
                          TextField(
                            controller: _searchController,
                            onChanged: (val) => context
                                .read<MarketBloc>()
                                .add(MarketSearchQueryChangedEvent(val)),
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search crypto, stocks, commodities...',
                              prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppColors.grey500),
                                      onPressed: () {
                                        _searchController.clear();
                                        context
                                            .read<MarketBloc>()
                                            .add(const MarketSearchQueryChangedEvent(''));
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Category Chips
                          MarketCategoryChips(
                            categories: const ['All', 'Crypto', 'Stocks', 'Commodities'],
                            selectedCategory: marketState.selectedCategory,
                            onSelected: (cat) => context
                                .read<MarketBloc>()
                                .add(MarketChangeCategoryEvent(cat)),
                          ),
                          const SizedBox(height: 24),

                          // Top Gainers Section (if not actively searching)
                          if (marketState.searchQuery.isEmpty &&
                              marketState.topGainers.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TOP MOVERS',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: AppColors.grey400,
                                  ),
                                ),
                                const Icon(Icons.local_fire_department_rounded,
                                    color: AppColors.warning, size: 18),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: marketState.topGainers.length,
                                itemBuilder: (context, index) {
                                  final gainer = marketState.topGainers[index];
                                  return Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: GlassContainer(
                                      padding: const EdgeInsets.all(12),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AssetDetailPage(asset: gainer),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AssetAvatar(
                                                  symbol: gainer.symbol,
                                                  iconUrl: gainer.iconUrl,
                                                  size: 28),
                                              PriceChangeBadge(
                                                changePercentage: gainer.change24hPercentage,
                                                fontSize: 10,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                gainer.symbol,
                                                style: GoogleFonts.sora(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '\$${gainer.currentPrice.toStringAsFixed(2)}',
                                                style: GoogleFonts.inter(
                                                    fontSize: 11, color: AppColors.grey300),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // All Active Assets
                          Text(
                            'ALL ASSETS (${marketState.filteredAssets.length})',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.grey400,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (marketState.filteredAssets.isEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(32),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off_rounded,
                                      size: 48, color: AppColors.grey600),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No assets found matching "${marketState.searchQuery}"',
                                    style: GoogleFonts.inter(color: AppColors.grey400),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            ...marketState.filteredAssets.map(
                              (asset) => AssetListItem(
                                asset: asset,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssetDetailPage(asset: asset),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
