import cv2

from app.ia.pose.detector import PoseDetector
from app.ia.features.extractor import FeatureExtractor


def main():

    detector = PoseDetector()
    extractor = FeatureExtractor()


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



        # -----------------------------------------
        # Detect pose
        # -----------------------------------------

        results = detector.detect(frame)



        # -----------------------------------------
        # Draw skeleton
        # -----------------------------------------

        frame = detector.draw(frame, results)



        # -----------------------------------------
        # Extract landmarks
        # -----------------------------------------

        landmarks = detector.get_landmarks(results)



        if landmarks:

            features = extractor.extract(landmarks)


            print("-----------------------------")


            for name, value in features.items():

                print(
                    f"{name:<20}: {value:.2f}"
                )



            # -----------------------------------------
            # Display features on video
            # -----------------------------------------

            y = 30


            for name, value in features.items():

                text = (
                    f"{name}: {value:.1f}"
                )


                cv2.putText(
                    frame,
                    text,
                    (10, y),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.6,
                    (0, 255, 0),
                    2,
                )


                y += 25



        # -----------------------------------------
        # Display webcam
        # -----------------------------------------

        cv2.imshow(
            "iMotion Feature Extraction",
            frame
        )



        # Quit
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break



    # -----------------------------------------
    # Cleanup
    # -----------------------------------------

    detector.close()

    cap.release()

    cv2.destroyAllWindows()



if __name__ == "__main__":
    main()