import 'package:equatable/equatable.dart';
import '../../../domain/entities/auction.dart';

abstract class MyAuctionsEvent extends Equatable {
  const MyAuctionsEvent();

  @override
  List<Object?> get props => [];
}

class MyAuctionsStarted extends MyAuctionsEvent {
  const MyAuctionsStarted();
}

class MyAuctionsRefreshRequested extends MyAuctionsEvent {
  const MyAuctionsRefreshRequested();
}

class MyAuctionsUpdated extends MyAuctionsEvent {
  final List<Auction> auctions;

  const MyAuctionsUpdated(this.auctions);

  @override
  List<Object?> get props => [auctions];
}

class MyAuctionsFailed extends MyAuctionsEvent {
  final String message;

  const MyAuctionsFailed(this.message);

  @override
  List<Object?> get props => [message];
}
