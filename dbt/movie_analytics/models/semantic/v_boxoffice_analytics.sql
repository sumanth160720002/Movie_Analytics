{{ config(
    materialized='view',
    schema='SEM'
) }}

SELECT
    f.BOXOFFICE_ID,
    f.SHOW_DATE,

    -- Movie
    m.MOVIE_ID,
    m.TITLE,
    m.GENRE,
    m.LANGUAGE,
    m.CERTIFICATION,
    m.RELEASE_TYPE,
    m.IS_FRANCHISE,

    -- Studio
    s.STUDIO_ID,
    s.STUDIO_NAME,

    -- Location
    l.LOCATION_ID,
    l.CITY,
    l.STATE,
    l.COUNTRY,
    l.REGION,

    -- Box Office
    f.CHANNEL,
    f.PLATFORM_NAME,
    f.SCREENS,
    f.TICKETS_SOLD,
    f.AVG_TICKET_PRICE,
    f.GROSS_LAKHS,
    f.OCCUPANCY_RATE

FROM {{ ref('fact_boxoffice') }} f

LEFT JOIN {{ ref('dim_movie') }} m
    ON f.MOVIE_ID = m.MOVIE_ID
    AND m.IS_CURRENT = TRUE

LEFT JOIN {{ ref('dim_studio') }} s
    ON m.STUDIO_ID = s.STUDIO_ID
    AND s.IS_CURRENT = TRUE

LEFT JOIN {{ ref('dim_location') }} l
    ON f.LOCATION_ID = l.LOCATION_ID