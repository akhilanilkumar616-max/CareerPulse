import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';

/// Provider managing User Career Profile state and Firestore operations
class ProfileProvider with ChangeNotifier {
  final FirestoreService _firestoreService;

  UserProfile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasCompletedProfile =>
      _profile != null && _profile!.isProfileComplete;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Load profile from Firestore
  Future<void> loadProfile(String uid) async {
    if (uid.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _firestoreService.getUserProfile(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save or update profile in Firestore
  Future<bool> saveProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profileWithTimestamp = updatedProfile.copyWith(
        updatedAt: DateTime.now(),
      );
      await _firestoreService.saveUserProfile(profileWithTimestamp);
      _profile = profileWithTimestamp;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save profile: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Add skill to active profile
  void addSkill(String skill) {
    if (_profile == null || skill.trim().isEmpty) return;
    final trimmed = skill.trim();
    if (!_profile!.skills.contains(trimmed)) {
      final updatedList = List<String>.from(_profile!.skills)..add(trimmed);
      _profile = _profile!.copyWith(skills: updatedList);
      notifyListeners();
    }
  }

  /// Remove skill from active profile
  void removeSkill(String skill) {
    if (_profile == null) return;
    final updatedList = List<String>.from(_profile!.skills)..remove(skill);
    _profile = _profile!.copyWith(skills: updatedList);
    notifyListeners();
  }

  /// Add career interest
  void addCareerInterest(String interest) {
    if (_profile == null || interest.trim().isEmpty) return;
    final trimmed = interest.trim();
    if (!_profile!.careerInterests.contains(trimmed)) {
      final updatedList = List<String>.from(_profile!.careerInterests)..add(trimmed);
      _profile = _profile!.copyWith(careerInterests: updatedList);
      notifyListeners();
    }
  }

  /// Remove career interest
  void removeCareerInterest(String interest) {
    if (_profile == null) return;
    final updatedList = List<String>.from(_profile!.careerInterests)..remove(interest);
    _profile = _profile!.copyWith(careerInterests: updatedList);
    notifyListeners();
  }
}
