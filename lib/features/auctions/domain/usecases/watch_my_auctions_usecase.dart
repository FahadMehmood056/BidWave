import '../../../../core/usecase/usecase.dart';
import '../entities/auction.dart';
import '../repositories/auction_repository.dart';

class WatchMyAuctionsUseCase implements StreamUseCase<List<Auction>, NoParams> {
  final AuctionRepository repository;

  WatchMyAuctionsUseCase(this.repository);

  @override
  Stream<List<Auction>> call(NoParams params) {
    return repository.watchMyAuctions();
  }
}
