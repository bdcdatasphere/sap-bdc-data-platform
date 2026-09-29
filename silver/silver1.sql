INSERT INTO dim_jornada VALUES
(1,'ADM','Administrativo','08:00','17:00'),
(2,'T1','1º Turno','06:00','14:20'),
(3,'T2','2º Turno','14:20','22:40'),
(4,'T3','3º Turno','22:40','06:00'),
(5,'12X36','Escala 12x36','07:00','19:00');


INSERT INTO dim_funcionario VALUES
(1,'100001','Ana Souza','F',33,'Operador Produção','Produção','CC100','Carlos Silva',2,'ATIVO','2023-01-10'),
(2,'100002','Bruno Lima','M',41,'Operador Produção','Produção','CC100','Carlos Silva',2,'ATIVO','2021-03-15'),
(3,'100003','Camila Rocha','F',28,'Analista Qualidade','Qualidade','CC200','Marcos Alves',1,'ATIVO','2024-01-20'),
(4,'100004','Diego Santos','M',35,'Conferente','Logística','CC300','Fernanda Costa',3,'ATIVO','2022-05-10'),
(5,'100005','Eduardo Martins','M',46,'Supervisor','Produção','CC100','Carlos Silva',1,'ATIVO','2018-09-03'),
(6,'100006','Fernanda Melo','F',31,'Operador Produção','Produção','CC100','Carlos Silva',2,'ATIVO','2020-04-15'),
(7,'100007','Gabriel Oliveira','M',29,'Operador Produção','Produção','CC100','Carlos Silva',3,'ATIVO','2025-01-08'),
(8,'100008','Helena Castro','F',39,'Técnico Segurança','SSMA','CC400','Juliana Prado',1,'ATIVO','2019-07-22'),
(9,'100009','Igor Pereira','M',25,'Operador Produção','Produção','CC100','Carlos Silva',4,'ATIVO','2024-06-03'),
(10,'100010','Juliana Gomes','F',37,'Analista RH','RH','CC500','Ricardo Nunes',1,'ATIVO','2021-08-01'),
(11,'100011','Karla Almeida','F',42,'Operador Produção','Produção','CC100','Carlos Silva',2,'ATIVO','2017-01-12'),
(12,'100012','Lucas Ferreira','M',27,'Almoxarife','Logística','CC300','Fernanda Costa',3,'ATIVO','2023-11-20'),
(13,'100013','Mariana Teixeira','F',34,'Operador Produção','Produção','CC100','Carlos Silva',2,'ATIVO','2022-02-01'),
(14,'100014','Nathan Ribeiro','M',30,'Operador Produção','Produção','CC100','Carlos Silva',4,'ATIVO','2024-03-01'),
(15,'100015','Paula Costa','F',45,'Coordenador RH','RH','CC500','Ricardo Nunes',1,'ATIVO','2016-05-10');


INSERT INTO fato_presenca_diaria VALUES
('2026-09-28',1,'S','S','N','N','N'),
('2026-09-28',2,'S','S','N','N','N'),
('2026-09-28',3,'S','S','N','N','N'),
('2026-09-28',4,'S','S','N','N','N'),
('2026-09-28',5,'S','S','N','N','N'),
('2026-09-28',6,'S','N','S','N','N'),
('2026-09-28',7,'S','S','N','N','N'),
('2026-09-28',8,'S','S','N','N','N'),
('2026-09-28',9,'S','N','N','N','S'),
('2026-09-28',10,'S','S','N','N','N'),
('2026-09-28',11,'S','S','N','N','N'),
('2026-09-28',12,'S','S','N','N','N'),
('2026-09-28',13,'S','N','N','S','N'),
('2026-09-28',14,'S','S','N','N','N'),
('2026-09-28',15,'S','S','N','N','N');




INSERT INTO fato_headcount_mensal
SELECT
'2026-09-30',
id_funcionario,
'S'
FROM dim_funcionario;


SELECT COUNT(*) AS headcount
FROM fato_headcount_mensal
WHERE data_referencia='2026-09-30'
AND ativo_sn='S';



SELECT
j.descricao_jornada,
COUNT(*) AS quantidade
FROM fato_headcount_mensal h
JOIN dim_funcionario f ON h.id_funcionario=f.id_funcionario
JOIN dim_jornada j ON f.jornada_id=j.id_jornada
WHERE h.ativo_sn='S'
GROUP BY j.descricao_jornada;


SELECT
COUNT(*) AS presentes
FROM fato_presenca_diaria
WHERE data_referencia='2026-09-28'
AND presente_sn='S';

SELECT
SUM(CASE WHEN falta_sn='S' THEN 1 ELSE 0 END) AS faltas,
SUM(CASE WHEN ferias_sn='S' THEN 1 ELSE 0 END) AS ferias,
SUM(CASE WHEN afastado_sn='S' THEN 1 ELSE 0 END) AS afastados
FROM fato_presenca_diaria
WHERE data_referencia='2026-09-28';



SELECT
ROUND(100.0 *SUM(CASE WHEN presente_sn='N' THEN 1 ELSE 0 END) /COUNT(*),2) AS percentual_absenteismo
FROM fato_presenca_diaria
WhERE data_referencia='2026-09-30';

