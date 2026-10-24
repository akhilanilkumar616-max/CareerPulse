import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/pulse_background.dart';
import '../../widgets/responsive_layout.dart';

/// Career Profile Setup and Onboarding Screen
class ProfileSetupScreen extends StatefulWidget {
  final bool isEditing;

  const ProfileSetupScreen({super.key, this.isEditing = false});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _specializationController;
  late TextEditingController _summaryController;
  late TextEditingController _customSkillController;
  late TextEditingController _customInterestController;

  String _educationLevel = 'Undergraduate';
  String _graduationYear = '2025';

  final List<String> _skills = [];
  final List<String> _careerInterests = [];

  static const List<String> _suggestedSkills = [
    // Tech & Software
    'Python',
    'JavaScript',
    'SQL',
    'React',
    'Flutter',
    'Git',
    'Data Analysis',
    // Civil Engineering
    'AutoCAD',
    'STAAD.Pro',
    'Revit',
    'Structural Analysis',
    'Site Safety',
    'Geotechnical Engineering',
    // Animation & Digital Media
    'Blender',
    'Maya',
    'Rigging',
    'Keyframing',
    'Motion Graphics',
    'Storyboarding',
    // Healthcare & Nursing
    'Patient Triage',
    'EHR/EMR Charting',
    'BLS Certification',
    'ACLS Certification',
    'Pharmacology',
    'HIPAA Compliance',
  ];

  static const List<String> _suggestedInterests = [
    'Software Engineer',
    'Frontend Developer',
    'Civil Engineer',
    'Structural Engineer',
    '3D Animator',
    'Motion Graphics Designer',
    'Registered Nurse (RN)',
    'Clinical Nurse Specialist',
    'Data Analyst',
    'AI/ML Engineer',
    'Project Manager',
  ];

  static const List<String> _educationLevels = [
    'Undergraduate',
    'Postgraduate',
    'Doctorate',
    'Diploma / Certificate',
    'Working Professional',
  ];

  final List<String> _graduationYears = List.generate(
    10,
    (index) => (2020 + index).toString(),
  );

  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AuthProvider>();
    final existing = profileProvider.profile;

    _nameController = TextEditingController(
      text: existing?.fullName.isNotEmpty == true
          ? existing!.fullName
          : authProvider.currentDisplayName,
    );
    _institutionController = TextEditingController(text: existing?.institution ?? '');
    _degreeController = TextEditingController(text: existing?.degree ?? 'B.Tech Computer Science');
    _specializationController = TextEditingController(text: existing?.specialization ?? 'Computer Science');
    _summaryController = TextEditingController(text: existing?.professionalSummary ?? '');
    _customSkillController = TextEditingController();
    _customInterestController = TextEditingController();

    if (existing != null) {
      if (_educationLevels.contains(existing.educationLevel)) {
        _educationLevel = existing.educationLevel;
      }
      if (_graduationYears.contains(existing.graduationYear)) {
        _graduationYear = existing.graduationYear;
      }
      _skills.addAll(existing.skills);
      _careerInterests.addAll(existing.careerInterests);
    } else {
      // Default initial starter skills
      _skills.addAll(['Python', 'Java', 'SQL', 'Git']);
      _careerInterests.addAll(['Software Engineer', 'Full Stack Developer']);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _degreeController.dispose();
    _specializationController.dispose();
    _summaryController.dispose();
    _customSkillController.dispose();
    _customInterestController.dispose();
    super.dispose();
  }

  void _addCustomSkill() {
    final text = _customSkillController.text.trim();
    if (text.isNotEmpty && !_skills.contains(text)) {
      setState(() {
        _skills.add(text);
        _customSkillController.clear();
      });
    }
  }

  void _addCustomInterest() {
    final text = _customInterestController.text.trim();
    if (text.isNotEmpty && !_careerInterests.contains(text)) {
      setState(() {
        _careerInterests.add(text);
        _customInterestController.clear();
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add at least one skill.')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    final updatedProfile = UserProfile(
      uid: authProvider.currentUid,
      fullName: _nameController.text.trim(),
      email: authProvider.currentEmail,
      educationLevel: _educationLevel,
      institution: _institutionController.text.trim(),
      degree: _degreeController.text.trim(),
      specialization: _specializationController.text.trim(),
      graduationYear: _graduationYear,
      skills: _skills,
      careerInterests: _careerInterests,
      professionalSummary: _summaryController.text.trim(),
      createdAt: profileProvider.profile?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await profileProvider.saveProfile(updatedProfile);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Career profile saved successfully!'),
          backgroundColor: AppColors.teal,
        ),
      );
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Career Profile' : 'Career Profile Setup'),
        leading: widget.isEditing
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: PulseBackground(
        borderRadius: BorderRadius.zero,
        child: SafeArea(
          child: SingleChildScrollView(
            child: ResponsiveLayout(
              maxWidth: 800,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card (Personal Information)
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
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Candidate Identity & Background',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.darkNavy,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Personalize your CareerPulse employability profile and evaluations.',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Full name
                              AppTextField(
                                controller: _nameController,
                                label: 'Full Name *',
                                hint: 'e.g. Alexander Chen, Sarah Jenkins',
                                prefixIcon: Icons.person_outline,
                                validator: (val) => Validators.required(val, 'Please enter your name'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const PulseDivider(height: 24, opacity: 0.38),
                    const SizedBox(height: 18),

                    // Education section card
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
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Academic Track & Education',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkNavy,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Specify your degree, institution, and graduating cohort.',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Education level dropdown
                                  const Text(
                                    'Education Level',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  DropdownButtonFormField<String>(
                                    initialValue: _educationLevel,
                                    decoration: const InputDecoration(filled: true, fillColor: AppColors.white),
                                    items: _educationLevels
                                        .map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl)))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _educationLevel = val);
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Institution
                                  AppTextField(
                                    controller: _institutionController,
                                    label: 'College / University / Institution',
                                    hint: 'e.g. National Institute of Technology',
                                    prefixIcon: Icons.account_balance_outlined,
                                  ),
                                  const SizedBox(height: 18),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Degree
                                      Expanded(
                                        flex: 2,
                                        child: AppTextField(
                                          controller: _degreeController,
                                          label: 'Degree / Course *',
                                          hint: 'e.g. B.Tech, B.S., MSN, BFA',
                                          prefixIcon: Icons.workspace_premium_outlined,
                                          validator: (val) =>
                                              Validators.required(val, 'Please enter your degree'),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      // Graduation Year
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Grad Year',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            DropdownButtonFormField<String>(
                                              initialValue: _graduationYear,
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: AppColors.white,
                                              ),
                                              items: _graduationYears
                                                  .map((yr) =>
                                                      DropdownMenuItem(value: yr, child: Text(yr)))
                                                  .toList(),
                                              onChanged: (val) {
                                                if (val != null) setState(() => _graduationYear = val);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),

                                  // Specialization
                                  AppTextField(
                                    controller: _specializationController,
                                    label: 'Branch / Specialization',
                                    hint: 'e.g. Computer Science, Civil Engineering, 3D Animation, Nursing',
                                    prefixIcon: Icons.menu_book_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 18),
                    const PulseDivider(height: 24, opacity: 0.38),
                    const SizedBox(height: 18),

                    // Skills Section Card
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
                          padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Technical Skills & Domain Mastery *',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkNavy,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Select canonical skills or input custom specialized tools.',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 22),

                                  // Suggested chips
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _suggestedSkills.map((skill) {
                                      final isSelected = _skills.contains(skill);
                                      return FilterChip(
                                        label: Text(skill),
                                        selected: isSelected,
                                        selectedColor: AppColors.primaryBlue.withAlpha(40),
                                        checkmarkColor: AppColors.primaryBlue,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _skills.add(skill);
                                            } else {
                                              _skills.remove(skill);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),

                                  // Custom skill entry
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          controller: _customSkillController,
                                          hint: 'Add custom skill (e.g. AWS, Kotlin, STAAD.Pro)',
                                          prefixIcon: Icons.add_circle_outline,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      AppButton(
                                        text: 'Add',
                                        icon: Icons.add,
                                        onPressed: _addCustomSkill,
                                        type: AppButtonType.secondary,
                                      ),
                                    ],
                                  ),

                                  if (_skills.isNotEmpty) ...[
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Active Skills Selected:',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _skills.map((skill) {
                                        return Chip(
                                          label: Text(skill),
                                          backgroundColor: AppColors.matchedBackground,
                                          side: BorderSide(color: AppColors.teal.withAlpha(80)),
                                          deleteIcon: const Icon(Icons.close, size: 16),
                                          onDeleted: () {
                                            setState(() => _skills.remove(skill));
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 18),
                    const PulseDivider(height: 24, opacity: 0.38),
                    const SizedBox(height: 18),

                    // Career Interests Section Card
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
                          padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Target Career Interests & Roles',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkNavy,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Roles you are aiming for in recruitment, hiring, and interviews.',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 22),

                                  // Suggested roles
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _suggestedInterests.map((role) {
                                      final isSelected = _careerInterests.contains(role);
                                      return FilterChip(
                                        label: Text(role),
                                        selected: isSelected,
                                        selectedColor: AppColors.teal.withAlpha(40),
                                        checkmarkColor: AppColors.teal,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _careerInterests.add(role);
                                            } else {
                                              _careerInterests.remove(role);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),

                                  // Custom interest entry
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          controller: _customInterestController,
                                          hint: 'Add custom target role (e.g. Structural Engineer)',
                                          prefixIcon: Icons.work_outline,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      AppButton(
                                        text: 'Add',
                                        icon: Icons.add,
                                        onPressed: _addCustomInterest,
                                        type: AppButtonType.secondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 18),
                    const PulseDivider(height: 24, opacity: 0.38),
                    const SizedBox(height: 18),

                    // Professional Summary
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
                          padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Professional Summary (Optional)',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkNavy,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Highlight key projects, research initiatives, or technical passions.',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  AppTextField(
                                    controller: _summaryController,
                                    hint: 'Brief summary of your academic projects, passion, and career aspirations...',
                                    maxLines: 4,
                                    minLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 32),

                    // Save Profile Button
                    AppButton(
                      text: widget.isEditing ? 'Save Profile Changes' : 'Complete Profile Setup & Continue',
                      icon: widget.isEditing ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                      onPressed: _handleSave,
                      isLoading: profileProvider.isLoading,
                      height: 54,
                    ),
                    const SizedBox(height: 28),
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
