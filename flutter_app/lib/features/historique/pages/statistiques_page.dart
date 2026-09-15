import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/seance.dart';
import '../../../services/seance_service.dart';
import '../../dashboard/widgets/sidebar.dart';

class StatistiquesPage extends StatefulWidget {
  const StatistiquesPage({super.key});

  @override
  State<StatistiquesPage> createState() =>
      _StatistiquesPageState();
}

class _StatistiquesPageState
    extends State<StatistiquesPage> {
  final SeanceService _seanceService =
      SeanceService();

  List<SeanceEms> _seances = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  // =========================================================
  // CHARGEMENT
  // =========================================================

  Future<void> _loadStatistics() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final seances =
          await _seanceService.getSeances();

      seances.sort(
        (a, b) =>
            a.dateDebut.compareTo(b.dateDebut),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _seances = seances;
        _loading = false;
      });

      debugPrint(
        "✅ Statistiques chargées : "
        "${seances.length} séance(s)",
      );
    } catch (e) {
      debugPrint(
        "❌ Erreur statistiques : $e",
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
  // SCORE MOYEN
  // =========================================================

  double get _scoreMoyen {
    if (_seances.isEmpty) {
      return 0;
    }

    final scores = _seances
        .map(
          (seance) =>
              seance.scoreGlobal ?? 0,
        )
        .toList();

    final total = scores.fold<double>(
      0,
      (sum, score) => sum + score,
    );

    return total / scores.length;
  }

  // =========================================================
  // MEILLEUR SCORE
  // =========================================================

  double get _meilleurScore {
    if (_seances.isEmpty) {
      return 0;
    }

    return _seances
        .map(
          (seance) =>
              seance.scoreGlobal ?? 0,
        )
        .reduce(
          (a, b) => a > b ? a : b,
        );
  }

  // =========================================================
  // DERNIER SCORE
  // =========================================================

  double get _dernierScore {
    if (_seances.isEmpty) {
      return 0;
    }

    return _seances.last.scoreGlobal ?? 0;
  }

  // =========================================================
  // DURÉE MOYENNE
  // =========================================================

  double get _dureeMoyenne {
    if (_seances.isEmpty) {
      return 0;
    }

    final durees = _seances
        .map(
          (seance) =>
              seance.duree ?? 0,
        )
        .toList();

    final total = durees.fold<int>(
      0,
      (sum, duree) => sum + duree,
    );

    return total / durees.length;
  }

  // =========================================================
  // FORMATTAGE DURÉE
  // =========================================================

  String _formatDuration(double seconds) {
    final totalSeconds =
        seconds.round();

    if (totalSeconds <= 0) {
      return "--:--";
    }

    final hours =
        totalSeconds ~/ 3600;

    final minutes =
        (totalSeconds % 3600) ~/ 60;

    final secs =
        totalSeconds % 60;

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

  Color _scoreColor(double score) {
    if (score >= 85) {
      return AppColors.success;
    }

    if (score >= 70) {
      return AppColors.info;
    }

    if (score >= 50) {
      return AppColors.warning;
    }

    return AppColors.error;
  }

  // =========================================================
  // LABEL SCORE
  // =========================================================

  String _scoreLabel(double score) {
    if (score >= 85) {
      return "Excellent";
    }

    if (score >= 70) {
      return "Bon";
    }

    if (score >= 50) {
      return "Correct";
    }

    return "À améliorer";
  }

  // =========================================================
  // PROGRESSION
  // =========================================================

  int get _progression {
    if (_seances.length < 2) {
      return 0;
    }

    final previous =
        _seances[_seances.length - 2]
                .scoreGlobal ??
            0;

    final current =
        _seances.last.scoreGlobal ?? 0;

    return (current - previous).round();
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
                  // HEADER
                  // =================================================

                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Statistiques",
                              style: TextStyle(
                                color:
                                    AppColors.textPrimary,
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Suivez l'évolution des performances au fil des séances.",
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
                                : _loadStatistics,
                        tooltip:
                            "Actualiser",
                        icon:
                            const Icon(
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
                    child: _buildContent(),
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
        child:
            CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_seances.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =======================================================
          // CARTES STATISTIQUES
          // =======================================================

          Row(
            children: [
              Expanded(
                child: _StatisticCard(
                  title: "Séances",
                  value:
                      "${_seances.length}",
                  subtitle:
                      "Séances enregistrées",
                  icon:
                      Icons.fitness_center_rounded,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _StatisticCard(
                  title: "Score moyen",
                  value:
                      "${_scoreMoyen.round()}/100",
                  subtitle:
                      _scoreLabel(
                    _scoreMoyen,
                  ),
                  icon:
                      Icons.analytics_rounded,
                  color:
                      _scoreColor(
                    _scoreMoyen,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _StatisticCard(
                  title: "Meilleur score",
                  value:
                      "${_meilleurScore.round()}/100",
                  subtitle:
                      "Meilleure performance",
                  icon:
                      Icons.emoji_events_rounded,
                  color:
                      AppColors.warning,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _StatisticCard(
                  title: "Dernier score",
                  value:
                      "${_dernierScore.round()}/100",
                  subtitle:
                      "Dernière séance",
                  icon:
                      Icons.trending_up_rounded,
                  color:
                      _scoreColor(
                    _dernierScore,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // DEUXIÈME LIGNE
          // =======================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatisticCard(
                  title:
                      "Durée moyenne",
                  value:
                      _formatDuration(
                    _dureeMoyenne,
                  ),
                  subtitle:
                      "Par séance",
                  icon:
                      Icons.timer_outlined,
                  color:
                      AppColors.info,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _StatisticCard(
                  title:
                      "Progression",
                  value: _progression >= 0
                      ? "+$_progression"
                      : "$_progression",
                  subtitle:
                      "Par rapport à la séance précédente",
                  icon:
                      _progression >= 0
                          ? Icons
                              .arrow_upward_rounded
                          : Icons
                              .arrow_downward_rounded,
                  color:
                      _progression >= 0
                          ? AppColors.success
                          : AppColors.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // ÉVOLUTION DU SCORE
          // =======================================================

          _ScoreEvolutionCard(
            seances: _seances,
            scoreColor: _scoreColor,
          ),

          const SizedBox(height: 20),

          // =======================================================
          // DERNIÈRES SÉANCES
          // =======================================================

          _RecentSessionsCard(
            seances: _seances,
            scoreColor: _scoreColor,
            formatDuration:
                _formatDurationFromInt,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FORMAT DURÉE INT
  // =========================================================

  String _formatDurationFromInt(
    int? seconds,
  ) {
    return _formatDuration(
      (seconds ?? 0).toDouble(),
    );
  }

  // =========================================================
  // ÉTAT VIDE
  // =========================================================

  Widget _buildEmptyState() {
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
                  AppColors.surface,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
              border: Border.all(
                color:
                    AppColors.border,
              ),
            ),
            child:
                const Icon(
              Icons.analytics_outlined,
              size: 34,
              color:
                  AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Aucune statistique disponible",
            style: TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Les statistiques apparaîtront après vos premières séances.",
            style: TextStyle(
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

  // =========================================================
  // ÉTAT ERREUR
  // =========================================================

  Widget _buildErrorState() {
    return Center(
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
              Icons
                  .error_outline_rounded,
              color:
                  AppColors.error,
              size: 30,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Impossible de charger les statistiques",
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
            _error ??
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
            onPressed:
                _loadStatistics,
            icon:
                const Icon(
              Icons.refresh_rounded,
            ),
            label:
                const Text(
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
    );
  }
}

// ===============================================================
// CARTE STATISTIQUE
// ===============================================================

class _StatisticCard
    extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          17,
        ),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(
                  color:
                      color.withOpacity(
                    0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                ),
                child:
                    Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),

              const Spacer(),

              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      AppColors
                          .textSecondary,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            value,
            style:
                TextStyle(
              color:
                  color,
              fontSize: 25,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style:
                const TextStyle(
              color:
                  AppColors
                      .textSecondary,
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// ÉVOLUTION DU SCORE
// ===============================================================

class _ScoreEvolutionCard
    extends StatelessWidget {
  final List<SeanceEms> seances;
  final Color Function(double) scoreColor;

  const _ScoreEvolutionCard({
    required this.seances,
    required this.scoreColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.show_chart_rounded,
                color:
                    AppColors.primary,
                size: 21,
              ),
              SizedBox(width: 10),
              Text(
                "Évolution du score",
                style:
                    TextStyle(
                  color:
                      AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          const Text(
            "Évolution des performances au fil des séances.",
            style:
                TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 240,
            child: CustomPaint(
              painter:
                  _ScoreChartPainter(
                seances: seances,
                scoreColor:
                    scoreColor,
              ),
              child:
                  const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// PAINTER GRAPHIQUE
// ===============================================================

class _ScoreChartPainter
    extends CustomPainter {
  final List<SeanceEms> seances;
  final Color Function(double) scoreColor;

  _ScoreChartPainter({
    required this.seances,
    required this.scoreColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (seances.isEmpty) {
      return;
    }

    const leftPadding = 40.0;
    const rightPadding = 15.0;
    const topPadding = 15.0;
    const bottomPadding = 30.0;

    final chartWidth =
        size.width -
        leftPadding -
        rightPadding;

    final chartHeight =
        size.height -
        topPadding -
        bottomPadding;

    // ===========================================================
    // AXES
    // ===========================================================

    final axisPaint = Paint()
      ..color =
          AppColors.border
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(
        leftPadding,
        topPadding,
      ),
      Offset(
        leftPadding,
        topPadding +
            chartHeight,
      ),
      axisPaint,
    );

    canvas.drawLine(
      Offset(
        leftPadding,
        topPadding +
            chartHeight,
      ),
      Offset(
        leftPadding +
            chartWidth,
        topPadding +
            chartHeight,
      ),
      axisPaint,
    );

    // ===========================================================
    // LIGNES HORIZONTALES
    // ===========================================================

    final gridPaint = Paint()
      ..color =
          AppColors.border
              .withOpacity(0.55)
      ..strokeWidth = 1;

    const gridValues = [
      0,
      25,
      50,
      75,
      100,
    ];

    for (final value in gridValues) {
      final y =
          topPadding +
          chartHeight *
              (1 - value / 100);

      canvas.drawLine(
        Offset(
          leftPadding,
          y,
        ),
        Offset(
          leftPadding +
              chartWidth,
          y,
        ),
        gridPaint,
      );

      final textPainter =
          TextPainter(
        text:
            TextSpan(
          text: "$value",
          style:
              const TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        textDirection:
            TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          leftPadding -
              textPainter.width -
              8,
          y -
              textPainter.height /
                  2,
        ),
      );
    }

    // ===========================================================
    // POINTS
    // ===========================================================

    final points =
        <Offset>[];

    for (int i = 0;
        i < seances.length;
        i++) {
      final score =
          (seances[i]
                  .scoreGlobal ??
              0)
          .clamp(0, 100);

      final x =
          seances.length == 1
              ? leftPadding +
                  chartWidth / 2
              : leftPadding +
                  chartWidth *
                      (i /
                          (seances.length -
                              1));

      final y =
          topPadding +
          chartHeight *
              (1 - score / 100);

      points.add(
        Offset(x, y),
      );
    }

    // ===========================================================
    // COURBE
    // ===========================================================

    final linePaint = Paint()
      ..color =
          AppColors.primary
      ..strokeWidth = 3
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round
      ..strokeJoin =
          StrokeJoin.round;

    if (points.length > 1) {
      final path =
          Path();

      path.moveTo(
        points.first.dx,
        points.first.dy,
      );

      for (int i = 1;
          i < points.length;
          i++) {
        path.lineTo(
          points[i].dx,
          points[i].dy,
        );
      }

      canvas.drawPath(
        path,
        linePaint,
      );
    }

    // ===========================================================
    // POINTS + VALEURS
    // ===========================================================

    for (int i = 0;
        i < points.length;
        i++) {
      final point =
          points[i];

      final score =
          (seances[i]
                  .scoreGlobal ??
              0)
          .clamp(0, 100);

      final pointPaint =
          Paint()
            ..color =
                scoreColor(
              score.toDouble(),
            );

      canvas.drawCircle(
        point,
        6,
        pointPaint,
      );

      final valuePainter =
          TextPainter(
        text:
            TextSpan(
          text:
              "${score.round()}",
          style:
              TextStyle(
            color:
                scoreColor(
              score.toDouble(),
            ),
            fontSize: 11,
            fontWeight:
                FontWeight.w800,
          ),
        ),
        textDirection:
            TextDirection.ltr,
      );

      valuePainter.layout();

      valuePainter.paint(
        canvas,
        Offset(
          point.dx -
              valuePainter.width /
                  2,
          point.dy -
              valuePainter.height -
              8,
        ),
      );

      final labelPainter =
          TextPainter(
        text:
            TextSpan(
          text:
              "${i + 1}",
          style:
              const TextStyle(
            color:
                AppColors
                    .textSecondary,
            fontSize: 10,
          ),
        ),
        textDirection:
            TextDirection.ltr,
      );

      labelPainter.layout();

      labelPainter.paint(
        canvas,
        Offset(
          point.dx -
              labelPainter.width /
                  2,
          topPadding +
              chartHeight +
              8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _ScoreChartPainter oldDelegate,
  ) {
    return oldDelegate.seances !=
            seances ||
        oldDelegate.scoreColor !=
            scoreColor;
  }
}

// ===============================================================
// DERNIÈRES SÉANCES
// ===============================================================

class _RecentSessionsCard
    extends StatelessWidget {
  final List<SeanceEms> seances;
  final Color Function(double) scoreColor;
  final String Function(int?) formatDuration;

  const _RecentSessionsCard({
    required this.seances,
    required this.scoreColor,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final recent = seances.reversed
        .take(5)
        .toList();

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_rounded,
                color:
                    AppColors.primary,
                size: 21,
              ),
              SizedBox(width: 10),
              Text(
                "Dernières séances",
                style:
                    TextStyle(
                  color:
                      AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...recent.map(
            (seance) {
              final score =
                  seance.scoreGlobal ??
                      0;

              final color =
                  scoreColor(score);

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 10,
                ),
                child:
                    Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors
                            .background,
                    borderRadius:
                        BorderRadius
                            .circular(
                      12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration:
                            BoxDecoration(
                          color:
                              color.withOpacity(
                            0.10,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),
                        child:
                            Icon(
                          Icons
                              .fitness_center_rounded,
                          size: 18,
                          color:
                              color,
                        ),
                      ),

                      const SizedBox(
                        width: 11,
                      ),

                      Expanded(
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              "Séance #"
                              "${seance.idSeance ?? '-'}",
                              style:
                                  const TextStyle(
                                color:
                                    AppColors
                                        .textPrimary,
                                fontSize:
                                    13,
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Adhérent #"
                              "${seance.idAdherent}",
                              style:
                                  const TextStyle(
                                color:
                                    AppColors
                                        .textSecondary,
                                fontSize:
                                    11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,
                        children: [
                          Text(
                            "${score.round()}/100",
                            style:
                                TextStyle(
                              color:
                                  color,
                              fontSize:
                                  14,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            formatDuration(
                              seance.duree,
                            ),
                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .textSecondary,
                              fontSize:
                                  10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}