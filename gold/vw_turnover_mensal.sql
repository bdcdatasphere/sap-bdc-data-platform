SELECT
    ano_mes,
    admissao,
    desligamento,
    ROUND(
        desligamento * 100.0 /
        NULLIF(headcount_medio,0),
        2
    ) AS turnover_pct
FROM fact_turnover;