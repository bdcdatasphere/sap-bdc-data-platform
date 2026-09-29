--CREATE VIEW gold_headcount AS
--Headcount por Data, Departamento e Jornada
SELECT
    h.data_referencia,
    f.departamento,
    j.descricao_jornada,
    COUNT(*) AS headcount

FROM fato_headcount_mensal h

INNER JOIN dim_funcionario f
    ON h.id_funcionario = f.id_funcionario

INNER JOIN dim_jornada j
    ON f.jornada_id = j.id_jornada

WHERE h.ativo_sn = 'S'

GROUP BY
    h.data_referencia,
    f.departamento,
    j.descricao_jornada;


--Presença diária por Departamento e Jornada
--CREATE VIEW gold_presenca_diaria AS

SELECT
    p.data_referencia,
    f.departamento,
    j.descricao_jornada,
    COUNT(*) AS escalados,
    SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) AS presentes,
    SUM(CASE WHEN p.falta_sn='S' THEN 1 ELSE 0 END) AS faltas,
    SUM(CASE WHEN p.ferias_sn='S' THEN 1 ELSE 0 END) AS ferias,
    SUM(CASE WHEN p.afastado_sn='S' THEN 1 ELSE 0 END) AS afastados
      FROM fato_presenca_diaria p
INNER JOIN dim_funcionario f ON p.id_funcionario= f.id_funcionario
INNER JOIN dim_jornada j ON f.jornada_id = j.id_jornada

GROUP BY
    p.data_referencia,
    f.departamento,
    j.descricao_jornada;



--
--CREATE VIEW gold_absenteismo*AS
--Taxa diária de absenteísmo
SELECT
    p.data_referencia,
    f.departamento,
    ROUND(100.0 * SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) / COUNT(*),2) AS absenteismo_pct
FROM fato_presenca_diaria p
INNER JOIN dim_funcionario f  ON p.id_funcionario = f.id_funcionario
GRoUP BY p.data_referencia, f.departamento;


--
--CREA*E VIEW gold_ocupacao_turno AS
--Mostra quantos estão presentes em relação ao headcount.
SELECT
    p.data_referencia,
    j.descricao_jornada,
    COUNT(*) AS headcount,
    SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) AS presentes,
    ROUND(100.0 * SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) / COUNT(*),2) AS ocupacao_pct

FROM fato_presenca_diaria p
INNER JOIN dim_funcionario f ON p.id_funcionario = f.id_funcionario
INNER JOIN dim_jornada j ON f.jornada_id=j.id_jornada
GROUP BY p.data_referencia, j.descricao_jornada;

--
--CREATE VIEW gold_gestor AS
--Visão por Gestor
SELECT
    p.data_referencia,
    f.gestor,
    COUNT(*) AS colaboradores,
    SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) AS presentes,
    SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) AS ausentes
FROM fato_presenca_diaria p
INNER JOIN dim_funcionario f ON p.id_funcionario=f.id_funcionario
GROUP BY p.data_referencia, f.gestor;


--CREATE VIEW gold_demografia AS
--Distribuição de colaboradores
SELECT
    departamento,
    sexo,
    CASE
        WHEN idade < 25 THEN 'Até 24'
        WHEN idade < 35 THEN '25-34'
        WHEN idade < 45 THEN '35-44'
        ELSE '45+'
    END AS faixa_etaria,
    COUNT(*) AS quantidade
FROM dim_funcionario
GROUP BY departamento, sexo,  faixa_etaria;

--CREATE VIEW gold_movimentacao_mensal AS

SELECT

    strftime('%Y-%m', data_admissao) AS competencia,

    COUNT(*) AS admissoes

FROM dim_funcionario

GROUP BY

    strftime('%Y-%m', data_admissao);
    
    
    --Quando houver admissões e desligamentos.
    --CREATE VIEW gold_movimentacao_mensal AS

SELECT
    strftime('%Y-%m', data_admissao) AS competencia,
    COUNT(*) AS admissoes
FROM dim_funcionario
GROUP BY strftime('%Y-%m', data_admissao);

--CREATE VIEW gold_kpi_executivo AS
--Esta costuma ser minha tabela favorita para dashboards executivos.
SELECT
    p.data_referencia,
    COUNT(*) AS escalados,
    SUM(CASE WHEN p.presente_sn='S' THEN 1 ELSE 0 END) AS presentes,
    SUM(CASE WHEN p.falta_sn='S' THEN 1 ELSE 0 END) AS faltas,
    SUM(CASE WHEN p.ferias_sn='S' THEN 1 ELSE 0 END) AS ferias,
    SUM(CASE WHEN p.afastado_sn='S' THEN 1 ELSE 0 END) AS afastados,
    ROUND(100.0 * SUM(CASE WHEN p.presente_sn='N' THEN 1 ELSE 0 END) / COUNT(*),2) AS absenteismo_pct
FROM fato_presenca_diaria p
GROUP BY p.data_referencia;