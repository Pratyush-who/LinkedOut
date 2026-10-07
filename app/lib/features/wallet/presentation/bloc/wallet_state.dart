import 'package:equatable/equatable.dart';
import '../../data/models/wallet_model.dart';

class WalletState extends Equatable {
  final WalletDetailsModel? wallet;
  final List<LedgerEntryModel> ledger;
  final bool isLoading;
  final String? errorMessage;
  final String selectedFilter;

  const WalletState({
    this.wallet,
    this.ledger = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedFilter = 'ALL',
  });

  double get balance => wallet?.balance ?? 0.0;
  String get currency => wallet?.currency ?? 'USD';

  List<LedgerEntryModel> get filteredLedger {
    if (selectedFilter == 'ALL') return ledger;
    if (selectedFilter == 'DEPOSITS') {
      return ledger.where((e) => e.type == 'DEPOSIT').toList();
    }
    if (selectedFilter == 'WITHDRAWALS') {
      return ledger.where((e) => e.type == 'WITHDRAWAL').toList();
    }
    if (selectedFilter == 'TRADES') {
      return ledger.where((e) => e.type == 'TRADE_BUY' || e.type == 'TRADE_SELL').toList();
    }
    return ledger;
  }

  WalletState copyWith({
    WalletDetailsModel? wallet,
    List<LedgerEntryModel>? ledger,
    bool? isLoading,
    String? errorMessage,
    String? selectedFilter,
    bool clearError = false,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      ledger: ledger ?? this.ledger,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [
        wallet,
        ledger,
        isLoading,
        errorMessage,
        selectedFilter,
      ];
}
