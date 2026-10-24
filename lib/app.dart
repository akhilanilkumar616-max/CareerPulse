import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/analysis_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/resume_service.dart';

/// Root CareerPulse Application Widget
class CareerPulseApp extends StatefulWidget {
  const CareerPulseApp({super.key});

  @override
  State<CareerPulseApp> createState() => _CareerPulseAppState();
}

class _CareerPulseAppState extends State<CareerPulseApp> {
  late final AuthService _authService;
  late final FirestoreService _firestoreService;
  late final ResumeService _resumeService;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _firestoreService = FirestoreService();
    _resumeService = ResumeService();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: _authService),
        Provider<FirestoreService>.value(value: _firestoreService),
        Provider<ResumeService>.value(value: _resumeService),
        Provider<ApiService>.value(value: _apiService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authService: _authService,
            firestoreService: _firestoreService,
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(
            firestoreService: _firestoreService,
          ),
        ),
        ChangeNotifierProvider<AnalysisProvider>(
          create: (_) => AnalysisProvider(
            apiService: _apiService,
            resumeService: _resumeService,
            firestoreService: _firestoreService,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.read<AuthProvider>();
          final router = createRouter(authProvider);

          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
