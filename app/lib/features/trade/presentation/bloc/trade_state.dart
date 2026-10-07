import 'package:equatable/equatable.dart';
import '../../data/models/trade_response_model.dart';

enum TradeStatus { initial, executing, success, failure }

class TradeState extends Equatable {
  final TradeStatus status;
  final TradeResponseModel? lastTradeResponse;
  final String? errorMessage;

  const TradeState({
    this.status = TradeStatus.initial,
    this.lastTradeResponse,
    this.errorMessage,
  });

  bool get isExecuting => status == TradeStatus.executing;
  bool get isSuccess => status == TradeStatus.success;
  bool get isFailure => status == TradeStatus.failure;

  TradeState copyWith({
    TradeStatus? status,
    TradeResponseModel? lastTradeResponse,
    String? errorMessage,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return TradeState(
      status: status ?? this.status,
      lastTradeResponse: clearResponse ? null : (lastTradeResponse ?? this.lastTradeResponse),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, lastTradeResponse, errorMessage];
}
