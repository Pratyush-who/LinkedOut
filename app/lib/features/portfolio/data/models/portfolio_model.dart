class PortfolioHoldingModel {
  final String assetId;
  final String symbol;
  final String name;
  final double quantity;
  final double avgBuyPrice;
  final double currentPrice;
  final double currentValue;
  final double gainLoss;
  final double gainLossPercentage;
  final String? category;
  final String? iconUrl;

  PortfolioHoldingModel({
    required this.assetId,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.avgBuyPrice,
    required this.currentPrice,
    required this.currentValue,
    required this.gainLoss,
    required this.gainLossPercentage,
    this.category,
    this.iconUrl,
  });

  factory PortfolioHoldingModel.fromJson(Map<String, dynamic> json) {
    return PortfolioHoldingModel(
      assetId: json['assetId']?.toString() ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? 'N/A',
      name: json['name']?.toString() ?? json['symbol']?.toString() ?? 'Asset',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      avgBuyPrice: (json['avgBuyPrice'] as num?)?.toDouble() ?? 0.0,
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      gainLoss: (json['gainLoss'] as num?)?.toDouble() ?? 0.0,
      gainLossPercentage: (json['gainLossPercentage'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? 'Crypto',
      iconUrl: json['iconUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'symbol': symbol,
      'name': name,
      'quantity': quantity,
      'avgBuyPrice': avgBuyPrice,
      'currentPrice': currentPrice,
      'currentValue': currentValue,
      'gainLoss': gainLoss,
      'gainLossPercentage': gainLossPercentage,
      'category': category,
      'iconUrl': iconUrl,
    };
  }
}

class PortfolioSnapshotModel {
  final double totalValue;
  final double totalInvested;
  final double totalGainLoss;
  final double totalGainLossPercentage;
  final List<PortfolioHoldingModel> holdings;
  final String? updatedAt;

  PortfolioSnapshotModel({
    required this.totalValue,
    required this.totalInvested,
    required this.totalGainLoss,
    required this.totalGainLossPercentage,
    required this.holdings,
    this.updatedAt,
  });

  factory PortfolioSnapshotModel.fromJson(Map<String, dynamic> json) {
    final holdingsJson = json['holdings'] as List? ?? [];
    return PortfolioSnapshotModel(
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
      totalInvested: (json['totalInvested'] as num?)?.toDouble() ?? 0.0,
      totalGainLoss: (json['totalGainLoss'] as num?)?.toDouble() ?? 0.0,
      totalGainLossPercentage: (json['totalGainLossPercentage'] as num?)?.toDouble() ?? 0.0,
      holdings: holdingsJson
          .map((e) => PortfolioHoldingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalValue': totalValue,
      'totalInvested': totalInvested,
      'totalGainLoss': totalGainLoss,
      'totalGainLossPercentage': totalGainLossPercentage,
      'holdings': holdings.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt,
    };
  }
}
