import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/glass_container.dart';
import '../bloc/wallet_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletBloc>().add(const WalletFetchEvent());
    });
  }

  void _showDepositModal() {
    final amountController = TextEditingController(text: '5000');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: Color(0xFF262C3A), width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'DEPOSIT FUNDS',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Add simulated balance instantly to your Olympus trading wallet.',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey400),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                prefixStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                labelText: 'Amount (USD)',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [1000, 5000, 10000, 25000].map((amt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        amountController.text = amt.toString();
                      },
                      child: Text(
                        '+\$${CurrencyFormatter.formatCompact(amt).replaceAll('\$', '')}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey300),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(amountController.text.trim()) ?? 0.0;
                if (amt <= 0) {
                  UiHelpers.showSnackBar(context, 'Enter a valid amount', isError: true);
                  return;
                }
                Navigator.pop(modalContext);
                context.read<WalletBloc>().add(WalletDepositEvent(amt));
                UiHelpers.showSnackBar(
                  context,
                  'Deposited ${CurrencyFormatter.format(amt)} successfully!',
                  isSuccess: true,
                );
              },
              child: const Text('Confirm Deposit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'WALLET',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.grey300),
                onPressed: () => context.read<WalletBloc>().add(const WalletFetchEvent(isRefresh: true)),
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
              context.read<WalletBloc>().add(const WalletFetchEvent(isRefresh: true));
            },
            color: AppColors.primaryLight,
            backgroundColor: AppColors.surface,
            child: walletState.isLoading && walletState.wallet == null
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryLight))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    children: [
                      // Sleek Obsidian Digital Card
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A1B4E), Color(0xFF161A22), Color(0xFF0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.primaryLight.withOpacity(0.3), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.blur_on_rounded, color: AppColors.primaryLight, size: 24),
                                    const SizedBox(width: 8),
                                    Text(
                                      'OLYMPUS PRIME',
                                      style: GoogleFonts.sora(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.contactless_rounded, color: AppColors.grey400, size: 24),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AVAILABLE BALANCE',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                    color: AppColors.grey400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(walletState.balance),
                                  style: GoogleFonts.sora(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '•••• •••• •••• 8842',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    letterSpacing: 2,
                                    color: AppColors.grey400,
                                  ),
                                ),
                                Text(
                                  walletState.currency,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons (Deposit / Withdraw)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showDepositModal,
                              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                              label: const Text('Deposit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                UiHelpers.showSnackBar(context, 'Withdrawals are currently simulated.');
                              },
                              icon: const Icon(Icons.arrow_upward_rounded, size: 18, color: Colors.white),
                              label: Text('Withdraw', style: GoogleFonts.inter(color: Colors.white)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: Color(0xFF262C3A)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Ledger & Filter Tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TRANSACTION LEDGER',
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

                      // Filter Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['ALL', 'DEPOSITS', 'WITHDRAWALS', 'TRADES'].map((f) {
                            final isSelected = walletState.selectedFilter == f;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(f),
                                selected: isSelected,
                                onSelected: (_) =>
                                    context.read<WalletBloc>().add(WalletFilterChangedEvent(f)),
                                backgroundColor: AppColors.surface,
                                selectedColor: AppColors.surfaceElevated,
                                side: BorderSide(
                                  color: isSelected ? AppColors.primaryLight : const Color(0xFF262C3A),
                                ),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primaryLight : AppColors.grey400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ledger Items List
                      if (walletState.filteredLedger.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.grey600),
                              const SizedBox(height: 12),
                              Text('No transactions found in this view',
                                  style: GoogleFonts.inter(color: AppColors.grey400)),
                            ],
                          ),
                        ),
                      ] else ...[
                        ...walletState.filteredLedger.map((tx) {
                          final isCredit = tx.isCredit;
                          final sign = isCredit ? '+' : '-';
                          final color = isCredit ? AppColors.green : AppColors.white;

                          return GlassContainer(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: (isCredit ? AppColors.green : AppColors.primary).withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isCredit ? Icons.arrow_downward_rounded : Icons.swap_horiz_rounded,
                                    color: isCredit ? AppColors.green : AppColors.primaryLight,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        DateFormatter.formatTimestamp(tx.timestamp),
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$sign${CurrencyFormatter.format(tx.amount)}',
                                      style: GoogleFonts.sora(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        tx.status,
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey400,
                                        ),
                                      ),
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
