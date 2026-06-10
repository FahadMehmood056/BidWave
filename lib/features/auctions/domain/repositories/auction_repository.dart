import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auction.dart';

abstract class AuctionRepository {
  Stream<List<Auction>> watchLiveAuctions();

  Stream<List<Auction>> watchMyAuctions();

  Future<Either<Failure, String>> postAuction({
    required String title,
    required String category,
    required String currencyCode,
    required double startingPrice,
    required Duration duration,
    required List<String> localImagePaths,
  });
}
