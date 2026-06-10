import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/bid.dart';

class BidModel extends Bid {
  const BidModel({
    required super.id,
    required super.bidderId,
    required super.bidderName,
    required super.amount,
    required super.timestamp,
  });

  factory BidModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return BidModel(
      id: doc.id,
      bidderId: data[BidFields.bidderId] as String? ?? '',
      bidderName: data[BidFields.bidderName] as String? ?? 'Bidder',
      amount: (data[BidFields.amount] as num? ?? 0).toDouble(),
      timestamp:
          (data[BidFields.timestamp] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      BidFields.bidderId: bidderId,
      BidFields.bidderName: bidderName,
      BidFields.amount: amount,
      BidFields.timestamp: FieldValue.serverTimestamp(),
    };
  }
}
