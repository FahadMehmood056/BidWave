import '../../../../core/usecase/usecase.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../repositories/bid_repository.dart';

class WatchAuctionUseCase implements StreamUseCase<Auction, String> {
  final BidRepository repository;

  WatchAuctionUseCase(this.repository);

  @override
  Stream<Auction> call(String auctionId) {
    return repository.watchAuction(auctionId);
  }
}
