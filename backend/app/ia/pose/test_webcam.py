import cv2

from detector import PoseDetector


def main():
    detector = PoseDetector()

    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("❌ Unable to access the webcam.")
        return

    print("✅ Webcam started successfully!")
    print("Press 'q' to quit.\n")

    while True:
        success, frame = cap.read()

        if not success:
            print("❌ Failed to read frame.")
            break

        results = detector.detect(frame)

        frame = detector.draw(frame, results)

        cv2.imshow("iMotion Pose Detection", frame)

        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

    detector.close()
    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()