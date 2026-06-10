import 'package:equatable/equatable.dart';
import '../../../../bids/domain/entities/my_bid.dart';

abstract class WonAuctionsState extends Equatable {
  const WonAuctionsState();

  @override
  List<Object?> get props => [];
}

class WonAuctionsInitial extends WonAuctionsState {
  const WonAuctionsInitial();
}

class WonAuctionsLoading extends WonAuctionsState {
  const WonAuctionsLoading();
}

class WonAuctionsLoaded extends WonAuctionsState {
  final List<MyBid> wonAuctions;

  const WonAuctionsLoaded(this.wonAuctions);

  @override
  List<Object?> get props => [wonAuctions];
}

class WonAuctionsError extends WonAuctionsState {
  final String message;

  const WonAuctionsError(this.message);

  @override
  List<Object?> get props => [message];
}
