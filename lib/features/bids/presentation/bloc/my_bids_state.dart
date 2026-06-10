import 'package:equatable/equatable.dart';
import '../../domain/entities/my_bid.dart';

abstract class MyBidsState extends Equatable {
  const MyBidsState();

  @override
  List<Object?> get props => [];
}

class MyBidsInitial extends MyBidsState {
  const MyBidsInitial();
}

class MyBidsLoading extends MyBidsState {
  const MyBidsLoading();
}

class MyBidsLoaded extends MyBidsState {
  final List<MyBid> bids;

  const MyBidsLoaded(this.bids);

  int get winningCount => bids.where((bid) => bid.isWinning).length;

  int get losingCount => bids.where((bid) => !bid.isWinning).length;

  @override
  List<Object?> get props => [bids];
}

class MyBidsError extends MyBidsState {
  final String message;

  const MyBidsError(this.message);

  @override
  List<Object?> get props => [message];
}
