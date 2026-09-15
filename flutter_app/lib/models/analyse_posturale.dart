class AnalysePosturale {
  final String exercise;
  final int repetitions;
  final String posture;
  final int score;
  final double confidence;
  final List<String> errors;
  final Map<String, dynamic>? details;

  AnalysePosturale({
    required this.exercise,
    required this.repetitions,
    required this.posture,
    required this.score,
    required this.confidence,
    required this.errors,
    this.details,
  });

  factory AnalysePosturale.fromJson(Map<String, dynamic> json) {
    return AnalysePosturale(
      exercise: json['exercise'] ?? '',
      repetitions: json['repetitions'] ?? 0,
      posture: json['posture'] ?? '',
      score: json['score'] ?? 0,
      confidence: (json['confidence'] ?? 0).toDouble(),
      errors: List<String>.from(
        json['errors'] ?? [],
      ),
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise,
      'repetitions': repetitions,
      'posture': posture,
      'score': score,
      'confidence': confidence,
      'errors': errors,
      'details': details,
    };
  }
}