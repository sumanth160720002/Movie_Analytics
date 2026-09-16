# 🎬 Movie Analytics Platform — Box Office & OTT

## 📌 Project Overview

The Movie Analytics Platform is a cloud-based data engineering project designed to ingest, transform, validate, and analyze movie, studio, location, and box-office data.

The platform uses **AWS S3, Snowflake, Snowpipe, dbt, and Streamlit** to build a complete data pipeline following the **Medallion Architecture (Bronze → Silver → Gold)**.

The final solution provides business-ready analytics for movie performance, studio performance, regional performance, revenue, ticket sales, occupancy, and channel/platform analysis.

---

## 🏗️ Architecture

```text
                    AWS S3
                      │
                      ▼
              Snowflake External Stage
                      │
                      ▼
                  Snowpipe
                      │
                      ▼
              🥉 BRONZE LAYER
       Raw Studios / Movies / Locations
              / Box Office Data
                      │
                      ▼
                    dbt
                      │
                      ▼
              🥈 SILVER LAYER
       Clean / Standardize / Validate
            Deduplicate / SCD Type 2
                      │
                      ▼
               🥇 GOLD LAYER
          Star Schema / Business Data
                      │
                      ▼
              SEMANTIC VIEWS
                      │
                      ▼
                 Streamlit
                 Dashboard

🛠️ Technologies Used
Technology	Purpose
AWS S3	Cloud landing zone for source CSV files
Snowflake	Cloud data warehouse and data platform
Snowpipe	Automated data ingestion into Snowflake
dbt	Data transformation, testing, and SCD Type 2
Python	Streamlit application
Streamlit	Interactive analytics dashboard
Git / GitHub	Version control and project repository
VS Code	Development environment
📂 Source Data

The project uses four CSV datasets:

movie_studios.csv — Studio information
movie_titles.csv — Movie information
movie_locations.csv — Theatre/location information
movie_boxoffice.csv — Daily box-office performance
Dataset Size
Dataset	Records
Studios	15
Movies	20
Locations	15
Box Office	25
Total	75
☁️ AWS S3 Landing Structure
landing/movie_analytics/
│
├── studios/
│   └── movie_studios.csv
│
├── movies/
│   └── movie_titles.csv
│
├── locations/
│   └── movie_locations.csv
│
├── boxoffice/
│   └── movie_boxoffice.csv
│
├── quarantine/
│
└── archive/

AWS S3 acts as the landing/source zone for incoming files.

❄️ Snowflake Implementation
Database
MOVIE_ANALYTICS
Schemas
BRONZE
SILVER
GOLD
SEM
OPS
Warehouse
MOVIE_ANALYTICS_WH

Configuration:

Warehouse size: X-SMALL
Auto Suspend: 60 seconds
Auto Resume: TRUE
🥉 Bronze Layer

The Bronze layer stores raw data in Snowflake.

Tables:

BRONZE.RAW_STUDIOS
BRONZE.RAW_MOVIES
BRONZE.RAW_LOCATIONS
BRONZE.RAW_BOXOFFICE

Data is loaded from AWS S3 through an external stage and Snowpipe.

Ingestion metadata is also captured:

LOAD_TS
FILE_NAME
ROW_NUMBER
Snowpipe

One Snowpipe is created for each entity:

PIPE_RAW_STUDIOS
PIPE_RAW_MOVIES
PIPE_RAW_LOCATIONS
PIPE_RAW_BOXOFFICE

The pipelines use ON_ERROR = CONTINUE for controlled error handling.

🥈 Silver Layer

dbt is used to transform the Bronze data into clean and standardized datasets.

The Silver layer performs:

Data type standardization
Cleaning
Validation
Deduplication
Business transformations
SCD Type 2 preparation

Silver models:

SILVER_MOVIES
SILVER_STUDIOS
SILVER_LOCATIONS
SILVER_BOXOFFICE
🔄 SCD Type 2

Slowly Changing Dimension Type 2 is implemented for movie and studio attributes.

Snapshots:

movie_snapshot
studio_snapshot

Tracked movie attributes include:

Title
Genre
Language
Runtime
Certification
Release Type
Budget
Franchise Flag

Tracked studio attributes include:

Studio Name
Country
HQ City
HQ State
Size Band
Status

SCD Type 2 maintains historical versions of changed records while keeping the current record available for analytics.

🥇 Gold Layer

The Gold layer contains business-ready tables following a star-schema design.

Dimensions
GOLD.DIM_DATE
GOLD.DIM_LOCATION
GOLD.DIM_MOVIE
GOLD.DIM_STUDIO
Fact
GOLD.FACT_BOXOFFICE
Fact Grain

FACT_BOXOFFICE contains one record representing box-office performance for a movie at a location on a show date, with the available channel/platform metrics.

Key metrics include:

Gross
Tickets Sold
Average Ticket Price
Screens
Occupancy Rate
📊 Semantic Layer

Business-facing views are created in the SEM schema.

SEM.V_BOXOFFICE_ANALYTICS
SEM.V_MOVIE_PERFORMANCE
SEM.V_STUDIO_PERFORMANCE

The semantic layer provides simplified datasets for analytics applications without exposing the underlying raw and transformation layers.

📈 Streamlit Dashboard

The Streamlit application is located in:

streamlit/app.py

The dashboard contains four pages:

1. Overview

Displays:

Total Gross
Tickets Sold
Average Ticket Price
Average Occupancy
Total Screens
Daily Gross Trend
Top Movies
Regional Performance
2. Movie Detail

Provides movie-level performance analysis.

3. Studio Portfolio

Provides studio-level performance analysis.

4. Explorer

Allows users to explore the underlying business metrics through filters.

The Streamlit application queries the SEM views rather than directly accessing raw tables.

✅ Data Quality

dbt tests are implemented for the Gold layer.

Tests include:

Primary key not-null validation
Key uniqueness
Fact-to-dimension relationships
Valid box-office metrics
Valid show dates

Current validation:

Generic dbt tests: 15 PASS
Custom data-quality tests: 2 PASS
Warnings: 0
Errors: 0
🔐 Security

Role-based access control is implemented in Snowflake.

Roles:

ROLE_ADMIN
ROLE_INGEST
ROLE_ETL
ROLE_ANALYST
ROLE_APP_STREAMLIT

The application and analyst roles access business-facing semantic views rather than raw ingestion tables.

This follows the principle of least privilege.

📝 Operations & Monitoring

The OPS schema contains:

OPS.LOAD_AUDIT
OPS.REJECTS
LOAD_AUDIT

Tracks:

Entity
File name
Load start/end time
Row count
Status
Error message
Batch ID
REJECTS

Stores rejected records and rejection information for troubleshooting and reconciliation.

⚠️ Data Engineering Considerations

The project considers several real-world data engineering scenarios:

Late-arriving data
Incorrect partner reporting
Schema drift
Data quality failures
Multi-country currencies
SCD Type 2 table growth
Access control
Pipeline monitoring

Potential mitigation strategies include:

Reconciliation and backfills
Data validation
Quarantine of bad files
Versioned data contracts
Currency standardization
Clustering and retention strategies
Role-based access control
Audit logging
📁 Project Structure
movie-analytics-platform/
│
├── README.md
│
├── snowflake/
│   ├── 01_database_setup.sql
│   ├── 02_schemas.sql
│   ├── 03_warehouse.sql
│   ├── 04_external_stage.sql
│   ├── 05_file_formats.sql
│   ├── 06_raw_tables.sql
│   ├── 07_snowpipes.sql
│   ├── 08_ops_audit.sql
│   ├── 09_security_roles.sql
│   └── 10_cleanup.sql
│
├── dbt/
│   └── movie_analytics/
│       ├── models/
│       │   ├── staging/
│       │   ├── silver/
│       │   ├── gold/
│       │   └── semantic/
│       ├── snapshots/
│       ├── tests/
│       ├── macros/
│       ├── dbt_project.yml
│       └── README.md
│
└── streamlit/
    └── app.py
🚀 Project Workflow
1. Source CSV files
       ↓
2. AWS S3 Landing
       ↓
3. Snowflake External Stage
       ↓
4. Snowpipe Ingestion
       ↓
5. Bronze Raw Tables
       ↓
6. dbt Staging
       ↓
7. Silver Transformation
       ↓
8. SCD Type 2 Snapshots
       ↓
9. Gold Star Schema
       ↓
10. Semantic Views
       ↓
11. Streamlit Dashboard
🎯 Business Use Cases

The platform can be used to analyze:

Movie revenue performance
Ticket sales
Average ticket price
Occupancy
Screen utilization
Movie performance by region
Genre performance
Studio portfolio performance
Channel/platform performance
Historical movie and studio attribute changes
📌 Key Project Outcomes
Implemented a cloud-based movie analytics pipeline
Built a Medallion Architecture using Snowflake and dbt
Implemented SCD Type 2 using dbt snapshots
Created a dimensional star schema
Added automated data-quality testing
Implemented Snowflake RBAC
Built semantic views for analytics consumption
Developed an interactive Streamlit dashboard
Added operational audit and rejected-record handling
Version-controlled the complete project using Git and GitHub
👨‍💻 Project

Movie Analytics Platform — Box Office + OTT

Built using:

AWS S3 | Snowflake | Snowpipe | dbt | Python | Streamlit | GitHub


### After pasting

Save it with:

**Ctrl + S**

Then run:

```powershell
git add README.md