import cv2
import mediapipe as mp


class PoseDetector:
    """
    Wrapper around MediaPipe Pose for detecting and drawing human poses.
    """

    def __init__(
        self,
        static_image_mode=False,
        model_complexity=1,
        smooth_landmarks=True,
        enable_segmentation=False,
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5,
    ):
        # MediaPipe modules
        self.mp_pose = mp.solutions.pose
        self.mp_drawing = mp.solutions.drawing_utils
        self.mp_drawing_styles = mp.solutions.drawing_styles

        # Initialize Pose model
        self.pose = self.mp_pose.Pose(
            static_image_mode=static_image_mode,
            model_complexity=model_complexity,
            smooth_landmarks=smooth_landmarks,
            enable_segmentation=enable_segmentation,
            min_detection_confidence=min_detection_confidence,
            min_tracking_confidence=min_tracking_confidence,
        )

    def detect(self, frame):
        """
        Detect pose landmarks in a frame.

        Args:
            frame: BGR image from OpenCV.

        Returns:
            MediaPipe detection results.
        """
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.pose.process(rgb_frame)
        return results

    def draw(self, frame, results):
        """
        Draw pose landmarks on the frame.
        """
        if results.pose_landmarks:
            self.mp_drawing.draw_landmarks(
                frame,
                results.pose_landmarks,
                self.mp_pose.POSE_CONNECTIONS,
                landmark_drawing_spec=self.mp_drawing_styles.get_default_pose_landmarks_style(),
            )

        return frame

    def get_landmarks(self, results):
        """
        Return pose landmarks if detected.
        """
        if results.pose_landmarks:
            return results.pose_landmarks.landmark
        return None

    def close(self):
        """
        Release MediaPipe resources.
        """
        self.pose.close()