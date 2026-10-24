import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/pulse_background.dart';
import '../../widgets/responsive_layout.dart';

/// Clean, modern Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      await profileProvider.loadProfile(authProvider.currentUid);
      if (!mounted) return;

      if (!profileProvider.hasCompletedProfile) {
        context.go('/profile/setup');
      } else {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Stack(
        children: [
          // Ambient blurred logo and pulse wave visual background
          Positioned.fill(
            child: _buildBlurredLogoBackground(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ResponsiveLayout(
                  maxWidth: AppConstants.maxFormWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border.withAlpha(220), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkNavy.withAlpha(14),
                          offset: const Offset(0, 8),
                          blurRadius: 30,
                        ),
                        BoxShadow(
                          color: AppColors.primaryBlue.withAlpha(10),
                          offset: const Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Logo (prominent)
                              Center(
                                child: Hero(
                                  tag: 'app-logo',
                                  child: Image.asset(
                                    AppConstants.logoAsset,
                                    height: 155,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Text(
                                      AppConstants.appName,
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkNavy,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),

                                  // Welcome headings
                                  const Text(
                                    'Welcome Back',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.darkNavy,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Sign in to access your resume assessments and career prep',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                      // Error banner if any
                      if (authProvider.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.error.withAlpha(50)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Email Field
                      AppTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'name@institution.edu',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 18),

                      // Password Field
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        validator: Validators.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.secondaryText,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot-password'),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Button
                      AppButton(
                        text: 'Sign In',
                        icon: Icons.login_rounded,
                        onPressed: _handleLogin,
                        isLoading: authProvider.isLoading,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20),

                      // Logo-inspired Pulse Divider
                      const PulseDivider(height: 20, opacity: 0.35),
                      const SizedBox(height: 14),

                      // Navigation to Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              authProvider.clearError();
                              context.push('/register');
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
          ),
        ],
      ),
    );
  }

  /// Ambient decorative background featuring the enlarged, blurred CareerPulse logo,
  /// soft atmospheric glow pools, and underlying ECG pulse waveform geometry.
  Widget _buildBlurredLogoBackground() {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Underlying decorative pulse canvas matching CareerPulse branding
          Positioned.fill(
            child: CustomPaint(
              painter: PulseWavePainter(),
            ),
          ),
          // Soft radial glow in top-left (Teal)
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.teal.withAlpha(50), // ~20% opacity
                    AppColors.teal.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),

          // Soft radial glow in bottom-right (Primary Blue)
          Positioned(
            bottom: -140,
            right: -120,
            child: Container(
              width: 480,
              height: 480,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryBlue.withAlpha(45), // ~18% opacity
                    AppColors.primaryBlue.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),

          // Primary enlarged, blurred logo watermark in the center
          Center(
            child: Opacity(
              opacity: 0.16,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Transform.scale(
                  scale: 1.35,
                  child: Image.asset(
                    AppConstants.logoAsset,
                    width: 620,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
              ),
            ),
          ),

          // Faint, secondary semi-sharp logo silhouette for depth
          Center(
            child: Opacity(
              opacity: 0.045,
              child: Transform.scale(
                scale: 1.15,
                child: Image.asset(
                  AppConstants.logoAsset,
                  width: 580,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
