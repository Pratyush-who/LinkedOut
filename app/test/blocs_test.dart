import 'package:flutter_test/flutter_test.dart';
import 'package:linkedout/features/auth/data/models/user_profile_model.dart';
import 'package:linkedout/features/auth/data/repositories/auth_repository.dart';
import 'package:linkedout/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:linkedout/features/market/data/models/asset_model.dart';
import 'package:linkedout/features/market/data/models/market_trend_model.dart';
import 'package:linkedout/features/market/data/repositories/market_repository.dart';
import 'package:linkedout/features/market/presentation/bloc/market_bloc.dart';
import 'package:linkedout/features/portfolio/data/models/portfolio_model.dart';
import 'package:linkedout/features/portfolio/data/repositories/portfolio_repository.dart';
import 'package:linkedout/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:linkedout/features/trade/data/models/trade_request_model.dart';
import 'package:linkedout/features/trade/data/models/trade_response_model.dart';
import 'package:linkedout/features/trade/data/repositories/trade_repository.dart';
import 'package:linkedout/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:linkedout/features/wallet/data/models/wallet_model.dart';
import 'package:linkedout/features/wallet/data/repositories/wallet_repository.dart';
import 'package:linkedout/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:linkedout/core/network/api_client.dart';

class MockAuthRepository extends AuthRepository {
  MockAuthRepository() : super(apiClient: ApiClient());

  @override
  Future<Map<String, dynamic>> requestOtp({required String phone}) async {
    return {'otp': '123456', 'message': 'OTP sent'};
  }
}

class MockPortfolioRepository extends PortfolioRepository {
  MockPortfolioRepository() : super(apiClient: ApiClient());

  @override
  Future<PortfolioSnapshotModel> getPortfolioSnapshot() async {
    return PortfolioSnapshotModel(
      totalValue: 10000,
      totalInvested: 8000,
      totalGainLoss: 2000,
      totalGainLossPercentage: 25.0,
      holdings: [],
    );
  }
}

class MockTradeRepository extends TradeRepository {
  MockTradeRepository() : super(apiClient: ApiClient());

  @override
  Future<TradeResponseModel> buyAsset(TradeRequestModel request) async {
    return TradeResponseModel(
      orderId: 'ord-123',
      assetId: request.assetId,
      symbol: 'BTC',
      quantity: request.quantity,
      executionPrice: 65000,
      totalAmount: 65000 * request.quantity,
      type: 'BUY',
      status: 'COMPLETED',
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}

class MockMarketRepository extends MarketRepository {
  MockMarketRepository() : super(apiClient: ApiClient());

  @override
  Future<List<AssetModel>> getAssets() async {
    return [
      AssetModel(id: 'btc', symbol: 'BTC', name: 'Bitcoin', currentPrice: 65000, category: 'Crypto'),
      AssetModel(id: 'eth', symbol: 'ETH', name: 'Ethereum', currentPrice: 3500, category: 'Crypto'),
    ];
  }

  @override
  Future<MarketTrendModel> getMarketTrend() async {
    return MarketTrendModel(currentTrend: 0.05, isMarketDip: false, status: 'BULLISH');
  }
}

class MockWalletRepository extends WalletRepository {
  MockWalletRepository() : super(apiClient: ApiClient());

  @override
  Future<WalletResponseModel> getWalletDetails() async {
    return WalletResponseModel(
      wallet: WalletDetailsModel(id: 'w1', balance: 50000, currency: 'USD'),
      ledger: [],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthBloc Tests', () {
    test('initial state is unauthenticated/initial', () {
      final authBloc = AuthBloc(authRepository: MockAuthRepository());
      expect(authBloc.state.status, AuthStatus.initial);
      expect(authBloc.state.isLoading, false);
      authBloc.close();
    });

    test('requestOtp emits otpSent state', () async {
      final authBloc = AuthBloc(authRepository: MockAuthRepository());
      authBloc.add(const AuthRequestOtpEvent('+1234567890'));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          predicate<AuthState>((s) => s.isLoading && s.phone == '+1234567890'),
          predicate<AuthState>((s) => !s.isLoading && s.status == AuthStatus.otpSent && s.lastGeneratedOtp == '123456'),
        ]),
      );
      authBloc.close();
    });

    test('updateProfile updates currentUser in state', () async {
      final authBloc = AuthBloc(authRepository: MockAuthRepository());
      authBloc.add(AuthProfileLoadedEvent(UserProfileModel(
        phone: '+1234567890',
        displayName: 'Alex',
        username: 'alex',
        onboardingComplete: true,
      )));

      await expectLater(
        authBloc.stream,
        emits(predicate<AuthState>((s) => s.currentUser?.displayName == 'Alex')),
      );
      authBloc.close();
    });
  });

  group('MarketBloc Tests', () {
    test('initial state has empty assets', () {
      final marketBloc = MarketBloc(marketRepository: MockMarketRepository());
      expect(marketBloc.state.assets, isEmpty);
      expect(marketBloc.state.selectedCategory, 'All');
      marketBloc.close();
    });

    test('MarketFetchDataEvent loads assets and trend', () async {
      final marketBloc = MarketBloc(marketRepository: MockMarketRepository());
      marketBloc.add(const MarketFetchDataEvent());

      await expectLater(
        marketBloc.stream,
        emitsInOrder([
          predicate<MarketState>((s) => s.isLoading),
          predicate<MarketState>((s) => !s.isLoading && s.assets.length == 2 && s.marketTrend != null),
        ]),
      );
      expect(marketBloc.state.filteredAssets.length, 2);
      marketBloc.close();
    });

    test('MarketChangeCategoryEvent updates category', () async {
      final marketBloc = MarketBloc(marketRepository: MockMarketRepository());
      marketBloc.add(const MarketChangeCategoryEvent('Crypto'));

      await expectLater(
        marketBloc.stream,
        emits(predicate<MarketState>((s) => s.selectedCategory == 'Crypto')),
      );
      marketBloc.close();
    });

    test('MarketSearchQueryChangedEvent updates search query', () async {
      final marketBloc = MarketBloc(marketRepository: MockMarketRepository());
      marketBloc.add(const MarketSearchQueryChangedEvent('BTC'));

      await expectLater(
        marketBloc.stream,
        emits(predicate<MarketState>((s) => s.searchQuery == 'BTC')),
      );
      marketBloc.close();
    });
  });

  group('PortfolioBloc Tests', () {
    test('initial state is empty', () {
      final bloc = PortfolioBloc(portfolioRepository: MockPortfolioRepository());
      expect(bloc.state.snapshot, isNull);
      expect(bloc.state.isLoading, false);
      bloc.close();
    });

    test('PortfolioFetchEvent loads snapshot', () async {
      final bloc = PortfolioBloc(portfolioRepository: MockPortfolioRepository());
      bloc.add(const PortfolioFetchEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<PortfolioState>((s) => s.isLoading),
          predicate<PortfolioState>((s) => !s.isLoading && s.snapshot != null && s.totalValue == 10000),
        ]),
      );
      bloc.close();
    });
  });

  group('TradeBloc Tests', () {
    test('initial state is initial', () {
      final bloc = TradeBloc(tradeRepository: MockTradeRepository());
      expect(bloc.state.status, TradeStatus.initial);
      expect(bloc.state.isExecuting, false);
      bloc.close();
    });

    test('TradeExecuteEvent executes buy trade', () async {
      final bloc = TradeBloc(tradeRepository: MockTradeRepository());
      bloc.add(const TradeExecuteEvent(assetId: 'bitcoin', quantity: 1.0, isBuy: true));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<TradeState>((s) => s.status == TradeStatus.executing),
          predicate<TradeState>((s) => s.status == TradeStatus.success && s.lastTradeResponse != null),
        ]),
      );
      bloc.close();
    });
  });

  group('WalletBloc Tests', () {
    test('initial state is empty', () {
      final bloc = WalletBloc(walletRepository: MockWalletRepository());
      expect(bloc.state.wallet, isNull);
      expect(bloc.state.selectedFilter, 'ALL');
      bloc.close();
    });

    test('WalletFetchEvent loads wallet details', () async {
      final bloc = WalletBloc(walletRepository: MockWalletRepository());
      bloc.add(const WalletFetchEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<WalletState>((s) => s.isLoading),
          predicate<WalletState>((s) => !s.isLoading && s.wallet?.balance == 50000),
        ]),
      );
      bloc.close();
    });

    test('WalletFilterChangedEvent updates filter', () async {
      final bloc = WalletBloc(walletRepository: MockWalletRepository());
      bloc.add(const WalletFilterChangedEvent('DEPOSITS'));

      await expectLater(
        bloc.stream,
        emits(predicate<WalletState>((s) => s.selectedFilter == 'DEPOSITS')),
      );
      bloc.close();
    });
  });
}
