"""
Train a posture classification model from the generated dataset.

Input:
    datasets/posture_dataset.csv

Output:
    app/ia/models/posture_classifier.pkl
"""

from pathlib import Path

import joblib
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split


# ==========================================================
# Paths
# ==========================================================

BASE_DIR = Path(__file__).resolve().parents[3]

DATASET_PATH = BASE_DIR / "app" / "ia" / "datasets" / "posture_dataset.csv"

MODEL_DIR = BASE_DIR / "app" / "ia" / "models"
MODEL_DIR.mkdir(parents=True, exist_ok=True)

MODEL_PATH = MODEL_DIR / "posture_classifier.pkl"


# ==========================================================
# Main
# ==========================================================

def main():
    print("=" * 50)
    print("Loading dataset...")
    print("=" * 50)

    # Load CSV
    df = pd.read_csv(DATASET_PATH)

    print(f"Dataset loaded successfully!")
    print(f"Shape : {df.shape}")
    print()

    # Display first rows
    print(df.head())
    print()

    # ======================================================
    # Features / Labels
    # ======================================================

    X = df.drop(columns=["label"])
    y = df["label"]

    print(f"Features : {list(X.columns)}")
    print(f"Classes  : {sorted(y.unique())}")
    print()

    # ======================================================
    # Train / Test split
    # ======================================================

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.20,
        random_state=42,
        stratify=y,
    )

    print(f"Training samples : {len(X_train)}")
    print(f"Testing samples  : {len(X_test)}")
    print()

    # ======================================================
    # Model
    # ======================================================

    print("Training Random Forest...")

    model = RandomForestClassifier(
        n_estimators=100,
        random_state=42,
    )

    model.fit(X_train, y_train)

    print("Training completed!")
    print()

    # ======================================================
    # Evaluation
    # ======================================================

    print("=" * 50)
    print("Evaluation")
    print("=" * 50)

    predictions = model.predict(X_test)

    accuracy = accuracy_score(y_test, predictions)

    print(f"Accuracy : {accuracy:.2%}")
    print()

    print(classification_report(y_test, predictions))

    # ======================================================
    # Save model
    # ======================================================

    joblib.dump(model, MODEL_PATH)

    print("=" * 50)
    print("Model saved successfully!")
    print(MODEL_PATH)
    print("=" * 50)


if __name__ == "__main__":
    main()