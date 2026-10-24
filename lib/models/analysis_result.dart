import 'skill.dart';

/// Complete Resume Analysis Result Model
class AnalysisResult {
  final String resultId;
  final String jobTitle;
  final String? companyName;
  final DateTime analysisDate;
  final int matchScore; // 0 - 100
  final List<SkillMatch> matchedSkills;
  final List<SkillMatch> partialSkills;
  final List<SkillMatch> potentialMissingSkills;
  final List<SkillRecommendation> recommendations;
  final String summary;
  final String? resumeFileName;
  final String analysisVersion;

  const AnalysisResult({
    required this.resultId,
    required this.jobTitle,
    this.companyName,
    required this.analysisDate,
    required this.matchScore,
    required this.matchedSkills,
    required this.partialSkills,
    required this.potentialMissingSkills,
    required this.recommendations,
    required this.summary,
    this.resumeFileName,
    this.analysisVersion = '1.0',
  });

  int get totalIdentifiedSkills =>
      matchedSkills.length + partialSkills.length + potentialMissingSkills.length;

  Map<String, dynamic> toMap() {
    return {
      'resultId': resultId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'analysisDate': analysisDate.toIso8601String(),
      'matchScore': matchScore,
      'matchedSkills': matchedSkills.map((s) => s.toMap()).toList(),
      'partialSkills': partialSkills.map((s) => s.toMap()).toList(),
      'potentialMissingSkills': potentialMissingSkills.map((s) => s.toMap()).toList(),
      'recommendations': recommendations.map((r) => r.toMap()).toList(),
      'summary': summary,
      'resumeFileName': resumeFileName,
      'analysisVersion': analysisVersion,
    };
  }

  factory AnalysisResult.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AnalysisResult(
      resultId: docId ?? map['resultId'] as String? ?? '',
      jobTitle: map['jobTitle'] as String? ?? 'Target Role',
      companyName: map['companyName'] as String?,
      analysisDate: map['analysisDate'] != null
          ? DateTime.tryParse(map['analysisDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      matchScore: (map['matchScore'] as num?)?.toInt() ?? 0,
      matchedSkills: (map['matchedSkills'] as List<dynamic>?)
              ?.map((item) => SkillMatch.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      partialSkills: (map['partialSkills'] as List<dynamic>?)
              ?.map((item) => SkillMatch.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      potentialMissingSkills: (map['potentialMissingSkills'] as List<dynamic>?)
              ?.map((item) => SkillMatch.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      recommendations: (map['recommendations'] as List<dynamic>?)
              ?.map((item) => SkillRecommendation.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      summary: map['summary'] as String? ?? '',
      resumeFileName: map['resumeFileName'] as String?,
      analysisVersion: map['analysisVersion'] as String? ?? '1.0',
    );
  }

  /// Construct directly from FastAPI JSON response
  factory AnalysisResult.fromApiResponse(
    Map<String, dynamic> json, {
    required String resultId,
    required String jobTitle,
    String? companyName,
    String? resumeFileName,
  }) {
    return AnalysisResult(
      resultId: resultId,
      jobTitle: json['job_title'] as String? ?? jobTitle,
      companyName: companyName,
      analysisDate: DateTime.now(),
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      matchedSkills: (json['matched_skills'] as List<dynamic>?)
              ?.map((item) => SkillMatch.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      partialSkills: (json['partial_skills'] as List<dynamic>?)
              ?.map((item) => SkillMatch.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      potentialMissingSkills: (json['potential_missing_skills'] as List<dynamic>?)
              ?.map((item) => SkillMatch.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((item) => SkillRecommendation.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      summary: json['summary'] as String? ?? '',
      resumeFileName: resumeFileName,
      analysisVersion: '1.0',
    );
  }
}
