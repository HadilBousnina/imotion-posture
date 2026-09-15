import mediapipe as mp

from .angles import calculate_angle, calculate_trunk_angle


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

        features.update(
            self._extract_knee_angles(landmarks)
        )

        features.update(
            self._extract_hip_angles(landmarks)
        )

        features.update(
            self._extract_trunk_angle(landmarks)
        )


        return features



    # =====================================================
    # Knee angles
    # =====================================================

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



    # =====================================================
    # Hip angles
    # =====================================================

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



    # =====================================================
    # Trunk angle
    # =====================================================

    def _extract_trunk_angle(self, landmarks):

        pose = self.pose


        return {

            "trunk_angle": calculate_trunk_angle(

                landmarks[pose.LEFT_SHOULDER.value],
                landmarks[pose.RIGHT_SHOULDER.value],

                landmarks[pose.LEFT_HIP.value],
                landmarks[pose.RIGHT_HIP.value],
            )
        }