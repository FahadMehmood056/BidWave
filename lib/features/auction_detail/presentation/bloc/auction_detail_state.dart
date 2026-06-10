import 'package:equatable/equatable.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../../domain/entities/bid.dart';

class AuctionDetailState extends Equatable {
  final String auctionId;
  final String? currentUserId;
  final Auction? auction;
  final List<Bid> bids;
  final bool isLoading;
  final bool isPlacingBid;
  final String? errorMessage;
  final String? successMessage;

  const AuctionDetailState({
    required this.auctionId,
    this.currentUserId,
    this.auction,
    this.bids = const [],
    this.isLoading = false,
    this.isPlacingBid = false,
    this.errorMessage,
    this.successMessage,
  });

  factory AuctionDetailState.initial({
    required String auctionId,
    required String? currentUserId,
  }) {
    return AuctionDetailState(
      auctionId: auctionId,
      currentUserId: currentUserId,
      isLoading: true,
    );
  }

  AuctionDetailState copyWith({
    String? auctionId,
    String? currentUserId,
    Auction? auction,
    List<Bid>? bids,
    bool? isLoading,
    bool? isPlacingBid,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuctionDetailState(
      auctionId: auctionId ?? this.auctionId,
      currentUserId: currentUserId ?? this.currentUserId,
      auction: auction ?? this.auction,
      bids: bids ?? this.bids,
      isLoading: isLoading ?? this.isLoading,
      isPlacingBid: isPlacingBid ?? this.isPlacingBid,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    auctionId,
    currentUserId,
    auction,
    bids,
    isLoading,
    isPlacingBid,
    errorMessage,
    successMessage,
  ];
}
