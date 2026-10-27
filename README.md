# Noise Watch Smart Health Analytics

### Real-Time Health Data Collection and Power BI Dashboard

## Project Overview

Noise Watch Smart Health Analytics is a health-data analytics project designed to collect supported health records from Android Health Connect, send the records to a Python API, store them in MySQL, and visualize health metrics through Microsoft Power BI.

The project combines Android development, API integration, database management, and business intelligence.

## Project Objectives

- Collect supported health metrics through Android Health Connect.
- Transfer health records to a Python FastAPI backend.
- Store health records in a MySQL database.
- Analyze steps, heart rate, calories, distance, and other available metrics.
- Build an interactive Power BI dashboard for health-data monitoring.

## Technology Stack

- **Android:** Kotlin and Health Connect
- **Backend:** Python and FastAPI
- **Database:** MySQL
- **Data Visualization:** Microsoft Power BI
- **Analytics:** SQL, DAX, and Power BI

## Data Flow

Noise Smartwatch → NoiseFit → Health Connect → Android Collector App → FastAPI → MySQL → Power BI

Data availability depends on the smartwatch, connected applications, Health Connect permissions, and supported record types.

## Key Features

- Android health-data collection
- REST API integration
- MySQL health-record storage
- Power BI health analytics dashboard
- Daily health metrics visualization
- Demo data for dashboard testing

## Dashboard Preview

Dashboard screenshots will be added to the `power-bi` folder.

## Project Structure

- `android-app/` — Android Collector App source code
- `backend/` — Python API
- `database/` — SQL scripts
- `power-bi/` — Power BI report and screenshots
- `docs/` — Project report and diagrams
- `assets/` — Project images and visual assets

## Setup

1. Clone or download this repository.
2. Configure the Android application and Health Connect permissions.
3. Install the Python packages listed in `backend/requirements.txt`.
4. Configure MySQL and create the required database and tables.
5. Configure the backend environment variables.
6. Start the FastAPI server.
7. Connect Power BI to the database and configure the report.

Detailed setup instructions will be maintained in the project documentation.

## Data Disclaimer

Some dashboard records may be synthetic demo data used for testing and visualization. Demo records should not be interpreted as actual smartwatch measurements. Real-data availability depends on the configured data sources and successful synchronization.

## Future Improvements

- Automatic background data synchronization
- Improved data validation and error handling
- Additional health metrics and historical analysis
- Enhanced Power BI dashboard and trend analysis

## Author

Yogesh Singh
