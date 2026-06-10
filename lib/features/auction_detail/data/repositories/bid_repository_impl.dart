import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../../domain/entities/bid.dart';
import '../../domain/repositories/bid_repository.dart';
import '../datasources/bid_remote_data_source.dart';

class BidRepositoryImpl implements BidRepository {
  final BidRemoteDataSource remoteDataSource;

  BidRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Auction> watchAuction(String auctionId) {
    return remoteDataSource.watchAuction(auctionId);
  }

  @override
  Stream<List<Bid>> watchBids(String auctionId) {
    return remoteDataSource.watchBids(auctionId);
  }

  @override
  Future<Either<Failure, void>> placeBid({
    required String auctionId,
    required double amount,
  }) async {
    try {
      await remoteDataSource.placeBid(auctionId: auctionId, amount: amount);

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        ServerFailure('Failed to place bid. Please try again.'),
      );
    }
  }
}
