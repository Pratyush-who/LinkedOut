import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';

class MockDataInterceptor extends Interceptor {
  // In-memory mock state for smooth dynamic interaction
  static double _mockWalletBalance = 25000.00;
  static final List<Map<String, dynamic>> _mockLedger = [
    {
      'id': 'tx-101',
      'type': 'DEPOSIT',
      'amount': 25000.00,
      'description': 'Initial Welcome Deposit',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'status': 'COMPLETED',
    },
  ];

  static final List<Map<String, dynamic>> _mockHoldings = [
    {
      'assetId': 'bitcoin',
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'quantity': 0.35,
      'avgBuyPrice': 62500.0,
      'currentPrice': 67450.0,
      'currentValue': 23607.5,
      'gainLoss': 1732.5,
      'gainLossPercentage': 7.92,
      'category': 'Crypto',
      'iconUrl': 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
    },
    {
      'assetId': 'ethereum',
      'symbol': 'ETH',
      'name': 'Ethereum',
      'quantity': 2.5,
      'avgBuyPrice': 3100.0,
      'currentPrice': 3480.0,
      'currentValue': 8700.0,
      'gainLoss': 950.0,
      'gainLossPercentage': 12.26,
      'category': 'Crypto',
      'iconUrl': 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
    },
    {
      'assetId': 'solana',
      'symbol': 'SOL',
      'name': 'Solana',
      'quantity': 18.0,
      'avgBuyPrice': 135.0,
      'currentPrice': 152.4,
      'currentValue': 2743.2,
      'gainLoss': 313.2,
      'gainLossPercentage': 12.89,
      'category': 'Crypto',
      'iconUrl': 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
    },
    {
      'assetId': 'nvidia',
      'symbol': 'NVDA',
      'name': 'NVIDIA Corp',
      'quantity': 12.0,
      'avgBuyPrice': 118.0,
      'currentPrice': 124.5,
      'currentValue': 1494.0,
      'gainLoss': 78.0,
      'gainLossPercentage': 5.51,
      'category': 'Stocks',
      'iconUrl': 'https://logo.clearbit.com/nvidia.com',
    },
  ];

  static final List<Map<String, dynamic>> _mockAssets = [
    {
      'id': 'bitcoin',
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'currentPrice': 67450.00,
      'change24h': 2140.50,
      'change24hPercentage': 3.28,
      'high24h': 68200.00,
      'low24h': 65100.00,
      'volume24h': 34298100234.0,
      'marketCap': 1324890200000.0,
      'category': 'Crypto',
      'iconUrl': 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      'description': 'The world\'s premier decentralized digital currency and store of value.',
      'sparkline': [64900.0, 65200.0, 65050.0, 66100.0, 65900.0, 67200.0, 67450.0],
    },
    {
      'id': 'ethereum',
      'symbol': 'ETH',
      'name': 'Ethereum',
      'currentPrice': 3480.00,
      'change24h': 145.20,
      'change24hPercentage': 4.35,
      'high24h': 3520.00,
      'low24h': 3310.00,
      'volume24h': 18920100450.0,
      'marketCap': 418290100000.0,
      'category': 'Crypto',
      'iconUrl': 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      'description': 'Open-source, decentralized blockchain with smart contract functionality.',
      'sparkline': [3310.0, 3340.0, 3380.0, 3420.0, 3390.0, 3460.0, 3480.0],
    },
    {
      'id': 'solana',
      'symbol': 'SOL',
      'name': 'Solana',
      'currentPrice': 152.40,
      'change24h': -3.80,
      'change24hPercentage': -2.43,
      'high24h': 158.90,
      'low24h': 149.20,
      'volume24h': 4280190000.0,
      'marketCap': 71200000000.0,
      'category': 'Crypto',
      'iconUrl': 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
      'description': 'High-throughput blockchain designed for fast, decentralized apps and crypto.',
      'sparkline': [158.0, 156.5, 155.0, 153.0, 150.8, 151.2, 152.4],
    },
    {
      'id': 'apple',
      'symbol': 'AAPL',
      'name': 'Apple Inc.',
      'currentPrice': 228.30,
      'change24h': 3.45,
      'change24hPercentage': 1.53,
      'high24h': 230.10,
      'low24h': 225.40,
      'volume24h': 62100800.0,
      'marketCap': 3490000000000.0,
      'category': 'Stocks',
      'iconUrl': 'https://logo.clearbit.com/apple.com',
      'description': 'Global consumer electronics, software, and online services giant.',
      'sparkline': [225.0, 226.2, 226.0, 227.4, 228.0, 227.8, 228.3],
    },
    {
      'id': 'nvidia',
      'symbol': 'NVDA',
      'name': 'NVIDIA Corp',
      'currentPrice': 124.50,
      'change24h': 6.20,
      'change24hPercentage': 5.24,
      'high24h': 126.00,
      'low24h': 117.80,
      'volume24h': 105400900.0,
      'marketCap': 3060000000000.0,
      'category': 'Stocks',
      'iconUrl': 'https://logo.clearbit.com/nvidia.com',
      'description': 'Pioneer of GPU-accelerated computing and artificial intelligence chips.',
      'sparkline': [118.0, 119.5, 121.0, 120.4, 122.8, 123.9, 124.5],
    },
    {
      'id': 'gold',
      'symbol': 'XAU',
      'name': 'Gold Spot',
      'currentPrice': 2658.20,
      'change24h': 14.80,
      'change24hPercentage': 0.56,
      'high24h': 2665.00,
      'low24h': 2640.00,
      'volume24h': 8900000000.0,
      'marketCap': 16500000000000.0,
      'category': 'Commodities',
      'iconUrl': 'https://cdn-icons-png.flaticon.com/512/2583/2583344.png',
      'description': 'Traditional global safe-haven asset and precious metal store of value.',
      'sparkline': [2642.0, 2645.0, 2650.0, 2648.0, 2654.0, 2656.0, 2658.2],
    },
  ];

  static Map<String, dynamic> generateMockResponse(RequestOptions options) {
    final path = options.path;
    final method = options.method.toUpperCase();

    // 1. Auth: request-otp
    if (path.contains(ApiEndpoints.requestOtp)) {
      final phone = options.data is Map ? options.data['phone'] ?? '+1234567890' : '+1234567890';
      return {
        'message': 'OTP sent successfully to $phone',
        'otp': '123456',
        'phone': phone,
      };
    }

    // 2. Auth: verify-otp
    if (path.contains(ApiEndpoints.verifyOtp)) {
      final phone = options.data is Map ? options.data['phone'] ?? '+1234567890' : '+1234567890';
      return {
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'isNewUser': false,
        'phone': phone,
        'username': 'olympian_trader',
        'displayName': 'Alex Vance',
        'profilePhotoUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
        'onboardingComplete': true,
      };
    }

    // 3. Auth: onboard
    if (path.contains(ApiEndpoints.onboard)) {
      final data = options.data is Map ? options.data : {};
      return {
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'isNewUser': false,
        'phone': data['phone'] ?? '+1234567890',
        'username': data['username'] ?? 'trader_one',
        'displayName': data['displayName'] ?? 'Trader One',
        'profilePhotoUrl': null,
        'onboardingComplete': true,
      };
    }

    // 4. Auth: profile
    if (path.contains(ApiEndpoints.profile)) {
      if (method == 'PATCH') {
        final data = options.data is Map ? options.data : {};
        return {
          'phone': options.queryParameters['phone'] ?? '+1234567890',
          'username': 'olympian_trader',
          'displayName': data['displayName'] ?? 'Alex Vance',
          'profilePhotoUrl': data['profilePhotoUrl'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
          'onboardingComplete': true,
        };
      }
      return {
        'phone': options.queryParameters['phone'] ?? '+1234567890',
        'username': 'olympian_trader',
        'displayName': 'Alex Vance',
        'profilePhotoUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
        'onboardingComplete': true,
      };
    }

    // 5. Wallet
    if (path.contains(ApiEndpoints.wallet)) {
      return {
        'wallet': {
          'id': 'w-olympus-01',
          'balance': _mockWalletBalance,
          'currency': 'USD',
          'updatedAt': DateTime.now().toIso8601String(),
        },
        'ledger': List<Map<String, dynamic>>.from(_mockLedger),
      };
    }

    // 6. Trading: Buy
    if (path.contains(ApiEndpoints.tradeBuy)) {
      final data = options.data is Map ? options.data : {};
      final assetId = (data['assetId'] ?? 'bitcoin').toString().toLowerCase();
      final quantity = (data['quantity'] as num?)?.toDouble() ?? 1.0;
      
      final asset = _mockAssets.firstWhere(
        (a) => a['id'].toString().toLowerCase() == assetId || a['symbol'].toString().toLowerCase() == assetId,
        orElse: () => _mockAssets.first,
      );
      final price = (asset['currentPrice'] as num).toDouble();
      final totalCost = price * quantity;
      
      _mockWalletBalance -= totalCost;
      _mockLedger.insert(0, {
        'id': 'tx-${DateTime.now().millisecondsSinceEpoch}',
        'type': 'TRADE_BUY',
        'amount': totalCost,
        'description': 'Bought $quantity ${asset['symbol']} @ \$${price.toStringAsFixed(2)}',
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'COMPLETED',
      });

      // Update holdings
      final existingIndex = _mockHoldings.indexWhere((h) => h['assetId'] == asset['id']);
      if (existingIndex >= 0) {
        final existing = _mockHoldings[existingIndex];
        final oldQty = (existing['quantity'] as num).toDouble();
        final oldAvg = (existing['avgBuyPrice'] as num).toDouble();
        final newQty = oldQty + quantity;
        final newAvg = ((oldQty * oldAvg) + totalCost) / newQty;
        existing['quantity'] = newQty;
        existing['avgBuyPrice'] = newAvg;
        existing['currentValue'] = newQty * price;
        existing['gainLoss'] = (price - newAvg) * newQty;
        existing['gainLossPercentage'] = ((price - newAvg) / newAvg) * 100;
      } else {
        _mockHoldings.add({
          'assetId': asset['id'],
          'symbol': asset['symbol'],
          'name': asset['name'],
          'quantity': quantity,
          'avgBuyPrice': price,
          'currentPrice': price,
          'currentValue': totalCost,
          'gainLoss': 0.0,
          'gainLossPercentage': 0.0,
          'category': asset['category'],
          'iconUrl': asset['iconUrl'],
        });
      }

      return {
        'orderId': 'ord-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'FILLED',
        'type': 'BUY',
        'assetId': asset['id'],
        'symbol': asset['symbol'],
        'quantity': quantity,
        'executionPrice': price,
        'totalAmount': totalCost,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    // 7. Trading: Sell
    if (path.contains(ApiEndpoints.tradeSell)) {
      final data = options.data is Map ? options.data : {};
      final assetId = (data['assetId'] ?? 'bitcoin').toString().toLowerCase();
      final quantity = (data['quantity'] as num?)?.toDouble() ?? 1.0;
      
      final asset = _mockAssets.firstWhere(
        (a) => a['id'].toString().toLowerCase() == assetId || a['symbol'].toString().toLowerCase() == assetId,
        orElse: () => _mockAssets.first,
      );
      final price = (asset['currentPrice'] as num).toDouble();
      final totalProceeds = price * quantity;
      
      _mockWalletBalance += totalProceeds;
      _mockLedger.insert(0, {
        'id': 'tx-${DateTime.now().millisecondsSinceEpoch}',
        'type': 'TRADE_SELL',
        'amount': totalProceeds,
        'description': 'Sold $quantity ${asset['symbol']} @ \$${price.toStringAsFixed(2)}',
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'COMPLETED',
      });

      // Update holdings
      final existingIndex = _mockHoldings.indexWhere((h) => h['assetId'] == asset['id']);
      if (existingIndex >= 0) {
        final existing = _mockHoldings[existingIndex];
        final oldQty = (existing['quantity'] as num).toDouble();
        final newQty = (oldQty - quantity).clamp(0.0, double.infinity);
        if (newQty <= 0) {
          _mockHoldings.removeAt(existingIndex);
        } else {
          existing['quantity'] = newQty;
          existing['currentValue'] = newQty * price;
          final avg = (existing['avgBuyPrice'] as num).toDouble();
          existing['gainLoss'] = (price - avg) * newQty;
          existing['gainLossPercentage'] = ((price - avg) / avg) * 100;
        }
      }

      return {
        'orderId': 'ord-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'FILLED',
        'type': 'SELL',
        'assetId': asset['id'],
        'symbol': asset['symbol'],
        'quantity': quantity,
        'executionPrice': price,
        'totalAmount': totalProceeds,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    // 8. Portfolio
    if (path.contains(ApiEndpoints.portfolio)) {
      double totalVal = 0;
      double totalInvest = 0;
      for (final h in _mockHoldings) {
        final qty = (h['quantity'] as num).toDouble();
        final curPrice = (h['currentPrice'] as num).toDouble();
        final avgPrice = (h['avgBuyPrice'] as num).toDouble();
        totalVal += qty * curPrice;
        totalInvest += qty * avgPrice;
      }
      final totalGain = totalVal - totalInvest;
      final gainPct = totalInvest > 0 ? (totalGain / totalInvest) * 100 : 0.0;

      return {
        'totalValue': totalVal,
        'totalInvested': totalInvest,
        'totalGainLoss': totalGain,
        'totalGainLossPercentage': gainPct,
        'holdings': List<Map<String, dynamic>>.from(_mockHoldings),
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }

    // 9. Market: Trend
    if (path.contains(ApiEndpoints.marketTrend)) {
      return {
        'currentTrend': 0.05,
        'isMarketDip': false,
        'status': 'NORMAL', // or 'CRASH'
        'sentimentScore': 78,
        'marketStatusText': 'Bullish Momentum across Crypto & Tech Assets',
      };
    }

    // 10. Market: Asset by Symbol
    if (path.contains('/api/v1/market/assets/')) {
      final symbol = path.split('/').last.toUpperCase();
      final asset = _mockAssets.firstWhere(
        (a) => a['symbol'].toString().toUpperCase() == symbol || a['id'].toString().toUpperCase() == symbol,
        orElse: () => _mockAssets.first,
      );
      return asset;
    }

    // 11. Market: Assets list
    if (path.contains(ApiEndpoints.marketAssets) || path.contains(ApiEndpoints.allAssets)) {
      return {
        'assets': List<Map<String, dynamic>>.from(_mockAssets),
      };
    }

    return {'message': 'Success (Mock)', 'status': 200};
  }

  // Method to add demo funds into wallet for rich testing
  static void depositMockFunds(double amount) {
    _mockWalletBalance += amount;
    _mockLedger.insert(0, {
      'id': 'tx-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'DEPOSIT',
      'amount': amount,
      'description': 'Direct Instant Deposit',
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'COMPLETED',
    });
  }
}
