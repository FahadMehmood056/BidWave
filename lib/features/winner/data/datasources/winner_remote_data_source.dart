import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../../../bids/data/models/my_bid_model.dart';
import '../../domain/entities/winner_detail.dart';

abstract class WinnerRemoteDataSource {
  Stream<List<MyBidModel>> watchWonAuctions();

  Future<WinnerDetail> getWinnerDetail(String auctionId);
}

class WinnerRemoteDataSourceImpl implements WinnerRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  WinnerRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Stream<List<MyBidModel>> watchWonAuctions() {
    final user = auth.currentUser;

    if (user == null) {
      throw AuthException('You are not logged in.');
    }

    return firestore
        .collection(FirestorePaths.users)
        .doc(user.uid)
        .collection(FirestorePaths.myBids)
        .where(MyBidFields.status, isEqualTo: 'ended')
        .where(MyBidFields.isWinning, isEqualTo: true)
        .orderBy(MyBidFields.updatedAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MyBidModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<WinnerDetail> getWinnerDetail(String auctionId) async {
    final user = auth.currentUser;

    if (user == null) {
      throw AuthException('You are not logged in.');
    }

    final auctionDoc = await firestore
        .collection(FirestorePaths.auctions)
        .doc(auctionId)
        .get();

    if (!auctionDoc.exists) {
      throw ServerException('Auction not found.');
    }

    final auctionData = auctionDoc.data() ?? {};

    final winnerId = auctionData[AuctionFields.winnerId] as String?;
    final sellerId = auctionData[AuctionFields.sellerId] as String? ?? '';

    if (winnerId != user.uid) {
      throw ServerException('You are not the winner of this auction.');
    }

    final sellerDoc = await firestore
        .collection(FirestorePaths.users)
        .doc(sellerId)
        .get();

    final sellerData = sellerDoc.data() ?? {};

    return WinnerDetail(
      auctionId: auctionDoc.id,
      title: auctionData[AuctionFields.title] as String? ?? 'Auction',
      sellerId: sellerId,
      sellerName: sellerData[UserFields.name] as String? ?? 'Seller',
      sellerPhone: sellerData[UserFields.phone] as String? ?? '',
      currencyCode: auctionData[AuctionFields.currencyCode] as String? ?? 'PKR',
      winningBid: (auctionData[AuctionFields.currentBid] as num? ?? 0)
          .toDouble(),
      totalBids: auctionData[AuctionFields.totalBids] as int? ?? 0,
    );
  }
}
