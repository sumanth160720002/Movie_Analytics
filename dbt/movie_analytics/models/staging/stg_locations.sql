{{ config(
    materialized='view'
) }}

SELECT
    LOCATION_ID,
    CITY,
    STATE,
    COUNTRY,
    REGION,
    CURRENCY,
    TIMEZONE,
    STATUS,
    UPDATED_AT
FROM {{ source('bronze', 'RAW_LOCATIONS') }}