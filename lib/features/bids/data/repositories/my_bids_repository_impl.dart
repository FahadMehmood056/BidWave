import '../../domain/entities/my_bid.dart';
import '../../domain/repositories/my_bids_repository.dart';
import '../datasources/my_bids_remote_data_source.dart';

class MyBidsRepositoryImpl implements MyBidsRepository {
  final MyBidsRemoteDataSource remoteDataSource;

  MyBidsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<MyBid>> watchMyBids() {
    return remoteDataSource.watchMyBids();
  }
}
