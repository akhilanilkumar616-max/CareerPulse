import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with fallback handling if platform config is pending
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase successfully initialized');
  } catch (e) {
    debugPrint('Note: Firebase.initializeApp() caught: $e');
    debugPrint('Running CareerPulse with integrated resilience layer.');
  }

  runApp(const CareerPulseApp());
}
