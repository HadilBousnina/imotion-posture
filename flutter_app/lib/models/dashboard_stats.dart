class DashboardStats {
  final int totalAdherents;
  final int sessionsToday;
  final double averageScore;
  final double progression;

  const DashboardStats({
    required this.totalAdherents,
    required this.sessionsToday,
    required this.averageScore,
    required this.progression,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalAdherents: json['total_adherents'] ?? 0,
      sessionsToday: json['sessions_today'] ?? 0,
      averageScore:
          (json['average_score'] as num?)?.toDouble() ?? 0,
      progression:
          (json['progression'] as num?)?.toDouble() ?? 0,
    );
  }
}