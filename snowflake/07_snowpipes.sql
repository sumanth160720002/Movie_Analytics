USE DATABASE MOVIE_ANALYTICS;
USE SCHEMA BRONZE;


-- =========================================================
-- SNOWPIPE: STUDIOS
-- =========================================================

CREATE OR REPLACE PIPE PIPE_RAW_STUDIOS
    AUTO_INGEST = FALSE
AS
COPY INTO RAW_STUDIOS
(
    STUDIO_ID,
    STUDIO_NAME,
    COUNTRY,
    HQ_CITY,
    HQ_STATE,
    SIZE_BAND,
    STATUS,
    FOUNDED_DATE,
    UPDATED_AT,
    LOAD_TS,
    FILE_NAME,
    ROW_NUMBER
)
FROM
(
    SELECT
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        METADATA$START_SCAN_TIME,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER
    FROM @S3_MOVIE_STAGE/studios/
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';


-- =========================================================
-- SNOWPIPE: MOVIES
-- =========================================================

CREATE OR REPLACE PIPE PIPE_RAW_MOVIES
    AUTO_INGEST = FALSE
AS
COPY INTO RAW_MOVIES
(
    MOVIE_ID,
    TITLE,
    STUDIO_ID,
    RELEASE_DATE,
    GENRE,
    LANGUAGE,
    RUNTIME_MIN,
    CERTIFICATION,
    RELEASE_TYPE,
    BUDGET_CR,
    IS_FRANCHISE,
    STATUS,
    UPDATED_AT,
    LOAD_TS,
    FILE_NAME,
    ROW_NUMBER
)
FROM
(
    SELECT
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        METADATA$START_SCAN_TIME,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER
    FROM @S3_MOVIE_STAGE/movies/
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';


-- =========================================================
-- SNOWPIPE: LOCATIONS
-- =========================================================

CREATE OR REPLACE PIPE PIPE_RAW_LOCATIONS
    AUTO_INGEST = FALSE
AS
COPY INTO RAW_LOCATIONS
(
    LOCATION_ID,
    CITY,
    STATE,
    COUNTRY,
    REGION,
    CURRENCY,
    TIMEZONE,
    STATUS,
    UPDATED_AT,
    LOAD_TS,
    FILE_NAME,
    ROW_NUMBER
)
FROM
(
    SELECT
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        METADATA$START_SCAN_TIME,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER
    FROM @S3_MOVIE_STAGE/locations/
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';


-- =========================================================
-- SNOWPIPE: BOX OFFICE
-- =========================================================

CREATE OR REPLACE PIPE PIPE_RAW_BOXOFFICE
    AUTO_INGEST = FALSE
AS
COPY INTO RAW_BOXOFFICE
(
    BOXOFFICE_ID,
    SHOW_DATE,
    MOVIE_ID,
    LOCATION_ID,
    CHANNEL,
    PLATFORM_NAME,
    SCREENS,
    TICKETS_SOLD,
    AVG_TICKET_PRICE,
    GROSS_LAKHS,
    OCCUPANCY_RATE,
    UPDATED_AT,
    LOAD_TS,
    FILE_NAME,
    ROW_NUMBER
)
FROM
(
    SELECT
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        METADATA$START_SCAN_TIME,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER
    FROM @S3_MOVIE_STAGE/boxoffice/
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';