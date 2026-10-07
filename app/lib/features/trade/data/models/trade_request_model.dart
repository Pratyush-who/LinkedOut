class TradeRequestModel {
  final String assetId;
  final double quantity;

  TradeRequestModel({
    required this.assetId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'quantity': quantity,
    };
  }
}
