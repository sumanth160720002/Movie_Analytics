{{ config(
    materialized='view'
) }}

SELECT
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
    UPDATED_AT
FROM {{ source('bronze', 'RAW_BOXOFFICE') }}