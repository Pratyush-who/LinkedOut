import 'package:equatable/equatable.dart';

abstract class TradeEvent extends Equatable {
  const TradeEvent();

  @override
  List<Object?> get props => [];
}

class TradeExecuteEvent extends TradeEvent {
  final String assetId;
  final double quantity;
  final bool isBuy;

  const TradeExecuteEvent({
    required this.assetId,
    required this.quantity,
    required this.isBuy,
  });

  @override
  List<Object?> get props => [assetId, quantity, isBuy];
}

class TradeResetEvent extends TradeEvent {
  const TradeResetEvent();
}
