import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/market/data/repositories/market_repository.dart';
import 'features/market/presentation/bloc/market_bloc.dart';
import 'features/portfolio/data/repositories/portfolio_repository.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'features/trade/data/repositories/trade_repository.dart';
import 'features/trade/presentation/bloc/trade_bloc.dart';
import 'features/wallet/data/repositories/wallet_repository.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent secure storage
  await SecureStorageService.init();

  // Initialize network API client
  final apiClient = ApiClient();

  // Initialize Repositories
  final authRepository = AuthRepository(apiClient: apiClient);
  final marketRepository = MarketRepository(apiClient: apiClient);
  final tradeRepository = TradeRepository(apiClient: apiClient);
  final portfolioRepository = PortfolioRepository(apiClient: apiClient);
  final walletRepository = WalletRepository(apiClient: apiClient);

  // Global 401 unauthorized interceptor callback
  ApiClient.onUnauthorized = () {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.signup,
      (route) => false,
    );
  };

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<MarketBloc>(
          create: (_) => MarketBloc(marketRepository: marketRepository),
        ),
        BlocProvider<TradeBloc>(
          create: (_) => TradeBloc(tradeRepository: tradeRepository),
        ),
        BlocProvider<PortfolioBloc>(
          create: (_) => PortfolioBloc(portfolioRepository: portfolioRepository),
        ),
        BlocProvider<WalletBloc>(
          create: (_) => WalletBloc(walletRepository: walletRepository),
        ),
      ],
      child: const OlympusApp(),
    ),
  );
}

class OlympusApp extends StatelessWidget {
  const OlympusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renma Olympus',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
