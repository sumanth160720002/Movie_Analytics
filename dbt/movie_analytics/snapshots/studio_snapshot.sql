{% snapshot studio_snapshot %}

{{
    config(
        target_schema='GOLD',
        unique_key='STUDIO_ID',
        strategy='check',
        check_cols=[
            'STUDIO_NAME',
            'COUNTRY',
            'HQ_CITY',
            'HQ_STATE',
            'SIZE_BAND',
            'STATUS'
        ]
    )
}}

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
FROM {{ ref('silver_studios') }}

{% endsnapshot %}