import 'package:equatable/equatable.dart';

class Auction extends Equatable {
  final String id;
  final String title;
  final String category;
  final List<String> images;
  final String sellerId;
  final String currencyCode;
  final double startingPrice;
  final double currentBid;
  final String? currentBidderId;
  final double bidIncrement;
  final int totalBids;
  final DateTime endTime;
  final String status;
  final String? winnerId;

  const Auction({
    required this.id,
    required this.title,
    required this.category,
    required this.images,
    required this.sellerId,
    required this.currencyCode,
    required this.startingPrice,
    required this.currentBid,
    required this.currentBidderId,
    required this.bidIncrement,
    required this.totalBids,
    required this.endTime,
    required this.status,
    required this.winnerId,
  });

  bool get isLive {
    return status == 'live' && endTime.isAfter(DateTime.now());
  }

  Duration get remainingDuration {
    final remaining = endTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    images,
    sellerId,
    currencyCode,
    startingPrice,
    currentBid,
    currentBidderId,
    bidIncrement,
    totalBids,
    endTime,
    status,
    winnerId,
  ];
}
