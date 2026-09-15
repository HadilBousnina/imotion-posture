from app.ia.classifier.posture_classifier import PostureClassifier


classifier = PostureClassifier()


sample = {
    "left_knee": 95.99,
    "right_knee": 74.10,
    "left_hip": 120,
    "right_hip": 118,
    "left_elbow": 91,
    "right_elbow": 93
}


result = classifier.predict(sample)


print("Prediction :", result)


