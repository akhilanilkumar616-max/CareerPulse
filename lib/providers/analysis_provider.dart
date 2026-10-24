import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/api_service.dart';
import '../services/resume_service.dart';
import '../services/firestore_service.dart';

/// Provider managing Resume Analysis, FastAPI requests, and Assessment History
class AnalysisProvider with ChangeNotifier {
  final ApiService _apiService;
  final ResumeService _resumeService;
  final FirestoreService _firestoreService;

  SelectedResumeFile? _selectedFile;
  AnalysisResult? _currentResult;
  List<AnalysisResult> _history = [];

  bool _isAnalyzing = false;
  bool _isLoadingHistory = false;
  String? _errorMessage;

  AnalysisProvider({
    required ApiService apiService,
    required ResumeService resumeService,
    required FirestoreService firestoreService,
  })  : _apiService = apiService,
        _resumeService = resumeService,
        _firestoreService = firestoreService;

  SelectedResumeFile? get selectedFile => _selectedFile;
  AnalysisResult? get currentResult => _currentResult;
  List<AnalysisResult> get history => _history;
  bool get isAnalyzing => _isAnalyzing;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorMessage => _errorMessage;

  bool get hasSelectedFile => _selectedFile != null;
  bool get hasAnalysisResult => _currentResult != null || _history.isNotEmpty;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedFile() {
    _selectedFile = null;
    notifyListeners();
  }

  void setCurrentResult(AnalysisResult result) {
    _currentResult = result;
    notifyListeners();
  }

  /// Pick PDF resume from user storage
  Future<bool> pickResume() async {
    _errorMessage = null;
    try {
      final file = await _resumeService.pickResumeFile();
      if (file != null) {
        _selectedFile = file;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Send PDF and Job details to FastAPI backend for analysis and save to Firestore
  Future<bool> analyzeResume({
    required String jobTitle,
    String? companyName,
    required String jobDescription,
    required String uid,
  }) async {
    if (_selectedFile == null) {
      _errorMessage = 'Please upload a PDF resume before analyzing.';
      notifyListeners();
      return false;
    }

    if (jobDescription.trim().length < 30) {
      _errorMessage = 'Please enter a more detailed job description (minimum 30 characters).';
      notifyListeners();
      return false;
    }

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.analyzeResume(
        resumeFile: _selectedFile!,
        jobTitle: jobTitle,
        companyName: companyName,
        jobDescription: jobDescription,
      );

      _currentResult = result;

      // Save report in Firestore under users/{uid}/assessmentResults/{resultId}
      if (uid.isNotEmpty) {
        try {
          await _firestoreService.saveAssessmentResult(uid, result);
          // Add to local history list
          _history.insert(0, result);
        } catch (e) {
          debugPrint('Could not persist result to Firestore: $e');
        }
      }

      _isAnalyzing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isAnalyzing = false;
      notifyListeners();
      return false;
    }
  }

  /// Load user assessment history from Firestore
  Future<void> loadHistory(String uid) async {
    if (uid.isEmpty) return;

    _isLoadingHistory = true;
    notifyListeners();

    try {
      _history = await _firestoreService.getAssessmentResults(uid);
      _isLoadingHistory = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistory = false;
      debugPrint('Error loading assessment history: $e');
      notifyListeners();
    }
  }
}
