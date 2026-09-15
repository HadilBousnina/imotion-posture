"""
Squat biomechanical rules.

Analyzes squat posture errors
using extracted biomechanical features.
"""


class SquatRules:


    def __init__(self):

        # Squat detection
        self.squat_knee_threshold = 160


        # Depth
        self.min_depth_angle = 70
        self.max_depth_angle = 160


        # Back
        self.min_back_angle = 130


        # Symmetry
        self.max_difference = 20



    # =====================================================
    # Main analyzer
    # =====================================================

    def analyze(self, features):

        errors = []


        # Ignore standing position
        if not self.is_squat_position(features):
            return errors



        errors += self.check_depth(features)

        errors += self.check_back(features)

        errors += self.check_symmetry(features)



        return errors



    # =====================================================
    # Detect squat phase
    # =====================================================

    def is_squat_position(self, features):

        left_knee = features.get("left_knee")
        right_knee = features.get("right_knee")


        if not left_knee or not right_knee:
            return False


        avg_knee = (
            left_knee + right_knee
        ) / 2



        return avg_knee < self.squat_knee_threshold



    # =====================================================
    # Depth
    # =====================================================

    def check_depth(self, features):

        errors = []


        left_knee = features.get("left_knee")
        right_knee = features.get("right_knee")


        if left_knee and right_knee:

            avg_knee = (
                left_knee + right_knee
            ) / 2


            if avg_knee > self.max_depth_angle:

                errors.append(
                    "Squat too shallow"
                )


            elif avg_knee < self.min_depth_angle:

                errors.append(
                    "Squat too deep"
                )


        return errors



    # =====================================================
    # Back posture
    # =====================================================

    def check_back(self, features):

        errors = []


        trunk_angle = features.get(
            "trunk_angle"
        )


        if trunk_angle is not None:
            # trunk_angle:
            # 0° -> perfectly upright
            # 45° -> significantly inclined
            # >45° -> excessive inclination
            
            max_trunk_angle = 45

            if trunk_angle > max_trunk_angle:
                
                errors.append(
                    "Back too inclined"
                )


        return errors



    # =====================================================
    # Symmetry
    # =====================================================

    def check_symmetry(self, features):

        errors = []


        left_knee = features.get(
            "left_knee"
        )

        right_knee = features.get(
            "right_knee"
        )


        if left_knee and right_knee:

            difference = abs(
                left_knee - right_knee
            )


            if difference > self.max_difference:

                errors.append(
                    "Knee asymmetry detected"
                )



        left_hip = features.get(
            "left_hip"
        )

        right_hip = features.get(
            "right_hip"
        )


        if left_hip and right_hip:

            difference = abs(
                left_hip - right_hip
            )


            if difference > self.max_difference:

                errors.append(
                    "Hip asymmetry detected"
                )


        return errors
    