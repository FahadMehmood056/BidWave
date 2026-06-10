import 'package:equatable/equatable.dart';
import '../../../../bids/domain/entities/my_bid.dart';

abstract class WonAuctionsEvent extends Equatable {
  const WonAuctionsEvent();

  @override
  List<Object?> get props => [];
}

class WonAuctionsStarted extends WonAuctionsEvent {
  const WonAuctionsStarted();
}

class WonAuctionsUpdated extends WonAuctionsEvent {
  final List<MyBid> wonAuctions;

  const WonAuctionsUpdated(this.wonAuctions);

  @override
  List<Object?> get props => [wonAuctions];
}

class WonAuctionsFailed extends WonAuctionsEvent {
  final String message;

  const WonAuctionsFailed(this.message);

  @override
  List<Object?> get props => [message];
}
