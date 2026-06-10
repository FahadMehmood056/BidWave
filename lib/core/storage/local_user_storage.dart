import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../../features/profile/domain/entities/profile_user.dart';

class LocalUserStorage {
  static const _userKey = 'cached_user';

  final SharedPreferences preferences;

  LocalUserStorage(this.preferences);

  Future<void> saveUser(AppUser user) async {
    final existingProfile = getProfile();

    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'wonCount': existingProfile?.wonCount ?? 0,
      'soldCount': existingProfile?.soldCount ?? 0,
      'bidsCount': existingProfile?.bidsCount ?? 0,
    });

    await preferences.setString(_userKey, userJson);
  }

  Future<void> saveProfile(ProfileUser user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'wonCount': user.wonCount,
      'soldCount': user.soldCount,
      'bidsCount': user.bidsCount,
    });

    await preferences.setString(_userKey, userJson);
  }

  AppUser? getUser() {
    final data = _getUserMap();

    if (data == null) return null;

    return AppUser(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
    );
  }

  ProfileUser? getProfile() {
    final data = _getUserMap();

    if (data == null) return null;

    return ProfileUser(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      wonCount: data['wonCount'] as int? ?? 0,
      soldCount: data['soldCount'] as int? ?? 0,
      bidsCount: data['bidsCount'] as int? ?? 0,
    );
  }

  Future<void> clearUser() async {
    await preferences.remove(_userKey);
  }

  Map<String, dynamic>? _getUserMap() {
    final userJson = preferences.getString(_userKey);

    if (userJson == null) return null;

    return jsonDecode(userJson) as Map<String, dynamic>;
  }
}
