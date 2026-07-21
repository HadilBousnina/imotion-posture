import mediapipe as mp

from .angles import calculate_angle


class FeatureExtractor:
    """
    Extract biomechanical features from MediaPipe landmarks.
    """

    def __init__(self):
        self.pose = mp.solutions.pose.PoseLandmark

    def extract(self, landmarks):
        """
        Extract all posture features.
        """

        features = {}

        features.update(self._extract_knee_angles(landmarks))
        features.update(self._extract_hip_angles(landmarks))
        features.update(self._extract_elbow_angles(landmarks))

        return features

    def _extract_knee_angles(self, landmarks):
        pose = self.pose

        return {
            "left_knee": calculate_angle(
                landmarks[pose.LEFT_HIP.value],
                landmarks[pose.LEFT_KNEE.value],
                landmarks[pose.LEFT_ANKLE.value],
            ),
            "right_knee": calculate_angle(
                landmarks[pose.RIGHT_HIP.value],
                landmarks[pose.RIGHT_KNEE.value],
                landmarks[pose.RIGHT_ANKLE.value],
            ),
        }

    def _extract_hip_angles(self, landmarks):
        pose = self.pose

        return {
            "left_hip": calculate_angle(
                landmarks[pose.LEFT_SHOULDER.value],
                landmarks[pose.LEFT_HIP.value],
                landmarks[pose.LEFT_KNEE.value],
            ),
            "right_hip": calculate_angle(
                landmarks[pose.RIGHT_SHOULDER.value],
                landmarks[pose.RIGHT_HIP.value],
                landmarks[pose.RIGHT_KNEE.value],
            ),
        }

    def _extract_elbow_angles(self, landmarks):
        pose = self.pose

        return {
            "left_elbow": calculate_angle(
                landmarks[pose.LEFT_SHOULDER.value],
                landmarks[pose.LEFT_ELBOW.value],
                landmarks[pose.LEFT_WRIST.value],
            ),
            "right_elbow": calculate_angle(
                landmarks[pose.RIGHT_SHOULDER.value],
                landmarks[pose.RIGHT_ELBOW.value],
                landmarks[pose.RIGHT_WRIST.value],
            ),
        }