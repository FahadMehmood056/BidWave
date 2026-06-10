import '../../../../core/usecase/usecase.dart';
import '../entities/bid.dart';
import '../repositories/bid_repository.dart';

class WatchBidsUseCase implements StreamUseCase<List<Bid>, String> {
  final BidRepository repository;

  WatchBidsUseCase(this.repository);

  @override
  Stream<List<Bid>> call(String auctionId) {
    return repository.watchBids(auctionId);
  }
}
