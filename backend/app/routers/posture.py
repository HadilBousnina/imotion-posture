import shutil
import tempfile
from pathlib import Path

from fastapi import (
    APIRouter,
    File,
    HTTPException,
    UploadFile,
)

from app.services.posture_service import PostureService


router = APIRouter(
    prefix="/posture",
    tags=["Posture IA"],
)

# Allowed video formats
ALLOWED_VIDEO_EXTENSIONS = (
    ".mp4",
    ".avi",
    ".mov",
)

# Service instance
posture_service = PostureService()


@router.post("/analyze-video")
async def analyze_video(
    video: UploadFile = File(...)
):
    """
    Analyze a squat video and return the posture analysis.
    """

    # =====================================================
    # Validate uploaded file
    # =====================================================

    if (
        not video.filename
        or not video.filename.lower().endswith(ALLOWED_VIDEO_EXTENSIONS)
    ):
        raise HTTPException(
            status_code=400,
            detail="Unsupported video format.",
        )

    temp_path = None

    try:

        # =====================================================
        # Save uploaded video temporarily
        # =====================================================

        suffix = Path(video.filename).suffix

        with tempfile.NamedTemporaryFile(
            delete=False,
            suffix=suffix,
        ) as temp_file:

            shutil.copyfileobj(
                video.file,
                temp_file,
            )

            temp_path = temp_file.name

        # =====================================================
        # Analyze video
        # =====================================================

        result = posture_service.analyze_video(
            temp_path
        )

        return result

    except HTTPException:
        raise

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e),
        )

    finally:

        # =====================================================
        # Delete temporary file
        # =====================================================

        if temp_path is not None:
            Path(temp_path).unlink(
                missing_ok=True
            )