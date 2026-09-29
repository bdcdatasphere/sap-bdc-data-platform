--CREATE VIEW gold_headcount_mensal AS
--Competência x Departamento x Jornada
SELECT

    strftime('%Y-%m', h.data_referencia) AS competencia,

    f.departamento,

    j.descricao_jornada,

    COUNT(*) AS headcount

FROM fato_headcount_mensal h

JOIN dim_funcionario f
    ON h.id_funcionario = f.id_funcionario

JOIN dim_jornada j
    ON f.jornada_id = j.id_jornada

WHERE h.ativo_sn = 'S'

GROUP BY

    strftime('%Y-%m', h.data_referencia),
    f.departamento,
    j.descricao_jornada;
    
--CREATE VIEW gold_presenca_mensal AS
--Competência x Departamento x Jornada
SELECT
    strftime('%Y-%m', p.data_referencia) AS competencia,
    f.departamento,
    j.descricao_jornada,
    COUNT(*) AS escalados,
    SUM(
        CASE WHEN p.presente_sn='S'
        THEN 1 ELSE 0 END
    ) AS presentes,

    SUM(
        CASE WHEN p.falta_sn='S'
        THEN 1 ELSE 0 END
    ) AS faltas,

    SUM(
        CASE WHEN p.ferias_sn='S'
        THEN 1 ELSE 0 END
    ) AS ferias,

    SUM(
        CASE WHEN p.afastado_sn='S'
        THEN 1 ELSE 0 END
    ) AS afastados

FROM fato_presenca_diaria p
JOIN dim_funcionario f ON p.id_funcionario = f.id_funcionario
JOIN dim_jornada j ON f.jornada_id = j.id_jornada
GROUP BY strftime('%Y-%m', p.data_referencia), f.departamento, j.descricao_jornada;



--Competência x Departamento
--CREATE VIEW gold_absenteismo_mensal AS

SELECT
    strftime('%Y-%m', p.data_referencia) AS competencia,
    f.departamento,
    COUNT(*) AS escalados,
    SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) AS ausencias,
    ROUND(100.0 * SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) / COUNT(*),2) AS absenteismo_pct
FROM fato_presenca_diaria p
JOIN dim_funcionario f ON p.id_funcionario = f.id_funcionario
GROUP BY strftime('%Y-%m', p.data_referencia), f.departamento;



--Competência x Jornada
--CREATE VIEW gold_jornada_mensal AS

SELECT
    strftime('%Y-%m', h.data_referencia) AS competencia,
    j.descricao_jornada,
    COUNT(*) AS headcount,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY strftime('%Y-%m', h.data_referencia)),2) AS percentual
    FROM fato_headcount_mensal h
JOIN dim_funcionario f ON h.id_funcionario = f.id_funcionario
JOIN dim_jornada j ON f.jornada_id = j.id_jornada
WHERE h.ativo_sn='S'
GROUP BY strftime('%Y-%m', h.data_referencia), j.descricao_jornada;


--CREATE VIEW gol*_departamento_mensal AS
--Competência x Departamento
SELECT
	strftime('%Y-%m', h.data_referencia) AS competencia,
    f.departamento,
    COUNT(*) AS headcount
FROM fato_headcount_mensal h
JOIN dim_funcionario f ON h.id_funcionario = f.id_funcionario
WHERE h.ativo_sn='S'
GROUP BY
    strftime('%Y-%m', h.data_referencia),
    f.departamento;


--CREATE VIEW gold_g*stor_mensal AS
--Competência x Gestor
SELECT
    strftime('%Y-%m', p.data_referencia) AS competencia,
    f.gestor,
    COUNT(*) AS escalados,
    SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) AS presentes,
    SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) AS ausentes
FROM fato_presenca_diaria p
JOIN dim_funcionario f ON p.id_funcionario = f.id_funcionario
GROUP BY strftime('%Y-%m', p.data_referencia), f.gestor;


--CREATE VIEW gold_kpi_mensal AS
--Competência
SELECT
    strftime('%Y-%m', p.data_referencia) AS competencia,
    COUNT(*) AS escalados,
    SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) AS presentes,
    SUM(CASE WHEN p.falta_sn='S' THEN 1 ELSE 0 END) AS faltas,
    SUM(CASE WHEN p.ferias_sn='S' THEN 1 ELSE 0 END) AS ferias,
    SUM(CASE WHEN p.afastado_sn='S' THEN 1 ELSE 0 END) AS afastados,
    ROUND(100.0 * SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) / COUNT(*),2) AS absenteismo_pct
FROM fato_presenca_diaria p
GROUP BY strftime('%Y-%m', p.data_referencia);