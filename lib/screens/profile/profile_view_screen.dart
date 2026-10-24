import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/responsive_layout.dart';

/// Profile View Screen displaying current profile and options to edit
class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;

    final name = profile?.fullName.isNotEmpty == true
        ? profile!.fullName
        : authProvider.currentDisplayName;
    final email = profile?.email.isNotEmpty == true
        ? profile!.email
        : authProvider.currentEmail;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: const AppHeader(showBackButton: true, title: 'Career Profile'),
      body: SingleChildScrollView(
        child: ResponsiveLayout(
          maxWidth: 820,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Identity Header Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkNavy.withAlpha(8),
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 28,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              profile?.degree.isNotEmpty == true
                                  ? '${profile!.degree} (${profile.graduationYear})'
                                  : 'Profile Incomplete',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: 'Edit',
                      icon: Icons.edit_outlined,
                      type: AppButtonType.outline,
                      onPressed: () => context.push('/profile/edit'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Academic Information Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Education & Background',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Institution', profile?.institution ?? 'Not specified'),
                    _buildInfoRow('Education Level', profile?.educationLevel ?? 'Not specified'),
                    _buildInfoRow('Degree', profile?.degree ?? 'Not specified'),
                    _buildInfoRow('Specialization', profile?.specialization ?? 'Not specified'),
                    _buildInfoRow('Graduation Year', profile?.graduationYear ?? 'Not specified'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Skills & Competencies Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Skills',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (profile != null && profile.skills.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.skills
                            .map((s) => Chip(
                                  label: Text(s),
                                  backgroundColor: AppColors.lightBlueBackground,
                                ))
                            .toList(),
                      )
                    else
                      const Text(
                        'No skills added yet. Add your technical skills to improve analysis.',
                        style: TextStyle(color: AppColors.mutedText, fontSize: 14),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Target Career Interests
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target Career Interests',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (profile != null && profile.careerInterests.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.careerInterests
                            .map((role) => Chip(
                                  label: Text(role),
                                  backgroundColor: AppColors.matchedBackground,
                                ))
                            .toList(),
                      )
                    else
                      const Text(
                        'No career interests selected.',
                        style: TextStyle(color: AppColors.mutedText, fontSize: 14),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Professional Summary Card
              if (profile?.professionalSummary.isNotEmpty == true) ...[
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Professional Summary',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkNavy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile!.professionalSummary,
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Actions
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'View Assessment History',
                      type: AppButtonType.secondary,
                      icon: Icons.history,
                      onPressed: () => context.push('/history'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: AppButton(
                      text: 'Sign Out',
                      type: AppButtonType.outline,
                      icon: Icons.logout,
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
