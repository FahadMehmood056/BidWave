import '../../../../core/usecase/usecase.dart';
import '../../../bids/domain/entities/my_bid.dart';
import '../repositories/winner_repository.dart';

class WatchWonAuctionsUseCase implements StreamUseCase<List<MyBid>, NoParams> {
  final WinnerRepository repository;

  WatchWonAuctionsUseCase(this.repository);

  @override
  Stream<List<MyBid>> call(NoParams params) {
    return repository.watchWonAuctions();
  }
}
