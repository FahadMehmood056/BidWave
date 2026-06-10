import 'package:equatable/equatable.dart';
import '../../domain/entities/my_bid.dart';

abstract class MyBidsEvent extends Equatable {
  const MyBidsEvent();

  @override
  List<Object?> get props => [];
}

class MyBidsStarted extends MyBidsEvent {
  const MyBidsStarted();
}

class MyBidsRefreshRequested extends MyBidsEvent {
  const MyBidsRefreshRequested();
}

class MyBidsUpdated extends MyBidsEvent {
  final List<MyBid> bids;

  const MyBidsUpdated(this.bids);

  @override
  List<Object?> get props => [bids];
}

class MyBidsFailed extends MyBidsEvent {
  final String message;

  const MyBidsFailed(this.message);

  @override
  List<Object?> get props => [message];
}
