import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/watch_my_bids_usecase.dart';
import 'my_bids_event.dart';
import 'my_bids_state.dart';

class MyBidsBloc extends Bloc<MyBidsEvent, MyBidsState> {
  final WatchMyBidsUseCase watchMyBidsUseCase;
  final FirebaseAuth auth;

  StreamSubscription? _subscription;

  MyBidsBloc({required this.watchMyBidsUseCase, required this.auth})
    : super(const MyBidsInitial()) {
    on<MyBidsStarted>(_onStarted);
    on<MyBidsRefreshRequested>(_onRefreshRequested);
    on<MyBidsUpdated>(_onUpdated);
    on<MyBidsFailed>(_onFailed);
  }

  void _onStarted(MyBidsStarted event, Emitter<MyBidsState> emit) {
    emit(const MyBidsLoading());
    _listen();
  }

  void _onRefreshRequested(
    MyBidsRefreshRequested event,
    Emitter<MyBidsState> emit,
  ) {
    _listen();
  }

  void _onUpdated(MyBidsUpdated event, Emitter<MyBidsState> emit) {
    emit(MyBidsLoaded(event.bids));
  }

  void _onFailed(MyBidsFailed event, Emitter<MyBidsState> emit) {
    emit(MyBidsError(event.message));
  }

  void _listen() {
    _subscription?.cancel();

    _subscription = watchMyBidsUseCase(const NoParams()).listen(
      (bids) => add(MyBidsUpdated(bids)),
      onError: (_) {
        if (auth.currentUser == null) return;
        add(const MyBidsFailed('Failed to load your bids.'));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
