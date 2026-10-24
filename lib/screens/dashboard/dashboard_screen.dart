import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../models/analysis_result.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/feature_card.dart';
import '../../widgets/pulse_background.dart';
import '../../widgets/responsive_layout.dart';

/// Main CareerPulse Dashboard & Landing Page
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<AnalysisProvider>().loadHistory(authProvider.currentUid);
        context.read<ProfileProvider>().loadProfile(authProvider.currentUid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final analysisProvider = context.watch<AnalysisProvider>();
    final history = analysisProvider.history;

    final displayName = authProvider.currentDisplayName;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: const AppHeader(),
      body: PulseBackground(
        borderRadius: BorderRadius.zero,
        child: SingleChildScrollView(
          child: ResponsiveLayout(
            maxWidth: AppConstants.maxContentWidth,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Hero Banner with Faded Pulse Background & Prominently Scaled Logo
                PulseBackground(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkNavy.withAlpha(8),
                          offset: const Offset(0, 8),
                          blurRadius: 28,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.isMobile(context) ? 20 : 36,
                      vertical: Responsive.isMobile(context) ? 28 : 38,
                    ),
                    child: Responsive(
                      // Desktop layout: Side-by-side with 50%+ enlarged logo (height 250)
                      desktop: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildHeroContent(context, displayName),
                          ),
                          const SizedBox(width: 36),
                          Expanded(
                            flex: 2,
                            child: _buildProminentLogo(context, height: 250),
                          ),
                        ],
                      ),
                      // Tablet layout: Side-by-side with enlarged logo (height 180)
                      tablet: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildHeroContent(context, displayName),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 2,
                            child: _buildProminentLogo(context, height: 180),
                          ),
                        ],
                      ),
                      // Mobile layout: Stacked with prominent logo (height 110) anchoring the hero cleanly
                      mobile: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: _buildProminentLogo(context, height: 110),
                          ),
                          const SizedBox(height: 24),
                          _buildHeroContent(context, displayName),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Logo-inspired Pulse divider
                const PulseDivider(height: 28, opacity: 0.45),
                const SizedBox(height: 32),

                // Section Heading: Core Features with logo-inspired pulse badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.teal.withAlpha(60)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal.withAlpha(18),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.insights,
                        size: 20,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assessment & Preparation Modules',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'AI-powered resume parsing and targeted skill gap evaluations',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // 3 Main Feature Cards in Responsive Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;
                    final isMedium = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildResumeAnalysisCard(context)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildMockSessionCard(context)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildHistoryCard(context)),
                        ],
                      );
                    } else if (isMedium) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildResumeAnalysisCard(context)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildMockSessionCard(context)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildHistoryCard(context),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildResumeAnalysisCard(context),
                          const SizedBox(height: 16),
                          _buildMockSessionCard(context),
                          const SizedBox(height: 16),
                          _buildHistoryCard(context),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 38),

                // Logo-inspired Pulse divider
                const PulseDivider(height: 28, opacity: 0.4),
                const SizedBox(height: 32),

                // Section Heading: Recent Activity with logo-inspired badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.heroGradient,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primaryBlue.withAlpha(60)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withAlpha(16),
                                offset: const Offset(0, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.history,
                            size: 20,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Analysis Activity',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkNavy,
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Your latest resume assessments and benchmark reports',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (history.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => context.push('/history'),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('View All'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Recent Activity Records or Empty State
                if (history.isNotEmpty)
                  Column(
                    children: history.take(3).map((item) => _buildRecentItem(context, item)).toList(),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              size: 40,
                              color: AppColors.deepBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No assessment results yet',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Analyze your resume against a job description to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 18),
                          AppButton(
                            text: 'Analyze Resume',
                            onPressed: () => context.push('/resume-analysis'),
                            type: AppButtonType.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context, String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $displayName',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Build your career with confidence.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.darkNavy,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'AI-powered employability assessment and resume analytics across engineering, animation, healthcare, and technology domains.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.secondaryText,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              text: 'Analyze My Resume',
              icon: Icons.upload_file,
              onPressed: () => context.push('/resume-analysis'),
            ),
            AppButton(
              text: 'View History',
              icon: Icons.history,
              type: AppButtonType.outline,
              onPressed: () => context.push('/history'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProminentLogo(BuildContext context, {required double height}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(220),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withAlpha(180), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withAlpha(14),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          AppConstants.logoAsset,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insights, size: height * 0.5, color: AppColors.primaryBlue),
              const SizedBox(height: 8),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumeAnalysisCard(BuildContext context) {
    return FeatureCard(
      title: 'Resume Analysis',
      description:
          'Compare your resume with a job description and identify matching skills and potential skill gaps.',
      buttonText: 'Upload Resume',
      icon: Icons.document_scanner_outlined,
      onAction: () => context.push('/resume-analysis'),
      buttonType: AppButtonType.primary,
    );
  }

  Widget _buildMockSessionCard(BuildContext context) {
    return FeatureCard(
      title: 'Start Mock Session',
      description: 'Prepare for aptitude tests and job interviews.',
      buttonText: 'Start Session',
      icon: Icons.quiz_outlined,
      onAction: () => context.push('/mock-session'),
      buttonType: AppButtonType.secondary,
      trailingBadge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.lightBlueBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Phase 2',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context) {
    return FeatureCard(
      title: 'Assessment History',
      description: 'Review previous resume analyses and track your preparation.',
      buttonText: 'View History',
      icon: Icons.history,
      onAction: () => context.push('/history'),
      buttonType: AppButtonType.outline,
    );
  }

  Widget _buildRecentItem(BuildContext context, AnalysisResult item) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.matchScore >= 70
                  ? AppColors.matchedBackground
                  : item.matchScore >= 45
                      ? AppColors.partialBackground
                      : AppColors.gapBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${item.matchScore}%',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: item.matchScore >= 70
                      ? AppColors.teal
                      : item.matchScore >= 45
                          ? AppColors.warning
                          : AppColors.error,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.jobTitle,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dateFormat.format(item.analysisDate)}  •  ${item.matchedSkills.length} Matched  •  ${item.potentialMissingSkills.length} Gaps',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            text: 'View Report',
            type: AppButtonType.outline,
            height: 38,
            onPressed: () {
              context.read<AnalysisProvider>().setCurrentResult(item);
              context.push('/analysis-report');
            },
          ),
        ],
      ),
    );
  }
}
