import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../market/presentation/bloc/market_bloc.dart';
import '../../../market/presentation/pages/market_page.dart';
import '../../../portfolio/presentation/bloc/portfolio_bloc.dart';
import '../../../portfolio/presentation/pages/portfolio_page.dart';
import '../../../trade/presentation/widgets/trade_bottom_sheet.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MarketPage(),
    PortfolioPage(),
    WalletPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketBloc>().add(const MarketFetchDataEvent());
      context.read<PortfolioBloc>().add(const PortfolioFetchEvent());
      context.read<WalletBloc>().add(const WalletFetchEvent());
    });
  }

  void _onFabPressed() {
    final marketState = context.read<MarketBloc>().state;
    if (marketState.assets.isNotEmpty) {
      TradeBottomSheet.show(context, asset: marketState.assets.first, isBuy: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 12,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.candlestick_chart_rounded, 'Market'),
              _buildNavItem(1, Icons.pie_chart_outline_rounded, 'Portfolio'),
              const SizedBox(width: 48), // Space for notched FAB
              _buildNavItem(2, Icons.account_balance_wallet_outlined, 'Wallet'),
              _buildNavItem(3, Icons.person_outline_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primaryLight : AppColors.grey500;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
