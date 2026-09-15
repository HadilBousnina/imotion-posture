"""
Posture Analyzer.

Combines:

- Machine Learning classifier
- Biomechanical rules
- Live posture score
"""

from app.ia.classifier.posture_classifier import PostureClassifier
from app.ia.rules.squat_rules import SquatRules


class PostureAnalyzer:
    """
    Main entry point of the IA module.

    Responsibilities:
    - Predict posture using the trained ML model.
    - Compute prediction confidence.
    - Explain incorrect postures using biomechanical rules.
    - Calculate a posture score.
    """

    def __init__(self):

        self.classifier = PostureClassifier()
        self.rules = SquatRules()

    # =====================================================
    # Score calculation
    # =====================================================

    def _calculate_score(
        self,
        prediction,
        confidence,
        errors
    ):
        """
        Calculate posture score between 0 and 100.

        Rules:
        - correct     -> confidence * 100
        - incorrect   -> (1 - confidence) * 100
        - each error  -> -10 points
        - not_squat   -> 0
        """

        # No squat detected
        if prediction == "not_squat":
            return 0

        # Correct posture
        if prediction == "correct":

            score = confidence * 100

        # Incorrect posture
        else:

            score = (1 - confidence) * 100

        # Penalty for biomechanical errors
        score -= len(errors) * 10

        # Keep score between 0 and 100
        score = max(
            0,
            min(100, score)
        )

        return round(score)

    # =====================================================
    # Main analyzer
    # =====================================================

    def analyze(self, features):
        """
        Analyze one posture sample.

        Returns:
            {
                "prediction": str,
                "confidence": float,
                "score": int,
                "errors": list[str]
            }
        """

        # ---------------------------------
        # Machine Learning prediction
        # ---------------------------------

        prediction, confidence = (
            self.classifier.predict_with_confidence(
                features
            )
        )

        # ---------------------------------
        # Biomechanical explanation
        # ---------------------------------

        if prediction == "incorrect":

            errors = self.rules.analyze(
                features
            )

        else:

            errors = []

        # ---------------------------------
        # Score
        # ---------------------------------

        score = self._calculate_score(
            prediction,
            confidence,
            errors
        )

        # ---------------------------------
        # Final result
        # ---------------------------------

        return {
            "prediction": prediction,
            "confidence": round(
                float(confidence),
                2
            ),
            "score": score,
            "errors": errors,
        }
