import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/watch_won_auctions_usecase.dart';
import 'won_auctions_event.dart';
import 'won_auctions_state.dart';

class WonAuctionsBloc extends Bloc<WonAuctionsEvent, WonAuctionsState> {
  final WatchWonAuctionsUseCase watchWonAuctionsUseCase;

  StreamSubscription? _subscription;

  WonAuctionsBloc({required this.watchWonAuctionsUseCase})
    : super(const WonAuctionsInitial()) {
    on<WonAuctionsStarted>(_onStarted);
    on<WonAuctionsUpdated>(_onUpdated);
    on<WonAuctionsFailed>(_onFailed);
  }

  void _onStarted(WonAuctionsStarted event, Emitter<WonAuctionsState> emit) {
    emit(const WonAuctionsLoading());

    _subscription?.cancel();

    _subscription = watchWonAuctionsUseCase(const NoParams()).listen(
      (wonAuctions) => add(WonAuctionsUpdated(wonAuctions)),
      onError: (_) =>
          add(const WonAuctionsFailed('Failed to load won auctions.')),
    );
  }

  void _onUpdated(WonAuctionsUpdated event, Emitter<WonAuctionsState> emit) {
    emit(WonAuctionsLoaded(event.wonAuctions));
  }

  void _onFailed(WonAuctionsFailed event, Emitter<WonAuctionsState> emit) {
    emit(WonAuctionsError(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
