import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../models/analysis_result.dart';

/// Service handling Cloud Firestore persistence for User Profiles and Assessment Results
class FirestoreService {
  FirebaseFirestore? _firestore;
  bool _firestoreAvailable = false;

  // In-memory local cache for smooth demo / evaluation before Firebase project linkage
  final Map<String, UserProfile> _localProfiles = {};
  final Map<String, List<AnalysisResult>> _localResults = {};

  FirestoreService() {
    _initFirestore();
  }

  void _initFirestore() {
    try {
      _firestore = FirebaseFirestore.instance;
      _firestoreAvailable = true;
    } catch (e) {
      debugPrint('Cloud Firestore not yet initialized: $e');
      _firestoreAvailable = false;
    }
  }

  bool get isFirestoreAvailable => _firestoreAvailable && _firestore != null;

  /// Save or update user career profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      _localProfiles[profile.uid] = profile;

      if (isFirestoreAvailable) {
        await _firestore!.collection('users').doc(profile.uid).set(
              profile.toMap(),
              SetOptions(merge: true),
            );
      }
    } catch (e) {
      debugPrint('Firestore saveUserProfile error: $e');
      // If Firestore network failed, profile is still in local cache for session
    }
  }

  /// Retrieve user career profile
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      if (isFirestoreAvailable) {
        final doc = await _firestore!.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          final profile = UserProfile.fromMap(doc.data()!, uid);
          _localProfiles[uid] = profile;
          return profile;
        }
      }
      return _localProfiles[uid];
    } catch (e) {
      debugPrint('Firestore getUserProfile error: $e');
      return _localProfiles[uid];
    }
  }

  /// Save resume analysis report
  Future<void> saveAssessmentResult(String uid, AnalysisResult result) async {
    try {
      _localResults.putIfAbsent(uid, () => []);
      // Prepend to show latest first
      _localResults[uid]!.insert(0, result);

      if (isFirestoreAvailable) {
        await _firestore!
            .collection('users')
            .doc(uid)
            .collection('assessmentResults')
            .doc(result.resultId)
            .set(result.toMap());
      }
    } catch (e) {
      debugPrint('Firestore saveAssessmentResult error: $e');
    }
  }

  /// Retrieve all assessment results for user (sorted newest first)
  Future<List<AnalysisResult>> getAssessmentResults(String uid) async {
    try {
      if (isFirestoreAvailable) {
        final snapshot = await _firestore!
            .collection('users')
            .doc(uid)
            .collection('assessmentResults')
            .orderBy('analysisDate', descending: true)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final results = snapshot.docs
              .map((doc) => AnalysisResult.fromMap(doc.data(), docId: doc.id))
              .toList();
          _localResults[uid] = results;
          return results;
        }
      }
      return _localResults[uid] ?? [];
    } catch (e) {
      debugPrint('Firestore getAssessmentResults error: $e');
      return _localResults[uid] ?? [];
    }
  }

  /// Retrieve specific assessment result
  Future<AnalysisResult?> getAssessmentResultById(String uid, String resultId) async {
    try {
      if (isFirestoreAvailable) {
        final doc = await _firestore!
            .collection('users')
            .doc(uid)
            .collection('assessmentResults')
            .doc(resultId)
            .get();

        if (doc.exists && doc.data() != null) {
          return AnalysisResult.fromMap(doc.data()!, docId: doc.id);
        }
      }
      final list = _localResults[uid] ?? [];
      return list.cast<AnalysisResult?>().firstWhere(
            (r) => r?.resultId == resultId,
            orElse: () => null,
          );
    } catch (e) {
      debugPrint('Firestore getAssessmentResultById error: $e');
      return null;
    }
  }
}
