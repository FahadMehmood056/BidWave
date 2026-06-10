import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return UserModel(
      id: doc.id,
      name: data[UserFields.name] as String? ?? '',
      email: data[UserFields.email] as String? ?? '',
      phone: data[UserFields.phone] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      UserFields.name: name,
      UserFields.email: email,
      UserFields.phone: phone,
      UserFields.fcmToken: '',
      UserFields.wonCount: 0,
      UserFields.soldCount: 0,
      UserFields.bidsCount: 0,
      UserFields.createdAt: FieldValue.serverTimestamp(),
    };
  }
}
