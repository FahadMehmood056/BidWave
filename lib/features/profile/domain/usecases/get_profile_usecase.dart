import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<ProfileUser, NoParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileUser>> call(NoParams params) {
    return repository.getProfile();
  }
}
