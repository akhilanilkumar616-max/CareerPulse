import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/pulse_background.dart';
import '../../widgets/responsive_layout.dart';

/// Module 2: Resume Analysis Input Screen
class ResumeAnalysisScreen extends StatefulWidget {
  const ResumeAnalysisScreen({super.key});

  @override
  State<ResumeAnalysisScreen> createState() => _ResumeAnalysisScreenState();
}

class _ResumeAnalysisScreenState extends State<ResumeAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController(text: 'Frontend Developer');
  final _companyController = TextEditingController();
  final _jobDescriptionController = TextEditingController();

  static const String _sampleJobDescription =
      'We are looking for a passionate Frontend Developer skilled in JavaScript, HTML5, CSS3, and React. '
      'The ideal candidate should have hands-on experience building responsive web applications, interacting with REST APIs, '
      'and version control with Git. Knowledge of TypeScript, Docker, and testing frameworks is a strong plus.';

  @override
  void initState() {
    super.initState();
    // Pre-populate with a sensible default description so user can easily test
    _jobDescriptionController.text = _sampleJobDescription;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleAnalyze() async {
    if (!_formKey.currentState!.validate()) return;

    final analysisProvider = context.read<AnalysisProvider>();
    final authProvider = context.read<AuthProvider>();

    final success = await analysisProvider.analyzeResume(
      jobTitle: _jobTitleController.text.trim(),
      companyName: _companyController.text.trim(),
      jobDescription: _jobDescriptionController.text.trim(),
      uid: authProvider.currentUid,
    );

    if (success && mounted) {
      context.push('/analysis-report');
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisProvider = context.watch<AnalysisProvider>();
    final selectedFile = analysisProvider.selectedFile;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: const AppHeader(showBackButton: true, title: 'Resume Analysis'),
      body: PulseBackground(
        borderRadius: BorderRadius.zero,
        child: analysisProvider.isAnalyzing
            ? const Center(
                child: AppLoadingIndicator(
                  message:
                      'Analyzing resume against job requirements...\nExtracting skills & evaluating semantic similarity',
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: ResponsiveLayout(
                    maxWidth: 840,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border.withAlpha(220), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkNavy.withAlpha(8),
                                  offset: const Offset(0, 6),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Resume & Job Skill Matcher',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.darkNavy,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Upload candidate resume PDF and benchmark required competencies using our fine-tuned skill taxonomy and cosine embeddings.',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: AppColors.secondaryText,
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Error message if any
                          if (analysisProvider.errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.errorBackground,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.error.withAlpha(70)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      analysisProvider.errorMessage!,
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
                          ],

                          const SizedBox(height: 18),
                          const PulseDivider(height: 24, opacity: 0.38),
                          const SizedBox(height: 18),

                          // Job Details Card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border.withAlpha(220), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkNavy.withAlpha(8),
                                  offset: const Offset(0, 6),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Target Job Specification *',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.darkNavy,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Provide target role parameters and job description expectations.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 22),

                                    // Job Title
                                    AppTextField(
                                      controller: _jobTitleController,
                                      label: 'Target Job Role *',
                                      hint: 'e.g. Frontend Developer, Python Developer, Data Analyst',
                                      prefixIcon: Icons.badge_outlined,
                                      validator: (val) =>
                                          Validators.required(val, 'Please enter target job title'),
                                    ),
                                    const SizedBox(height: 18),

                                    // Company Name
                                    AppTextField(
                                      controller: _companyController,
                                      label: 'Company Name (Optional)',
                                      hint: 'e.g. Google, Microsoft, Tech Corp',
                                      prefixIcon: Icons.business_outlined,
                                    ),
                                    const SizedBox(height: 18),

                                    // Job Description
                                    AppTextField(
                                      controller: _jobDescriptionController,
                                      label: 'Job Description & Requirements *',
                                      hint: 'Paste the complete job description, requirements, and responsibilities...',
                                      prefixIcon: Icons.article_outlined,
                                      maxLines: 8,
                                      minLines: 5,
                                      validator: Validators.jobDescription,
                                      helperText: 'A detailed job description produces higher precision semantic matching.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
                          const PulseDivider(height: 24, opacity: 0.38),
                          const SizedBox(height: 18),

                          // Resume Upload Card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border.withAlpha(220), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkNavy.withAlpha(8),
                                  offset: const Offset(0, 6),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Candidate Resume Document *',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.darkNavy,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Standard PDF format up to 5 MB supported.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 22),

                                        if (selectedFile == null)
                                          InkWell(
                                            onTap: () => analysisProvider.pickResume(),
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 24),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    AppColors.lightBlueBackground,
                                                    AppColors.matchedBackground.withAlpha(120),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: AppColors.primaryBlue.withAlpha(100),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors.primaryBlue.withAlpha(25),
                                                          blurRadius: 14,
                                                          offset: const Offset(0, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      Icons.file_upload_outlined,
                                                      size: 36,
                                                      color: AppColors.primaryBlue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const Text(
                                                    'Click or drop resume PDF here to upload',
                                                    style: TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.darkNavy,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  const Text(
                                                    'PDF only (Max 5 MB) • Compatible with ATS & standard text extractors',
                                                    style: TextStyle(
                                                      fontSize: 12.5,
                                                      color: AppColors.mutedText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          Container(
                                            padding: const EdgeInsets.all(18),
                                            decoration: BoxDecoration(
                                              color: AppColors.matchedBackground,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: AppColors.teal.withAlpha(120), width: 1.2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.teal.withAlpha(15),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius: BorderRadius.circular(12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors.error.withAlpha(20),
                                                        blurRadius: 8,
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.picture_as_pdf_rounded,
                                                    color: AppColors.error,
                                                    size: 30,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        selectedFile.name,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15,
                                                          color: AppColors.darkNavy,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 6,
                                                            height: 6,
                                                            decoration: const BoxDecoration(
                                                              color: AppColors.teal,
                                                              shape: BoxShape.circle,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Text(
                                                            '${selectedFile.formattedSize}  •  Ready for evaluation',
                                                            style: const TextStyle(
                                                              fontSize: 12.5,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.teal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  icon: const Icon(Icons.refresh_rounded, size: 18),
                                                  label: const Text('Change'),
                                                  onPressed: () => analysisProvider.pickResume(),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close_rounded, color: AppColors.secondaryText, size: 20),
                                                  onPressed: () => analysisProvider.clearSelectedFile(),
                                                  tooltip: 'Remove',
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                          const SizedBox(height: 28),

                          // Analyze Resume Button
                          AppButton(
                            text: 'Analyze Resume',
                            icon: Icons.analytics_outlined,
                            height: 52,
                            onPressed: selectedFile == null ? null : _handleAnalyze,
                            isLoading: analysisProvider.isAnalyzing,
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shield_outlined, size: 14, color: AppColors.secondaryText),
                                SizedBox(width: 6),
                                Text(
                                  'Privacy protected • End-to-end local & secure semantic evaluation',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
