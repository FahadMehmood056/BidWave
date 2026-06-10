import 'package:equatable/equatable.dart';
import '../../../auctions/domain/entities/auction.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Auction> auctions;
  final String selectedCategory;
  final int unreadNotificationCount;

  const HomeLoaded({
    required this.auctions,
    required this.selectedCategory,
    this.unreadNotificationCount = 0,
  });

  List<String> get categories {
    final categorySet = auctions
        .map((auction) => auction.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categorySet.sort();

    return ['All', ...categorySet];
  }

  List<Auction> get filteredAuctions {
    if (selectedCategory == 'All') return auctions;

    return auctions
        .where((auction) => auction.category == selectedCategory)
        .toList();
  }

  @override
  List<Object?> get props => [
    auctions,
    selectedCategory,
    unreadNotificationCount,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
