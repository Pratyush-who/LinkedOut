import 'package:flutter_test/flutter_test.dart';
import 'package:linkedout/core/utils/currency_formatter.dart';
import 'package:linkedout/core/utils/date_formatter.dart';
import 'package:linkedout/features/auth/data/models/auth_response_model.dart';
import 'package:linkedout/features/market/data/models/asset_model.dart';
import 'package:linkedout/features/market/data/models/market_trend_model.dart';
import 'package:linkedout/features/trade/data/models/trade_request_model.dart';
import 'package:linkedout/features/wallet/data/models/wallet_model.dart';

void main() {
  group('Currency & Date Formatter Tests', () {
    test('CurrencyFormatter formats currency correctly', () {
      expect(CurrencyFormatter.format(1234.56), '\$1,234.56');
      expect(CurrencyFormatter.format(0), '\$0.00');
      expect(CurrencyFormatter.format(null), '\$0.00');
      expect(CurrencyFormatter.formatPercentage(5.24), '+5.24%');
      expect(CurrencyFormatter.formatPercentage(-3.12), '-3.12%');
    });

    test('DateFormatter parses timestamps safely', () {
      final nowStr = DateTime.now().toIso8601String();
      expect(DateFormatter.formatTimestamp(nowStr), 'Just now');
      expect(DateFormatter.formatTimestamp(null), 'Recent');
    });
  });

  group('Data Model Deserialization Tests', () {
    test('AuthResponseModel deserializes correctly', () {
      final json = {
        'token': 'jwt_123',
        'isNewUser': false,
        'phone': '+1234567890',
        'username': 'trader',
        'displayName': 'Alex',
        'profilePhotoUrl': 'https://example.com/photo.jpg',
        'onboardingComplete': true,
      };
      final model = AuthResponseModel.fromJson(json);
      expect(model.token, 'jwt_123');
      expect(model.isNewUser, false);
      expect(model.phone, '+1234567890');
      expect(model.onboardingComplete, true);
    });

    test('AssetModel deserializes correctly', () {
      final json = {
        'id': 'bitcoin',
        'symbol': 'BTC',
        'name': 'Bitcoin',
        'currentPrice': 65000.0,
        'change24h': 1500.0,
        'change24hPercentage': 2.36,
        'category': 'Crypto',
      };
      final model = AssetModel.fromJson(json);
      expect(model.symbol, 'BTC');
      expect(model.currentPrice, 65000.0);
      expect(model.sparkline.isNotEmpty, true);
    });

    test('MarketTrendModel flags crash status correctly', () {
      final trendNormal = MarketTrendModel.fromJson({
        'currentTrend': 0.05,
        'isMarketDip': false,
        'status': 'NORMAL',
      });
      expect(trendNormal.isCrash, false);

      final trendCrash = MarketTrendModel.fromJson({
        'currentTrend': -0.15,
        'isMarketDip': true,
        'status': 'CRASH',
      });
      expect(trendCrash.isCrash, true);
    });

    test('TradeRequestModel serializes correctly', () {
      final req = TradeRequestModel(assetId: 'bitcoin', quantity: 2.5);
      expect(req.toJson(), {'assetId': 'bitcoin', 'quantity': 2.5});
    });

    test('Wallet & Ledger models deserialize correctly', () {
      final json = {
        'wallet': {
          'id': 'w-1',
          'balance': 15000.0,
          'currency': 'USD',
        },
        'ledger': [
          {
            'id': 'tx-1',
            'type': 'DEPOSIT',
            'amount': 5000.0,
            'description': 'Deposit',
            'timestamp': '2026-10-06T12:00:00Z',
            'status': 'COMPLETED',
          }
        ],
      };
      final response = WalletResponseModel.fromJson(json);
      expect(response.wallet.balance, 15000.0);
      expect(response.ledger.length, 1);
      expect(response.ledger.first.isCredit, true);
    });
  });
}
