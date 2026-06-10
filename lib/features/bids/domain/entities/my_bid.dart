import 'package:equatable/equatable.dart';

class MyBid extends Equatable {
  final String auctionId;
  final String title;
  final String imageUrl;
  final String currencyCode;
  final double currentBid;
  final double myHighestBid;
  final bool isWinning;
  final String status;
  final DateTime updatedAt;

  const MyBid({
    required this.auctionId,
    required this.title,
    required this.imageUrl,
    required this.currencyCode,
    required this.currentBid,
    required this.myHighestBid,
    required this.isWinning,
    required this.status,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    auctionId,
    title,
    imageUrl,
    currencyCode,
    currentBid,
    myHighestBid,
    isWinning,
    status,
    updatedAt,
  ];
}
