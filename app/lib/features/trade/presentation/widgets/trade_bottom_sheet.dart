import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/asset_avatar.dart';
import '../../../market/data/models/asset_model.dart';
import '../../../portfolio/presentation/bloc/portfolio_bloc.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../bloc/trade_bloc.dart';

class TradeBottomSheet extends StatefulWidget {
  final AssetModel asset;
  final bool initialIsBuy;

  const TradeBottomSheet({
    super.key,
    required this.asset,
    this.initialIsBuy = true,
  });

  static Future<void> show(
    BuildContext context, {
    required AssetModel asset,
    bool isBuy = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => TradeBottomSheet(
        asset: asset,
        initialIsBuy: isBuy,
      ),
    );
  }

  @override
  State<TradeBottomSheet> createState() => _TradeBottomSheetState();
}

class _TradeBottomSheetState extends State<TradeBottomSheet> {
  late bool _isBuy;
  final TextEditingController _quantityController = TextEditingController();
  double _quantity = 1.0;

  @override
  void initState() {
    super.initState();
    _isBuy = widget.initialIsBuy;
    _quantityController.text = '1.0';
    _quantityController.addListener(_onQuantityChanged);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _onQuantityChanged() {
    final parsed = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    if (parsed != _quantity) {
      setState(() {
        _quantity = parsed;
      });
    }
  }

  void _setPercentage(double fraction, double maxAvailable) {
    final qty = (maxAvailable * fraction);
    setState(() {
      _quantity = double.parse(qty.toStringAsFixed(4));
      _quantityController.text = _quantity.toString();
    });
  }

  void _submitTrade(BuildContext context, WalletState walletState, PortfolioState portfolioState) {
    if (_quantity <= 0) {
      UiHelpers.showSnackBar(context, 'Please enter a valid quantity', isError: true);
      return;
    }

    final totalCost = _quantity * widget.asset.currentPrice;

    if (_isBuy && totalCost > walletState.balance) {
      UiHelpers.showSnackBar(
        context,
        'Insufficient wallet balance (${CurrencyFormatter.format(walletState.balance)})',
        isError: true,
      );
      return;
    }

    final holdings = portfolioState.holdings.where(
      (h) =>
          h.assetId == widget.asset.id ||
          h.symbol.toUpperCase() == widget.asset.symbol.toUpperCase(),
    );
    final holding = holdings.isNotEmpty ? holdings.first : null;

    if (!_isBuy) {
      final ownedQty = holding?.quantity ?? 0.0;
      if (_quantity > ownedQty) {
        UiHelpers.showSnackBar(
          context,
          'You only own $ownedQty ${widget.asset.symbol}',
          isError: true,
        );
        return;
      }
    }

    FocusScope.of(context).unfocus();

    context.read<TradeBloc>().add(
          TradeExecuteEvent(
            assetId: widget.asset.id,
            quantity: _quantity,
            isBuy: _isBuy,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TradeBloc, TradeState>(
      listener: (context, tradeState) {
        if (tradeState.isSuccess) {
          context.read<WalletBloc>().add(const WalletFetchEvent(isRefresh: true));
          context.read<PortfolioBloc>().add(const PortfolioFetchEvent(isRefresh: true));

          Navigator.pop(context);
          UiHelpers.showSnackBar(
            context,
            '${_isBuy ? "Bought" : "Sold"} $_quantity ${widget.asset.symbol} successfully!',
            isSuccess: true,
          );
          context.read<TradeBloc>().add(const TradeResetEvent());
        } else if (tradeState.isFailure) {
          UiHelpers.showSnackBar(
            context,
            tradeState.errorMessage ?? 'Failed to execute trade',
            isError: true,
          );
          context.read<TradeBloc>().add(const TradeResetEvent());
        }
      },
      builder: (context, tradeState) {
        final walletState = context.watch<WalletBloc>().state;
        final portfolioState = context.watch<PortfolioBloc>().state;

        final holdings = portfolioState.holdings.where(
          (h) =>
              h.assetId == widget.asset.id ||
              h.symbol.toUpperCase() == widget.asset.symbol.toUpperCase(),
        );
        final holding = holdings.isNotEmpty ? holdings.first : null;
        final ownedQty = holding?.quantity ?? 0.0;

        final totalEstimated = _quantity * widget.asset.currentPrice;
        final primaryActionColor = _isBuy ? AppColors.green : AppColors.red;

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
              // Drag handle
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

              // Header Asset Info
              Row(
                children: [
                  AssetAvatar(symbol: widget.asset.symbol, iconUrl: widget.asset.iconUrl, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.asset.name} (${widget.asset.symbol})',
                          style: GoogleFonts.sora(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Current Price: ${CurrencyFormatter.format(widget.asset.currentPrice)}',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Buy / Sell Switcher Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isBuy = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isBuy ? AppColors.green : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'BUY',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: _isBuy ? Colors.black : AppColors.grey400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isBuy = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isBuy ? AppColors.red : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'SELL',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: !_isBuy ? Colors.white : AppColors.grey400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quantity Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quantity',
                      style: GoogleFonts.inter(color: AppColors.grey400, fontSize: 13)),
                  Text(
                    _isBuy
                        ? 'Avail: ${CurrencyFormatter.format(walletState.balance)}'
                        : 'Holding: $ownedQty ${widget.asset.symbol}',
                    style: GoogleFonts.inter(
                        color: AppColors.primaryLight, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style:
                    GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                decoration: InputDecoration(
                  suffixText: widget.asset.symbol,
                  suffixStyle:
                      GoogleFonts.inter(color: AppColors.grey400, fontWeight: FontWeight.w600),
                  prefixIcon: const Icon(Icons.calculate_outlined, color: AppColors.grey500),
                ),
              ),
              const SizedBox(height: 12),

              // Quick Percentage Presets
              Row(
                children: [0.25, 0.50, 0.75, 1.0].map((fraction) {
                  final label = '${(fraction * 100).toInt()}%';
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
                          if (_isBuy) {
                            final maxQty = widget.asset.currentPrice > 0
                                ? (walletState.balance / widget.asset.currentPrice)
                                : 0.0;
                            _setPercentage(fraction, maxQty);
                          } else {
                            _setPercentage(fraction, ownedQty);
                          }
                        },
                        child: Text(
                          label,
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey300),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Total Calculation Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isBuy ? 'Estimated Total Cost' : 'Estimated Total Proceeds',
                      style: GoogleFonts.inter(color: AppColors.grey400, fontSize: 13),
                    ),
                    Text(
                      CurrencyFormatter.format(totalEstimated),
                      style: GoogleFonts.sora(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryActionColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Order CTA
              ElevatedButton(
                onPressed: tradeState.isExecuting
                    ? null
                    : () => _submitTrade(context, walletState, portfolioState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryActionColor,
                  foregroundColor: _isBuy ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: tradeState.isExecuting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        '${_isBuy ? "Confirm Buy" : "Confirm Sell"} ${widget.asset.symbol}',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
