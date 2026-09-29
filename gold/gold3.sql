-- Jornadas

CREATE TABLE dim_jornada (
    id_jornada INTEGER PRIMARY KEY,
    codigo_jornada TEXT,
    descricao_jornada TEXT,
    hora_inicio TEXT,
    hora_fim TEXT
);

-- Funcionários

CREATE TABLE dim_funcionario (
    id_funcionario INTEGER PRIMARY KEY,
    matricula TEXT,
    nome TEXT,
    sexo TEXT,
    idade INTEGER,
    cargo TEXT,
    departamento TEXT,
    centro_custo TEXT,
    gestor TEXT,
    jornada_id INTEGER,
    situacao TEXT,
    data_admissao DATE,
    FOREIGN KEY (jornada_id) REFERENCES dim_jornada(id_jornada)
);

-- Snapshot diário

CREATE TABLE fato_presenca_diaria (
    data_referencia DATE,
    id_funcionario INTEGER,
    escalado_sn TEXT,
    presente_sn TEXT,
    falta_sn TEXT,
    ferias_sn TEXT,
    afastado_sn TEXT,
    FOREIGN KEY (id_funcionario) REFERENCES dim_funcionario(id_funcionario)
);

-- Snapshot mensal

CREATE TABLE fato_headcount_mensal (
    data_referencia DATE,
    id_funcionario INTEGER,
    ativo_sn TEXT,
    FOREIGN KEY (id_funcionario) REFERENCES dim_funcionario(id_funcionario)
);