import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/bid_repository.dart';

class PlaceBidUseCase implements UseCase<void, PlaceBidParams> {
  final BidRepository repository;

  PlaceBidUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PlaceBidParams params) {
    return repository.placeBid(
      auctionId: params.auctionId,
      amount: params.amount,
    );
  }
}

class PlaceBidParams extends Equatable {
  final String auctionId;
  final double amount;

  const PlaceBidParams({required this.auctionId, required this.amount});

  @override
  List<Object?> get props => [auctionId, amount];
}
