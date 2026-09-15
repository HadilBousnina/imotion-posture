"""
Full IA pipeline test

Video
 -> MediaPipe Pose
 -> Feature extraction
 -> Posture Analyzer
 -> Prediction smoothing
 -> Error smoothing
 -> Squat repetition counter
"""

import cv2
from collections import deque, Counter

from app.ia.pose.detector import PoseDetector
from app.ia.features.extractor import FeatureExtractor
from app.ia.analyzer.posture_analyzer import PostureAnalyzer
from app.ia.repetition.counter import SquatCounter


# =====================================================
# Video path
# =====================================================

VIDEO_PATH = "app/ia/datasets/test_videos/incorrect/test_incorrect_02.mp4"


# =====================================================
# Initialize components
# =====================================================

pose_detector = PoseDetector()
feature_extractor = FeatureExtractor()
analyzer = PostureAnalyzer()
counter = SquatCounter()


# =====================================================
# Smoothing buffers
# =====================================================

prediction_buffer = deque(maxlen=10)
error_buffer = deque(maxlen=10)


# =====================================================
# Open video
# =====================================================

cap = cv2.VideoCapture(VIDEO_PATH)

if not cap.isOpened():
    raise Exception("❌ Cannot open video")

frame_count = 0


# =====================================================
# Process video
# =====================================================

while True:

    success, frame = cap.read()

    if not success:
        break

    frame_count += 1

    # -----------------------------------------
    # Pose detection
    # -----------------------------------------

    results = pose_detector.detect(frame)

    if results.pose_landmarks:

        landmarks = results.pose_landmarks.landmark

        frame = pose_detector.draw(frame, results)

        # -----------------------------------------
        # Feature extraction
        # -----------------------------------------

        features = feature_extractor.extract(landmarks)

        if features:

            # -----------------------------------------
            # Squat counter
            # -----------------------------------------

            repetitions = counter.update(features)

            # -----------------------------------------
            # Full posture analysis
            # -----------------------------------------

            result = analyzer.analyze(features)

            prediction = result["prediction"]
            confidence = result["confidence"]
            errors = result["errors"]

            # -----------------------------------------
            # Prediction smoothing
            # -----------------------------------------

            prediction_buffer.append(prediction)

            if len(prediction_buffer) >= 5:
                stable_prediction = Counter(
                    prediction_buffer
                ).most_common(1)[0][0]
            else:
                stable_prediction = prediction

            # -----------------------------------------
            # Error smoothing
            # -----------------------------------------

            if stable_prediction == "incorrect" and errors:
                error_buffer.append(errors[0])
            else:
                error_buffer.append(None)

            if len(error_buffer) >= 5:

                valid_errors = [
                    err for err in error_buffer
                    if err is not None
                ]

                if valid_errors:
                    stable_error = Counter(
                        valid_errors
                    ).most_common(1)[0][0]
                else:
                    stable_error = None

            else:
                stable_error = errors[0] if errors else None

            # -----------------------------------------
            # Console
            # -----------------------------------------

            print(
                f"Frame {frame_count:03d}"
                f" | Posture: {stable_prediction}"
                f" | Confidence: {confidence:.2f}"
                f" | Reps: {repetitions}"
            )

            if stable_error:
                print("   Error:", stable_error)

            # -----------------------------------------
            # Display posture
            # -----------------------------------------

            color = (
                (0, 255, 0)
                if stable_prediction == "correct"
                else (0, 0, 255)
            )

            cv2.putText(
                frame,
                f"Posture : {stable_prediction}",
                (20, 40),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.8,
                color,
                2,
            )

            # -----------------------------------------
            # Confidence
            # -----------------------------------------

            cv2.putText(
                frame,
                f"Confidence : {confidence:.1%}",
                (20, 80),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.7,
                (255, 255, 255),
                2,
            )

            # -----------------------------------------
            # Error
            # -----------------------------------------

            if stable_error:

                cv2.putText(
                    frame,
                    f"Error : {stable_error}",
                    (20, 120),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.7,
                    (0, 0, 255),
                    2,
                )

            # -----------------------------------------
            # Repetitions
            # -----------------------------------------

            cv2.putText(
                frame,
                f"Reps : {repetitions}",
                (20, 160),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.8,
                (255, 255, 0),
                2,
            )

    # =====================================================
    # Display
    # =====================================================

    cv2.imshow("iMotion IA Pipeline", frame)

    if cv2.waitKey(25) & 0xFF == ord("q"):
        break


# =====================================================
# Cleanup
# =====================================================

cap.release()
pose_detector.close()
cv2.destroyAllWindows()

print("\n✅ Pipeline test completed!")