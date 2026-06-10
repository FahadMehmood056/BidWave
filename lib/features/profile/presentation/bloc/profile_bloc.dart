import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_cached_profile_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCachedProfileUseCase getCachedProfileUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getCachedProfileUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshRequested>(_onRefreshRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    final cachedProfile = getCachedProfileUseCase(const NoParams());

    if (cachedProfile != null) {
      emit(ProfileLoaded(profile: cachedProfile, isRefreshing: true));
    } else {
      emit(const ProfileLoading());
    }

    final result = await getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        ProfileError(message: failure.message, cachedProfile: cachedProfile),
      ),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final cachedProfile = currentState is ProfileLoaded
        ? currentState.profile
        : getCachedProfileUseCase(const NoParams());

    if (cachedProfile != null) {
      emit(ProfileLoaded(profile: cachedProfile, isRefreshing: true));
    } else {
      emit(const ProfileLoading());
    }

    final result = await getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        ProfileError(message: failure.message, cachedProfile: cachedProfile),
      ),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    if (currentState is ProfileLoaded) {
      emit(ProfileLoaded(profile: currentState.profile, isUpdating: true));
    } else {
      emit(const ProfileLoading());
    }

    final result = await updateProfileUseCase(
      UpdateProfileParams(name: event.name, phone: event.phone),
    );

    result.fold(
      (failure) => emit(
        ProfileError(
          message: failure.message,
          cachedProfile: currentState is ProfileLoaded
              ? currentState.profile
              : null,
        ),
      ),
      (profile) => emit(ProfileUpdateSuccess(profile)),
    );
  }
}
