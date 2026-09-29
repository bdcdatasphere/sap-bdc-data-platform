--------------------------------------------------
-- LIMPEZA
--------------------------------------------------

DROP TABLE IF EXISTS dim_jornada;
DROP TABLE IF EXISTS dim_funcionario;
DROP TABLE IF EXISTS fato_presenca_diaria;
DROP TABLE IF EXISTS fato_headcount_mensal;

--------------------------------------------------
-- DIMENSÕES
--------------------------------------------------

CREATE TABLE dim_jornada (
    id_jornada INTEGER PRIMARY KEY,
    codigo_jornada TEXT,
    descricao_jornada TEXT,
    hora_inicio TEXT,
    hora_fim TEXT
);

CREATE TABLE dim_funcionario (
    id_funcionario INTEGER PRIMARY KEY,
    --matricula TEXT,
    --nome TEXT,
    sexo TEXT,
    idade INTEGER,
    cargo TEXT,
    departamento TEXT,
    centro_custo TEXT,
    gestor TEXT,
    jornada_id INTEGER,
    situacao TEXT,
    data_admissao DATE
);

CREATE TABLE fato_presenca_diaria (
    data_referencia DATE,
    id_funcionario INTEGER,
    escalado_sn TEXT,
    presente_sn TEXT,
    falta_sn TEXT,
    ferias_sn TEXT,
    afastado_sn TEXT
);

CREATE TABLE fato_headcount_mensal (
    data_referencia DATE,
    id_funcionario INTEGER,
    ativo_sn TEXT
);

--------------------------------------------------
-- JORNADAS
--------------------------------------------------

INSERT INTO dim_jornada VALUES
(1,'ADM','Administrativo','08:00','17:00'),
(2,'T1','1º Turno','06:00','14:20'),
(3,'T2','2º Turno','14:20','22:40'),
(4,'T3','3º Turno','22:40','06:00'),
(5,'12X36','Escala 12x36','07:00','19:00');

--------------------------------------------------
-- FUNCIONÁRIOS
--------------------------------------------------

WITH RECURSIVE seq(n) AS
(
    SELECT 1
    UNION ALL
    SELECT n+1
    FROM seq
    WHERE n < 50
)

INSERT INTO dim_funcionario
SELECT
    n,
    printf('%06d',100000+n),
    'Funcionario '||n,
    CASE WHEN n % 2 = 0 THEN 'M' ELSE 'F' END,
    20 + (n % 30),

    CASE
        WHEN n <= 30 THEN 'Operador Produção'
        WHEN n <= 40 THEN 'Conferente'
        WHEN n <= 45 THEN 'Analista Qualidade'
        ELSE 'Analista RH'
    END,

    CASE
        WHEN n <= 30 THEN 'Produção'
        WHEN n <= 40 THEN 'Logística'
        WHEN n <= 45 THEN 'Qualidade'
        ELSE 'RH'
    END,

    'CC' || (100 + (n % 5) * 100),

    CASE
        WHEN n <= 30 THEN 'Carlos Silva'
        WHEN n <= 40 THEN 'Fernanda Costa'
        WHEN n <= 45 THEN 'Marcos Alves'
        ELSE 'Ricardo Nunes'
    END,

    CASE
        WHEN n <= 20 THEN 2
        WHEN n <= 35 THEN 3
        WHEN n <= 40 THEN 4
        ELSE 1
    END,

    'ATIVO',

    date('2020-01-01','+'||n||' day')

FROM seq;

--------------------------------------------------
-- HEADCOUNT MENSAL
--------------------------------------------------

INSERT INTO fato_headcount_mensal
SELECT
    '2026-09-30',
    id_funcionario,
    'S'
FROM dim_funcionario;

--------------------------------------------------
-- PRESENÇA DIÁRIA - 30 DIAS
--------------------------------------------------

WITH RECURSIVE datas(dt) AS
(
    SELECT date('2026-09-01')
    UNION ALL
    SELECT date(dt,'+1 day')
    FROM datas
    WHERE dt < date('2026-09-30')
)

INSERT INTO fato_presenca_diaria
SELECT

    d.dt,
    f.id_funcionario,

    'S',

    CASE
        WHEN ((strftime('%d',d.dt)+f.id_funcionario) % 20) = 0
            THEN 'N'
        WHEN ((strftime('%d',d.dt)+f.id_funcionario) % 33) = 0
            THEN 'N'
        WHEN ((strftime('%d',d.dt)+f.id_funcionario) % 41) = 0
            THEN 'N'
        ELSE 'S'
    END,

    CASE
        WHEN ((strftime('%d',d.dt)+f.id_funcionario) % 20) = 0
            THEN 'S'
        ELSE 'N'
    END,

    CASE
        WHEN ((strftime('%d',d.dt)+f.id_funcionario) % 33) = 0
            THEN 'S'
        ELSE 'N'
    END,

    CASE
        WHEN ((strftime('%d',d.dt)+f.id_funcionario) % 41) = 0
            THEN 'S'
        ELSE 'N'
    END

FROM datas d
CROSS JOIN dim_funcionario f;