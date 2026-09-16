{{ config(
    materialized='table'
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

    MD5(
        CONCAT(
            COALESCE(STUDIO_NAME, ''),
            '|', COALESCE(COUNTRY, ''),
            '|', COALESCE(HQ_CITY, ''),
            '|', COALESCE(HQ_STATE, ''),
            '|', COALESCE(SIZE_BAND, ''),
            '|', COALESCE(STATUS, '')
        )
    ) AS HASH_DIFF,

    DBT_VALID_FROM AS EFF_START_TS,

    COALESCE(
        DBT_VALID_TO,
        '9999-12-31 23:59:59'::TIMESTAMP_NTZ
    ) AS EFF_END_TS,

    CASE
        WHEN DBT_VALID_TO IS NULL THEN TRUE
        ELSE FALSE
    END AS IS_CURRENT

FROM {{ ref('studio_snapshot') }}