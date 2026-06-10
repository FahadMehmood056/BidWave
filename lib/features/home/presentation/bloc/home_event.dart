import 'package:equatable/equatable.dart';
import '../../../auctions/domain/entities/auction.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

class HomeCategoryChanged extends HomeEvent {
  final String category;

  const HomeCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class HomeAuctionsUpdated extends HomeEvent {
  final List<Auction> auctions;

  const HomeAuctionsUpdated(this.auctions);

  @override
  List<Object?> get props => [auctions];
}

class HomeAuctionsFailed extends HomeEvent {
  final String message;

  const HomeAuctionsFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeUnreadCountUpdated extends HomeEvent {
  final int unreadCount;

  const HomeUnreadCountUpdated(this.unreadCount);

  @override
  List<Object?> get props => [unreadCount];
}

class HomeUnreadCountFailed extends HomeEvent {
  const HomeUnreadCountFailed();
}
