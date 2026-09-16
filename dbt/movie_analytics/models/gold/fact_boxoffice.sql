{{ config(
    materialized='table'
) }}

SELECT
    b.BOXOFFICE_ID,
    b.SHOW_DATE,
    b.MOVIE_ID,
    b.LOCATION_ID,
    b.CHANNEL,
    b.PLATFORM_NAME,
    b.SCREENS,
    b.TICKETS_SOLD,
    b.AVG_TICKET_PRICE,
    b.GROSS_LAKHS,
    b.OCCUPANCY_RATE

FROM {{ ref('silver_boxoffice') }} b

WHERE b.BOXOFFICE_ID IS NOT NULL