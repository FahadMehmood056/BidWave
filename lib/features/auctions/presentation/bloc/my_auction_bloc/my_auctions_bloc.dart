import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/watch_my_auctions_usecase.dart';
import 'my_auctions_event.dart';
import 'my_auctions_state.dart';

class MyAuctionsBloc extends Bloc<MyAuctionsEvent, MyAuctionsState> {
  final WatchMyAuctionsUseCase watchMyAuctionsUseCase;

  StreamSubscription? _subscription;

  MyAuctionsBloc({required this.watchMyAuctionsUseCase})
    : super(const MyAuctionsInitial()) {
    on<MyAuctionsStarted>(_onStarted);
    on<MyAuctionsRefreshRequested>(_onRefreshRequested);
    on<MyAuctionsUpdated>(_onUpdated);
    on<MyAuctionsFailed>(_onFailed);
  }

  void _onStarted(MyAuctionsStarted event, Emitter<MyAuctionsState> emit) {
    emit(const MyAuctionsLoading());
    _listen();
  }

  void _onRefreshRequested(
    MyAuctionsRefreshRequested event,
    Emitter<MyAuctionsState> emit,
  ) {
    _listen();
  }

  void _onUpdated(MyAuctionsUpdated event, Emitter<MyAuctionsState> emit) {
    emit(MyAuctionsLoaded(event.auctions));
  }

  void _onFailed(MyAuctionsFailed event, Emitter<MyAuctionsState> emit) {
    emit(MyAuctionsError(event.message));
  }

  void _listen() {
    _subscription?.cancel();

    _subscription = watchMyAuctionsUseCase(const NoParams()).listen(
      (auctions) => add(MyAuctionsUpdated(auctions)),
      onError: (_) =>
          add(const MyAuctionsFailed('Failed to load your auctions.')),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
