import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum AppButtonType { primary, secondary, outline }

/// Standard reusable button adhering to CareerPulse visual identity
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (type) {
        case AppButtonType.primary:
          return AppColors.primaryBlue;
        case AppButtonType.secondary:
          return AppColors.teal;
        case AppButtonType.outline:
          return Colors.transparent;
      }
    }

    Color getForegroundColor() {
      switch (type) {
        case AppButtonType.primary:
        case AppButtonType.secondary:
          return AppColors.white;
        case AppButtonType.outline:
          return AppColors.primaryBlue;
      }
    }

    BorderSide? getBorderSide() {
      if (type == AppButtonType.outline) {
        return const BorderSide(color: AppColors.primaryBlue, width: 1.5);
      }
      return null;
    }

    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(getForegroundColor()),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: getForegroundColor()),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: getForegroundColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getForegroundColor(),
          elevation: 0,
          side: getBorderSide(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: child,
      ),
    );
  }
}
