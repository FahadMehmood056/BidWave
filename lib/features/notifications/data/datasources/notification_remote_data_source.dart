import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../models/app_notification_model.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<AppNotificationModel>> watchNotifications();

  Stream<int> watchUnreadCount();

  Future<void> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotificationRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Stream<List<AppNotificationModel>> watchNotifications() {
    final user = auth.currentUser;

    if (user == null) {
      throw AuthException('You are not logged in.');
    }

    return firestore
        .collection(FirestorePaths.users)
        .doc(user.uid)
        .collection(FirestorePaths.notifications)
        .orderBy(NotificationFields.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppNotificationModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Stream<int> watchUnreadCount() {
    final user = auth.currentUser;

    if (user == null) {
      throw AuthException('You are not logged in.');
    }

    return firestore
        .collection(FirestorePaths.users)
        .doc(user.uid)
        .collection(FirestorePaths.notifications)
        .where(NotificationFields.isRead, isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final user = auth.currentUser;

    if (user == null) {
      throw AuthException('You are not logged in.');
    }

    await firestore
        .collection(FirestorePaths.users)
        .doc(user.uid)
        .collection(FirestorePaths.notifications)
        .doc(notificationId)
        .update({NotificationFields.isRead: true});
  }
}
