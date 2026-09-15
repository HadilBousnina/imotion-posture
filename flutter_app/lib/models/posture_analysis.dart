class PostureAnalysis {
  final String exercise;
  final int repetitions;
  final String posture;
  final int score;
  final double confidence;
  final List<String> errors;
  final Map<String, dynamic>? details;

  const PostureAnalysis({
    required this.exercise,
    required this.repetitions,
    required this.posture,
    required this.score,
    required this.confidence,
    required this.errors,
    this.details,
  });

  factory PostureAnalysis.fromJson(Map<String, dynamic> json) {
    return PostureAnalysis(
      exercise: json['exercise'],
      repetitions: json['repetitions'],
      posture: json['posture'],
      score: json['score'],
      confidence: (json['confidence'] as num).toDouble(),
      errors: List<String>.from(json['errors']),
      details: json['details'],
    );
  }
}