import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../models/my_bid_model.dart';

abstract class MyBidsRemoteDataSource {
  Stream<List<MyBidModel>> watchMyBids();
}

class MyBidsRemoteDataSourceImpl implements MyBidsRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  MyBidsRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Stream<List<MyBidModel>> watchMyBids() {
    final firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      return Stream.value([]);
    }

    return firestore
        .collection(FirestorePaths.users)
        .doc(firebaseUser.uid)
        .collection(FirestorePaths.myBids)
        .where(MyBidFields.status, isEqualTo: 'live')
        .orderBy(MyBidFields.updatedAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MyBidModel.fromFirestore(doc))
              .toList(),
        );
  }
}
