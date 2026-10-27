CREATE DATABASE IF NOT EXISTS noisewatch CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'noisewatch_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_PASSWORD';
GRANT ALL PRIVILEGES ON noisewatch.* TO 'noisewatch_user'@'localhost';
FLUSH PRIVILEGES;
