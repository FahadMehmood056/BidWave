import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/enums/notification_type.dart';
import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.auctionId,
    required super.type,
    required super.isRead,
    required super.createdAt,
  });

  factory AppNotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return AppNotificationModel(
      id: doc.id,
      title: data[NotificationFields.title] as String? ?? '',
      body: data[NotificationFields.body] as String? ?? '',
      auctionId: data[NotificationFields.auctionId] as String? ?? '',
      type: NotificationType.fromFirestore(
        data[NotificationFields.type] as String? ?? 'new_bid',
      ),
      isRead: data[NotificationFields.isRead] as bool? ?? false,
      createdAt:
          (data[NotificationFields.createdAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }
}
