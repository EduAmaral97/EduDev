

SELECT
    F.EMPRESA AS COD_EMPRESA,
    G.NOME AS EMPRESA,
    F.MATRICULA AS MATRICULA,
    F.NOME  AS FUNCIONARIO,
    SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) AS MES_ANO,
    C.CODIGO    AS COD_EVENTO,
    C.NOME  AS EVENTO,
    B.HORAS AS REFERENCIA,
    B.VALOR AS VALOR,
    D.HANDLE AS COD_TIPOFOLHA, 
    D.IDENTIFICADOR AS TIPOFOLHA
FROM FP_FUNCIONARIOFOLHASCALCULADAS A
    INNER JOIN FP_FUNCIONARIOFOLHAVERBAS B ON B.FOLHAFUNCIONARIO = A.HANDLE
    LEFT JOIN FP_VERBAS C ON C.HANDLE = B.VERBA
    LEFT JOIN Z_FLAGSITENS D ON D.HANDLE = A.TIPOFOLHA
    LEFT JOIN FP_COMPETENCIAS E ON E.HANDLE = A.COMPETENCIA
    LEFT JOIN DO_FUNCIONARIOS F ON F.HANDLE = A.FUNCIONARIO
    LEFT JOIN ADM_EMPRESAS G ON G.HANDLE = F.EMPRESA
WHERE 1=1
/*SITUACAO FOLHA*/		  AND A.SITUACAO = 2
/*TIPO DE FOLHA*/         AND D.HANDLE IN (11,18,21)
--/*VERBA*/                 AND C.CODIGO = 12
--/*MEPRESA*/				  AND F.EMPRESA = 3
--/*MATRICULA FUNCIONARIO*/ AND F.MATRICULA = 2172
/*COMPETENCIA FOLHA*/     AND SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) IN ('01/2023')
