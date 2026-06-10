import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/profile_user.dart';

class ProfileModel extends ProfileUser {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.wonCount,
    required super.soldCount,
    required super.bidsCount,
  });

  factory ProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return ProfileModel(
      id: doc.id,
      name: data[UserFields.name] as String? ?? '',
      email: data[UserFields.email] as String? ?? '',
      phone: data[UserFields.phone] as String? ?? '',
      wonCount: data[UserFields.wonCount] as int? ?? 0,
      soldCount: data[UserFields.soldCount] as int? ?? 0,
      bidsCount: data[UserFields.bidsCount] as int? ?? 0,
    );
  }

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    return ProfileModel(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      wonCount: data['wonCount'] as int? ?? 0,
      soldCount: data['soldCount'] as int? ?? 0,
      bidsCount: data['bidsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toCacheMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'wonCount': wonCount,
      'soldCount': soldCount,
      'bidsCount': bidsCount,
    };
  }
}
