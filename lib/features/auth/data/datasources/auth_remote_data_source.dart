import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signInWithGoogle();

  Future<void> logout();

  Stream<UserModel?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw AuthException('Signup failed. Please try again.');
      }

      final user = UserModel(
        id: firebaseUser.uid,
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
      );

      await firestore
          .collection(FirestorePaths.users)
          .doc(user.id)
          .set(user.toFirestore());

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException('Signup failed. Please try again.');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw AuthException('Login failed. Please try again.');
      }

      final doc = await firestore
          .collection(FirestorePaths.users)
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        throw AuthException('User profile not found.');
      }

      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException('Login failed. Please try again.');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw AuthException('Google Sign-In was cancelled.');
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        throw AuthException(
          'Google Sign-In failed because ID token was missing.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw AuthException('Google Sign-In failed. Please try again.');
      }

      final userRef = firestore
          .collection(FirestorePaths.users)
          .doc(firebaseUser.uid);

      final doc = await userRef.get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }

      final user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? googleUser.displayName ?? 'User',
        email: firebaseUser.email ?? googleUser.email,
        phone: firebaseUser.phoneNumber ?? '',
      );

      await userRef.set(user.toFirestore());

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Google Sign-In failed. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (_) {
      throw AuthException('Logout failed. Please try again.');
    }
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final doc = await firestore
          .collection(FirestorePaths.users)
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    });
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
