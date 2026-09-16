{{ config(
    materialized='table'
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

    MD5(
        CONCAT(
            COALESCE(TITLE, ''),
            '|', COALESCE(GENRE, ''),
            '|', COALESCE(LANGUAGE, ''),
            '|', COALESCE(RUNTIME_MIN::VARCHAR, ''),
            '|', COALESCE(CERTIFICATION, ''),
            '|', COALESCE(RELEASE_TYPE, ''),
            '|', COALESCE(BUDGET_CR::VARCHAR, ''),
            '|', COALESCE(IS_FRANCHISE::VARCHAR, '')
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

FROM {{ ref('movie_snapshot') }}