import 'package:equatable/equatable.dart';
import '../../domain/entities/bid.dart';
import '../../../auctions/domain/entities/auction.dart';

abstract class AuctionDetailEvent extends Equatable {
  const AuctionDetailEvent();

  @override
  List<Object?> get props => [];
}

class AuctionDetailStarted extends AuctionDetailEvent {
  final String auctionId;

  const AuctionDetailStarted(this.auctionId);

  @override
  List<Object?> get props => [auctionId];
}

class AuctionDetailAuctionUpdated extends AuctionDetailEvent {
  final Auction auction;

  const AuctionDetailAuctionUpdated(this.auction);

  @override
  List<Object?> get props => [auction];
}

class AuctionDetailBidsUpdated extends AuctionDetailEvent {
  final List<Bid> bids;

  const AuctionDetailBidsUpdated(this.bids);

  @override
  List<Object?> get props => [bids];
}

class AuctionDetailFailed extends AuctionDetailEvent {
  final String message;

  const AuctionDetailFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class AuctionDetailBidSubmitted extends AuctionDetailEvent {
  final double amount;

  const AuctionDetailBidSubmitted(this.amount);

  @override
  List<Object?> get props => [amount];
}
