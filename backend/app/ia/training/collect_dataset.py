from pathlib import Path
import csv
import cv2

from app.ia.pose.detector import PoseDetector
from app.ia.features.extractor import FeatureExtractor


CSV_COLUMNS = [
    "left_knee",
    "right_knee",
    "left_hip",
    "right_hip",
    "trunk_angle",
    "label",
]


class DatasetCollector:
    """
    Collect a machine learning dataset from labeled squat videos.
    """

    def __init__(
        self,
        videos_dir,
        output_csv,
        max_samples_per_video=250,
    ):
        self.videos_dir = Path(videos_dir)
        self.output_csv = Path(output_csv)
        self.max_samples_per_video = max_samples_per_video

        self.detector = PoseDetector()
        self.extractor = FeatureExtractor()

    def collect(self):
        """
        Main dataset collection pipeline.
        """

        self.output_csv.parent.mkdir(parents=True, exist_ok=True)

        with open(self.output_csv, "w", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(CSV_COLUMNS)

            for label_dir in self.videos_dir.iterdir():

                if not label_dir.is_dir():
                    continue

                label = label_dir.name

                print(f"\n========== {label.upper()} ==========\n")

                for video_path in label_dir.glob("*.mp4"):
                    self._process_video(video_path, label, writer)

        print("\nDataset collection completed!")

    def _process_video(self, video_path, label, writer):
        """
        Process a single video and extract posture features.
        """

        print(f"Processing: {video_path.name}")

        capture = cv2.VideoCapture(str(video_path))

        if not capture.isOpened():
            print(f"Unable to open {video_path}")
            return

        total_frames = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))

        sample_step = max(
            total_frames // self.max_samples_per_video,
            1,
        )

        frame_index = 0
        saved_samples = 0

        while True:

            success, frame = capture.read()

            if not success:
                break

            if frame_index % sample_step != 0:
                frame_index += 1
                continue

            results = self.detector.detect(frame)

            landmarks = self.detector.get_landmarks(results)

            if landmarks is None:
                frame_index += 1
                continue

            features = self.extractor.extract(landmarks)

            self._append_sample(features, label, writer)

            saved_samples += 1
            frame_index += 1

        capture.release()

        print(f"✔ {saved_samples} samples saved")

    def _append_sample(self, features, label, writer):
        """
        Append one feature sample to the CSV.
        """

        writer.writerow([
            round(features["left_knee"], 2),
            round(features["right_knee"], 2),
            round(features["left_hip"], 2),
            round(features["right_hip"], 2),
            round(features["trunk_angle"], 2),
            label,
        ])

    def close(self):
        """
        Release MediaPipe resources.
        """
        self.detector.close()


if __name__ == "__main__":

    collector = DatasetCollector(
        videos_dir="app/ia/datasets/videos",
        output_csv="app/ia/datasets/posture_dataset.csv",
    )

    try:
        collector.collect()
    finally:
        collector.close()