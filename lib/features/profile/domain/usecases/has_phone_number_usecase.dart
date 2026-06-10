import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class HasPhoneNumberUseCase {
  final ProfileRepository repository;

  HasPhoneNumberUseCase(this.repository);

  Future<bool> call(NoParams params) {
    return repository.hasPhoneNumber();
  }
}
