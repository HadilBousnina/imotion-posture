from app.ia.analyzer.posture_analyzer import PostureAnalyzer


def main():

    analyzer = PostureAnalyzer()

    fake_features = {

        "left_knee": 120,
        "right_knee": 122,

        "left_hip": 110,
        "right_hip": 115,

        "trunk_angle": 30
    }

    result = analyzer.analyze(
        fake_features
    )

    print(result)


if __name__ == "__main__":
    main()

