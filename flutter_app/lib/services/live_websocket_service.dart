import 'dart:convert';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

class LiveWebSocketService {
  WebSocketChannel? _channel;

  void connect({
    required void Function(Map<String, dynamic> data) onResult,
  }) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8000/ws/live'),
    );

    print("🟢 WebSocket connecté");

    _channel!.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message.toString());

          if (data is Map<String, dynamic>) {
            print("📥 Résultat IA : $data");
            onResult(data);
          }
        } catch (e) {
          print("❌ Erreur lecture réponse WebSocket : $e");
        }
      },
      onError: (error) {
        print("❌ WebSocket error : $error");
      },
      onDone: () {
        print("🔴 WebSocket terminé");
      },
    );
  }

  void sendFrame(Uint8List bytes) {
    if (_channel == null) {
      return;
    }

    _channel!.sink.add(bytes);

    print(
      "📤 Frame envoyée : ${bytes.length} bytes",
    );
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;

    print("🔴 WebSocket fermé");
  }
}

