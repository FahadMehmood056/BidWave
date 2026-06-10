import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auctions/domain/usecases/watch_live_auctions_usecase.dart';
import '../../../notifications/domain/usecases/watch_unread_notifications_count_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WatchLiveAuctionsUseCase watchLiveAuctionsUseCase;
  final WatchUnreadNotificationsCountUseCase
  watchUnreadNotificationsCountUseCase;

  StreamSubscription? _auctionSubscription;
  StreamSubscription? _unreadCountSubscription;
  String _selectedCategory = 'All';
  int _unreadNotificationCount = 0;

  HomeBloc({
    required this.watchLiveAuctionsUseCase,
    required this.watchUnreadNotificationsCountUseCase,
  }) : super(const HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeCategoryChanged>(_onCategoryChanged);
    on<HomeAuctionsUpdated>(_onAuctionsUpdated);
    on<HomeAuctionsFailed>(_onAuctionsFailed);
    on<HomeUnreadCountUpdated>(_onUnreadCountUpdated);
    on<HomeUnreadCountFailed>(_onUnreadCountFailed);
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    emit(const HomeLoading());
    _listenToAuctions();
    _listenToUnreadCount();
  }

  void _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) {
    _listenToAuctions();
    _listenToUnreadCount();
  }

  void _onCategoryChanged(HomeCategoryChanged event, Emitter<HomeState> emit) {
    _selectedCategory = event.category;

    final currentState = state;

    if (currentState is HomeLoaded) {
      emit(
        HomeLoaded(
          auctions: currentState.auctions,
          selectedCategory: _selectedCategory,
          unreadNotificationCount: _unreadNotificationCount,
        ),
      );
    }
  }

  void _onAuctionsUpdated(HomeAuctionsUpdated event, Emitter<HomeState> emit) {
    final categories = event.auctions
        .map((auction) => auction.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet();

    if (_selectedCategory != 'All' && !categories.contains(_selectedCategory)) {
      _selectedCategory = 'All';
    }

    emit(
      HomeLoaded(
        auctions: event.auctions,
        selectedCategory: _selectedCategory,
        unreadNotificationCount: _unreadNotificationCount,
      ),
    );
  }

  void _onAuctionsFailed(HomeAuctionsFailed event, Emitter<HomeState> emit) {
    emit(HomeError(event.message));
  }

  void _listenToAuctions() {
    _auctionSubscription?.cancel();

    _auctionSubscription = watchLiveAuctionsUseCase(const NoParams()).listen(
      (auctions) {
        add(HomeAuctionsUpdated(auctions));
      },
      onError: (_) {
        add(const HomeAuctionsFailed('Failed to load auctions.'));
      },
    );
  }

  void _onUnreadCountUpdated(
    HomeUnreadCountUpdated event,
    Emitter<HomeState> emit,
  ) {
    _unreadNotificationCount = event.unreadCount;

    final currentState = state;

    if (currentState is HomeLoaded) {
      emit(
        HomeLoaded(
          auctions: currentState.auctions,
          selectedCategory: currentState.selectedCategory,
          unreadNotificationCount: _unreadNotificationCount,
        ),
      );
    }
  }

  void _onUnreadCountFailed(
    HomeUnreadCountFailed event,
    Emitter<HomeState> emit,
  ) {
    _unreadNotificationCount = 0;
  }

  void _listenToUnreadCount() {
    _unreadCountSubscription?.cancel();

    _unreadCountSubscription =
        watchUnreadNotificationsCountUseCase(const NoParams()).listen(
          (count) {
            add(HomeUnreadCountUpdated(count));
          },
          onError: (_) {
            add(const HomeUnreadCountFailed());
          },
        );
  }

  @override
  Future<void> close() {
    _auctionSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    return super.close();
  }
}
