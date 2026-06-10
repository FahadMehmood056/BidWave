import '../../../../core/usecase/usecase.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class GetCachedProfileUseCase {
  final ProfileRepository repository;

  GetCachedProfileUseCase(this.repository);

  ProfileUser? call(NoParams params) {
    return repository.getCachedProfile();
  }
}
