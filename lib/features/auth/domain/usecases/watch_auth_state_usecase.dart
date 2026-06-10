import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class WatchAuthStateUseCase implements StreamUseCase<AppUser?, NoParams> {
  final AuthRepository repository;

  WatchAuthStateUseCase(this.repository);

  @override
  Stream<AppUser?> call(NoParams params) {
    return repository.authStateChanges();
  }
}
