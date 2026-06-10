import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile({
    required String name,
    required String phone,
  });

  Future<bool> hasPhoneNumber();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final firebaseUser = auth.currentUser;

      if (firebaseUser == null) {
        throw AuthException('You are not logged in.');
      }

      final doc = await firestore
          .collection(FirestorePaths.users)
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        throw ServerException('Profile not found.');
      }

      return ProfileModel.fromFirestore(doc);
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Failed to load profile.');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final firebaseUser = auth.currentUser;

      if (firebaseUser == null) {
        throw AuthException('You are not logged in.');
      }

      final userRef = firestore
          .collection(FirestorePaths.users)
          .doc(firebaseUser.uid);

      await userRef.update({
        UserFields.name: name.trim(),
        UserFields.phone: phone.trim(),
      });

      final updatedDoc = await userRef.get();

      return ProfileModel.fromFirestore(updatedDoc);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw ServerException('Failed to update profile.');
    }
  }

  @override
  Future<bool> hasPhoneNumber() async {
    final firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw AuthException('You are not logged in.');
    }

    final doc = await firestore
        .collection(FirestorePaths.users)
        .doc(firebaseUser.uid)
        .get();

    final phone = doc.data()?[UserFields.phone] as String?;

    return phone != null && phone.trim().isNotEmpty;
  }
}
