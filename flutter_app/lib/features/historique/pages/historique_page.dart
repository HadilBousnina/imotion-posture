import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/seance.dart';
import '../../../services/seance_service.dart';
import '../../dashboard/widgets/sidebar.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() =>
      _HistoriquePageState();
}

class _HistoriquePageState
    extends State<HistoriquePage> {
  final SeanceService _seanceService =
      SeanceService();

  List<SeanceEms> _seances = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSeances();
  }

  // =========================================================
  // CHARGER LES SÉANCES
  // =========================================================

  Future<void> _loadSeances() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final seances =
          await _seanceService.getSeances();

      // Les plus récentes en premier.
      seances.sort(
        (a, b) =>
            b.dateDebut.compareTo(a.dateDebut),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _seances = seances;
        _loading = false;
      });

      debugPrint(
        "✅ Historique chargé : "
        "${seances.length} séance(s)",
      );
    } catch (e) {
      debugPrint(
        "❌ Erreur historique : $e",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final day =
        localDate.day.toString().padLeft(2, '0');

    final month =
        localDate.month.toString().padLeft(2, '0');

    final year =
        localDate.year.toString();

    final hour =
        localDate.hour.toString().padLeft(2, '0');

    final minute =
        localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à $hour:$minute';
  }

  // =========================================================
  // FORMAT DURÉE
  // =========================================================

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) {
      return '--:--';
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
  // LABEL SCORE
  // =========================================================

  String _scoreLabel(double? score) {
    final value = score ?? 0;

    if (value >= 85) {
      return 'Excellent';
    }

    if (value >= 70) {
      return 'Bon';
    }

    if (value >= 50) {
      return 'Correct';
    }

    return 'À améliorer';
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
  // OUVRIR LES DÉTAILS
  // =========================================================

  void _openSeanceDetails(
    SeanceEms seance,
  ) {
    final idSeance = seance.idSeance;

    if (idSeance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Identifiant de séance introuvable.",
          ),
        ),
      );
      return;
    }

    debugPrint(
      "🟢 OUVERTURE DÉTAILS → séance #$idSeance",
    );

    context.push(
      '/seance-detail',
      extra: idSeance,
    );
  }

  // =========================================================
  // OUVRIR STATISTIQUES
  // =========================================================

  void _openStatistics() {
    debugPrint(
      "📊 OUVERTURE STATISTIQUES",
    );

    context.push('/statistiques');
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      body: Row(
        children: [
          const Sidebar(
            selectedIndex: 3,
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // EN-TÊTE
                  // =================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Historique',
                              style:
                                  TextStyle(
                                color:
                                    AppColors
                                        .textPrimary,
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Consultez les séances et les performances des adhérents.',
                              style:
                                  TextStyle(
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
                      // STATISTIQUES
                      // =================================================

                      OutlinedButton.icon(
                        onPressed:
                            _openStatistics,
                        icon:
                            const Icon(
                          Icons
                              .analytics_outlined,
                          size: 19,
                        ),
                        label:
                            const Text(
                          'Statistiques',
                        ),
                        style:
                            OutlinedButton
                                .styleFrom(
                          foregroundColor:
                              AppColors
                                  .primary,
                          side:
                              const BorderSide(
                            color:
                                AppColors
                                    .primary,
                          ),
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              11,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // =================================================
                      // ACTUALISER
                      // =================================================

                      IconButton(
                        onPressed:
                            _loading
                                ? null
                                : _loadSeances,
                        tooltip:
                            'Actualiser',
                        icon:
                            const Icon(
                          Icons
                              .refresh_rounded,
                        ),
                        color:
                            AppColors
                                .textPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // CONTENU
                  // =================================================

                  Expanded(
                    child: Container(
                      width:
                          double.infinity,
                      decoration:
                          BoxDecoration(
                        color:
                            AppColors.surface,
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                        border:
                            Border.all(
                          color:
                              AppColors
                                  .border,
                        ),
                      ),
                      child:
                          _buildContent(),
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
  // CONTENU DYNAMIQUE
  // =========================================================

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child:
            CircularProgressIndicator(
          color:
              AppColors.primary,
        ),
      );
    }

    if (_error != null) {
      return _ErrorHistoryState(
        message:
            _error!,
        onRetry:
            _loadSeances,
      );
    }

    if (_seances.isEmpty) {
      return const _EmptyHistoryState();
    }

    return ListView.separated(
      padding:
          const EdgeInsets.all(22),
      itemCount:
          _seances.length,
      separatorBuilder: (_, __) =>
          const SizedBox(
        height: 12,
      ),
      itemBuilder:
          (context, index) {
        final seance =
            _seances[index];

        return _SeanceCard(
          seance:
              seance,
          formatDate:
              _formatDate,
          formatDuration:
              _formatDuration,
          scoreLabel:
              _scoreLabel,
          scoreColor:
              _scoreColor,
          onTap: () =>
              _openSeanceDetails(
            seance,
          ),
        );
      },
    );
  }
}

// ===========================================================
// CARTE SÉANCE
// ===========================================================

class _SeanceCard
    extends StatelessWidget {
  final SeanceEms seance;

  final String Function(DateTime)
      formatDate;

  final String Function(int?)
      formatDuration;

  final String Function(double?)
      scoreLabel;

  final Color Function(double?)
      scoreColor;

  final VoidCallback onTap;

  const _SeanceCard({
    required this.seance,
    required this.formatDate,
    required this.formatDuration,
    required this.scoreLabel,
    required this.scoreColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        scoreColor(
      seance.scoreGlobal,
    );

    final score =
        seance.scoreGlobal?.round() ??
            0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        child: Container(
          padding:
              const EdgeInsets.all(
            18,
          ),
          decoration:
              BoxDecoration(
            color:
                AppColors.background,
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            border:
                Border.all(
              color:
                  AppColors.border,
            ),
          ),
          child: Row(
            children: [
              // =================================================
              // ICÔNE
              // =================================================

              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color:
                      color.withOpacity(
                    0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  Icons
                      .fitness_center_rounded,
                  color: color,
                  size: 23,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              // =================================================
              // INFORMATIONS
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Séance #'
                          '${seance.idSeance ?? '-'}',
                          style:
                              const TextStyle(
                            color:
                                AppColors
                                    .textPrimary,
                            fontSize: 15,
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                color
                                    .withOpacity(
                              0.10,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),
                          child:
                              Text(
                            scoreLabel(
                              seance
                                  .scoreGlobal,
                            ),
                            style:
                                TextStyle(
                              color:
                                  color,
                              fontSize:
                                  11,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Text(
                      'Adhérent #'
                      '${seance.idAdherent}',
                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .textSecondary,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      formatDate(
                        seance.dateDebut,
                      ),
                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 20,
              ),

              // =================================================
              // DURÉE
              // =================================================

              _HistoryStat(
                label:
                    'Durée',
                value:
                    formatDuration(
                  seance.duree,
                ),
                icon:
                    Icons.timer_outlined,
              ),

              const SizedBox(
                width: 24,
              ),

              // =================================================
              // SCORE
              // =================================================

              _HistoryStat(
                label:
                    'Score',
                value:
                    '$score/100',
                icon:
                    Icons.insights_rounded,
                valueColor:
                    color,
              ),

              const SizedBox(
                width: 16,
              ),

              // =================================================
              // FLÈCHE
              // =================================================

              const Icon(
                Icons
                    .chevron_right_rounded,
                color:
                    AppColors
                        .textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// STATISTIQUE
// ===========================================================

class _HistoryStat
    extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _HistoryStat({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Icon(
          icon,
          size: 17,
          color:
              AppColors
                  .textSecondary,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style:
              TextStyle(
            color:
                valueColor ??
                AppColors.textPrimary,
            fontSize: 16,
            fontWeight:
                FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style:
              const TextStyle(
            color:
                AppColors
                    .textSecondary,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// ÉTAT VIDE
// ===========================================================

class _EmptyHistoryState
    extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration:
                BoxDecoration(
              color:
                  AppColors.background,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
              border:
                  Border.all(
                color:
                    AppColors.border,
              ),
            ),
            child:
                const Icon(
              Icons.history_rounded,
              size: 34,
              color:
                  AppColors
                      .textSecondary,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'Aucune séance enregistrée',
            style:
                TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Les séances terminées apparaîtront ici.',
            style:
                TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign:
                TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// ERREUR
// ===========================================================

class _ErrorHistoryState
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorHistoryState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
              decoration:
                  BoxDecoration(
                color:
                    AppColors.error
                        .withOpacity(
                  0.10,
                ),
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
              child:
                  const Icon(
                Icons.error_outline_rounded,
                color:
                    AppColors.error,
                size: 30,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'Impossible de charger l’historique',
              style:
                  TextStyle(
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
              message,
              style:
                  const TextStyle(
                color:
                    AppColors
                        .textSecondary,
                fontSize: 12.5,
              ),
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 18,
            ),

            ElevatedButton.icon(
              onPressed:
                  onRetry,
              icon:
                  const Icon(
                Icons
                    .refresh_rounded,
              ),
              label:
                  const Text(
                'Réessayer',
              ),
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}