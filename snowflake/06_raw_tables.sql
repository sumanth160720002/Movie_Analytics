USE DATABASE MOVIE_ANALYTICS;
USE SCHEMA BRONZE;


-- =========================================================
-- RAW STUDIOS
-- =========================================================

CREATE OR REPLACE TABLE RAW_STUDIOS (
    STUDIO_ID       VARCHAR(20),
    STUDIO_NAME     VARCHAR(200),
    COUNTRY         VARCHAR(100),
    HQ_CITY         VARCHAR(100),
    HQ_STATE        VARCHAR(100),
    SIZE_BAND       VARCHAR(50),
    STATUS          VARCHAR(50),
    FOUNDED_DATE    DATE,
    UPDATED_AT      TIMESTAMP_NTZ,

    LOAD_TS         TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FILE_NAME       VARCHAR(500),
    ROW_NUMBER      NUMBER
);


-- =========================================================
-- RAW MOVIES
-- =========================================================

CREATE OR REPLACE TABLE RAW_MOVIES (
    MOVIE_ID        VARCHAR(20),
    TITLE           VARCHAR(300),
    STUDIO_ID       VARCHAR(20),
    RELEASE_DATE    DATE,
    GENRE           VARCHAR(100),
    LANGUAGE        VARCHAR(100),
    RUNTIME_MIN     NUMBER,
    CERTIFICATION   VARCHAR(20),
    RELEASE_TYPE    VARCHAR(50),
    BUDGET_CR       NUMBER(18,2),
    IS_FRANCHISE    VARCHAR(5),
    STATUS          VARCHAR(50),
    UPDATED_AT      TIMESTAMP_NTZ,

    LOAD_TS         TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FILE_NAME       VARCHAR(500),
    ROW_NUMBER      NUMBER
);


-- =========================================================
-- RAW LOCATIONS
-- =========================================================

CREATE OR REPLACE TABLE RAW_LOCATIONS (
    LOCATION_ID     VARCHAR(20),
    CITY            VARCHAR(100),
    STATE           VARCHAR(100),
    COUNTRY         VARCHAR(100),
    REGION          VARCHAR(50),
    CURRENCY        VARCHAR(20),
    TIMEZONE        VARCHAR(100),
    STATUS          VARCHAR(50),
    UPDATED_AT      TIMESTAMP_NTZ,

    LOAD_TS         TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FILE_NAME       VARCHAR(500),
    ROW_NUMBER      NUMBER
);


-- =========================================================
-- RAW BOX OFFICE
-- =========================================================

CREATE OR REPLACE TABLE RAW_BOXOFFICE (
    BOXOFFICE_ID       VARCHAR(20),
    SHOW_DATE          DATE,
    MOVIE_ID           VARCHAR(20),
    LOCATION_ID        VARCHAR(20),
    CHANNEL            VARCHAR(50),
    PLATFORM_NAME      VARCHAR(100),
    SCREENS            NUMBER,
    TICKETS_SOLD       NUMBER,
    AVG_TICKET_PRICE   NUMBER(18,2),
    GROSS_LAKHS        NUMBER(18,2),
    OCCUPANCY_RATE     NUMBER(10,4),
    UPDATED_AT         TIMESTAMP_NTZ,

    LOAD_TS            TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FILE_NAME          VARCHAR(500),
    ROW_NUMBER         NUMBER
);