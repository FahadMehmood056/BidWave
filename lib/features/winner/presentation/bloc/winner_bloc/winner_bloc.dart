import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_winner_detail_usecase.dart';
import 'winner_event.dart';
import 'winner_state.dart';

class WinnerBloc extends Bloc<WinnerEvent, WinnerState> {
  final GetWinnerDetailUseCase getWinnerDetailUseCase;

  WinnerBloc({required this.getWinnerDetailUseCase})
    : super(const WinnerInitial()) {
    on<WinnerStarted>(_onStarted);
  }

  Future<void> _onStarted(
    WinnerStarted event,
    Emitter<WinnerState> emit,
  ) async {
    emit(const WinnerLoading());

    try {
      final detail = await getWinnerDetailUseCase(event.auctionId);
      emit(WinnerLoaded(detail));
    } catch (_) {
      emit(const WinnerError('Failed to load winner details.'));
    }
  }
}
