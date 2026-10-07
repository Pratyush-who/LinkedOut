import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class PortfolioFetchEvent extends PortfolioEvent {
  final bool isRefresh;

  const PortfolioFetchEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}
