{{ config(
    materialized='view'
) }}

SELECT
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
    UPDATED_AT
FROM {{ source('bronze', 'RAW_MOVIES') }}