import 'package:equatable/equatable.dart';

class WinnerDetail extends Equatable {
  final String auctionId;
  final String title;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String currencyCode;
  final double winningBid;
  final int totalBids;

  const WinnerDetail({
    required this.auctionId,
    required this.title,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.currencyCode,
    required this.winningBid,
    required this.totalBids,
  });

  String get winningBidText {
    return '$currencyCode ${winningBid.toStringAsFixed(0)}';
  }

  @override
  List<Object?> get props => [
    auctionId,
    title,
    sellerId,
    sellerName,
    sellerPhone,
    currencyCode,
    winningBid,
    totalBids,
  ];
}
