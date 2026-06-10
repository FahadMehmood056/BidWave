import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auctions/data/models/auction_model.dart';
import '../models/bid_model.dart';

abstract class BidRemoteDataSource {
  Stream<AuctionModel> watchAuction(String auctionId);

  Stream<List<BidModel>> watchBids(String auctionId);

  Future<void> placeBid({required String auctionId, required double amount});
}

class BidRemoteDataSourceImpl implements BidRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  BidRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Stream<AuctionModel> watchAuction(String auctionId) {
    return firestore
        .collection(FirestorePaths.auctions)
        .doc(auctionId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw ServerException('Auction not found.');
          }

          return AuctionModel.fromFirestore(doc);
        });
  }

  @override
  Stream<List<BidModel>> watchBids(String auctionId) {
    return firestore
        .collection(FirestorePaths.auctions)
        .doc(auctionId)
        .collection(FirestorePaths.bids)
        .orderBy(BidFields.timestamp, descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => BidModel.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<void> placeBid({
    required String auctionId,
    required double amount,
  }) async {
    final firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw AuthException('You are not logged in.');
    }

    final auctionRef = firestore
        .collection(FirestorePaths.auctions)
        .doc(auctionId);

    final userRef = firestore
        .collection(FirestorePaths.users)
        .doc(firebaseUser.uid);

    try {
      final userDoc = await userRef.get();
      final bidderName =
          userDoc.data()?[UserFields.name] as String? ?? 'Bidder';

      await firestore.runTransaction((transaction) async {
        final auctionSnapshot = await transaction.get(auctionRef);

        if (!auctionSnapshot.exists) {
          throw ValidationException('Auction not found.');
        }

        final data = auctionSnapshot.data() as Map<String, dynamic>;

        final status = data[AuctionFields.status] as String? ?? 'live';

        if (status != 'live') {
          throw ValidationException('This auction has ended.');
        }

        final sellerId = data[AuctionFields.sellerId] as String? ?? '';

        if (sellerId == firebaseUser.uid) {
          throw ValidationException('You cannot bid on your own auction.');
        }

        final startingPrice = (data[AuctionFields.startingPrice] as num? ?? 0)
            .toDouble();

        final currentBid =
            (data[AuctionFields.currentBid] as num? ?? startingPrice)
                .toDouble();

        final bidIncrement = (data[AuctionFields.bidIncrement] as num? ?? 1)
            .toDouble();

        final totalBids = data[AuctionFields.totalBids] as int? ?? 0;

        final minimumBid = totalBids == 0
            ? startingPrice
            : currentBid + bidIncrement;

        if (amount < minimumBid) {
          throw ValidationException(
            'Bid must be at least ${minimumBid.toStringAsFixed(0)}.',
          );
        }

        final endTime =
            (data[AuctionFields.endTime] as Timestamp?)?.toDate() ??
            DateTime.now();

        if (DateTime.now().isAfter(endTime)) {
          throw ValidationException('This auction has ended.');
        }

        final secondsLeft = endTime.difference(DateTime.now()).inSeconds;

        final updatedEndTime = secondsLeft <= 10
            ? Timestamp.fromDate(endTime.add(const Duration(seconds: 30)))
            : data[AuctionFields.endTime];

        final bidRef = auctionRef.collection(FirestorePaths.bids).doc();

        final myBidRef = firestore
            .collection(FirestorePaths.users)
            .doc(firebaseUser.uid)
            .collection(FirestorePaths.myBids)
            .doc(auctionId);

        transaction.update(auctionRef, {
          AuctionFields.currentBid: amount,
          AuctionFields.currentBidderId: firebaseUser.uid,
          AuctionFields.totalBids: FieldValue.increment(1),
          AuctionFields.endTime: updatedEndTime,
        });

        transaction.set(bidRef, {
          BidFields.bidderId: firebaseUser.uid,
          BidFields.bidderName: bidderName,
          BidFields.amount: amount,
          BidFields.timestamp: FieldValue.serverTimestamp(),
        });

        transaction.set(myBidRef, {
          MyBidFields.auctionId: auctionId,
          MyBidFields.title: data[AuctionFields.title] as String? ?? '',
          MyBidFields.imageUrl:
              ((data[AuctionFields.images] as List?)?.isNotEmpty ?? false)
              ? (data[AuctionFields.images] as List).first as String
              : '',
          MyBidFields.currencyCode:
              data[AuctionFields.currencyCode] as String? ?? 'PKR',
          MyBidFields.currentBid: amount,
          MyBidFields.myHighestBid: amount,
          MyBidFields.isWinning: true,
          MyBidFields.status: status,
          MyBidFields.updatedAt: FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        transaction.update(userRef, {
          UserFields.bidsCount: FieldValue.increment(1),
        });
      });
    } on AuthException {
      rethrow;
    } on ValidationException {
      rethrow;
    } catch (_) {
      throw ServerException('Failed to place bid. Please try again.');
    }
  }
}
