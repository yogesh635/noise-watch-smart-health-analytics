# Power BI connection to MySQL
1. Start MySQL Server and the FastAPI backend.
2. In Power BI Desktop, choose **Get Data → MySQL database**.
3. Server: `localhost:3306`; Database: `noisewatch`.
4. Select `health_records`, choose Import, and sign in with the MySQL user.
5. If prompted, install Oracle MySQL Connector/NET: https://dev.mysql.com/downloads/connector/net/
6. Create visuals using `record_type`, `start_time`, `value`, and `source`.
7. Refresh after new uploads. Step records from different sources may overlap; do not blindly sum them.
