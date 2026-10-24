import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/analysis_result.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/responsive_layout.dart';

/// Section 14: Assessment History Screen displaying saved Firestore analyses
class InterviewHistoryScreen extends StatefulWidget {
  const InterviewHistoryScreen({super.key});

  @override
  State<InterviewHistoryScreen> createState() => _InterviewHistoryScreenState();
}

class _InterviewHistoryScreenState extends State<InterviewHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<AnalysisProvider>().loadHistory(authProvider.currentUid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final analysisProvider = context.watch<AnalysisProvider>();
    final history = analysisProvider.history;
    final isLoading = analysisProvider.isLoadingHistory;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: const AppHeader(showBackButton: true, title: 'Assessment History'),
      body: isLoading
          ? const Center(child: AppLoadingIndicator(message: 'Loading assessment history...'))
          : SingleChildScrollView(
              child: ResponsiveLayout(
                maxWidth: 860,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Heading card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.history, color: AppColors.primaryBlue, size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assessment History',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkNavy,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Review previous resume analyses, match scores, and identified skill gaps.',
                                  style: TextStyle(fontSize: 13.5, color: AppColors.secondaryText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // History List or Empty State
                    if (history.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: AppColors.lightBlueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.document_scanner_outlined,
                                  size: 48,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No Assessment History Found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkNavy,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Your assessment history will appear here after your first resume analysis.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 24),
                              AppButton(
                                text: 'Analyze Resume Now',
                                icon: Icons.upload_file,
                                onPressed: () => context.push('/resume-analysis'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        children: history.map((item) => _buildHistoryCard(context, item)).toList(),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, AnalysisResult item) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withAlpha(6),
            offset: const Offset(0, 3),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.matchScore >= 70
                      ? AppColors.matchedBackground
                      : item.matchScore >= 45
                          ? AppColors.warningBackground
                          : AppColors.gapBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${item.matchScore}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    if (item.companyName != null && item.companyName!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.companyName!,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(item.analysisDate),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildStatBadge(
                    '${item.matchedSkills.length} Matched',
                    AppColors.teal,
                    AppColors.matchedBackground,
                  ),
                  const SizedBox(width: 8),
                  _buildStatBadge(
                    '${item.partialSkills.length} Partial',
                    AppColors.warning,
                    AppColors.warningBackground,
                  ),
                  const SizedBox(width: 8),
                  _buildStatBadge(
                    '${item.potentialMissingSkills.length} Gaps',
                    AppColors.error,
                    AppColors.gapBackground,
                  ),
                ],
              ),
              AppButton(
                text: 'View Full Report',
                type: AppButtonType.primary,
                height: 38,
                onPressed: () {
                  context.read<AnalysisProvider>().setCurrentResult(item);
                  context.push('/analysis-report');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String text, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
