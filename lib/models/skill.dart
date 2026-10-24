/// Skill item with match categorization and context
class SkillMatch {
  final String name;
  final String status; // 'matched', 'partial', 'potential_gap'
  final String? resumeEvidence;
  final String? reason;

  const SkillMatch({
    required this.name,
    required this.status,
    this.resumeEvidence,
    this.reason,
  });

  bool get isMatched => status == 'matched';
  bool get isPartial => status == 'partial';
  bool get isPotentialGap => status == 'potential_gap';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'resume_evidence': resumeEvidence,
      'reason': reason,
    };
  }

  factory SkillMatch.fromMap(Map<String, dynamic> map) {
    return SkillMatch(
      name: map['name'] as String? ?? '',
      status: map['status'] as String? ?? 'potential_gap',
      resumeEvidence: map['resume_evidence'] as String?,
      reason: map['reason'] as String?,
    );
  }
}

/// Skill recommendation item
class SkillRecommendation {
  final String skill;
  final String recommendation;

  const SkillRecommendation({
    required this.skill,
    required this.recommendation,
  });

  Map<String, dynamic> toMap() {
    return {
      'skill': skill,
      'recommendation': recommendation,
    };
  }

  factory SkillRecommendation.fromMap(Map<String, dynamic> map) {
    return SkillRecommendation(
      skill: map['skill'] as String? ?? '',
      recommendation: map['recommendation'] as String? ?? '',
    );
  }
}
