import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../entities/bid.dart';

abstract class BidRepository {
  Stream<Auction> watchAuction(String auctionId);

  Stream<List<Bid>> watchBids(String auctionId);

  Future<Either<Failure, void>> placeBid({
    required String auctionId,
    required double amount,
  });
}
