import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/local_user_storage.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final LocalUserStorage localUserStorage;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localUserStorage,
  });

  @override
  ProfileUser? getCachedProfile() {
    return localUserStorage.getProfile();
  }

  @override
  Future<Either<Failure, ProfileUser>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();

      await localUserStorage.saveProfile(profile);

      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to load profile.'));
    }
  }

  @override
  Future<Either<Failure, ProfileUser>> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final profile = await remoteDataSource.updateProfile(
        name: name,
        phone: phone,
      );

      await localUserStorage.saveProfile(profile);

      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to update profile.'));
    }
  }

  @override
  Future<bool> hasPhoneNumber() {
    return remoteDataSource.hasPhoneNumber();
  }
}
