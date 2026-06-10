import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signInWithGoogle();

  Future<Either<Failure, void>> logout();

  Stream<AppUser?> authStateChanges();
}
