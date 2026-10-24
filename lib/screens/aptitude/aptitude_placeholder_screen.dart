import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/responsive_layout.dart';

/// Phase 2 Placeholder Screen adhering to CareerPulse Theme
class AptitudePlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const AptitudePlaceholderScreen({
    super.key,
    this.title = 'Aptitude Assessment',
    this.description = 'Comprehensive quantitative, logical, and verbal aptitude testing.',
    this.icon = Icons.calculate_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: AppHeader(showBackButton: true, title: title),
      body: Center(
        child: ResponsiveLayout(
          maxWidth: 620,
          child: Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkNavy.withAlpha(8),
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.lightBlueBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 52, color: AppColors.primaryBlue),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: AppColors.secondaryText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),

                // Phase 2 Notice Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.matchedBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.teal.withAlpha(50)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_filled, size: 18, color: AppColors.teal),
                      SizedBox(width: 10),
                      Text(
                        'This feature will be available in the next development phase.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Back',
                        onPressed: () => context.pop(),
                        type: AppButtonType.outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Go to Dashboard',
                        onPressed: () => context.go('/dashboard'),
                        type: AppButtonType.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
