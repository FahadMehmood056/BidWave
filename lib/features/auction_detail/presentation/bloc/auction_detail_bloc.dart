import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/place_bid_usecase.dart';
import '../../domain/usecases/watch_auction_usecase.dart';
import '../../domain/usecases/watch_bids_usecase.dart';
import 'auction_detail_event.dart';
import 'auction_detail_state.dart';

class AuctionDetailBloc extends Bloc<AuctionDetailEvent, AuctionDetailState> {
  final WatchAuctionUseCase watchAuctionUseCase;
  final WatchBidsUseCase watchBidsUseCase;
  final PlaceBidUseCase placeBidUseCase;

  StreamSubscription? _auctionSubscription;
  StreamSubscription? _bidsSubscription;

  AuctionDetailBloc({
    required String auctionId,
    required String? currentUserId,
    required this.watchAuctionUseCase,
    required this.watchBidsUseCase,
    required this.placeBidUseCase,
  }) : super(
         AuctionDetailState.initial(
           auctionId: auctionId,
           currentUserId: currentUserId,
         ),
       ) {
    on<AuctionDetailStarted>(_onStarted);
    on<AuctionDetailAuctionUpdated>(_onAuctionUpdated);
    on<AuctionDetailBidsUpdated>(_onBidsUpdated);
    on<AuctionDetailFailed>(_onFailed);
    on<AuctionDetailBidSubmitted>(_onBidSubmitted);
  }

  void _onStarted(
    AuctionDetailStarted event,
    Emitter<AuctionDetailState> emit,
  ) {
    emit(
      state.copyWith(
        auctionId: event.auctionId,
        isLoading: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    _auctionSubscription?.cancel();
    _bidsSubscription?.cancel();

    _auctionSubscription = watchAuctionUseCase(event.auctionId).listen(
      (auction) => add(AuctionDetailAuctionUpdated(auction)),
      onError: (_) => add(const AuctionDetailFailed('Failed to load auction.')),
    );

    _bidsSubscription = watchBidsUseCase(event.auctionId).listen(
      (bids) => add(AuctionDetailBidsUpdated(bids)),
      onError: (_) => add(const AuctionDetailFailed('Failed to load bids.')),
    );
  }

  void _onAuctionUpdated(
    AuctionDetailAuctionUpdated event,
    Emitter<AuctionDetailState> emit,
  ) {
    emit(
      state.copyWith(
        auction: event.auction,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  void _onBidsUpdated(
    AuctionDetailBidsUpdated event,
    Emitter<AuctionDetailState> emit,
  ) {
    emit(state.copyWith(bids: event.bids, clearError: true));
  }

  void _onFailed(AuctionDetailFailed event, Emitter<AuctionDetailState> emit) {
    emit(
      state.copyWith(
        isLoading: false,
        isPlacingBid: false,
        errorMessage: event.message,
      ),
    );
  }

  Future<void> _onBidSubmitted(
    AuctionDetailBidSubmitted event,
    Emitter<AuctionDetailState> emit,
  ) async {
    emit(
      state.copyWith(isPlacingBid: true, clearError: true, clearSuccess: true),
    );

    final result = await placeBidUseCase(
      PlaceBidParams(auctionId: state.auctionId, amount: event.amount),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(isPlacingBid: false, errorMessage: failure.message),
        );
      },
      (_) {
        emit(
          state.copyWith(
            isPlacingBid: false,
            successMessage: 'Bid placed successfully',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _auctionSubscription?.cancel();
    _bidsSubscription?.cancel();
    return super.close();
  }
}
