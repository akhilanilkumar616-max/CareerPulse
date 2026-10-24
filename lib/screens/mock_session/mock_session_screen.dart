import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/analysis_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/responsive_layout.dart';

/// Section 13: Mock Session Setup Page (Navigable Phase 1 version)
class MockSessionScreen extends StatefulWidget {
  const MockSessionScreen({super.key});

  @override
  State<MockSessionScreen> createState() => _MockSessionScreenState();
}

class _MockSessionScreenState extends State<MockSessionScreen> {
  String _selectedDifficulty = 'Medium';

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    final analysisProvider = context.watch<AnalysisProvider>();
    final hasResult = analysisProvider.hasAnalysisResult;
    final latestResult = analysisProvider.currentResult ??
        (analysisProvider.history.isNotEmpty ? analysisProvider.history.first : null);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: const AppHeader(showBackButton: true, title: 'Mock Preparation'),
      body: SingleChildScrollView(
        child: ResponsiveLayout(
          maxWidth: 860,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pre-requisite check card if no resume analyzed
              if (!hasResult) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.warningBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.warning.withAlpha(60)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, size: 36, color: AppColors.warning),
                      const SizedBox(height: 12),
                      const Text(
                        'Resume Analysis Recommended',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkNavy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'To get customized interview questions and difficulty aligned with your skill gaps, please analyze your resume first.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Analyze Resume First',
                        onPressed: () => context.push('/resume-analysis'),
                        type: AppButtonType.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ] else if (latestResult != null) ...[
                // Display context from active analysis
                Container(
                  padding: const EdgeInsets.all(20),
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
                        child: const Icon(Icons.psychology, color: AppColors.primaryBlue, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target Role: ${latestResult.jobTitle}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkNavy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${latestResult.matchScore}% Match  •  ${latestResult.potentialMissingSkills.length} Identified Gaps',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Session Setup Heading
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
                      'Prepare for Your Mock Session',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select the preparation level and choose your session type.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Difficulty selector
                    const Text(
                      'Select Difficulty Level:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: _difficulties.map((diff) {
                        final isSelected = _selectedDifficulty == diff;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              onTap: () => setState(() => _selectedDifficulty = diff),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryBlue : AppColors.lightBlueBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primaryBlue : AppColors.border,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    diff,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: isSelected ? AppColors.white : AppColors.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Two Feature Cards: Aptitude Test & Mock Interview
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aptitude Test Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calculate_outlined, color: AppColors.primaryBlue, size: 28),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aptitude Test',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Prepare for aptitude-based assessments including logical reasoning and problem solving.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.secondaryText,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: 'Start Aptitude Test',
                            onPressed: () => context.push('/aptitude-test'),
                            type: AppButtonType.primary,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Mock Interview Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.record_voice_over_outlined, color: AppColors.teal, size: 28),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Mock Interview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Practice interview questions for your selected role.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.secondaryText,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            text: 'View Interview Questions',
                            onPressed: () => context.push('/interview-questions'),
                            type: AppButtonType.outline,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Start Interview Session',
                            onPressed: () => context.push('/interview-session'),
                            type: AppButtonType.secondary,
                            width: double.infinity,
                          ),
                        ],
                      ),
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
}
