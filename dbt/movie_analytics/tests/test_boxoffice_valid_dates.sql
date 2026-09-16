SELECT *
FROM {{ ref('fact_boxoffice') }}
WHERE SHOW_DATE IS NULL