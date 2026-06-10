import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/fcm_token_service.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final LogoutUseCase logoutUseCase;
  final FcmTokenService fcmTokenService;

  bool _isListeningForTokenRefresh = false;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.googleSignInUseCase,
    required this.logoutUseCase,
    required this.fcmTokenService,
  }) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _saveFcmToken() async {
    final allowed = await fcmTokenService.requestPermission();

    if (!allowed) return;

    await fcmTokenService.saveToken();

    if (!_isListeningForTokenRefresh) {
      fcmTokenService.listenForTokenRefresh();
      _isListeningForTokenRefresh = true;
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(AuthLoadingType.email));

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (user) async {
        await _saveFcmToken();
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(AuthLoadingType.email));

    final result = await signUpUseCase(
      SignUpParams(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (user) async {
        await _saveFcmToken();
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(AuthLoadingType.google));

    try {
      final result = await googleSignInUseCase(const NoParams());

      await result.fold(
        (failure) async {
          emit(AuthError(failure.message));
        },
        (user) async {
          try {
            await _saveFcmToken();
          } catch (_) {}

          emit(AuthAuthenticated(user));
        },
      );
    } catch (error) {
      emit(const AuthError('Google Sign-In failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(AuthLoadingType.logout));

    final result = await logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
