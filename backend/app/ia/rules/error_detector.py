"""
Central error detector.

Decides when to apply biomechanical rules.
"""


from app.ia.rules.squat_rules import SquatRules



class ErrorDetector:
    """
    Main entry point for posture error detection.
    """


    def __init__(self):
        self.squat_rules = SquatRules()



    def detect(self, prediction, features):
        """
        Detect biomechanical errors.

        Args:
            prediction (str):
                ML classifier prediction.

            features (dict):
                Extracted biomechanical features.

        Returns:
            list[str]:
                Detected warnings.
        """


        # No data
        if not features:
            return []


        # Normalize prediction
        prediction = prediction.lower().strip()


        # Ignore non-squat frames
        if prediction == "not_squat":
            return []


        # Apply squat biomechanical rules
        return self.squat_rules.analyze(features)