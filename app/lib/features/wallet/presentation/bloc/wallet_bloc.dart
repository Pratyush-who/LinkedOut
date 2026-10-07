import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/mock_data_interceptor.dart';
import '../../data/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

export 'wallet_event.dart';
export 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({required this.walletRepository}) : super(const WalletState()) {
    on<WalletFetchEvent>(_onFetchWallet);
    on<WalletDepositEvent>(_onDeposit);
    on<WalletFilterChangedEvent>(_onFilterChanged);
  }

  Future<void> _onFetchWallet(
    WalletFetchEvent event,
    Emitter<WalletState> emit,
  ) async {
    if (!event.isRefresh && state.wallet != null) {
      // background refresh
    } else {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    try {
      final data = await walletRepository.getWalletDetails();
      emit(state.copyWith(
        wallet: data.wallet,
        ledger: data.ledger,
        isLoading: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeposit(
    WalletDepositEvent event,
    Emitter<WalletState> emit,
  ) async {
    MockDataInterceptor.depositMockFunds(event.amount);
    add(const WalletFetchEvent(isRefresh: true));
  }

  void _onFilterChanged(
    WalletFilterChangedEvent event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }
}
