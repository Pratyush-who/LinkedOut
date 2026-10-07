class MarketTrendModel {
  final double currentTrend;
  final bool isMarketDip;
  final String status; // 'NORMAL' or 'CRASH'
  final int? sentimentScore;
  final String? marketStatusText;

  MarketTrendModel({
    required this.currentTrend,
    required this.isMarketDip,
    required this.status,
    this.sentimentScore,
    this.marketStatusText,
  });

  factory MarketTrendModel.fromJson(Map<String, dynamic> json) {
    return MarketTrendModel(
      currentTrend: (json['currentTrend'] as num?)?.toDouble() ?? 0.0,
      isMarketDip: json['isMarketDip'] ?? false,
      status: json['status']?.toString() ?? 'NORMAL',
      sentimentScore: json['sentimentScore'] as int?,
      marketStatusText: json['marketStatusText']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentTrend': currentTrend,
      'isMarketDip': isMarketDip,
      'status': status,
      'sentimentScore': sentimentScore,
      'marketStatusText': marketStatusText,
    };
  }

  bool get isCrash => status.toUpperCase() == 'CRASH' || isMarketDip;
}
