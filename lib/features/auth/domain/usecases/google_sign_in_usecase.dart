import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUseCase implements UseCase<AppUser, NoParams> {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}
