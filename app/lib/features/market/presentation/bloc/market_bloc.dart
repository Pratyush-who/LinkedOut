import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/asset_model.dart';
import '../../data/models/market_trend_model.dart';
import '../../data/repositories/market_repository.dart';
import 'market_event.dart';
import 'market_state.dart';

export 'market_event.dart';
export 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository marketRepository;

  MarketBloc({required this.marketRepository}) : super(const MarketState()) {
    on<MarketFetchDataEvent>(_onFetchData);
    on<MarketChangeCategoryEvent>(_onChangeCategory);
    on<MarketSearchQueryChangedEvent>(_onSearchQueryChanged);
    on<MarketFetchAssetDetailEvent>(_onFetchAssetDetail);
  }

  Future<void> _onFetchData(
    MarketFetchDataEvent event,
    Emitter<MarketState> emit,
  ) async {
    if (!event.isRefresh && state.assets.isNotEmpty) {
      // background refresh without showing full loader
    } else {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    try {
      final results = await Future.wait([
        marketRepository.getAssets(),
        marketRepository.getMarketTrend(),
      ]);

      emit(state.copyWith(
        assets: results[0] as List<AssetModel>,
        marketTrend: results[1] as MarketTrendModel,
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

  void _onChangeCategory(
    MarketChangeCategoryEvent event,
    Emitter<MarketState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onSearchQueryChanged(
    MarketSearchQueryChangedEvent event,
    Emitter<MarketState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onFetchAssetDetail(
    MarketFetchAssetDetailEvent event,
    Emitter<MarketState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final asset = await marketRepository.getAssetBySymbol(event.symbol);
      emit(state.copyWith(
        selectedAsset: asset,
        isLoading: false,
        clearError: true,
      ));
    } catch (e) {
      final cached = state.assets.firstWhere(
        (a) => a.symbol.toUpperCase() == event.symbol.toUpperCase(),
        orElse: () => state.assets.isNotEmpty
            ? state.assets.first
            : AssetModel(id: '0', symbol: event.symbol, name: event.symbol, currentPrice: 0),
      );
      emit(state.copyWith(
        selectedAsset: cached,
        isLoading: false,
      ));
    }
  }
}
