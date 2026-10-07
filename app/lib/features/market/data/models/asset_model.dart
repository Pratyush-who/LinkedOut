class AssetModel {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double change24h;
  final double change24hPercentage;
  final double? high24h;
  final double? low24h;
  final double? volume24h;
  final double? marketCap;
  final String? category;
  final String? iconUrl;
  final String? description;
  final List<double> sparkline;

  AssetModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    this.change24h = 0.0,
    this.change24hPercentage = 0.0,
    this.high24h,
    this.low24h,
    this.volume24h,
    this.marketCap,
    this.category,
    this.iconUrl,
    this.description,
    this.sparkline = const [],
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    List<double> parsedSparkline = [];
    if (json['sparkline'] is List) {
      parsedSparkline = (json['sparkline'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    } else {
      // Generate realistic minor fluctuation points if missing
      final price = (json['currentPrice'] as num?)?.toDouble() ?? 100.0;
      final change = (json['change24hPercentage'] as num?)?.toDouble() ?? 0.0;
      final start = price / (1 + (change / 100));
      parsedSparkline = [
        start,
        start * 1.01,
        start * 0.995,
        start * 1.015,
        start * 1.008,
        price * 0.998,
        price,
      ];
    }

    return AssetModel(
      id: json['id']?.toString() ?? json['symbol']?.toString().toLowerCase() ?? 'asset',
      symbol: json['symbol']?.toString().toUpperCase() ?? 'N/A',
      name: json['name']?.toString() ?? json['symbol']?.toString() ?? 'Asset',
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      change24h: (json['change24h'] as num?)?.toDouble() ?? 0.0,
      change24hPercentage: (json['change24hPercentage'] as num?)?.toDouble() ?? 0.0,
      high24h: (json['high24h'] as num?)?.toDouble(),
      low24h: (json['low24h'] as num?)?.toDouble(),
      volume24h: (json['volume24h'] as num?)?.toDouble(),
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      category: json['category']?.toString() ?? 'Crypto',
      iconUrl: json['iconUrl']?.toString(),
      description: json['description']?.toString(),
      sparkline: parsedSparkline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'currentPrice': currentPrice,
      'change24h': change24h,
      'change24hPercentage': change24hPercentage,
      'high24h': high24h,
      'low24h': low24h,
      'volume24h': volume24h,
      'marketCap': marketCap,
      'category': category,
      'iconUrl': iconUrl,
      'description': description,
      'sparkline': sparkline,
    };
  }
}
