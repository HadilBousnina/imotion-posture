import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../../services/live_websocket_service.dart';
import '../../../services/webcam_service.dart';

class LiveCameraCard extends StatefulWidget {
  const LiveCameraCard({
    super.key,
    required this.isSessionRunning,
    required this.onAIResult,
  });

  final bool isSessionRunning;

  /// Callback appelé à chaque résultat envoyé par le backend IA.
  final void Function(Map<String, dynamic> data) onAIResult;

  @override
  State<LiveCameraCard> createState() => _LiveCameraCardState();
}

class _LiveCameraCardState extends State<LiveCameraCard> {
  // =========================================================
  // CAMERA
  // =========================================================

  web.HTMLVideoElement? _video;
  web.MediaStream? _stream;
  web.HTMLCanvasElement? _canvas;

  final LiveWebSocketService _socketService =
      LiveWebSocketService();

  final WebcamService _webcamService =
      WebcamService();

  Timer? _captureTimer;

  bool _isStarting = false;

  // =========================================================
  // IA RESULTS
  // =========================================================

  List<Map<String, dynamic>> _landmarks = [];

  String _posture = "no_pose";

  double _confidence = 0.0;

  int _score = 0;

  int _repetitions = 0;

  List<String> _errors = [];

  // =========================================================
  // MEDIAPIPE CONNECTIONS
  // =========================================================

  static const List<List<int>> _connections = [
    // Face
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 7],

    [0, 4],
    [4, 5],
    [5, 6],
    [6, 8],

    // Shoulders / arms
    [11, 12],

    [11, 13],
    [13, 15],

    [12, 14],
    [14, 16],

    // Torso
    [11, 23],
    [12, 24],
    [23, 24],

    // Left leg
    [23, 25],
    [25, 27],
    [27, 29],
    [27, 31],

    // Right leg
    [24, 26],
    [26, 28],
    [28, 30],
    [28, 32],

    // Feet
    [29, 31],
    [30, 32],
  ];

  // =========================================================
  // LIFECYCLE
  // =========================================================

  @override
  void initState() {
    super.initState();

    if (widget.isSessionRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startCamera();
      });
    }
  }

  @override
  void didUpdateWidget(
    covariant LiveCameraCard oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    // Session démarre
    if (!oldWidget.isSessionRunning &&
        widget.isSessionRunning) {
      _startCamera();
    }

    // Session terminée
    if (oldWidget.isSessionRunning &&
        !widget.isSessionRunning) {
      _stopCamera();
    }
  }

  // =========================================================
  // START CAMERA
  // =========================================================

  Future<void> _startCamera() async {
    if (_isStarting) {
      return;
    }

    _isStarting = true;

    try {
      debugPrint("📷 Démarrage caméra...");

      // -----------------------------------------------------
      // Démarrage caméra
      // -----------------------------------------------------

      await _webcamService.startCamera();

      _video = _webcamService.video;
      _stream = _webcamService.stream;

      // -----------------------------------------------------
      // Canvas
      // -----------------------------------------------------

      _canvas = _webcamService.canvas;

      _canvas ??= web.HTMLCanvasElement();

      if (!mounted) {
        return;
      }

      setState(() {});

      debugPrint(
        "📹 Video : ${_video != null}",
      );

      debugPrint(
        "🎨 Canvas : ${_canvas != null}",
      );

      // -----------------------------------------------------
      // WebSocket
      // -----------------------------------------------------

      debugPrint(
        "🔌 Connexion WebSocket...",
      );

      _socketService.connect(
        onResult: (data) {
          _handleAIResult(data);
        },
      );

      // -----------------------------------------------------
      // Capture frames
      // -----------------------------------------------------

      _startFrameCapture();

      debugPrint(
        "✅ Caméra + WebSocket démarrés",
      );
    } catch (e) {
      debugPrint(
        "❌ Erreur démarrage caméra : $e",
      );
    } finally {
      _isStarting = false;
    }
  }

  // =========================================================
  // RECEIVE IA RESULT
  // =========================================================

  void _handleAIResult(
    Map<String, dynamic> data,
  ) {
    if (!mounted) {
      return;
    }

    // -------------------------------------------------------
    // Landmarks
    // -------------------------------------------------------

    final rawLandmarks = data["landmarks"];

    List<Map<String, dynamic>> landmarks = [];

    if (rawLandmarks is List) {
      landmarks = rawLandmarks
          .whereType<Map>()
          .map(
            (landmark) => Map<String, dynamic>.from(
              landmark,
            ),
          )
          .toList();
    }

    // -------------------------------------------------------
    // Errors
    // -------------------------------------------------------

    final rawErrors = data["errors"];

    List<String> errors = [];

    if (rawErrors is List) {
      errors = rawErrors
          .map(
            (error) => error.toString(),
          )
          .toList();
    }

    // -------------------------------------------------------
    // Valeurs IA
    // -------------------------------------------------------

    final posture =
        data["posture"]?.toString() ??
            "no_pose";

    final confidence =
        (data["confidence"] as num?)
                ?.toDouble() ??
            0.0;

    final score =
        (data["score"] as num?)
                ?.toInt() ??
            0;

    final repetitions =
        (data["repetitions"] as num?)
                ?.toInt() ??
            0;

    // -------------------------------------------------------
    // Règle UI :
    //
    // Si la posture est correcte, aucune erreur ne doit
    // apparaître dans l'interface.
    // -------------------------------------------------------

    if (posture == "correct") {
      errors = [];
    }

    // -------------------------------------------------------
    // Mise à jour UI
    // -------------------------------------------------------

    setState(() {
      _landmarks = landmarks;

      _posture = posture;

      _confidence = confidence;

      _score = score;

      _repetitions = repetitions;

      _errors = errors;
    });

    // -------------------------------------------------------
    // Transmission à AnalysePage
    // -------------------------------------------------------

    widget.onAIResult(data);

    // -------------------------------------------------------
    // DEBUG
    // -------------------------------------------------------

    debugPrint(
      "🦴 Landmarks reçus : "
      "${_landmarks.length}/33",
    );

    debugPrint(
      "🤖 $_posture | "
      "confidence=${_confidence.toStringAsFixed(2)} | "
      "score=$_score | "
      "reps=$_repetitions",
    );

    if (_posture != "correct") {
      debugPrint(
        "❌ Errors : $_errors",
      );
    }
  }

  // =========================================================
  // START FRAME CAPTURE
  // =========================================================

  void _startFrameCapture() {
    _captureTimer?.cancel();

    _captureTimer = Timer.periodic(
      const Duration(
        milliseconds: 100,
      ),
      (_) {
        _captureFrame();
      },
    );

    debugPrint(
      "🎥 Capture frames démarrée",
    );
  }

  // =========================================================
  // CAPTURE FRAME
  // =========================================================

  Future<void> _captureFrame() async {
    if (!widget.isSessionRunning) {
      return;
    }

    if (_video == null) {
      return;
    }

    _canvas ??= web.HTMLCanvasElement();

    final canvas = _canvas;

    if (canvas == null) {
      return;
    }

    // -------------------------------------------------------
    // Dimensions vidéo
    // -------------------------------------------------------

    final width = _video!.videoWidth;
    final height = _video!.videoHeight;

    if (width == 0 || height == 0) {
      return;
    }

    // -------------------------------------------------------
    // Dimensions canvas
    // -------------------------------------------------------

    canvas
      ..width = width
      ..height = height;

    // -------------------------------------------------------
    // Contexte 2D
    // -------------------------------------------------------

    final context =
        canvas.getContext('2d')
            as web.CanvasRenderingContext2D;

    // -------------------------------------------------------
    // Dessiner la frame vidéo
    // -------------------------------------------------------

    context.drawImage(
      _video!,
      0,
      0,
    );

    // -------------------------------------------------------
    // Convertir en JPEG
    // -------------------------------------------------------

    final dataUrl = canvas.toDataURL(
      'image/jpeg',
      0.8.toJS,
    );

    // -------------------------------------------------------
    // Extraire Base64
    // -------------------------------------------------------

    final parts = dataUrl.split(',');

    if (parts.length < 2) {
      return;
    }

    final base64Data = parts.last;

    if (base64Data.isEmpty) {
      return;
    }

    // -------------------------------------------------------
    // Base64 → bytes
    // -------------------------------------------------------

    final bytes = base64Decode(
      base64Data,
    );

    if (bytes.isEmpty) {
      return;
    }

    // -------------------------------------------------------
    // Envoyer au backend
    // -------------------------------------------------------

    _socketService.sendFrame(
      bytes,
    );
  }

  // =========================================================
  // STOP CAMERA
  // =========================================================

  void _stopCamera() {
    debugPrint(
      "🛑 Arrêt session live...",
    );

    _captureTimer?.cancel();

    _captureTimer = null;

    _webcamService.stopCamera();

    _socketService.disconnect();

    _video = null;

    _stream = null;

    _canvas = null;

    if (mounted) {
      setState(() {
        _landmarks = [];

        _posture = "no_pose";

        _confidence = 0.0;

        _score = 0;

        _repetitions = 0;

        _errors = [];
      });
    }

    debugPrint(
      "✅ Session live arrêtée",
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    debugPrint(
      "♻️ Dispose LiveCameraCard",
    );

    _captureTimer?.cancel();

    _captureTimer = null;

    _webcamService.stopCamera();

    _socketService.disconnect();

    super.dispose();
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // -------------------------------------------------------
    // Pas de session
    // -------------------------------------------------------

    if (!widget.isSessionRunning) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            alpha: 0.25,
          ),
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.videocam_off_outlined,
                color: Colors.white54,
                size: 42,
              ),
              SizedBox(height: 12),
              Text(
                "Aucune séance active",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Cliquez sur « Commencer la séance »",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // -------------------------------------------------------
    // Caméra en démarrage
    // -------------------------------------------------------

    if (_video == null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 14),
              Text(
                "Démarrage de la caméra...",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // -------------------------------------------------------
    // CAMERA + SKELETON + MODERN UI
    // -------------------------------------------------------

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // =================================================
          // CAMERA
          // =================================================

          const HtmlElementView(
            viewType: 'live-camera',
          ),

          // =================================================
          // SKELETON
          // =================================================

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: PosePainter(
                  landmarks: _landmarks,
                  connections: _connections,
                ),
              ),
            ),
          ),

          // =================================================
          // SUBTLE DARK GRADIENT
          // =================================================

          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(
                        alpha: 0.30,
                      ),
                      Colors.transparent,
                      Colors.black.withValues(
                        alpha: 0.38,
                      ),
                    ],
                    stops: const [
                      0.0,
                      0.45,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // =================================================
          // LIVE BADGE
          // =================================================

          Positioned(
            top: 16,
            right: 16,
            child: _buildLiveBadge(),
          ),

          // =================================================
          // AI STATUS
          // =================================================

          Positioned(
            top: 16,
            left: 16,
            child: _buildAIStatus(),
          ),

          // =================================================
          // BOTTOM INFO
          // =================================================

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildBottomOverlay(),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LIVE BADGE
  // =========================================================

  Widget _buildLiveBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.58,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            "LIVE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // AI STATUS
  // =========================================================

  Widget _buildAIStatus() {
    final bool hasPose =
        _landmarks.length == 33;

    final Color statusColor =
        _posture == "correct"
            ? Colors.greenAccent
            : _posture == "incorrect"
                ? Colors.orangeAccent
                : Colors.white70;

    final String label =
        _posture == "correct"
            ? "Bonne posture"
            : _posture == "incorrect"
                ? "À corriger"
                : _posture == "not_squat"
                    ? "En attente"
                    : "Analyse...";

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.58,
        ),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: hasPose
                  ? statusColor
                  : Colors.white38,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM OVERLAY
  // =========================================================

  Widget _buildBottomOverlay() {
    return Row(
      children: [
        // ---------------------------------------------------
        // SCORE
        // ---------------------------------------------------

        _buildMiniMetric(
          icon: Icons.analytics_outlined,
          label: "Score",
          value: "$_score",
        ),

        const SizedBox(width: 10),

        // ---------------------------------------------------
        // REPETITIONS
        // ---------------------------------------------------

        _buildMiniMetric(
          icon: Icons.repeat_rounded,
          label: "Répétitions",
          value: "$_repetitions",
        ),

        const Spacer(),

        // ---------------------------------------------------
        // CONFIDENCE
        // ---------------------------------------------------

        _buildMiniMetric(
          icon: Icons.auto_awesome_outlined,
          label: "IA",
          value:
              "${(_confidence * 100).round()}%",
        ),
      ],
    );
  }

  // =========================================================
  // MINI METRIC
  // =========================================================

  Widget _buildMiniMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.62,
        ),
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================
// POSE PAINTER
// =============================================================

class PosePainter extends CustomPainter {
  const PosePainter({
    required this.landmarks,
    required this.connections,
  });

  final List<Map<String, dynamic>> landmarks;

  final List<List<int>> connections;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (landmarks.length != 33) {
      return;
    }

    if (size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    // ---------------------------------------------------------
    // Paint points
    // ---------------------------------------------------------

    final pointPaint = Paint()
      ..style = PaintingStyle.fill;

    // ---------------------------------------------------------
    // Paint lignes
    // ---------------------------------------------------------

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // =========================================================
    // DRAW CONNECTIONS
    // =========================================================

    for (final connection in connections) {
      if (connection.length < 2) {
        continue;
      }

      final startIndex = connection[0];

      final endIndex = connection[1];

      if (startIndex < 0 ||
          endIndex < 0 ||
          startIndex >= landmarks.length ||
          endIndex >= landmarks.length) {
        continue;
      }

      final start = _getPoint(
        landmarks[startIndex],
        size,
      );

      final end = _getPoint(
        landmarks[endIndex],
        size,
      );

      if (start == null ||
          end == null) {
        continue;
      }

      final startVisibility =
          (landmarks[startIndex]["visibility"]
                      as num?)
                  ?.toDouble() ??
              0.0;

      final endVisibility =
          (landmarks[endIndex]["visibility"]
                      as num?)
                  ?.toDouble() ??
              0.0;

      if (startVisibility < 0.5 ||
          endVisibility < 0.5) {
        continue;
      }

      linePaint.color =
          Colors.greenAccent.withValues(
        alpha: 0.88,
      );

      canvas.drawLine(
        start,
        end,
        linePaint,
      );
    }

    // =========================================================
    // DRAW LANDMARKS
    // =========================================================

    for (final landmark in landmarks) {
      final visibility =
          (landmark["visibility"]
                      as num?)
                  ?.toDouble() ??
              0.0;

      if (visibility < 0.5) {
        continue;
      }

      final point = _getPoint(
        landmark,
        size,
      );

      if (point == null) {
        continue;
      }

      pointPaint.color =
          Colors.greenAccent;

      canvas.drawCircle(
        point,
        5,
        pointPaint,
      );

      final centerPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white;

      canvas.drawCircle(
        point,
        2,
        centerPaint,
      );
    }
  }

  // ===========================================================
  // GET POINT
  // ===========================================================

  Offset? _getPoint(
    Map<String, dynamic> landmark,
    Size size,
  ) {
    final x =
        (landmark["x"] as num?)
            ?.toDouble();

    final y =
        (landmark["y"] as num?)
            ?.toDouble();

    if (x == null ||
        y == null) {
      return null;
    }

    final safeX =
        x.clamp(0.0, 1.0);

    final safeY =
        y.clamp(0.0, 1.0);

    return Offset(
      safeX * size.width,
      safeY * size.height,
    );
  }

  // ===========================================================
  // REPAINT
  // ===========================================================

  @override
  bool shouldRepaint(
    covariant PosePainter oldDelegate,
  ) {
    return oldDelegate.landmarks !=
            landmarks ||
        oldDelegate.connections !=
            connections;
  }
}