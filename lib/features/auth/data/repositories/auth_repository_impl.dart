import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/local_user_storage.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalUserStorage localUserStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localUserStorage,
  });

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      await localUserStorage.saveUser(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localUserStorage.saveUser(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      await localUserStorage.saveUser(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localUserStorage.clearUser();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        ServerFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }
}
