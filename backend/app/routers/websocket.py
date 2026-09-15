import cv2
import numpy as np

from fastapi import APIRouter, WebSocket

from app.ia.pose.detector import PoseDetector
from app.ia.features.extractor import FeatureExtractor
from app.ia.analyzer.posture_analyzer import PostureAnalyzer
from app.ia.repetition.counter import SquatCounter


router = APIRouter()


pose_detector = PoseDetector()
feature_extractor = FeatureExtractor()
posture_analyzer = PostureAnalyzer()
squat_counter = SquatCounter()


@router.websocket("/ws/live")
async def live_posture(websocket: WebSocket):

    await websocket.accept()

    print("🟢 Client live connecté")

    try:

        while True:

            # ==========================================
            # Réception de la frame
            # ==========================================

            frame_bytes = await websocket.receive_bytes()

            print(
                f"📥 Frame reçue : {len(frame_bytes)} bytes"
            )

            # ==========================================
            # JPEG bytes → image OpenCV
            # ==========================================

            np_array = np.frombuffer(
                frame_bytes,
                np.uint8,
            )

            frame = cv2.imdecode(
                np_array,
                cv2.IMREAD_COLOR,
            )

            if frame is None:

                await websocket.send_json({
                    "status": "error",
                    "message": "Frame invalide",
                })

                continue

            # ==========================================
            # MediaPipe Pose
            # ==========================================

            results = pose_detector.detect(
                frame
            )

            landmarks = pose_detector.get_landmarks(
                results
            )

            # ==========================================
            # Aucun corps détecté
            # ==========================================

            if landmarks is None:

                await websocket.send_json({
                    "status": "success",
                    "posture": "no_pose",
                    "confidence": 0.0,
                    "errors": [],
                    "repetitions": squat_counter.count,
                    "details": {},
                })

                continue

            # ==========================================
            # Conversion des 33 landmarks pour Flutter
            # ==========================================
            
            landmarks_data = []
            
            for landmark in landmarks:
                landmarks_data.append({
                    "x": float(landmark.x),
                    "y": float(landmark.y),
                    "z": float(landmark.z),
                    "visibility": float(landmark.visibility),
                })
                
            
            # ==========================================
            # Feature extraction
            # ==========================================

            features = feature_extractor.extract(
                landmarks
            )

            # ==========================================
            # Posture analysis
            # ==========================================

            analysis = posture_analyzer.analyze(
                features
            )

            prediction = analysis["prediction"]
            confidence = analysis["confidence"]
            errors = analysis["errors"]
            score = analysis["score"]

            print(
                f"🤖 Prediction : {prediction}"
            )

            print(
                f"📊 Confidence : {confidence:.2f}"
            )

            print(
                f"⚠️ Errors : {errors}"
            )

            # ==========================================
            # Repetition counting
            # ==========================================

            repetitions = squat_counter.update(
                features
            )

            print(
                f"🔄 Repetitions : {repetitions}"
            )

            # ==========================================
            # Résultat envoyé à Flutter
            # ==========================================

            await websocket.send_json({
                "status": "success",
                "posture": prediction,
                "confidence": float(confidence),
                "errors": errors,
                "repetitions": repetitions,
                "details": features,
                "score": score,
                "landmarks": landmarks_data,
            })

    except Exception as e:

        print(
            "🔴 Connexion fermée :",
            e,
        )