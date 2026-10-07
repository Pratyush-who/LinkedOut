class TradeResponseModel {
  final String orderId;
  final String status;
  final String type; // 'BUY' or 'SELL'
  final String assetId;
  final String? symbol;
  final double quantity;
  final double executionPrice;
  final double totalAmount;
  final String timestamp;

  TradeResponseModel({
    required this.orderId,
    required this.status,
    required this.type,
    required this.assetId,
    this.symbol,
    required this.quantity,
    required this.executionPrice,
    required this.totalAmount,
    required this.timestamp,
  });

  factory TradeResponseModel.fromJson(Map<String, dynamic> json) {
    return TradeResponseModel(
      orderId: json['orderId']?.toString() ?? 'ord-${DateTime.now().millisecondsSinceEpoch}',
      status: json['status']?.toString() ?? 'COMPLETED',
      type: json['type']?.toString() ?? 'BUY',
      assetId: json['assetId']?.toString() ?? '',
      symbol: json['symbol']?.toString(),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      executionPrice: (json['executionPrice'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'type': type,
      'assetId': assetId,
      'symbol': symbol,
      'quantity': quantity,
      'executionPrice': executionPrice,
      'totalAmount': totalAmount,
      'timestamp': timestamp,
    };
  }
}
