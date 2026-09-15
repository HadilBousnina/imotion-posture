import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;
import '../../../services/webcam_service.dart';

class WebcamService {
  web.HTMLVideoElement? video;
  web.MediaStream? stream;
  web.HTMLCanvasElement? canvas;

  Timer? captureTimer;

  Future<void> startCamera() async {
    stream = await web.window.navigator.mediaDevices
        .getUserMedia(
          web.MediaStreamConstraints(
            video: true.toJS,
            audio: false.toJS,
          ),
        )
        .toDart;
    video = web.HTMLVideoElement()
      ..autoplay = true
      ..muted = true
      ..playsInline = true
      ..srcObject = stream
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.objectFit = "cover";
    ui_web.platformViewRegistry.registerViewFactory(
      'live-camera',
      (int viewId) => video!,
    );
  }

  void stopCamera() {
    captureTimer?.cancel();
    captureTimer = null;
    if (stream != null) {
      for (final track in stream!.getTracks().toDart) {
        track.stop();
      }
      stream = null;
    }
    video?.srcObject = null;
    video = null;
    canvas = null;
  }
}