import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/profile/profile_setup_screen.dart';
import '../../screens/profile/profile_view_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/resume_analysis/resume_analysis_screen.dart';
import '../../screens/resume_analysis/analysis_report_screen.dart';
import '../../screens/mock_session/mock_session_screen.dart';
import '../../screens/aptitude/aptitude_placeholder_screen.dart';
import '../../screens/interview_history/interview_history_screen.dart';

/// Central GoRouter configuration with route guards
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authProvider.isAuthenticated;
      final loc = state.matchedLocation;

      final isPublicRoute = loc == '/splash' ||
          loc == '/login' ||
          loc == '/register' ||
          loc == '/forgot-password';

      // If user is not authenticated and trying to access protected route, redirect to login
      if (!isAuth && !isPublicRoute) {
        return '/login';
      }

      // If user is authenticated and on login/register/forgot-password, redirect to dashboard
      if (isAuth && (loc == '/login' || loc == '/register' || loc == '/forgot-password')) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileViewScreen(),
      ),
      GoRoute(
        path: '/profile/setup',
        builder: (context, state) => const ProfileSetupScreen(isEditing: false),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const ProfileSetupScreen(isEditing: true),
      ),
      GoRoute(
        path: '/resume-analysis',
        builder: (context, state) => const ResumeAnalysisScreen(),
      ),
      GoRoute(
        path: '/analysis-report',
        builder: (context, state) => const AnalysisReportScreen(),
      ),
      GoRoute(
        path: '/mock-session',
        builder: (context, state) => const MockSessionScreen(),
      ),
      GoRoute(
        path: '/aptitude-test',
        builder: (context, state) => const AptitudePlaceholderScreen(
          title: 'Aptitude Test',
          description:
              'Quantitative aptitude, logical reasoning, and verbal ability assessment.',
          icon: Icons.calculate_outlined,
        ),
      ),
      GoRoute(
        path: '/interview-questions',
        builder: (context, state) => const AptitudePlaceholderScreen(
          title: 'Role Interview Questions',
          description:
              'Curated technical and behavioral questions tailored for your target job role.',
          icon: Icons.question_answer_outlined,
        ),
      ),
      GoRoute(
        path: '/interview-session',
        builder: (context, state) => const AptitudePlaceholderScreen(
          title: 'Live Mock Interview',
          description:
              'Simulated interactive interview session with AI feedback and evaluation.',
          icon: Icons.record_voice_over_outlined,
        ),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const InterviewHistoryScreen(),
      ),
    ],
  );
}
