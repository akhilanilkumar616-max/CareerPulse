import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'app_button.dart';

/// Main Feature Card for CareerPulse Dashboard
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final IconData icon;
  final VoidCallback onAction;
  final AppButtonType buttonType;
  final Widget? trailingBadge;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.onAction,
    this.buttonType = AppButtonType.primary,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withAlpha(200), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withAlpha(10),
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
          BoxShadow(
            color: AppColors.primaryBlue.withAlpha(8),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: AppColors.heroGradient,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primaryBlue.withAlpha(40)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.teal.withAlpha(15),
                                  offset: const Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              color: AppColors.primaryBlue,
                              size: 25,
                            ),
                          ),
                  ?trailingBadge,
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            text: buttonText,
            onPressed: onAction,
            type: buttonType,
            width: double.infinity,
          ),
        ],
          ),
        ),
      ),
    );
  }
}
