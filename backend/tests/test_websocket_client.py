import websocket
import json
import cv2


# ==========================================
# Connexion au WebSocket
# ==========================================

ws = websocket.create_connection(
    "ws://127.0.0.1:8000/ws/live"
)

print("🟢 Connecté au serveur")


# ==========================================
# Création d'une vraie image OpenCV
# ==========================================

frame = cv2.imread("tests/test_frame.jpg")

if frame is None:
    print("🔴 Impossible de charger tests/test_frame.jpg")
    ws.close()
    exit()


# ==========================================
# Image OpenCV → JPEG bytes
# ==========================================

success, encoded_frame = cv2.imencode(
    ".jpg",
    frame
)

if not success:
    print("🔴 Impossible d'encoder la frame en JPEG")
    ws.close()
    exit()


frame_bytes = encoded_frame.tobytes()


print(
    f"📦 Taille de la frame JPEG : {len(frame_bytes)} bytes"
)


# ==========================================
# Envoi de la frame
# ==========================================

ws.send_binary(frame_bytes)

print("📤 Frame envoyée")


# ==========================================
# Réception de la réponse
# ==========================================

response = ws.recv()

print("📥 Réponse serveur:")

print(
    json.loads(response)
)


# ==========================================
# Fermeture
# ==========================================

ws.close()

print("🔴 Connexion fermée")

