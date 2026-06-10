import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/auction.dart';

class AuctionModel extends Auction {
  const AuctionModel({
    required super.id,
    required super.title,
    required super.category,
    required super.images,
    required super.sellerId,
    required super.currencyCode,
    required super.startingPrice,
    required super.currentBid,
    required super.currentBidderId,
    required super.bidIncrement,
    required super.totalBids,
    required super.endTime,
    required super.status,
    required super.winnerId,
  });

  factory AuctionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return AuctionModel(
      id: doc.id,
      title: data[AuctionFields.title] as String? ?? '',
      category: data[AuctionFields.category] as String? ?? '',
      images: List<String>.from(data[AuctionFields.images] ?? const []),
      sellerId: data[AuctionFields.sellerId] as String? ?? '',
      currencyCode: data[AuctionFields.currencyCode] as String? ?? 'PKR',
      startingPrice: (data[AuctionFields.startingPrice] as num? ?? 0)
          .toDouble(),
      currentBid: (data[AuctionFields.currentBid] as num? ?? 0).toDouble(),
      currentBidderId: data[AuctionFields.currentBidderId] as String?,
      bidIncrement: (data[AuctionFields.bidIncrement] as num? ?? 1).toDouble(),
      totalBids: data[AuctionFields.totalBids] as int? ?? 0,
      endTime:
          (data[AuctionFields.endTime] as Timestamp?)?.toDate() ??
          DateTime.now(),
      status: data[AuctionFields.status] as String? ?? 'live',
      winnerId: data[AuctionFields.winnerId] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AuctionFields.title: title,
      AuctionFields.category: category,
      AuctionFields.images: images,
      AuctionFields.sellerId: sellerId,
      AuctionFields.currencyCode: currencyCode,
      AuctionFields.startingPrice: startingPrice,
      AuctionFields.currentBid: currentBid,
      AuctionFields.currentBidderId: currentBidderId,
      AuctionFields.bidIncrement: bidIncrement,
      AuctionFields.totalBids: totalBids,
      AuctionFields.endTime: Timestamp.fromDate(endTime),
      AuctionFields.status: status,
      AuctionFields.winnerId: winnerId,
      AuctionFields.createdAt: FieldValue.serverTimestamp(),
    };
  }
}
