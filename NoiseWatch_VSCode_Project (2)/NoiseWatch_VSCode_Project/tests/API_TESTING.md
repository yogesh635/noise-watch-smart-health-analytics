# API test checklist
- Open `http://127.0.0.1:8000/health`; expect status ok and database connected.
- POST sample data using README command, then query `SELECT * FROM health_records ORDER BY id DESC;`.
- A manual sample tests API/database only. End-to-end test requires actual data visible in Health Connect.
