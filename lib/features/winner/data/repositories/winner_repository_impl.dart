import '../../../bids/domain/entities/my_bid.dart';
import '../../domain/entities/winner_detail.dart';
import '../../domain/repositories/winner_repository.dart';
import '../datasources/winner_remote_data_source.dart';

class WinnerRepositoryImpl implements WinnerRepository {
  final WinnerRemoteDataSource remoteDataSource;

  WinnerRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<MyBid>> watchWonAuctions() {
    return remoteDataSource.watchWonAuctions();
  }

  @override
  Future<WinnerDetail> getWinnerDetail(String auctionId) {
    return remoteDataSource.getWinnerDetail(auctionId);
  }
}
