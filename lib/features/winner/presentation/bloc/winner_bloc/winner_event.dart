import 'package:equatable/equatable.dart';

abstract class WinnerEvent extends Equatable {
  const WinnerEvent();

  @override
  List<Object?> get props => [];
}

class WinnerStarted extends WinnerEvent {
  final String auctionId;

  const WinnerStarted(this.auctionId);

  @override
  List<Object?> get props => [auctionId];
}
