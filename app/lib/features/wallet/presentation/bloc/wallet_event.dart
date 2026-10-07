import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletFetchEvent extends WalletEvent {
  final bool isRefresh;

  const WalletFetchEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class WalletDepositEvent extends WalletEvent {
  final double amount;

  const WalletDepositEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class WalletFilterChangedEvent extends WalletEvent {
  final String filter;

  const WalletFilterChangedEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
