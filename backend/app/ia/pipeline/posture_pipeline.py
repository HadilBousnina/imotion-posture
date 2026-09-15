from app.ia.pose.detector import PoseDetector
from app.ia.features.extractor import FeatureExtractor
from app.ia.analyzer.posture_analyzer import PostureAnalyzer
from app.ia.repetition.counter import SquatCounter


class PosturePipeline:
    """
    Complete posture analysis pipeline.

    Responsibilities:
        - Detect pose
        - Extract landmarks
        - Compute biomechanical features
        - Analyze posture
        - Count repetitions
    """

    def __init__(self):
        self.pose_detector = PoseDetector()
        self.feature_extractor = FeatureExtractor()
        self.posture_analyzer = PostureAnalyzer()
        self.squat_counter = SquatCounter()

    # =====================================================
    # Process one frame
    # =====================================================

    def process(self, frame):
        """
        Process one video frame.

        Args:
            frame: OpenCV BGR image.

        Returns:
            dict | None
        """

        # ==========================================
        # Pose Detection
        # ==========================================

        results = self.pose_detector.detect(frame)

        landmarks = self.pose_detector.get_landmarks(results)

        if landmarks is None:
            return None

        # ==========================================
        # Feature Extraction
        # ==========================================

        features = self.feature_extractor.extract(landmarks)

        print("\n========== FEATURES ==========")

        for key, value in features.items():
            print(f"{key:15}: {value:.2f}")

        # ==========================================
        # Posture Analysis
        # ==========================================

        analysis = self.posture_analyzer.analyze(features)

        print("\n========== ANALYSIS ==========")
        print(analysis)

        # ==========================================
        # Repetition Counter
        # ==========================================

        repetitions = self.squat_counter.update(features)

        # ==========================================
        # Final Result
        # ==========================================

        analysis["repetitions"] = repetitions

        # IMPORTANT:
        # Keep biomechanical features so that the
        # video service can aggregate the angles.
        analysis["details"] = {
            "left_knee": features.get("left_knee"),
            "right_knee": features.get("right_knee"),
            "left_hip": features.get("left_hip"),
            "right_hip": features.get("right_hip"),
            "trunk_angle": features.get("trunk_angle"),
        }

        print("\n========== FINAL RESULT ==========")
        print(analysis)

        return analysis