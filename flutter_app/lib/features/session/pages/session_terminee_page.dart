import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../dashboard/widgets/sidebar.dart';

class ErreurFrequente {
  final String label;
  final int pourcentage;
  final Color color;
  final IconData icon;

  const ErreurFrequente({
    required this.label,
    required this.pourcentage,
    required this.color,
    required this.icon,
  });
}

class SessionTermineePage extends StatelessWidget {
  final int score;
  final String duree;
  final int nbSquats;
  final int precision;
  final int scorePrecedent;
  final int progression;
  final List<ErreurFrequente> erreurs;

  const SessionTermineePage({
    super.key,
    this.score = 84,
    this.duree = "18:24",
    this.nbSquats = 42,
    this.precision = 84,
    this.scorePrecedent = 78,
    this.progression = 6,
    this.erreurs = const [
      ErreurFrequente(
        label: "Dos légèrement incliné",
        pourcentage: 22,
        color: AppColors.warning,
        icon: Icons.warning_amber_rounded,
      ),
      ErreurFrequente(
        label: "Amplitude insuffisante",
        pourcentage: 13,
        color: AppColors.error,
        icon: Icons.arrow_downward_rounded,
      ),
      ErreurFrequente(
        label: "Genoux vers l'intérieur",
        pourcentage: 12,
        color: AppColors.info,
        icon: Icons.compress_rounded,
      ),
    ],
  });

  String get _scoreLabel {
    if (score >= 85) return "Excellent travail !";
    if (score >= 70) return "Très bon travail !";
    if (score >= 50) return "Peut mieux faire";
    return "À retravailler";
  }

  Color get _scoreColor {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.info;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const Sidebar(selectedIndex: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Session terminée",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _ScoreGaugeCard(
                          score: score,
                          label: _scoreLabel,
                          color: _scoreColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _ErreursCard(erreurs: erreurs),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: "Durée",
                          value: duree,
                          icon: Icons.timer_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatBox(
                          label: "Squats",
                          value: "$nbSquats",
                          icon: Icons.fitness_center_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatBox(
                          label: "Précision",
                          value: "$precision%",
                          icon: Icons.gps_fixed_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatBox(
                          label: "Session précédente",
                          value: "$scorePrecedent",
                          icon: Icons.history_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatBox(
                          label: "Progression",
                          value: "+$progression",
                          icon: Icons.trending_up_rounded,
                          valueColor: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO : GoRouter -> nouvelle session
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Nouvelle session",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO : GoRouter -> /historique
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Voir historique complet",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreGaugeCard extends StatelessWidget {
  final int score;
  final String label;
  final Color color;

  const _ScoreGaugeCard({
    required this.score,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 14,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(Colors.transparent),
                  ),
                ),
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 14,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$score",
                      style: TextStyle(
                        color: color,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "/ 100",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErreursCard extends StatelessWidget {
  final List<ErreurFrequente> erreurs;

  const _ErreursCard({required this.erreurs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Erreurs les plus fréquentes",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...erreurs.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: e.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(e.icon, color: e.color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        e.label,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "${e.pourcentage}%",
                      style: TextStyle(
                        color: e.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}