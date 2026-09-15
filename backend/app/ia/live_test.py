import cv2
import time

from app.ia.pose.detector import PoseDetector
from app.ia.features.extractor import FeatureExtractor
from app.ia.classifier import PostureClassifier


# =========================
# Initialize IA components
# =========================

pose_detector = PoseDetector()
feature_extractor = FeatureExtractor()
classifier = PostureClassifier()


# =========================
# Webcam initialization
# =========================

cap = cv2.VideoCapture(0)


if not cap.isOpened():
    print("❌ Webcam not detected")
    exit()


print("🎥 iMotion Live Posture Detection Started")
print("Press 'q' to quit")


# FPS variables
prev_time = 0


# =========================
# Live loop
# =========================

while True:

    ret, frame = cap.read()

    if not ret:
        print("❌ Cannot read frame")
        break


    # =========================
    # Pose detection
    # =========================

    results = pose_detector.detect(frame)


    landmarks = pose_detector.get_landmarks(results)


    prediction_text = "No squat"


    if landmarks:

        # =========================
        # Feature extraction
        # =========================

        features = feature_extractor.extract(
            landmarks
        )


        # =========================
        # Classification
        # =========================

        prediction = classifier.predict(
            features
        )


        if prediction != "not_squat":

            prediction_text = prediction


        else:

            prediction_text = "Waiting squat..."



    else:

        prediction_text = "No pose detected"



    # =========================
    # Draw skeleton
    # =========================

    frame = pose_detector.draw(
        frame,
        results
    )


    # =========================
    # FPS calculation
    # =========================

    current_time = time.time()

    fps = 1 / (current_time - prev_time) if prev_time else 0

    prev_time = current_time



    # =========================
    # Display prediction
    # =========================

    cv2.putText(
        frame,
        f"Posture: {prediction_text}",
        (30, 50),
        cv2.FONT_HERSHEY_SIMPLEX,
        1,
        (0, 255, 0),
        2
    )


    cv2.putText(
        frame,
        f"FPS: {int(fps)}",
        (30, 90),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.8,
        (255, 255, 255),
        2
    )


    # =========================
    # Show window
    # =========================

    cv2.imshow(
        "iMotion Live Posture",
        frame
    )


    # Quit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break



# =========================
# Cleanup
# =========================

cap.release()

pose_detector.close()

cv2.destroyAllWindows()


print("🛑 Live detection stopped")