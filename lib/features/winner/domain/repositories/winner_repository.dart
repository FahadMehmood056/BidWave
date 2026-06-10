import '../../../bids/domain/entities/my_bid.dart';
import '../entities/winner_detail.dart';

abstract class WinnerRepository {
  Stream<List<MyBid>> watchWonAuctions();

  Future<WinnerDetail> getWinnerDetail(String auctionId);
}
