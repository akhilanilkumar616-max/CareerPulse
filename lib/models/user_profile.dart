/// User Profile Model for CareerPulse
class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String educationLevel;
  final String institution;
  final String degree;
  final String specialization;
  final String graduationYear;
  final List<String> skills;
  final List<String> careerInterests;
  final List<String> preferredJobRoles;
  final String professionalSummary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.educationLevel = '',
    this.institution = '',
    this.degree = '',
    this.specialization = '',
    this.graduationYear = '',
    this.skills = const [],
    this.careerInterests = const [],
    this.preferredJobRoles = const [],
    this.professionalSummary = '',
    this.createdAt,
    this.updatedAt,
  });

  bool get isProfileComplete =>
      fullName.isNotEmpty &&
      degree.isNotEmpty &&
      skills.isNotEmpty;

  UserProfile copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? educationLevel,
    String? institution,
    String? degree,
    String? specialization,
    String? graduationYear,
    List<String>? skills,
    List<String>? careerInterests,
    List<String>? preferredJobRoles,
    String? professionalSummary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      educationLevel: educationLevel ?? this.educationLevel,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      specialization: specialization ?? this.specialization,
      graduationYear: graduationYear ?? this.graduationYear,
      skills: skills ?? this.skills,
      careerInterests: careerInterests ?? this.careerInterests,
      preferredJobRoles: preferredJobRoles ?? this.preferredJobRoles,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'educationLevel': educationLevel,
      'institution': institution,
      'degree': degree,
      'specialization': specialization,
      'graduationYear': graduationYear,
      'skills': skills,
      'careerInterests': careerInterests,
      'preferredJobRoles': preferredJobRoles,
      'professionalSummary': professionalSummary,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      educationLevel: map['educationLevel'] as String? ?? '',
      institution: map['institution'] as String? ?? '',
      degree: map['degree'] as String? ?? '',
      specialization: map['specialization'] as String? ?? '',
      graduationYear: map['graduationYear'] as String? ?? '',
      skills: (map['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      careerInterests: (map['careerInterests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      preferredJobRoles: (map['preferredJobRoles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      professionalSummary: map['professionalSummary'] as String? ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt'].toString()) : null,
    );
  }
}
