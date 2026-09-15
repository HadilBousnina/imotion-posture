import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/seance.dart';
import '../../../services/seance_service.dart';
import '../../dashboard/widgets/sidebar.dart';

class SeanceDetailPage extends StatefulWidget {
  final int idSeance;

  const SeanceDetailPage({
    super.key,
    required this.idSeance,
  });

  @override
  State<SeanceDetailPage> createState() =>
      _SeanceDetailPageState();
}

class _SeanceDetailPageState
    extends State<SeanceDetailPage> {
  final SeanceService _seanceService =
      SeanceService();

  SeanceEms? _seance;

  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSeance();
  }

  // =========================================================
  // CHARGER LA SÉANCE
  // =========================================================

  Future<void> _loadSeance() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final seance =
          await _seanceService.getSeance(
        widget.idSeance,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _seance = seance;
        _loading = false;
      });

      debugPrint(
        "✅ Séance chargée : ${seance.idSeance}",
      );
    } catch (e) {
      debugPrint(
        "❌ Erreur détail séance : $e",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return "Non renseignée";
    }

    final value = date.toLocal();

    final day =
        value.day.toString().padLeft(2, '0');

    final month =
        value.month.toString().padLeft(2, '0');

    final year =
        value.year.toString();

    final hour =
        value.hour.toString().padLeft(2, '0');

    final minute =
        value.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à $hour:$minute';
  }

  // =========================================================
  // FORMAT DURÉE
  // =========================================================

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) {
      return "--:--";
    }

    final hours = seconds ~/ 3600;
    final minutes =
        (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${secs.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  // =========================================================
  // COULEUR SCORE
  // =========================================================

  Color _scoreColor(double? score) {
    final value = score ?? 0;

    if (value >= 85) {
      return AppColors.success;
    }

    if (value >= 70) {
      return AppColors.info;
    }

    if (value >= 50) {
      return AppColors.warning;
    }

    return AppColors.error;
  }

  // =========================================================
  // LABEL SCORE
  // =========================================================

  String _scoreLabel(double? score) {
    final value = score ?? 0;

    if (value >= 85) {
      return "Excellent";
    }

    if (value >= 70) {
      return "Bon";
    }

    if (value >= 50) {
      return "Correct";
    }

    return "À améliorer";
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const Sidebar(
            selectedIndex: 3,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        tooltip: "Retour",
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                        ),
                        color:
                            AppColors.textPrimary,
                      ),

                      const SizedBox(width: 8),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Détails de la séance",
                              style: TextStyle(
                                color:
                                    AppColors.textPrimary,
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Consultez les résultats détaillés de la séance.",
                              style: TextStyle(
                                color:
                                    AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed:
                            _loading
                                ? null
                                : _loadSeance,
                        tooltip: "Actualiser",
                        icon: const Icon(
                          Icons.refresh_rounded,
                        ),
                        color:
                            AppColors.textPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // CONTENU
                  // =================================================

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                        border: Border.all(
                          color:
                              AppColors.border,
                        ),
                      ),
                      child: _buildContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CONTENU
  // =========================================================

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    final seance = _seance;

    if (seance == null) {
      return const Center(
        child: Text(
          "Séance introuvable.",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =======================================================
          // IDENTIFICATION
          // =======================================================

          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color:
                      _scoreColor(
                    seance.scoreGlobal,
                  ).withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: _scoreColor(
                    seance.scoreGlobal,
                  ),
                  size: 26,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Séance #${seance.idSeance}",
                      style: const TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Adhérent #${seance.idAdherent}",
                      style: const TextStyle(
                        color:
                            AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _scoreColor(
                    seance.scoreGlobal,
                  ).withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  _scoreLabel(
                    seance.scoreGlobal,
                  ),
                  style: TextStyle(
                    color: _scoreColor(
                      seance.scoreGlobal,
                    ),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =======================================================
          // SCORE
          // =======================================================

          _ScoreCard(
            score:
                seance.scoreGlobal ?? 0,
            color: _scoreColor(
              seance.scoreGlobal,
            ),
          ),

          const SizedBox(height: 20),

          // =======================================================
          // INFORMATIONS
          // =======================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoCard(
                  title: "Date de début",
                  value:
                      _formatDate(
                    seance.dateDebut,
                  ),
                  icon:
                      Icons.play_circle_outline_rounded,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _InfoCard(
                  title: "Date de fin",
                  value:
                      _formatDate(
                    seance.dateFin,
                  ),
                  icon:
                      Icons.stop_circle_outlined,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _InfoCard(
                  title: "Durée",
                  value:
                      _formatDuration(
                    seance.duree,
                  ),
                  icon:
                      Icons.timer_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoCard(
                  title: "Adhérent",
                  value:
                      "#${seance.idAdherent}",
                  icon:
                      Icons.person_outline_rounded,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _InfoCard(
                  title: "Coach",
                  value:
                      "#${seance.idCoach}",
                  icon:
                      Icons.badge_outlined,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _InfoCard(
                  title: "Score global",
                  value:
                      "${(seance.scoreGlobal ?? 0).round()}/100",
                  icon:
                      Icons.insights_rounded,
                  valueColor:
                      _scoreColor(
                    seance.scoreGlobal,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // COMMENTAIRE
          // =======================================================

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.notes_rounded,
                      color:
                          AppColors.primary,
                      size: 21,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Commentaire",
                      style: TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:
                        AppColors.background,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Text(
                    seance.commentaire
                            ?.isNotEmpty ==
                        true
                        ? seance.commentaire!
                        : "Aucun commentaire pour cette séance.",
                    style:
                        const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // =======================================================
          // RETOUR
          // =======================================================

          Align(
            alignment:
                Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
              label: const Text(
                "Retour à l'historique",
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
                  horizontal: 18,
                  vertical: 13,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ÉTAT ERREUR
  // =========================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color:
                    AppColors.error
                        .withOpacity(0.10),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 30,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Impossible de charger la séance",
              style: TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 17,
                fontWeight:
                    FontWeight.w700,
              ),
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              _errorMessage ??
                  "Une erreur est survenue.",
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 12.5,
              ),
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: _loadSeance,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                "Réessayer",
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================================
// CARTE SCORE
// ===============================================================

class _ScoreCard extends StatelessWidget {
  final double score;
  final Color color;

  const _ScoreCard({
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final safeScore =
        score.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              color.withOpacity(0.20),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment:
                  Alignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child:
                      CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 11,
                    backgroundColor:
                        AppColors.border,
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Colors.transparent,
                    ),
                  ),
                ),

                SizedBox(
                  width: 130,
                  height: 130,
                  child:
                      CircularProgressIndicator(
                    value:
                        safeScore / 100,
                    strokeWidth: 11,
                    strokeCap:
                        StrokeCap.round,
                    backgroundColor:
                        Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation(
                      color,
                    ),
                  ),
                ),

                Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      "${safeScore.round()}",
                      style: TextStyle(
                        color: color,
                        fontSize: 32,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "/ 100",
                      style: TextStyle(
                        color:
                            AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 25),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Score global",
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  score >= 85
                      ? "Excellente performance"
                      : score >= 70
                          ? "Bonne performance"
                          : score >= 50
                              ? "Performance correcte"
                              : "Performance à améliorer",
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 9),

                const Text(
                  "Ce score correspond à l'évaluation globale enregistrée pour cette séance.",
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
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

// ===============================================================
// CARTE INFORMATION
// ===============================================================

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(15),
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
              color:
                  AppColors.primary
                      .withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color:
                  AppColors.primary,
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
                  title,
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        valueColor ??
                        AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
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