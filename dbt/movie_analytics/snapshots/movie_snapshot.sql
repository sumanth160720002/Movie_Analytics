{% snapshot movie_snapshot %}

{{
    config(
        target_schema='GOLD',
        unique_key='MOVIE_ID',
        strategy='check',
        check_cols=[
            'TITLE',
            'GENRE',
            'LANGUAGE',
            'RUNTIME_MIN',
            'CERTIFICATION',
            'RELEASE_TYPE',
            'BUDGET_CR',
            'IS_FRANCHISE'
        ]
    )
}}

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
FROM {{ ref('silver_movies') }}

{% endsnapshot %}