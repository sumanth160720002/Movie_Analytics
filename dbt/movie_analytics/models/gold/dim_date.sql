{{ config(
    materialized='table'
) }}

WITH date_range AS (

    SELECT
        MIN(SHOW_DATE) AS MIN_DATE,
        MAX(SHOW_DATE) AS MAX_DATE
    FROM {{ ref('silver_boxoffice') }}

),

dates AS (

    SELECT
        DATEADD(
            DAY,
            SEQ4(),
            MIN_DATE
        ) AS DATE_VALUE

    FROM date_range,
         TABLE(
             GENERATOR(
                 ROWCOUNT => 1000
             )
         )

    WHERE DATEADD(DAY, SEQ4(), MIN_DATE) <= MAX_DATE

)

SELECT
    DATE_VALUE AS DATE_KEY,
    DATE_VALUE,
    YEAR(DATE_VALUE) AS YEAR,
    QUARTER(DATE_VALUE) AS QUARTER,
    MONTH(DATE_VALUE) AS MONTH,
    MONTHNAME(DATE_VALUE) AS MONTH_NAME,
    WEEK(DATE_VALUE) AS WEEK,
    DAY(DATE_VALUE) AS DAY,
    DAYOFWEEK(DATE_VALUE) AS DAY_OF_WEEK,
    DAYNAME(DATE_VALUE) AS DAY_NAME

FROM dates