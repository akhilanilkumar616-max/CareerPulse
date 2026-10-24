import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/skill.dart';
import '../../providers/analysis_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/responsive_layout.dart';

/// Skill Gap Analysis and Match Report Screen
class AnalysisReportScreen extends StatelessWidget {
  const AnalysisReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analysisProvider = context.watch<AnalysisProvider>();
    final result = analysisProvider.currentResult;

    if (result == null) {
      return Scaffold(
        backgroundColor: AppColors.lightBlueBackground,
        appBar: const AppHeader(showBackButton: true, title: 'Analysis Report'),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.description_outlined, size: 54, color: AppColors.mutedText),
              const SizedBox(height: 16),
              const Text(
                'No analysis report selected.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkNavy),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Go to Resume Analysis',
                onPressed: () => context.go('/resume-analysis'),
              ),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat('MMMM dd, yyyy');

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: const AppHeader(showBackButton: true, title: 'Resume Analysis Report'),
      body: SingleChildScrollView(
        child: ResponsiveLayout(
          maxWidth: 900,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary & Score Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkNavy.withAlpha(8),
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlueBackground,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Analyzed on ${dateFormat.format(result.analysisDate)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                result.jobTitle,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                              if (result.companyName != null && result.companyName!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  result.companyName!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Text(
                                result.summary,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Score Badge / Ring
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            border: Border.all(
                              color: result.matchScore >= 70
                                  ? AppColors.teal
                                  : result.matchScore >= 45
                                      ? AppColors.warning
                                      : AppColors.error,
                              width: 6,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${result.matchScore}%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: result.matchScore >= 70
                                        ? AppColors.teal
                                        : result.matchScore >= 45
                                            ? AppColors.warning
                                            : AppColors.error,
                                  ),
                                ),
                                const Text(
                                  'Match',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Metric breakdown counters
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricItem(
                            title: 'Matched Skills',
                            count: result.matchedSkills.length,
                            color: AppColors.teal,
                            bgColor: AppColors.matchedBackground,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricItem(
                            title: 'Needs Verification',
                            count: result.partialSkills.length,
                            color: AppColors.warning,
                            bgColor: AppColors.warningBackground,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricItem(
                            title: 'Potential Gaps',
                            count: result.potentialMissingSkills.length,
                            color: AppColors.error,
                            bgColor: AppColors.gapBackground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Academic / Transparency disclaimer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlueBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 18, color: AppColors.deepBlue),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Estimated Job Skill Match: This score reflects the skills identified in your resume and job description. It does not measure your complete ability or predict hiring outcomes.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.secondaryText,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section 1: Matched Skills
              _buildSectionCard(
                title: 'Matched Skills (${result.matchedSkills.length})',
                subtitle: 'Skills explicitly identified in your resume that fulfill the job requirements.',
                icon: Icons.check_circle_outline,
                iconColor: AppColors.teal,
                children: result.matchedSkills.isNotEmpty
                    ? result.matchedSkills.map((s) => _buildSkillTile(s, AppColors.teal)).toList()
                    : [const Text('No direct skill matches identified in this comparison.', style: TextStyle(color: AppColors.mutedText))],
              ),
              const SizedBox(height: 20),

              // Section 2: Needs Verification / Partial
              if (result.partialSkills.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Needs Verification (${result.partialSkills.length})',
                  subtitle: 'Related evidence exists in your resume, but the required competency or depth is uncertain.',
                  icon: Icons.help_outline,
                  iconColor: AppColors.warning,
                  children: result.partialSkills.map((s) => _buildSkillTile(s, AppColors.warning)).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Section 3: Potential Skill Gaps
              _buildSectionCard(
                title: 'Skills Not Identified in Your Resume (${result.potentialMissingSkills.length})',
                subtitle: 'A skill not found in a resume does not necessarily mean you lack it. Verify each potential gap and consider updating your resume if experienced.',
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.error,
                children: result.potentialMissingSkills.isNotEmpty
                    ? result.potentialMissingSkills.map((s) => _buildSkillTile(s, AppColors.error)).toList()
                    : [const Text('No missing skills detected! Great job.', style: TextStyle(color: AppColors.teal))],
              ),
              const SizedBox(height: 20),

              // Section 4: Recommendations
              if (result.recommendations.isNotEmpty) ...[
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
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: AppColors.primaryBlue, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Personalized Recommendations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Targeted preparation tips based on your identified skill gaps.',
                        style: TextStyle(fontSize: 13.5, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 16),
                      ...result.recommendations.map(
                        (r) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.skill,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                r.recommendation,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.secondaryText,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // Report Actions (3 buttons per requirements)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppButton(
                      text: 'Start Mock Session',
                      icon: Icons.play_arrow,
                      onPressed: () => context.push('/mock-session'),
                      type: AppButtonType.primary,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: AppButton(
                      text: 'Analyze Another Resume',
                      icon: Icons.refresh,
                      onPressed: () => context.push('/resume-analysis'),
                      type: AppButtonType.secondary,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: 'Dashboard',
                      icon: Icons.dashboard_outlined,
                      onPressed: () => context.go('/dashboard'),
                      type: AppButtonType.outline,
                      height: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required int count,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13.5, color: AppColors.secondaryText, height: 1.4),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSkillTile(SkillMatch skill, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: AppColors.primaryText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  skill.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          if (skill.resumeEvidence != null && skill.resumeEvidence!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Evidence: "${skill.resumeEvidence}"',
              style: const TextStyle(
                fontSize: 12.5,
                fontStyle: FontStyle.italic,
                color: AppColors.secondaryText,
              ),
            ),
          ],
          if (skill.reason != null && skill.reason!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              skill.reason!,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
