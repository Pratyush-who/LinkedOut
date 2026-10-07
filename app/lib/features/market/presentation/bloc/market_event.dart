import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class MarketFetchDataEvent extends MarketEvent {
  final bool isRefresh;

  const MarketFetchDataEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class MarketChangeCategoryEvent extends MarketEvent {
  final String category;

  const MarketChangeCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class MarketSearchQueryChangedEvent extends MarketEvent {
  final String query;

  const MarketSearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class MarketFetchAssetDetailEvent extends MarketEvent {
  final String symbol;

  const MarketFetchAssetDetailEvent(this.symbol);

  @override
  List<Object?> get props => [symbol];
}
