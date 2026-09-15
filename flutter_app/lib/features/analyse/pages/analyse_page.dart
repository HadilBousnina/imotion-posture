import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/posture_analysis.dart';
import '../../../models/seance.dart';
import '../../../services/posture_service.dart';
import '../../../services/seance_service.dart';
import '../../dashboard/widgets/sidebar.dart';
import '../widgets/live_camera_card.dart';

class AngleMesure {
  final String label;
  final int valeur;
  final int max;

  const AngleMesure({
    required this.label,
    required this.valeur,
    this.max = 180,
  });
}

class AnalysePage extends StatefulWidget {
  final String exercice;
  final String duree;
  final int score;
  final int repsReussies;
  final int repsTotal;
  final List<AngleMesure> angles;
  final String feedback;
  final int? idAdherent;

  const AnalysePage({
    super.key,
    this.idAdherent,
    this.exercice = "Squat - Session en cours",
    this.duree = "00:00:00",
    this.score = 0,
    this.repsReussies = 0,
    this.repsTotal = 0,
    this.angles = const [
      AngleMesure(
        label: "Genou",
        valeur: 0,
      ),
      AngleMesure(
        label: "Hanche",
        valeur: 0,
      ),
      AngleMesure(
        label: "Dos",
        valeur: 0,
      ),
    ],
    this.feedback = "Aucune analyse effectuée.",
  });

  @override
  State<AnalysePage> createState() => _AnalysePageState();
}

class _AnalysePageState extends State<AnalysePage> {
  final PostureService _service = PostureService();
  final SeanceService _seanceService = SeanceService();

  bool _loading = false;
  bool _isSessionRunning = false;

  DateTime? _dateDebutSession;

  // =========================================================
  // ANALYSE VIDÉO
  // =========================================================

  PostureAnalysis? _analysis;
  String? _videoName;

  // =========================================================
  // LIVE IA
  // =========================================================

  int _liveScore = 0;
  int _liveRepetitions = 0;
  double _liveConfidence = 0.0;

  String _livePosture = "no_pose";

  List<String> _liveErrors = [];

  Map<String, dynamic> _liveDetails = {};

  // =========================================================
  // SCORE GLOBAL DE LA SESSION
  // =========================================================

  double _sessionScoreSum = 0.0;
  int _sessionScoreSamples = 0;

  double _sessionConfidenceSum = 0.0;
  int _sessionConfidenceSamples = 0;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    debugPrint(
      "🟢 AnalysePage INIT → nouvelle instance",
    );

    debugPrint(
      "👤 ID adhérent reçu : ${widget.idAdherent}",
    );

    _resetSession();
  }

  // =========================================================
  // RESET SESSION
  // =========================================================

  void _resetSession() {
    _analysis = null;
    _videoName = null;

    _liveScore = 0;
    _liveRepetitions = 0;
    _liveConfidence = 0.0;
    _livePosture = "no_pose";

    _liveErrors = [];
    _liveDetails = {};

    _isSessionRunning = false;
    _dateDebutSession = null;

    _sessionScoreSum = 0.0;
    _sessionScoreSamples = 0;

    _sessionConfidenceSum = 0.0;
    _sessionConfidenceSamples = 0;
  }

  // =========================================================
  // CONFIDENCE
  // =========================================================

  String get _confidenceLabel {
    final confidence = _isSessionRunning
        ? _liveConfidence
        : (_analysis?.confidence ?? 0.0);

    return "${(confidence * 100).round()}%";
  }

  // =========================================================
  // ANGLES
  // =========================================================

  List<AngleMesure> get _currentAngles {
    // ---------------------------------------------------------
    // LIVE
    // ---------------------------------------------------------

    if (_isSessionRunning) {
      return [
        AngleMesure(
          label: "Genou gauche",
          valeur:
              (_liveDetails["left_knee"] as num?)
                      ?.round() ??
                  0,
        ),
        AngleMesure(
          label: "Genou droit",
          valeur:
              (_liveDetails["right_knee"] as num?)
                      ?.round() ??
                  0,
        ),
        AngleMesure(
          label: "Dos",
          valeur:
              (_liveDetails["trunk_angle"] as num?)
                      ?.round() ??
                  0,
        ),
      ];
    }

    // ---------------------------------------------------------
    // ANALYSE VIDÉO
    // ---------------------------------------------------------

    final details = _analysis?.details;

    if (details == null) {
      return widget.angles
          .map(
            (angle) => AngleMesure(
              label: angle.label,
              valeur: angle.valeur,
              max: angle.max,
            ),
          )
          .toList();
    }

    return [
      AngleMesure(
        label: "Genou gauche",
        valeur:
            (details["left_knee"] as num?)
                    ?.round() ??
                0,
      ),
      AngleMesure(
        label: "Genou droit",
        valeur:
            (details["right_knee"] as num?)
                    ?.round() ??
                0,
      ),
      AngleMesure(
        label: "Dos",
        valeur:
            (details["trunk_angle"] as num?)
                    ?.round() ??
                0,
      ),
    ];
  }

  // =========================================================
  // SCORE LABEL
  // =========================================================

  String get _scoreLabel {
    final score = _isSessionRunning
        ? _liveScore
        : (_analysis?.score ?? widget.score);

    if (score >= 85) {
      return "Excellent";
    }

    if (score >= 70) {
      return "Bon";
    }

    if (score >= 50) {
      return "Correct";
    }

    return "À corriger";
  }

  // =========================================================
  // SCORE ACTUEL
  // =========================================================

  int get _currentScore {
    if (_isSessionRunning) {
      return _liveScore;
    }

    return _analysis?.score ?? widget.score;
  }

  // =========================================================
  // RÉPÉTITIONS ACTUELLES
  // =========================================================

  int get _currentRepetitions {
    if (_isSessionRunning) {
      return _liveRepetitions;
    }

    return _analysis?.repetitions ?? 0;
  }

  // =========================================================
  // FEEDBACK ACTUEL
  // =========================================================

  String get _currentFeedback {
    // ---------------------------------------------------------
    // LIVE
    // ---------------------------------------------------------

    if (_isSessionRunning) {
      if (_liveErrors.isEmpty) {
        if (_livePosture == "correct") {
          return "Très bonne posture ! Continuez ainsi.";
        }

        if (_livePosture == "not_squat") {
          return "Positionnez-vous correctement pour effectuer un squat.";
        }

        if (_livePosture == "incorrect") {
          return "Corrigez votre posture.";
        }

        return "Analyse de votre posture en cours...";
      }

      return _liveErrors.join(", ");
    }

    // ---------------------------------------------------------
    // ANALYSE VIDÉO
    // ---------------------------------------------------------

    if (_analysis == null) {
      return widget.feedback;
    }

    if (_analysis!.errors.isEmpty) {
      return "Très bonne posture !";
    }

    return _analysis!.errors.join(", ");
  }

  // =========================================================
  // RÉCEPTION DES RÉSULTATS IA LIVE
  // =========================================================

  void _handleLiveAIResult(
    Map<String, dynamic> data,
  ) {
    if (!mounted) {
      return;
    }

    // ---------------------------------------------------------
    // DETAILS
    // ---------------------------------------------------------

    final rawDetails = data["details"];

    Map<String, dynamic> details = {};

    if (rawDetails is Map) {
      details = Map<String, dynamic>.from(
        rawDetails,
      );
    }

    // ---------------------------------------------------------
    // ERRORS
    // ---------------------------------------------------------

    final rawErrors = data["errors"];

    List<String> errors = [];

    if (rawErrors is List) {
      errors = rawErrors
          .map(
            (error) => error.toString(),
          )
          .toList();
    }

    // ---------------------------------------------------------
    // VALEURS DE LA FRAME
    // ---------------------------------------------------------

    final prediction =
        data["posture"]?.toString() ?? "no_pose";

    final frameScore =
        (data["score"] as num?)?.toDouble() ?? 0.0;

    final frameConfidence =
        (data["confidence"] as num?)?.toDouble() ?? 0.0;

    final repetitions =
        (data["repetitions"] as num?)?.toInt() ?? 0;

    // ---------------------------------------------------------
    // SCORE GLOBAL DE LA SESSION
    // ---------------------------------------------------------
    //
    // On ignore les frames :
    // - no_pose
    // - not_squat
    //
    // afin qu'une frame où l'utilisateur revient
    // en position initiale ne mette pas toute la séance à 0.
    //

    if (prediction != "no_pose" &&
        prediction != "not_squat") {
      _sessionScoreSum += frameScore;
      _sessionScoreSamples++;
    }

    // ---------------------------------------------------------
    // CONFIANCE GLOBALE
    // ---------------------------------------------------------

    if (prediction != "no_pose") {
      _sessionConfidenceSum += frameConfidence;
      _sessionConfidenceSamples++;
    }

    // ---------------------------------------------------------
    // MOYENNE SCORE
    // ---------------------------------------------------------

    final sessionScore =
        _sessionScoreSamples > 0
            ? (_sessionScoreSum /
                    _sessionScoreSamples)
                .round()
            : 0;

    // ---------------------------------------------------------
    // MOYENNE CONFIANCE
    // ---------------------------------------------------------

    final sessionConfidence =
        _sessionConfidenceSamples > 0
            ? _sessionConfidenceSum /
                _sessionConfidenceSamples
            : frameConfidence;

    // ---------------------------------------------------------
    // UPDATE UI
    // ---------------------------------------------------------

    setState(() {
      _liveScore = sessionScore;

      _liveRepetitions = repetitions;

      _liveConfidence = sessionConfidence;

      _livePosture = prediction;

      _liveErrors = errors;

      _liveDetails = details;
    });

    // ---------------------------------------------------------
    // DEBUG
    // ---------------------------------------------------------

    debugPrint(
      "📊 LIVE → "
      "frameScore=$frameScore | "
      "sessionScore=$_liveScore | "
      "reps=$_liveRepetitions | "
      "confidence=$_liveConfidence | "
      "posture=$_livePosture",
    );

    debugPrint(
      "📈 SESSION SCORE → "
      "sum=$_sessionScoreSum | "
      "samples=$_sessionScoreSamples | "
      "average=$_liveScore",
    );

    debugPrint(
      "📈 SESSION CONFIDENCE → "
      "sum=$_sessionConfidenceSum | "
      "samples=$_sessionConfidenceSamples | "
      "average=$_liveConfidence",
    );

    debugPrint(
      "📐 LIVE ANGLES → "
      "left_knee=${_liveDetails["left_knee"]} | "
      "right_knee=${_liveDetails["right_knee"]} | "
      "left_hip=${_liveDetails["left_hip"]} | "
      "right_hip=${_liveDetails["right_hip"]} | "
      "trunk=${_liveDetails["trunk_angle"]}",
    );
  }

  // =========================================================
  // CHOISIR UNE VIDÉO
  // =========================================================

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true,
    );

    if (result == null) {
      return;
    }

    final file = result.files.first;

    debugPrint(
      "📹 Vidéo sélectionnée : ${file.name}",
    );

    debugPrint(
      "📦 Taille : ${file.size}",
    );

    if (file.bytes == null) {
      debugPrint(
        "❌ Impossible de récupérer les données de la vidéo.",
      );
      return;
    }

    setState(() {
      _videoName = file.name;
      _loading = true;
    });

    try {
      final analysis = await _service.analyzeVideo(
        bytes: file.bytes!,
        fileName: file.name,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _analysis = analysis;
      });

      debugPrint(
        "✅ Analyse vidéo terminée",
      );

      debugPrint(
        "Score : ${analysis.score}",
      );

      debugPrint(
        "Répétitions : ${analysis.repetitions}",
      );

      debugPrint(
        "Confiance : ${analysis.confidence}",
      );

      debugPrint(
        "Errors : ${analysis.errors}",
      );
    } catch (e) {
      debugPrint(
        "❌ Erreur analyse vidéo : $e",
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur lors de l'analyse : $e",
          ),
        ),
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });
    }
  }

  // =========================================================
  // START SESSION
  // =========================================================

  void _startSession() {
    if (widget.idAdherent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Aucun adhérent n'est associé à cette séance.",
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();

    setState(() {
      _isSessionRunning = true;
      _dateDebutSession = now;

      // -------------------------------------------------------
      // RESET DES DONNÉES LIVE
      // -------------------------------------------------------

      _liveScore = 0;
      _liveRepetitions = 0;
      _liveConfidence = 0.0;

      _livePosture = "no_pose";

      _liveErrors = [];

      _liveDetails = {};

      // -------------------------------------------------------
      // RESET DES STATISTIQUES DE SESSION
      // -------------------------------------------------------

      _sessionScoreSum = 0.0;
      _sessionScoreSamples = 0;

      _sessionConfidenceSum = 0.0;
      _sessionConfidenceSamples = 0;
    });

    debugPrint(
      "🟢 SESSION LIVE DÉMARRÉE",
    );

    debugPrint(
      "👤 ID adhérent : ${widget.idAdherent}",
    );

    debugPrint(
      "🕐 Début : $_dateDebutSession",
    );
  }

  // =========================================================
  // FORMATAGE DURÉE
  // =========================================================

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
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
  // TERMINER SESSION
  // =========================================================

  Future<void> _finishSession() async {
    if (!_isSessionRunning) {
      return;
    }

    if (widget.idAdherent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impossible d'enregistrer la séance : adhérent introuvable.",
          ),
        ),
      );
      return;
    }

    // Le score est maintenant le score GLOBAL de la séance.
    final score = _liveScore;

    final repetitions = _liveRepetitions;

    final errors = List<String>.from(
      _liveErrors,
    );

    final dateFin = DateTime.now();

    final dateDebut =
        _dateDebutSession ?? dateFin;

    final duree = dateFin
        .difference(dateDebut)
        .inSeconds;

    final precision =
        (_liveConfidence * 100).round();

    debugPrint(
      "🔴 SESSION TERMINÉE",
    );

    debugPrint(
      "👤 Adhérent : ${widget.idAdherent}",
    );

    debugPrint(
      "🕐 Début : $dateDebut",
    );

    debugPrint(
      "🕐 Fin : $dateFin",
    );

    debugPrint(
      "⏱ Durée : $duree secondes",
    );

    debugPrint(
      "📊 Score final : $score",
    );

    debugPrint(
      "🔁 Répétitions : $repetitions",
    );

    debugPrint(
      "🎯 Précision IA : $precision%",
    );

    debugPrint(
      "⚠️ Erreurs : $errors",
    );

    setState(() {
      _loading = true;
      _isSessionRunning = false;
    });

    try {
      final seance = SeanceEms(
        idAdherent: widget.idAdherent!,
        idCoach: 0,
        dateDebut: dateDebut,
        dateFin: dateFin,
        duree: duree,
        scoreGlobal: score.toDouble(),
        commentaire: errors.isEmpty
            ? "Séance terminée avec succès."
            : errors.join(", "),
      );

      final seanceEnregistree =
          await _seanceService.createSeance(
        seance,
      );

      debugPrint(
        "✅ Séance enregistrée avec succès",
      );

      debugPrint(
        "🆔 ID séance : ${seanceEnregistree.idSeance}",
      );

      if (!mounted) {
        return;
      }

      context.go(
        '/session-terminee',
        extra: {
          'idSeance':
              seanceEnregistree.idSeance,

          'idAdherent':
              widget.idAdherent,

          'score':
              score,

          'duree':
              _formatDuration(duree),

          'nbSquats':
              repetitions,

          'precision':
              precision,

          'scorePrecedent':
              0,

          'progression':
              0,

          'erreurs':
              errors,

          'dateFin':
              dateFin.toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint(
        "❌ Erreur lors de l'enregistrement de la séance : $e",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSessionRunning = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Impossible d'enregistrer la séance : $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final currentScore = _currentScore;
    final currentRepetitions =
        _currentRepetitions;

    final hasError = _isSessionRunning
        ? _liveErrors.isNotEmpty
        : (_analysis?.errors.isNotEmpty ?? false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // =====================================================
          // SIDEBAR
          // =====================================================

          const Sidebar(
            selectedIndex: 2,
          ),

          // =====================================================
          // CONTENU
          // =====================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // BARRE DU HAUT
                  // =================================================

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.exercice,
                          style: const TextStyle(
                            color:
                                AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w700,
                          ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 20),

                      const Icon(
                        Icons.wifi_rounded,
                        color:
                            AppColors.success,
                        size: 20,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        widget.duree,
                        style: const TextStyle(
                          color:
                              AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // CONTENU PRINCIPAL
                  // =================================================

                  Expanded(
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        // ===========================================
                        // PARTIE GAUCHE
                        // ===========================================

                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,
                            children: [
                              // SCORE
                              _ScoreBar(
                                score:
                                    currentScore,
                                label:
                                    _scoreLabel,
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              // CAMERA
                              Expanded(
                                child:
                                    LiveCameraCard(
                                  isSessionRunning:
                                      _isSessionRunning,
                                  onAIResult:
                                      _handleLiveAIResult,
                                ),
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              // FEEDBACK
                              _FeedbackBanner(
                                message:
                                    _currentFeedback,
                                hasError:
                                    hasError,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        // ===========================================
                        // PARTIE DROITE
                        // ===========================================

                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              // ANGLES
                              _AnglesCard(
                                angles:
                                    _currentAngles,
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              // REPETITIONS
                              _RepetitionsCard(
                                repetitions:
                                    currentRepetitions,
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              // CONFIANCE
                              _ConfidenceCard(
                                confidence:
                                    _confidenceLabel,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // BOUTON VIDÉO
                  // =================================================

                  ElevatedButton.icon(
                    onPressed:
                        _loading ||
                                _isSessionRunning
                            ? null
                            : _pickVideo,
                    icon: const Icon(
                      Icons.upload_file,
                    ),
                    label: Text(
                      _loading
                          ? "Analyse en cours..."
                          : "Choisir une vidéo",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =================================================
                  // BOUTON SESSION
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _loading
                              ? null
                              : () {
                                  if (_isSessionRunning) {
                                    _finishSession();
                                  } else {
                                    _startSession();
                                  }
                                },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      child: Text(
                        _isSessionRunning
                            ? "Terminer la séance"
                            : "Commencer la séance",
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
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
}

// ===============================================================
// SCORE
// ===============================================================

class _ScoreBar extends StatelessWidget {
  final int score;
  final String label;

  const _ScoreBar({
    required this.score,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final safeScore =
        score.clamp(0, 100);

    final Color scoreColor;

    if (safeScore < 50) {
      scoreColor = Colors.redAccent;
    } else if (safeScore < 70) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = AppColors.success;
    }

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              scoreColor.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "SCORE",
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.baseline,
            textBaseline:
                TextBaseline.alphabetic,
            children: [
              Text(
                "$safeScore",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight:
                      FontWeight.w800,
                  color: scoreColor,
                ),
              ),

              const SizedBox(width: 4),

              const Text(
                "/100",
                style: TextStyle(
                  color:
                      AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: TextStyle(
              color: scoreColor,
              fontWeight:
                  FontWeight.w700,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child:
                LinearProgressIndicator(
              value:
                  safeScore / 100,
              minHeight: 8,
              backgroundColor:
                  AppColors.border,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                scoreColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// FEEDBACK BANNER
// ===============================================================

class _FeedbackBanner
    extends StatelessWidget {
  final String message;
  final bool hasError;

  const _FeedbackBanner({
    required this.message,
    this.hasError = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color accentColor =
        hasError
            ? Colors.redAccent
            : AppColors.success;

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color:
            accentColor.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              accentColor.withValues(
            alpha: 0.28,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            hasError
                ? Icons.warning_amber_rounded
                : Icons.check_circle_rounded,
            color: accentColor,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  hasError
                      ? "Attention"
                      : "Retour IA",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  message,
                  style: const TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 13.5,
                    fontWeight:
                        FontWeight.w500,
                    height: 1.35,
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
// ANGLES BIOMÉCANIQUES
// ===============================================================

class _AnglesCard
    extends StatelessWidget {
  final List<AngleMesure> angles;

  const _AnglesCard({
    required this.angles,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "ANGLES",
            style:
                TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 16),

          ...angles.map(
            (angle) {
              final safeValue =
                  angle.valeur.clamp(
                0,
                angle.max,
              );

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          angle.label,
                          style:
                              const TextStyle(
                            color:
                                AppColors
                                    .textPrimary,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        Text(
                          "${angle.valeur}°",
                          style:
                              const TextStyle(
                            color:
                                AppColors
                                    .success,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        6,
                      ),
                      child:
                          LinearProgressIndicator(
                        value:
                            safeValue /
                                angle.max,
                        minHeight: 6,
                        backgroundColor:
                            AppColors.border,
                        valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                          AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// REPETITIONS
// ===============================================================

class _RepetitionsCard
    extends StatelessWidget {
  final int repetitions;

  const _RepetitionsCard({
    required this.repetitions,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "RÉPÉTITIONS",
            style:
                TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "$repetitions",
              style:
                  const TextStyle(
                fontSize: 54,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Répétitions détectées",
              style:
                  TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// CONFIANCE IA
// ===============================================================

class _ConfidenceCard
    extends StatelessWidget {
  final String confidence;

  const _ConfidenceCard({
    required this.confidence,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final value =
        int.tryParse(
          confidence.replaceAll(
            '%',
            '',
          ),
        ) ??
        0;

    final safeValue =
        value.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(18),
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
                padding:
                    const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primary
                          .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child:
                    const Icon(
                  Icons.psychology_rounded,
                  color:
                      AppColors.primary,
                  size: 18,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                "CONFIANCE IA",
                style:
                    TextStyle(
                  color:
                      AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                "$safeValue",
                style:
                    const TextStyle(
                  color:
                      AppColors.primary,
                  fontSize: 38,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const Padding(
                padding:
                    EdgeInsets.only(
                  left: 3,
                  bottom: 5,
                ),
                child:
                    Text(
                  "%",
                  style:
                      TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child:
                LinearProgressIndicator(
              value:
                  safeValue / 100,
              minHeight: 7,
              backgroundColor:
                  AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Fiabilité de l'analyse en temps réel",
            style:
                TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}