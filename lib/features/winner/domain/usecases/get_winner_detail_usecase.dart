import '../entities/winner_detail.dart';
import '../repositories/winner_repository.dart';

class GetWinnerDetailUseCase {
  final WinnerRepository repository;

  GetWinnerDetailUseCase(this.repository);

  Future<WinnerDetail> call(String auctionId) {
    return repository.getWinnerDetail(auctionId);
  }
}
