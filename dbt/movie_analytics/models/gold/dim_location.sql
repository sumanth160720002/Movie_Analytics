{{ config(
    materialized='table'
) }}

SELECT
    LOCATION_ID,
    CITY,
    STATE,
    COUNTRY,
    REGION,
    CURRENCY,
    TIMEZONE,
    STATUS

FROM {{ ref('silver_locations') }}

WHERE LOCATION_ID IS NOT NULL