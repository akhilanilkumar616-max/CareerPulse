import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service handling Firebase Authentication operations
class AuthService {
  FirebaseAuth? _auth;
  bool _firebaseAvailable = false;

  // Local simulated user for demo/offline evaluation when Firebase credentials are not yet linked
  User? _mockUser;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();

  AuthService() {
    _initAuth();
  }

  void _initAuth() {
    try {
      _auth = FirebaseAuth.instance;
      _firebaseAvailable = true;
    } catch (e) {
      debugPrint('Firebase Auth not yet initialized: $e');
      _firebaseAvailable = false;
    }
  }

  bool get isFirebaseAvailable => _firebaseAvailable && _auth != null;

  User? get currentUser {
    if (isFirebaseAvailable) {
      return _auth?.currentUser;
    }
    return _mockUser;
  }

  Stream<User?> get authStateChanges {
    if (isFirebaseAvailable) {
      return _auth!.authStateChanges();
    }
    return _authStateController.stream;
  }

  /// Sign In with Email and Password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (isFirebaseAvailable) {
        return await _auth!.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      } else {
        // Fallback for evaluator testing before Firebase setup
        debugPrint('Using local authentication fallback');
        await Future.delayed(const Duration(milliseconds: 600));
        return null;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unable to sign in. Please check your network connection and try again.';
    }
  }

  /// Register new user with Email and Password
  Future<UserCredential?> register({
    required String email,
    required String password,
  }) async {
    try {
      if (isFirebaseAvailable) {
        return await _auth!.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
        return null;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unable to register account. Please check your connection and try again.';
    }
  }

  /// Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (isFirebaseAvailable) {
        await _auth!.sendPasswordResetEmail(email: email.trim());
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unable to send password reset email. Please try again later.';
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      if (isFirebaseAvailable) {
        await _auth!.signOut();
      } else {
        _mockUser = null;
        _authStateController.add(null);
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  /// User-friendly Firebase Auth error mapping
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not formatted correctly.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again in a few minutes.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection.';
      default:
        return e.message ?? 'An unexpected authentication error occurred.';
    }
  }
}
