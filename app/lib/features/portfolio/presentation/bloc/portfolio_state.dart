import 'package:equatable/equatable.dart';
import '../../data/models/portfolio_model.dart';

class PortfolioState extends Equatable {
  final PortfolioSnapshotModel? snapshot;
  final bool isLoading;
  final String? errorMessage;

  const PortfolioState({
    this.snapshot,
    this.isLoading = false,
    this.errorMessage,
  });

  List<PortfolioHoldingModel> get holdings => snapshot?.holdings ?? [];
  double get totalValue => snapshot?.totalValue ?? 0.0;
  double get totalInvested => snapshot?.totalInvested ?? 0.0;
  double get totalGainLoss => snapshot?.totalGainLoss ?? 0.0;
  double get totalGainLossPercentage => snapshot?.totalGainLossPercentage ?? 0.0;

  PortfolioState copyWith({
    PortfolioSnapshotModel? snapshot,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PortfolioState(
      snapshot: snapshot ?? this.snapshot,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [snapshot, isLoading, errorMessage];
}
