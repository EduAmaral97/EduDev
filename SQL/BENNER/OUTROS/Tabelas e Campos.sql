

SELECT
    B.name AS TABELA,
    A.name AS COLUNA
FROM sys.COLUMNS A
    LEFT JOIN SYS.tables B ON B.object_id = A.object_id
WHERE 1=1
    AND B.name IS NOT NULL
    --AND A.name LIKE '%USUARIO%'




