import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/portfolio_repository.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

export 'portfolio_event.dart';
export 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository portfolioRepository;

  PortfolioBloc({required this.portfolioRepository}) : super(const PortfolioState()) {
    on<PortfolioFetchEvent>(_onFetchPortfolio);
  }

  Future<void> _onFetchPortfolio(
    PortfolioFetchEvent event,
    Emitter<PortfolioState> emit,
  ) async {
    if (!event.isRefresh && state.snapshot != null) {
      // background refresh
    } else {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    try {
      final data = await portfolioRepository.getPortfolioSnapshot();
      emit(state.copyWith(
        snapshot: data,
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
}
