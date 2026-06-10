import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileUser profile;
  final bool isRefreshing;
  final bool isUpdating;

  const ProfileLoaded({
    required this.profile,
    this.isRefreshing = false,
    this.isUpdating = false,
  });

  @override
  List<Object?> get props => [profile, isRefreshing, isUpdating];
}

class ProfileError extends ProfileState {
  final String message;
  final ProfileUser? cachedProfile;

  const ProfileError({required this.message, this.cachedProfile});

  @override
  List<Object?> get props => [message, cachedProfile];
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileUser profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}
