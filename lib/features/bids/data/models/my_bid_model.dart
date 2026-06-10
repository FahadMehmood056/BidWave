import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/my_bid.dart';

class MyBidModel extends MyBid {
  const MyBidModel({
    required super.auctionId,
    required super.title,
    required super.imageUrl,
    required super.currencyCode,
    required super.currentBid,
    required super.myHighestBid,
    required super.isWinning,
    required super.status,
    required super.updatedAt,
  });

  factory MyBidModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return MyBidModel(
      auctionId: data[MyBidFields.auctionId] as String? ?? doc.id,
      title: data[MyBidFields.title] as String? ?? '',
      imageUrl: data[MyBidFields.imageUrl] as String? ?? '',
      currencyCode: data[MyBidFields.currencyCode] as String? ?? 'PKR',
      currentBid: (data[MyBidFields.currentBid] as num? ?? 0).toDouble(),
      myHighestBid: (data[MyBidFields.myHighestBid] as num? ?? 0).toDouble(),
      isWinning: data[MyBidFields.isWinning] as bool? ?? false,
      status: data[MyBidFields.status] as String? ?? 'live',
      updatedAt:
          (data[MyBidFields.updatedAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }
}
