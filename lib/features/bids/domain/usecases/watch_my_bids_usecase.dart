import '../../../../core/usecase/usecase.dart';
import '../entities/my_bid.dart';
import '../repositories/my_bids_repository.dart';

class WatchMyBidsUseCase implements StreamUseCase<List<MyBid>, NoParams> {
  final MyBidsRepository repository;

  WatchMyBidsUseCase(this.repository);

  @override
  Stream<List<MyBid>> call(NoParams params) {
    return repository.watchMyBids();
  }
}
