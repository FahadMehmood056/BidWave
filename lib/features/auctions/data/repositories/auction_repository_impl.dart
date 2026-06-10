import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auction.dart';
import '../../domain/repositories/auction_repository.dart';
import '../datasources/auction_remote_data_source.dart';
import '../models/auction_model.dart';

class AuctionRepositoryImpl implements AuctionRepository {
  final AuctionRemoteDataSource remoteDataSource;

  AuctionRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Auction>> watchLiveAuctions() {
    return remoteDataSource.watchLiveAuctions().map(
      (auctions) => auctions.where((auction) => auction.isLive).toList(),
    );
  }

  @override
  Stream<List<Auction>> watchMyAuctions() {
    return remoteDataSource.watchMyAuctions();
  }

  @override
  Future<Either<Failure, String>> postAuction({
    required String title,
    required String category,
    required String currencyCode,
    required double startingPrice,
    required Duration duration,
    required List<String> localImagePaths,
  }) async {
    try {
      final auction = AuctionModel(
        id: '',
        title: title.trim(),
        category: category.trim(),
        images: const [],
        sellerId: '',
        currencyCode: currencyCode,
        startingPrice: startingPrice,
        currentBid: startingPrice,
        currentBidderId: null,
        bidIncrement: _incrementFor(startingPrice),
        totalBids: 0,
        endTime: DateTime.now().add(duration),
        status: 'live',
        winnerId: null,
      );

      final auctionId = await remoteDataSource.postAuction(
        auction: auction,
        localImagePaths: localImagePaths,
      );

      return Right(auctionId);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        ServerFailure('Failed to post auction. Please try again.'),
      );
    }
  }

  double _incrementFor(double price) {
    if (price < 100) return 5;
    if (price < 1000) return 25;
    return 100;
  }
}
