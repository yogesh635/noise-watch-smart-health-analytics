# Noise Watch Collector — VS Code Starter (Windows)

Pipeline: Noise NSW-419 → NoiseFit → Health Connect → Android app → FastAPI → MySQL → Power BI.

**Important:** This is a starter project, not a verified production app. NoiseFit must actually sync the watch data into Health Connect. If it does not, this app cannot read the watch data from Health Connect. This version reads Steps and Heart Rate records from the last 24 hours after you grant permissions and uploads them when you tap the button. It does not upload continuously in the background.

## 1. Install tools
- VS Code: https://code.visualstudio.com/Download
- Python 3.11: https://www.python.org/downloads/
- MySQL Community Server: https://dev.mysql.com/downloads/installer/
- MySQL Workbench (optional GUI): https://dev.mysql.com/downloads/workbench/
- JDK 17: https://adoptium.net/temurin/releases/?version=17
- Android SDK command-line tools: https://developer.android.com/studio#command-line-tools-only
- Health Connect setup: https://developer.android.com/health-and-fitness/health-connect/get-started

Android Studio UI is not required for editing, but Android SDK/build tools and Gradle are still required to compile an Android app. On a phone with Android 14+, Health Connect is usually built in; on Android 13 and lower, install the Health Connect app from Play Store if supported.

## 2. Create MySQL database
Install MySQL Community Server (MySQL Installer) and remember the root password. Open MySQL Workbench, connect to your local server, then run:
```sql
CREATE DATABASE noisewatch CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'noisewatch_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_PASSWORD';
GRANT ALL PRIVILEGES ON noisewatch.* TO 'noisewatch_user'@'localhost';
FLUSH PRIVILEGES;
```
Use the same password in `backend/.env`. If you use a different MySQL user/host, update the SQL and connection URL accordingly.

## 3. Run Python API
Open `backend` folder in VS Code. PowerShell terminal:
```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
```
Edit `.env` and replace the database password. Start server:
```powershell
uvicorn app:app --host 0.0.0.0 --port 8000 --reload
```
Check `http://127.0.0.1:8000/health` and `http://127.0.0.1:8000/docs`.

### Test API before connecting phone
Open a second PowerShell terminal:
```powershell
$body = '{"device_id":"test-phone","records":[{"record_type":"steps","value":1234,"unit":"count","start_time":"2026-10-11T07:00:00Z","end_time":"2026-10-11T08:00:00Z","source":"manual-test"}]}'
Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8000/api/health-records -ContentType 'application/json' -Body $body
```
Then check MySQL in Workbench:
```sql
SELECT * FROM health_records ORDER BY id DESC;
```
This only tests API→database, not the watch.

## 4. Connect phone to laptop
1. Laptop and Android phone must be on the same trusted Wi-Fi.
2. On phone: Settings → About phone → tap Build number 7 times (menu names vary) → Developer options → USB debugging ON.
3. Connect phone using a USB data cable; unlock it and accept “Allow USB debugging”.
4. Install Android SDK Platform Tools and make sure `adb` is on PATH. Run `adb devices`; your phone should show as `device`.
5. On laptop PowerShell run `ipconfig` and note the Wi-Fi adapter IPv4, e.g. `192.168.1.10`.
6. Edit `android-app/app/src/main/java/com/example/noisewatchcollector/MainActivity.kt`: set `API_BASE_URL` to `http://YOUR_LAPTOP_IPV4:8000`. Do not use localhost/127.0.0.1 on the phone.
7. If needed, allow port 8000 through Windows Firewall for Private networks only. Do not expose this development server to the public internet.

## 5. Build and install Android app
This project contains Gradle build files but not the Gradle wrapper JAR/script. Install Gradle 8.9, open terminal in `android-app`, then run:
```powershell
gradle wrapper --gradle-version 8.9
.\gradlew.bat assembleDebug
```
APK should be at `app\build\outputs\apk\debug\app-debug.apk`. Install it with:
```powershell
adb install -r app\build\outputs\apk\debug\app-debug.apk
```
You can also open the `android-app` folder in Android Studio once to generate wrapper/build setup if easier; then continue editing in VS Code.

## 6. Read watch data and upload
1. Pair watch with NoiseFit and sync it.
2. Open phone Settings and search `Health Connect` → Data and access. Confirm Steps and/or Heart Rate data exists. NoiseFit support varies by version/region; if the data is not present, check NoiseFit settings for Health Connect sharing or this path will have no watch data.
3. Open Noise Watch Collector on phone.
4. Tap **Request Health Permissions** and allow Steps and Heart Rate.
5. Tap **Read & Upload** while laptop API is running and both devices are on the same Wi-Fi.
6. Check API at `http://127.0.0.1:8000/api/health-records` on laptop or query database:
```sql
SELECT record_type, COUNT(*), MAX(start_time) FROM health_records GROUP BY record_type;
```

## 7. Power BI
Power BI Desktop → Get Data → MySQL database. Server `localhost:3306`, database `noisewatch`, choose `health_records`, enter the MySQL credentials, and select Import. Install Oracle MySQL Connector/NET if Power BI asks for a MySQL connector. Refresh after new uploads. Use `record_type` to separate steps from heart rate. Be careful not to sum overlapping step records from multiple sources.

## Troubleshooting
- `adb` not recognized: install platform-tools and add its folder to PATH; reopen terminal.
- No phone in `adb devices`: unlock phone, accept prompt, try data cable/USB port.
- Phone cannot reach API: use laptop IPv4, same Wi-Fi, server must use `--host 0.0.0.0`, check firewall.
- No health records: confirm records exist in Health Connect and app permissions are granted.
- Build fails: verify `java -version`, SDK installation, Gradle version, internet access.

Health data is sensitive. Use only your own/authorized data, keep the API on a trusted private network, and add authentication + HTTPS before any production or remote deployment.
