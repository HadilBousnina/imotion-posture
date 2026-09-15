import cv2

from app.ia.pipeline.posture_pipeline import PosturePipeline


class PostureService:
    """
    Service responsible for posture analysis.

    Responsibilities:
        - Analyze one frame
        - Analyze a complete video
        - Execute the IA pipeline
    """

    def __init__(self):
        self.pipeline = PosturePipeline()

    # =====================================================
    # Analyze one frame
    # =====================================================

    def analyze_frame(self, frame):
        """
        Analyze a single OpenCV frame.

        Args:
            frame: OpenCV BGR frame.

        Returns:
            dict | None
        """

        return self.pipeline.process(frame)

    # =====================================================
    # Analyze one video
    # =====================================================

    def analyze_video(self, video_path):
        """
        Analyze an entire video.

        Args:
            video_path: Path to the video file.

        Returns:
            dict: Analysis result.
        """

        cap = cv2.VideoCapture(str(video_path))

        if not cap.isOpened():
            raise ValueError("Cannot open video.")

        total_frames = 0
        analyzed_frames = 0

        correct_frames = 0
        incorrect_frames = 0

        confidence_sum = 0.0

        errors = set()

        repetitions = 0

        # =================================================
        # Angle accumulation
        # =================================================

        angle_sums = {
            "left_knee": 0.0,
            "right_knee": 0.0,
            "left_hip": 0.0,
            "right_hip": 0.0,
            "trunk_angle": 0.0,
        }

        angle_counts = {
            "left_knee": 0,
            "right_knee": 0,
            "left_hip": 0,
            "right_hip": 0,
            "trunk_angle": 0,
        }

        try:

            while True:

                success, frame = cap.read()

                if not success:
                    break

                total_frames += 1

                result = self.analyze_frame(frame)

                if result is None:
                    continue

                analyzed_frames += 1

                # =================================================
                # Posture prediction
                # =================================================

                prediction = result.get("prediction")

                if prediction == "correct":
                    correct_frames += 1

                elif prediction == "incorrect":
                    incorrect_frames += 1

                # =================================================
                # Confidence
                # =================================================

                confidence_sum += result.get(
                    "confidence",
                    0.0,
                )

                # =================================================
                # Errors
                # =================================================

                errors.update(
                    result.get(
                        "errors",
                        [],
                    )
                )

                # =================================================
                # Repetitions
                # =================================================

                repetitions = result.get(
                    "repetitions",
                    repetitions,
                )

                # =================================================
                # Angles
                # =================================================

                details = result.get(
                    "details",
                    {},
                )

                if isinstance(details, dict):

                    for key in angle_sums:

                        value = details.get(key)

                        if value is not None:

                            try:

                                value = float(value)

                                angle_sums[key] += value
                                angle_counts[key] += 1

                            except (
                                TypeError,
                                ValueError,
                            ):
                                pass

        finally:
            cap.release()

        # =================================================
        # Global evaluation
        # =================================================

        squat_frames = (
            correct_frames + incorrect_frames
        )

        score = (
            int(
                (correct_frames / squat_frames)
                * 100
            )
            if squat_frames > 0
            else 0
        )

        posture = (
            "Correct"
            if correct_frames >= incorrect_frames
            else "Incorrect"
        )

        average_confidence = (
            confidence_sum / analyzed_frames
            if analyzed_frames > 0
            else 0.0
        )

        ignored_frames = (
            analyzed_frames - squat_frames
        )

        # =================================================
        # Average angles
        # =================================================

        average_angles = {}

        for key in angle_sums:

            count = angle_counts[key]

            if count > 0:

                average_angles[key] = round(
                    angle_sums[key] / count,
                    2,
                )

            else:

                average_angles[key] = 0.0

        # =================================================
        # Final response
        # =================================================

        return {
            "exercise": "Squat",

            "repetitions": repetitions,

            "posture": posture,

            "score": score,

            "confidence": round(
                average_confidence,
                2,
            ),

            "errors": sorted(errors),

            "details": {
                # -----------------------------
                # Average biomechanical angles
                # -----------------------------

                "left_knee": average_angles[
                    "left_knee"
                ],

                "right_knee": average_angles[
                    "right_knee"
                ],

                "left_hip": average_angles[
                    "left_hip"
                ],

                "right_hip": average_angles[
                    "right_hip"
                ],

                "trunk_angle": average_angles[
                    "trunk_angle"
                ],

                # -----------------------------
                # Video statistics
                # -----------------------------

                "total_frames": total_frames,

                "analyzed_frames": analyzed_frames,

                "correct_frames": correct_frames,

                "incorrect_frames": incorrect_frames,

                "ignored_frames": ignored_frames,
            },
        }

    # =====================================================
    # Release resources
    # =====================================================

    def close(self):
        """
        Release resources.
        """

        pass