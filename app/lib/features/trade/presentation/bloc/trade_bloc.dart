import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/trade_request_model.dart';
import '../../data/repositories/trade_repository.dart';
import 'trade_event.dart';
import 'trade_state.dart';

export 'trade_event.dart';
export 'trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  final TradeRepository tradeRepository;

  TradeBloc({required this.tradeRepository}) : super(const TradeState()) {
    on<TradeExecuteEvent>(_onExecuteTrade);
    on<TradeResetEvent>(_onResetTrade);
  }

  Future<void> _onExecuteTrade(
    TradeExecuteEvent event,
    Emitter<TradeState> emit,
  ) async {
    emit(state.copyWith(
      status: TradeStatus.executing,
      clearError: true,
      clearResponse: true,
    ));

    try {
      final request = TradeRequestModel(
        assetId: event.assetId,
        quantity: event.quantity,
      );

      final response = event.isBuy
          ? await tradeRepository.buyAsset(request)
          : await tradeRepository.sellAsset(request);

      emit(state.copyWith(
        status: TradeStatus.success,
        lastTradeResponse: response,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TradeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetTrade(
    TradeResetEvent event,
    Emitter<TradeState> emit,
  ) {
    emit(const TradeState());
  }
}
