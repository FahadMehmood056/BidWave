import 'package:equatable/equatable.dart';

abstract class PostAuctionEvent extends Equatable {
  const PostAuctionEvent();

  @override
  List<Object?> get props => [];
}

class PostAuctionSubmitted extends PostAuctionEvent {
  final String title;
  final String category;
  final String currencyCode;
  final double startingPrice;
  final Duration duration;
  final List<String> localImagePaths;

  const PostAuctionSubmitted({
    required this.title,
    required this.category,
    required this.currencyCode,
    required this.startingPrice,
    required this.duration,
    required this.localImagePaths,
  });

  @override
  List<Object?> get props => [
    title,
    category,
    currencyCode,
    startingPrice,
    duration,
    localImagePaths,
  ];
}
