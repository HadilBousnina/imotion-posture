from pydantic import BaseModel


class DashboardStatsRead(BaseModel):
    total_adherents: int
    sessions_today: int
    average_score: float
    progression: float