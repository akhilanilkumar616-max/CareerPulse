import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/responsive_layout.dart';

/// Forgot Password screen for password reset via Firebase
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.resetPassword(_emailController.text.trim());

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkNavy),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ResponsiveLayout(
              maxWidth: AppConstants.maxFormWidth,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkNavy.withAlpha(12),
                      offset: const Offset(0, 6),
                      blurRadius: 24,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: _emailSent
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColors.matchedBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mark_email_read_outlined,
                              size: 48,
                              color: AppColors.teal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Check Your Inbox',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'We have sent a password reset link to ${_emailController.text.trim()}. Follow the instructions in the email to recover your account.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          AppButton(
                            text: 'Back to Sign In',
                            onPressed: () => context.go('/login'),
                            width: double.infinity,
                          ),
                        ],
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkNavy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Enter your account email address and we will send you a password recovery link.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 24),

                            if (authProvider.errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.errorBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.error.withAlpha(50)),
                                ),
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            AppTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'name@institution.edu',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 24),

                            AppButton(
                              text: 'Send Reset Link',
                              onPressed: _handleReset,
                              isLoading: authProvider.isLoading,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('Back to Sign In'),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
