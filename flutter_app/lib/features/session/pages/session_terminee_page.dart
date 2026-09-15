import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../dashboard/widgets/sidebar.dart';

/// ===============================================================
/// ERREURS
/// ===============================================================

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

/// Convertit les erreurs retournées par le backend IA
/// en objets utilisables par l'interface.
List<ErreurFrequente> fromStrings(List<String> errors) {
  return errors.map((error) {
    switch (error) {
      case "Dos légèrement incliné":
        return const ErreurFrequente(
          label: "Dos légèrement incliné",
          pourcentage: 100,
          color: AppColors.warning,
          icon: Icons.warning_amber_rounded,
        );

      case "Amplitude insuffisante":
        return const ErreurFrequente(
          label: "Amplitude insuffisante",
          pourcentage: 100,
          color: AppColors.error,
          icon: Icons.arrow_downward_rounded,
        );

      case "Genoux vers l'intérieur":
        return const ErreurFrequente(
          label: "Genoux vers l'intérieur",
          pourcentage: 100,
          color: AppColors.info,
          icon: Icons.compress_rounded,
        );

      default:
        return ErreurFrequente(
          label: error,
          pourcentage: 100,
          color: Colors.grey,
          icon: Icons.help_outline_rounded,
        );
    }
  }).toList();
}

/// ===============================================================
/// SESSION TERMINÉE
/// ===============================================================

class SessionTermineePage extends StatelessWidget {
  final int? idSeance;

  final int score;
  final String duree;
  final int nbSquats;
  final int precision;

  final int scorePrecedent;
  final int progression;

  final List<ErreurFrequente> erreurs;

  const SessionTermineePage({
    super.key,
    this.idSeance,
    required this.score,
    required this.duree,
    required this.nbSquats,
    required this.precision,
    required this.scorePrecedent,
    required this.progression,
    required this.erreurs,
  });

  /// =============================================================
  /// SCORE
  /// =============================================================

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

  IconData get _scoreIcon {
    if (score >= 85) return Icons.emoji_events_rounded;
    if (score >= 70) return Icons.thumb_up_alt_rounded;
    if (score >= 50) return Icons.trending_up_rounded;
    return Icons.fitness_center_rounded;
  }

  String get _performanceMessage {
    if (score >= 85) {
      return "La posture est globalement très bien maîtrisée.";
    }

    if (score >= 70) {
      return "Une bonne séance avec encore quelques points à perfectionner.";
    }

    if (score >= 50) {
      return "La séance est encourageante. Quelques corrections peuvent améliorer la posture.";
    }

    return "Quelques points techniques sont à retravailler lors de la prochaine séance.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const Sidebar(
            selectedIndex: 2,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                32,
                28,
                32,
                32,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color:
                                        _scoreColor
                                            .withOpacity(0.12),
                                    borderRadius:
                                        BorderRadius.circular(
                                      13,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons
                                        .check_circle_rounded,
                                    color: _scoreColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                const Text(
                                  "Séance terminée",
                                  style: TextStyle(
                                    color:
                                        AppColors
                                            .textPrimary,
                                    fontSize: 29,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            const Text(
                              "Voici le résumé de la performance analysée par l'IA.",
                              style: TextStyle(
                                color:
                                    AppColors
                                        .textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =================================================
                      // BADGE
                      // =================================================

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _scoreColor
                                  .withOpacity(0.10),
                          borderRadius:
                              BorderRadius.circular(30),
                          border: Border.all(
                            color: _scoreColor
                                .withOpacity(0.22),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: _scoreColor,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              "Analyse IA terminée",
                              style: TextStyle(
                                color: _scoreColor,
                                fontSize: 12.5,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =================================================
                  // SCORE
                  // =================================================

                  _ScoreHero(
                    score: score,
                    color: _scoreColor,
                    label: _scoreLabel,
                    icon: _scoreIcon,
                    message: _performanceMessage,
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // STATISTIQUES
                  // =================================================

                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: "Durée",
                          value: duree,
                          icon: Icons.timer_outlined,
                          iconColor: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatBox(
                          label: "Répétitions",
                          value: "$nbSquats",
                          icon: Icons
                              .fitness_center_outlined,
                          iconColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatBox(
                          label: "Précision IA",
                          value: "$precision%",
                          icon: Icons.gps_fixed_rounded,
                          iconColor: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatBox(
                          label: "Session précédente",
                          value: "$scorePrecedent",
                          icon: Icons.history_rounded,
                          iconColor: AppColors.warning,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // PERFORMANCE + ERREURS
                  // =================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _PerformanceCard(
                          score: score,
                          scorePrecedent:
                              scorePrecedent,
                          progression: progression,
                          color: _scoreColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _ErreursCard(
                          erreurs: erreurs,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // =================================================
                  // ACTIONS
                  // =================================================

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/analyse');
                          },
                          icon: const Icon(
                            Icons.refresh_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            "Nouvelle session",
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primary,
                            foregroundColor:
                                Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                            textStyle:
                                const TextStyle(
                              fontSize: 14.5,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.go('/historique');
                          },
                          icon: const Icon(
                            Icons.history_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            "Voir l'historique",
                          ),
                          style:
                              OutlinedButton.styleFrom(
                            foregroundColor:
                                AppColors.textPrimary,
                            side: const BorderSide(
                              color: AppColors.border,
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                            textStyle:
                                const TextStyle(
                              fontSize: 14.5,
                              fontWeight:
                                  FontWeight.w700,
                            ),
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

/// ===============================================================
/// SCORE HERO
/// ===============================================================

class _ScoreHero extends StatelessWidget {
  final int score;
  final Color color;
  final String label;
  final IconData icon;
  final String message;

  const _ScoreHero({
    required this.score,
    required this.color,
    required this.label,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 190,
                  height: 190,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 15,
                    backgroundColor: AppColors.border,
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(
                  width: 190,
                  height: 190,
                  child: CircularProgressIndicator(
                    value:
                        score.clamp(0, 100) / 100,
                    strokeWidth: 15,
                    strokeCap: StrokeCap.round,
                    backgroundColor:
                        Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      "$score",
                      style: TextStyle(
                        color: color,
                        fontSize: 48,
                        fontWeight:
                            FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "/ 100",
                      style: TextStyle(
                        color:
                            AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 34),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(0.11),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 25,
                  ),
                ),

                const SizedBox(height: 17),

                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  message,
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: color,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Évaluation basée sur l'analyse de posture IA",
                      style: TextStyle(
                        color: color,
                        fontSize: 12.5,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// PERFORMANCE
/// ===============================================================

class _PerformanceCard extends StatelessWidget {
  final int score;
  final int scorePrecedent;
  final int progression;
  final Color color;

  const _PerformanceCard({
    required this.score,
    required this.scorePrecedent,
    required this.progression,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool positive = progression >= 0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      AppColors.primary
                          .withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Performance",
                    style: TextStyle(
                      color:
                          AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Comparaison avec la séance précédente",
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _MiniScore(
                  title: "Cette séance",
                  value: "$score",
                  color: color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MiniScore(
                  title: "Précédente",
                  value: "$scorePrecedent",
                  color:
                      AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MiniScore(
                  title: "Évolution",
                  value: positive
                      ? "+$progression"
                      : "$progression",
                  color: positive
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 8,
              value:
                  score.clamp(0, 100) / 100,
              backgroundColor:
                  AppColors.border,
              valueColor:
                  AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniScore extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MiniScore({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// ERREURS
/// ===============================================================

class _ErreursCard extends StatelessWidget {
  final List<ErreurFrequente> erreurs;

  const _ErreursCard({
    required this.erreurs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: erreurs.isEmpty
              ? AppColors.border
              : AppColors.error
                  .withOpacity(0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: erreurs.isEmpty
                      ? AppColors.success
                          .withOpacity(0.10)
                      : AppColors.error
                          .withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Icon(
                  erreurs.isEmpty
                      ? Icons
                          .check_circle_outline_rounded
                      : Icons
                          .warning_amber_rounded,
                  color: erreurs.isEmpty
                      ? AppColors.success
                      : AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  "Points à améliorer",
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (erreurs.isEmpty)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.success
                    .withOpacity(0.07),
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color:
                        AppColors.success,
                    size: 19,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Aucune erreur détectée pendant cette séance.",
                      style: TextStyle(
                        color:
                            AppColors
                                .textSecondary,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...erreurs.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 11,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: e.color
                        .withOpacity(0.055),
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    border: Border.all(
                      color: e.color
                          .withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration:
                            BoxDecoration(
                          color: e.color
                              .withOpacity(
                            0.13,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            9,
                          ),
                        ),
                        child: Icon(
                          e.icon,
                          color: e.color,
                          size: 17,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          e.label,
                          style:
                              const TextStyle(
                            color: AppColors
                                .textPrimary,
                            fontSize: 12.5,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "${e.pourcentage}%",
                        style: TextStyle(
                          color: e.color,
                          fontSize: 12.5,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// STATISTIQUE
/// ===============================================================

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}