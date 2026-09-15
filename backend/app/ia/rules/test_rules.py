"""
Test squat biomechanical rules
"""

from app.ia.rules.squat_rules import SquatRules


# =====================================================
# Initialize rules
# =====================================================

rules = SquatRules()


# =====================================================
# Test 1 : Good squat
# =====================================================

good_squat = {
    "left_knee": 100,
    "right_knee": 105,
    "left_hip": 90,
    "right_hip": 92,
    "left_elbow": 120,
    "right_elbow": 118,
}


print("\n===== GOOD SQUAT =====")

errors = rules.analyze(good_squat)

print("Errors:", errors)



# =====================================================
# Test 2 : Squat too shallow
# =====================================================

shallow_squat = {
    "left_knee": 170,
    "right_knee": 165,
    "left_hip": 100,
    "right_hip": 98,
    "left_elbow": 120,
    "right_elbow": 120,
}


print("\n===== SHALLOW SQUAT =====")

errors = rules.analyze(shallow_squat)

print("Errors:", errors)



# =====================================================
# Test 3 : Bad posture
# =====================================================

bad_squat = {
    "left_knee": 60,
    "right_knee": 65,
    "left_hip": 40,
    "right_hip": 45,
    "left_elbow": 110,
    "right_elbow": 115,
}


print("\n===== BAD SQUAT =====")

errors = rules.analyze(bad_squat)

print("Errors:", errors)