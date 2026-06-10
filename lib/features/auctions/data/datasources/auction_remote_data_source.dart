import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auction_model.dart';

abstract class AuctionRemoteDataSource {
  Stream<List<AuctionModel>> watchLiveAuctions();

  Stream<List<AuctionModel>> watchMyAuctions();

  Future<String> postAuction({
    required AuctionModel auction,
    required List<String> localImagePaths,
  });
}

class AuctionRemoteDataSourceImpl implements AuctionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  AuctionRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
    required this.auth,
  });

  @override
  Stream<List<AuctionModel>> watchLiveAuctions() {
    return firestore
        .collection(FirestorePaths.auctions)
        .where(AuctionFields.status, isEqualTo: 'live')
        .orderBy(AuctionFields.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuctionModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Stream<List<AuctionModel>> watchMyAuctions() {
    final firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw AuthException('You are not logged in.');
    }

    return firestore
        .collection(FirestorePaths.auctions)
        .where(AuctionFields.sellerId, isEqualTo: firebaseUser.uid)
        .orderBy(AuctionFields.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuctionModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<String> postAuction({
    required AuctionModel auction,
    required List<String> localImagePaths,
  }) async {
    try {
      final firebaseUser = auth.currentUser;

      if (firebaseUser == null) {
        throw AuthException('You are not logged in.');
      }

      final imageUrls = <String>[];

      for (var i = 0; i < localImagePaths.length; i++) {
        final file = File(localImagePaths[i]);

        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${firebaseUser.uid}_$i.jpg';

        final ref = storage.ref().child(
          'auctions/${firebaseUser.uid}/$fileName',
        );

        await ref.putFile(file);

        final downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      final docRef = await firestore.collection(FirestorePaths.auctions).add({
        ...auction.toFirestore(),
        AuctionFields.images: imageUrls,
        AuctionFields.sellerId: firebaseUser.uid,
      });

      return docRef.id;
    } on AuthException {
      rethrow;
    } catch (_) {
      throw ServerException('Failed to post auction. Please try again.');
    }
  }
}
