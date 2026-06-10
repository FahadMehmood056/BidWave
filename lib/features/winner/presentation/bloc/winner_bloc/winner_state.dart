import 'package:equatable/equatable.dart';
import '../../../domain/entities/winner_detail.dart';

abstract class WinnerState extends Equatable {
  const WinnerState();

  @override
  List<Object?> get props => [];
}

class WinnerInitial extends WinnerState {
  const WinnerInitial();
}

class WinnerLoading extends WinnerState {
  const WinnerLoading();
}

class WinnerLoaded extends WinnerState {
  final WinnerDetail detail;

  const WinnerLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class WinnerError extends WinnerState {
  final String message;

  const WinnerError(this.message);

  @override
  List<Object?> get props => [message];
}
