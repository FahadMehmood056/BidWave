import 'package:equatable/equatable.dart';

abstract class PostAuctionState extends Equatable {
  const PostAuctionState();

  @override
  List<Object?> get props => [];
}

class PostAuctionInitial extends PostAuctionState {
  const PostAuctionInitial();
}

class PostAuctionLoading extends PostAuctionState {
  const PostAuctionLoading();
}

class PostAuctionSuccess extends PostAuctionState {
  final String auctionId;

  const PostAuctionSuccess(this.auctionId);

  @override
  List<Object?> get props => [auctionId];
}

class PostAuctionError extends PostAuctionState {
  final String message;

  const PostAuctionError(this.message);

  @override
  List<Object?> get props => [message];
}
