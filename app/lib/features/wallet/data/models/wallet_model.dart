class LedgerEntryModel {
  final String id;
  final String type; // 'DEPOSIT', 'WITHDRAWAL', 'TRADE_BUY', 'TRADE_SELL'
  final double amount;
  final String description;
  final String timestamp;
  final String status; // 'COMPLETED', 'PENDING', 'FAILED'

  LedgerEntryModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
  });

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) {
    return LedgerEntryModel(
      id: json['id']?.toString() ?? 'tx-${DateTime.now().millisecondsSinceEpoch}',
      type: json['type']?.toString().toUpperCase() ?? 'TRANSACTION',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? 'Transaction',
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
      status: json['status']?.toString() ?? 'COMPLETED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': timestamp,
      'status': status,
    };
  }

  bool get isCredit => type == 'DEPOSIT' || type == 'TRADE_SELL';
}

class WalletDetailsModel {
  final String? id;
  final double balance;
  final String currency;
  final String? updatedAt;

  WalletDetailsModel({
    this.id,
    required this.balance,
    this.currency = 'USD',
    this.updatedAt,
  });

  factory WalletDetailsModel.fromJson(Map<String, dynamic> json) {
    return WalletDetailsModel(
      id: json['id']?.toString(),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'currency': currency,
      'updatedAt': updatedAt,
    };
  }
}

class WalletResponseModel {
  final WalletDetailsModel wallet;
  final List<LedgerEntryModel> ledger;

  WalletResponseModel({
    required this.wallet,
    required this.ledger,
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    final walletJson = json['wallet'] as Map<String, dynamic>? ?? {};
    final ledgerList = json['ledger'] as List? ?? [];

    return WalletResponseModel(
      wallet: WalletDetailsModel.fromJson(walletJson),
      ledger: ledgerList
          .map((e) => LedgerEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
