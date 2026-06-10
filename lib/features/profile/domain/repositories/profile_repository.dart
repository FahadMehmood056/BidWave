import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile_user.dart';

abstract class ProfileRepository {
  ProfileUser? getCachedProfile();

  Future<Either<Failure, ProfileUser>> getProfile();

  Future<Either<Failure, ProfileUser>> updateProfile({
    required String name,
    required String phone,
  });

  Future<bool> hasPhoneNumber();
}
