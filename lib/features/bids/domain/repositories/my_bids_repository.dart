import '../entities/my_bid.dart';

abstract class MyBidsRepository {
  Stream<List<MyBid>> watchMyBids();
}
