CREATE TABLE equipamento_bronze
(
    id_equipamento STRING,
    tipo_id INT,
    descricao STRING,
    fabricante STRING,
    data_carga TIMESTAMP
);

INSERT INTO equipamento_bronze VALUES
('EQ001',3,'CAT 950H','CAT', CURRENT_TIMESTAMP),
('EQ002',10,'Komatsu WA380','Komatsu',CURRENT_TIMESTAMP),
('EQ003',80,'Volvo L120','Volvo', CURRENT_TIMESTAMP);

CREATE TABLE map_tipo_equipamento
(
    tipo_id_origem INT,
    sk_tipo_equipamento INT
)

INSERT INTO map_tipo_equipamento VALUES
(3,1),
(10,1),
(80,1),
(5,2),
(15,2),
(6,3);

CREATE TABLE dim_tipo_equipamento
(
    sk_tipo_equipamento INT,
    codigo_negocio STRING,
    tipo_negocio STRING
)


INSERT INTO dim_tipo_equipamento VALUES
(1,'CAR','CARREGADEIRA'),
(2,'ESC','ESCAVADEIRA'),
(3,'CAM','CAMINHAO');


CREATE VIEW equipamento_silver AS

SELECT
    e.id_equipamento,
    e.tipo_id,
    m.sk_tipo_equipamento,
    d.tipo_negocio,
    e.fabricante,
    e.data_carga

FROM equipamento_bronze e
JOIN map_tipo_equipamento m ON e.tipo_id = m.tipo_id_origem
JOIN dim_tipo_equipamento d ON m.sk_tipo_equipamento = d.sk_tipo_equipamento;


CREATE TABLE dim_equipamento
(
    sk_equipamento BIGINT,
    codigo_equipamento STRING,
    fabricante STRING
);


INSERT INTO dim_equipamento
SELECT ROW_NUMBER() OVER (ORDER BY ID_EQUIPAMENTO) AS SK_EQUIPAMENTO, id_equipamento, fabricante
FROM equipamento_silver;




CREATE TABLE fato_equipamento
(
    sk_equipamento BIGINT,
    sk_tipo_equipamento INT,
    data_referencia DATE,
    horas_operadas DECIMAL(18,2),
    custo_operacional DECIMAL(18,2)
);


INSERT INTO fato_equipamento

SELECT DE.sk_equipamento,
    ES.sk_tipo_equipamento,
    current_date as data_referencia,
    120 as horas_operadas,
    5000 as custo_operacional
FROM equipamento_silver ES
JOIN dim_equipamento DE ON es.id_equipamento = de.codigo_equipamento;


SELECT

    DTE.tipo_negocio,

    COUNT(DISTINCT FE.sk_equipamento)

FROM fato_equipamento FE

JOIN dim_tipo_equipamento DTE
ON FE.sk_tipo_equipamento =
   DTE.sk_tipo_equipamento

GROUP BY DTE.tipo_negocio;



CREATE TABLE dim_tipo_equipamento
(
    sk_tipo_equipamento BIGINT,

    codigo_negocio STRING,

    tipo_negocio STRING,

    dt_inicio DATE,

    dt_fim DATE,

    fl_ativo STRING
)

