import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';

/// Authentication state provider for CareerPulse
class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Local state for when Firebase Auth isn't active
  bool _isLocallyLoggedIn = false;
  String _localUid = '';
  String _localEmail = '';
  String _localName = '';

  AuthProvider({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService {
    _currentUser = _authService.currentUser;
    _authService.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated =>
      _currentUser != null || (_isLocallyLoggedIn && _localUid.isNotEmpty);

  String get currentUid => _currentUser?.uid ?? _localUid;
  String get currentEmail => _currentUser?.email ?? _localEmail;
  String get currentDisplayName =>
      _currentUser?.displayName ?? (_localName.isNotEmpty ? _localName : 'Student');

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_authService.isFirebaseAvailable) {
        final credential = await _authService.signIn(email: email, password: password);
        _currentUser = credential?.user;
      } else {
        // Fallback demo login
        _isLocallyLoggedIn = true;
        _localUid = 'user_${email.hashCode.abs()}';
        _localEmail = email;
        _localName = email.split('@').first;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_authService.isFirebaseAvailable) {
        final credential = await _authService.register(email: email, password: password);
        _currentUser = credential?.user;
        if (_currentUser != null) {
          await _currentUser!.updateDisplayName(fullName);

          // Create initial user profile document in Firestore
          final initialProfile = UserProfile(
            uid: _currentUser!.uid,
            fullName: fullName,
            email: email,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestoreService.saveUserProfile(initialProfile);
        }
      } else {
        // Fallback demo registration
        _isLocallyLoggedIn = true;
        _localUid = 'user_${email.hashCode.abs()}';
        _localEmail = email;
        _localName = fullName;

        final initialProfile = UserProfile(
          uid: _localUid,
          fullName: fullName,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _firestoreService.saveUserProfile(initialProfile);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset Password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    _currentUser = null;
    _isLocallyLoggedIn = false;
    _localUid = '';
    _localEmail = '';
    _localName = '';
    _isLoading = false;
    notifyListeners();
  }
}
