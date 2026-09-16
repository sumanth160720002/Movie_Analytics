{{ config(
    materialized='view'
) }}

SELECT
    STUDIO_ID,
    STUDIO_NAME,
    COUNTRY,
    HQ_CITY,
    HQ_STATE,
    SIZE_BAND,
    STATUS,
    FOUNDED_DATE,
    UPDATED_AT
FROM {{ source('bronze', 'RAW_STUDIOS') }}