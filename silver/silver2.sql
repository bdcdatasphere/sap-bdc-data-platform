SELECT COUNT(*) FROM dim_funcionario;


SELECT COUNT(*) FROM fato_presenca_diaria;


SELECT
COUNT(*) AS headcount
FROM fato_headcount_mensal
WHERE ativo_sn='S';


SELECT
j.descricao_jornada,
COUNT(*) AS quantidade
FROM fato_headcount_mensal h
JOIN dim_funcionario f
ON h.id_funcionario=f.id_funcionario
JOIN dim_jornada j
ON f.jornada_id=j.id_jornada
GROUP BY j.descricao_jornada
ORDER BY quantidade DESC;
``

SELECT
departamento,
COUNT(*) AS quantidade
FROM dim_funcionario
GROUP BY departamento
ORDER BY quantidade DESC;


SELECT
COUNT(*) AS presentes
FROM fato_presenca_diaria
WHERE data_referencia='2026-09-30'
AND presente_sn='S';


SELECT
COUNT(*) AS ausentes
FROM fato_presenca_Diaria
WHERE data_referencia='2026-09-30'
AND presente_sn='N';


SELECT ROUND(100.0 *SUM(CASE WHEN presente_sn='N' THEN 1 ELSE 0 END)/COUNT(*),2) AS percentual_abseNteismo
FROM fato_presenca_diaria
WHERE data_referencia='2026-09-30';




SELECT
SUM(CASE WHEN falta_sn='S' THEN 1 ELSE 0 END) AS faltas,
SUM(CASE WHEN ferias_sn='S' THEN 1 ELSE 0 END) AS ferias,
SUM(CASE WHEN afastado_sn='S' THEN 1 ELSE 0 END) AS afastamentos
FROM fato_presenca_diaria
WHERE data_referencia='2026-09-30';
*


SELECT
f.departamento,
COUNT(*) AS presentes
FROM fato_presenca_diaria p
JOIN dim_funcionario f
ON p.id_funcionario=f.id_funcionario
WHERE p.data_referencia='2026-09-30'
AND p.presente_sn='S'
GROUP BY f.departamento
ORDER BY presentes DESC;


SELECT
j.descricao_jornada,
COUNT(*) AS presentes
FROM fato_presenca_diaria p
JOIN dim_funcionario f
ON p.id_funcionario=f.id_funcionario
JOIN dim_jornada j
ON f.jornada_id=j.id_jornada
WHERE p.data_referencia='2026-09-30'
AND p.presente_sn='S'
GROUP BY j.descricao_jornada;


SELECT
data_referencia,
COUNT(*) AS presentes
FROM fato_presenca_diaria
WHERE presente_sn='S'
GROUP BY data_referencia
ORDER BY data_referencia;


SELECT
data_referencia,
ROUND(100.0 *SUM(CASE WHEN presente_sn='N' THEN 1 ELSE 0 END)/COUNT(*),2) AS absenteismo_pct

FROM fato_presenca_diaria

GROUP BY data_referencia
ORDER BY data_referencia;


SELECT
f.gestor,
SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) AS ausencias

FROM fato_presenca_diaria p
JOIN dim_funcionario f
ON p.id_funcionario=f.id_funcionario

GROUP BY f.gestor
ORDER BY ausencias DESC;


SELECT
sexo,
COUNT(*) AS quantidade
FROM dim_funcionario
GROUP BY sexo;


SELECT

CASE
WHEN idade < 25 THEN 'Até 24'
WHEN idade < 35 THEN '25-34'
WHEN idade < 45 THEN '35-44'
ELSE '45+'
END AS faixa,

COUNT(*) AS quantidade

FROM dim_funcionario

GROUP BY faixa
ORDER BY faixa;


DROP TABLE IF EXISTS dim_calendario;

CREATE TABLE dim_calendario (
    sk_data INTEGER PRIMARY KEY,
    data DATE NOT NULL,
    ano INTEGER,
    semestre INTEGER,
    trimestre INTEGER,
    mes INTEGER,
    nome_mes TEXT,
    ano_mes TEXT,
    semana_ano INTEGER,
    dia_mes INTEGER,
    dia_ano INTEGER,
    dia_semana INTEGER,
    nome_dia_semana TEXT,
    fim_semana_sn TEXT,
    ultimo_dia_mes_sn TEXT,
    feriado_sn TEXT
);


SELECT * from dim_calendario

WITH RECURSIVE calendario(data_ref) AS (
    SELECT date('2020-01-01')

    UNION ALL

    SELECT date(data_ref,'+1 day')
    FROM calendario
    WHERE data_ref < '2035-12-31'
)

INSERT INTO dim_calendario
SELECT

    CAST(strftime('%Y%m%d', data_ref) AS INTEGER) AS sk_data,

    data_ref,

    CAST(strftime('%Y', data_ref) AS INTEGER) AS ano,

    CASE
        WHEN CAST(strftime('%m', data_ref) AS INTEGER) <= 6 THEN 1
        ELSE 2
    END AS semestre,

    ((CAST(strftime('%m', data_ref) AS INTEGER)-1)/3)+1 AS trimestre,

    CAST(strftime('%m', data_ref) AS INTEGER) AS mes,

    CASE strftime('%m', data_ref)
        WHEN '01' THEN 'Janeiro'
        WHEN '02' THEN 'Fevereiro'
        WHEN '03' THEN 'Marco'
        WHEN '04' THEN 'Abril'
        WHEN '05' THEN 'Maio'
        WHEN '06' THEN 'Junho'
        WHEN '07' THEN 'Julho'
        WHEN '08' THEN 'Agosto'
        WHEN '09' THEN 'Setembro'
        WHEN '10' THEN 'Outubro'
        WHEN '11' THEN 'Novembro'
        WHEN '12' THEN 'Dezembro'
    END AS nome_mes,

    strftime('%Y-%m', data_ref) AS ano_mes,

    CAST(strftime('%W', data_ref) AS INTEGER) + 1 AS semana_ano,

    CAST(strftime('%d', data_ref) AS INTEGER) AS dia_mes,

    CAST(strftime('%j', data_ref) AS INTEGER) AS dia_ano,

    CAST(strftime('%w', data_ref) AS INTEGER) AS dia_semana,

    CASE strftime('%w', data_ref)
        WHEN '0' THEN 'Domingo'
        WHEN '1' THEN 'Segunda'
        WHEN '2' THEN 'Terca'
        WHEN '3' THEN 'Quarta'
        WHEN '4' THEN 'Quinta'
        WHEN '5' THEN 'Sexta'
        WHEN '6' THEN 'Sabado'
    END AS nome_dia_semana,

    CASE
        WHEN strftime('%w', data_ref) IN ('0','6')
        THEN 'S'
        ELSE 'N'
    END AS fim_semana_sn,

    CASE
        WHEN date(data_ref,'+1 day') =
             date(data_ref,'start of month','+1 month')
        THEN 'S'
        ELSE 'N'
    END AS ultimo_dia_mes_sn,

    'N' AS feriado_sn

FROM calendario;