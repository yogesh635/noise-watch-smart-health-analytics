import os
from datetime import datetime
from typing import List, Optional
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL missing. Copy .env.example to .env and configure it.")
engine = create_engine(DATABASE_URL, pool_pre_ping=True)
app = FastAPI(title="Noise Watch Health API", version="1.0.0")

with engine.begin() as conn:
    conn.execute(text("""CREATE TABLE IF NOT EXISTS health_records (
        id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        device_id VARCHAR(200) NOT NULL,
        record_type VARCHAR(30) NOT NULL,
        value DOUBLE NOT NULL,
        unit VARCHAR(50) NOT NULL,
        start_time DATETIME(6) NOT NULL,
        end_time DATETIME(6) NOT NULL,
        source VARCHAR(255) NULL,
        received_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
        INDEX idx_health_records_type_time (record_type, start_time)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"""))

class HealthRecord(BaseModel):
    record_type: str = Field(pattern="^(steps|heart_rate)$")
    value: float
    unit: str
    start_time: datetime
    end_time: datetime
    source: Optional[str] = None
class UploadPayload(BaseModel):
    device_id: str = Field(min_length=1, max_length=200)
    records: List[HealthRecord] = Field(max_length=5000)

@app.get("/health")
def health():
    try:
        with engine.connect() as conn: conn.execute(text("SELECT 1"))
        return {"status": "ok", "database": "connected"}
    except SQLAlchemyError as exc:
        raise HTTPException(status_code=503, detail="Database connection failed") from exc

@app.post("/api/health-records")
def upload_records(payload: UploadPayload):
    if not payload.records: return {"inserted": 0, "message": "No records supplied"}
    rows = [{"device_id": payload.device_id, "record_type": r.record_type, "value": r.value, "unit": r.unit, "start_time": r.start_time, "end_time": r.end_time, "source": r.source} for r in payload.records]
    try:
        with engine.begin() as conn:
            conn.execute(text("""INSERT INTO health_records (device_id, record_type, value, unit, start_time, end_time, source) VALUES (:device_id, :record_type, :value, :unit, :start_time, :end_time, :source)"""), rows)
        return {"inserted": len(rows), "device_id": payload.device_id}
    except SQLAlchemyError as exc:
        raise HTTPException(status_code=500, detail="Could not insert records into database") from exc

@app.get("/api/health-records")
def list_records(limit: int = 100):
    limit = max(1, min(limit, 1000))
    with engine.connect() as conn:
        rows = conn.execute(text("""SELECT id, device_id, record_type, value, unit, start_time, end_time, source, received_at FROM health_records ORDER BY start_time DESC LIMIT :limit"""), {"limit": limit}).mappings().all()
    return [dict(row) for row in rows]
