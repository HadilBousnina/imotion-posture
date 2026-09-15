"""
Posture classifier using trained ML model.

Input:
    Biomechanical features extracted by FeatureExtractor

Output:
    correct / incorrect
"""


from pathlib import Path

import joblib
import pandas as pd



class PostureClassifier:


    def __init__(self):

        BASE_DIR = Path(__file__).resolve().parents[1]

        model_path = (
            BASE_DIR
            / "models"
            / "posture_classifier.pkl"
        )


        self.model = joblib.load(
            model_path
        )


        print("✅ Posture classifier loaded")



    # =====================================================
    # Squat detection
    # =====================================================

    def _is_squat(self, features):
        """
        Check if the person is performing a squat.

        Returns:
            bool
        """


        left_knee = features.get(
            "left_knee",
            180
        )

        right_knee = features.get(
            "right_knee",
            180
        )


        avg_knee = (
            left_knee + right_knee
        ) / 2


        return avg_knee <= 140




    # =====================================================
    # Basic prediction
    # =====================================================

    def predict(self, features: dict):
        """
        Predict posture class.

        Returns:
            correct / incorrect / not_squat
        """


        if not self._is_squat(features):

            return "not_squat"



        input_data = pd.DataFrame(
            [features]
        )


        prediction = self.model.predict(
            input_data
        )


        return prediction[0]



    # =====================================================
    # Prediction + confidence
    # =====================================================

    def predict_with_confidence(self, features):
        """
        Predict posture with confidence score.

        Returns:
            tuple:
                prediction,
                confidence
        """


        # Not squatting
        if not self._is_squat(features):

            return (
                "not_squat",
                1.0
            )



        # Prepare dataframe

        X = pd.DataFrame(
            [features]
        )



        # Prediction

        prediction = self.model.predict(
            X
        )[0]



        # Confidence

        probabilities = self.model.predict_proba(
            X
        )[0]


        confidence = max(
            probabilities
        )



        return (
            prediction,
            confidence
        )