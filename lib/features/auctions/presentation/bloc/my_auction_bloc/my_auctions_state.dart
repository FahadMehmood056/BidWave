import 'package:equatable/equatable.dart';
import '../../../domain/entities/auction.dart';

abstract class MyAuctionsState extends Equatable {
  const MyAuctionsState();

  @override
  List<Object?> get props => [];
}

class MyAuctionsInitial extends MyAuctionsState {
  const MyAuctionsInitial();
}

class MyAuctionsLoading extends MyAuctionsState {
  const MyAuctionsLoading();
}

class MyAuctionsLoaded extends MyAuctionsState {
  final List<Auction> auctions;

  const MyAuctionsLoaded(this.auctions);

  List<Auction> get liveAuctions {
    return auctions.where((auction) => auction.isLive).toList();
  }

  List<Auction> get endedAuctions {
    return auctions.where((auction) => !auction.isLive).toList();
  }

  @override
  List<Object?> get props => [auctions];
}

class MyAuctionsError extends MyAuctionsState {
  final String message;

  const MyAuctionsError(this.message);

  @override
  List<Object?> get props => [message];
}
