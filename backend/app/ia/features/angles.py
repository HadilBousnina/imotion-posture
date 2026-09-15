import math


def calculate_angle(a, b, c):
    """
    Calculate the angle (in degrees) formed by three points.

    Args:
        a, b, c:
            Landmarks or points with x and y attributes.
            The angle is calculated at point b.

    Returns:
        Angle in degrees (0–180).
    """

    # Vectors BA and BC
    ba_x = a.x - b.x
    ba_y = a.y - b.y

    bc_x = c.x - b.x
    bc_y = c.y - b.y

    # Dot product
    dot_product = ba_x * bc_x + ba_y * bc_y

    # Magnitudes
    magnitude_ba = math.sqrt(ba_x ** 2 + ba_y ** 2)
    magnitude_bc = math.sqrt(bc_x ** 2 + bc_y ** 2)

    # Avoid division by zero
    if magnitude_ba == 0 or magnitude_bc == 0:
        return 0.0

    # Cosine of the angle
    cosine = dot_product / (magnitude_ba * magnitude_bc)

    # Clamp because of floating-point precision
    cosine = max(-1.0, min(1.0, cosine))

    # Convert radians to degrees
    angle = math.degrees(math.acos(cosine))

    return angle


def calculate_trunk_angle(left_shoulder, right_shoulder,
                          left_hip, right_hip):
    """
    Calculate trunk inclination relative to the vertical axis.

    Returns:
        0°   -> perfectly upright
        Higher value -> trunk more inclined forward
    """

    # Shoulder center
    shoulder_x = (left_shoulder.x + right_shoulder.x) / 2
    shoulder_y = (left_shoulder.y + right_shoulder.y) / 2

    # Hip center
    hip_x = (left_hip.x + right_hip.x) / 2
    hip_y = (left_hip.y + right_hip.y) / 2

    # Trunk vector (hips -> shoulders)
    dx = shoulder_x - hip_x
    dy = shoulder_y - hip_y

    # Angle relative to vertical
    angle = math.degrees(math.atan2(abs(dx), abs(dy)))

    return angle