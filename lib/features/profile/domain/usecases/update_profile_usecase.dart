import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase
    implements UseCase<ProfileUser, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileUser>> call(UpdateProfileParams params) {
    return repository.updateProfile(name: params.name, phone: params.phone);
  }
}

class UpdateProfileParams extends Equatable {
  final String name;
  final String phone;

  const UpdateProfileParams({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}
