import 'package:equatable/equatable.dart';
import '../../data/models/asset_model.dart';
import '../../data/models/market_trend_model.dart';

class MarketState extends Equatable {
  final List<AssetModel> assets;
  final MarketTrendModel? marketTrend;
  final AssetModel? selectedAsset;
  final String selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const MarketState({
    this.assets = const [],
    this.marketTrend,
    this.selectedAsset,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  List<AssetModel> get filteredAssets {
    return assets.where((asset) {
      final matchesCategory = selectedCategory == 'All' ||
          (asset.category != null &&
              asset.category!.toLowerCase() == selectedCategory.toLowerCase());

      final matchesSearch = searchQuery.isEmpty ||
          asset.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          asset.symbol.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<AssetModel> get topGainers {
    final list = List<AssetModel>.from(assets);
    list.sort((a, b) => b.change24hPercentage.compareTo(a.change24hPercentage));
    return list.take(3).toList();
  }

  MarketState copyWith({
    List<AssetModel>? assets,
    MarketTrendModel? marketTrend,
    AssetModel? selectedAsset,
    String? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearSelectedAsset = false,
  }) {
    return MarketState(
      assets: assets ?? this.assets,
      marketTrend: marketTrend ?? this.marketTrend,
      selectedAsset: clearSelectedAsset ? null : (selectedAsset ?? this.selectedAsset),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        assets,
        marketTrend,
        selectedAsset,
        selectedCategory,
        searchQuery,
        isLoading,
        errorMessage,
      ];
}
