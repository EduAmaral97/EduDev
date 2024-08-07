
SELECT
FUNC.EMPRESA,
FUNC.MATRICULA,
FUNC.NOME,
ISNULL((
SELECT 
    B.VALOR
FROM FP_FUNCIONARIOFOLHASCALCULADAS A
    INNER JOIN FP_FUNCIONARIOFOLHAVERBAS B ON B.FOLHAFUNCIONARIO = A.HANDLE
    LEFT JOIN FP_VERBAS C ON C.HANDLE = B.VERBA
    LEFT JOIN Z_FLAGSITENS D ON D.HANDLE = A.TIPOFOLHA
    LEFT JOIN FP_COMPETENCIAS E ON E.HANDLE = A.COMPETENCIA
    LEFT JOIN DO_FUNCIONARIOS F ON F.HANDLE = A.FUNCIONARIO
    LEFT JOIN ADM_EMPRESAS G ON G.HANDLE = F.EMPRESA
WHERE 1=1
/*SITUACAO FOLHA*/		  AND A.SITUACAO = 2
--/*TIPO DE FOLHA*/         AND D.HANDLE IN (37)
/*VERBA*/                 AND C.CODIGO IN (3341)
/*MEPRESA*/				  AND F.EMPRESA = FUNC.EMPRESA
/*MATRICULA FUNCIONARIO*/ AND F.MATRICULA = FUNC.MATRICULA
/*COMPETENCIA FOLHA*/     AND SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) IN ('12/2022')
),0) AS FeriasSaldoAtual,
ISNULL((
SELECT 
    B.VALOR
FROM FP_FUNCIONARIOFOLHASCALCULADAS A
    INNER JOIN FP_FUNCIONARIOFOLHAVERBAS B ON B.FOLHAFUNCIONARIO = A.HANDLE
    LEFT JOIN FP_VERBAS C ON C.HANDLE = B.VERBA
    LEFT JOIN Z_FLAGSITENS D ON D.HANDLE = A.TIPOFOLHA
    LEFT JOIN FP_COMPETENCIAS E ON E.HANDLE = A.COMPETENCIA
    LEFT JOIN DO_FUNCIONARIOS F ON F.HANDLE = A.FUNCIONARIO
    LEFT JOIN ADM_EMPRESAS G ON G.HANDLE = F.EMPRESA
WHERE 1=1
/*SITUACAO FOLHA*/		  AND A.SITUACAO = 2
--/*TIPO DE FOLHA*/         AND D.HANDLE IN (37)
/*VERBA*/                 AND C.CODIGO IN (3342)
/*MEPRESA*/				  AND F.EMPRESA = FUNC.EMPRESA
/*MATRICULA FUNCIONARIO*/ AND F.MATRICULA = FUNC.MATRICULA
/*COMPETENCIA FOLHA*/     AND SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) IN ('12/2022')
),0) AS FeriasSaldoAtualUmTerco,
ISNULL((
SELECT 
    B.VALOR
FROM FP_FUNCIONARIOFOLHASCALCULADAS A
    INNER JOIN FP_FUNCIONARIOFOLHAVERBAS B ON B.FOLHAFUNCIONARIO = A.HANDLE
    LEFT JOIN FP_VERBAS C ON C.HANDLE = B.VERBA
    LEFT JOIN Z_FLAGSITENS D ON D.HANDLE = A.TIPOFOLHA
    LEFT JOIN FP_COMPETENCIAS E ON E.HANDLE = A.COMPETENCIA
    LEFT JOIN DO_FUNCIONARIOS F ON F.HANDLE = A.FUNCIONARIO
    LEFT JOIN ADM_EMPRESAS G ON G.HANDLE = F.EMPRESA
WHERE 1=1
/*SITUACAO FOLHA*/		  AND A.SITUACAO = 2
--/*TIPO DE FOLHA*/         AND D.HANDLE IN (37)
/*VERBA*/                 AND C.CODIGO IN (3343)
/*MEPRESA*/				  AND F.EMPRESA = FUNC.EMPRESA
/*MATRICULA FUNCIONARIO*/ AND F.MATRICULA = FUNC.MATRICULA
/*COMPETENCIA FOLHA*/     AND SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) IN ('12/2022')
),0) AS FeriasSaldoAtualINSS,
ISNULL((
SELECT
    B.VALOR
FROM FP_FUNCIONARIOFOLHASCALCULADAS A
    INNER JOIN FP_FUNCIONARIOFOLHAVERBAS B ON B.FOLHAFUNCIONARIO = A.HANDLE
    LEFT JOIN FP_VERBAS C ON C.HANDLE = B.VERBA
    LEFT JOIN Z_FLAGSITENS D ON D.HANDLE = A.TIPOFOLHA
    LEFT JOIN FP_COMPETENCIAS E ON E.HANDLE = A.COMPETENCIA
    LEFT JOIN DO_FUNCIONARIOS F ON F.HANDLE = A.FUNCIONARIO
    LEFT JOIN ADM_EMPRESAS G ON G.HANDLE = F.EMPRESA
WHERE 1=1
/*SITUACAO FOLHA*/		  AND A.SITUACAO = 2
--/*TIPO DE FOLHA*/         AND D.HANDLE IN (37)
/*VERBA*/                 AND C.CODIGO IN (3344)
/*MEPRESA*/				  AND F.EMPRESA = FUNC.EMPRESA
/*MATRICULA FUNCIONARIO*/ AND F.MATRICULA = FUNC.MATRICULA
/*COMPETENCIA FOLHA*/     AND SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) IN ('12/2022')
),0) AS FeriasSaldoAtuaFGTS,
ISNULL((
SELECT 
    B.VALOR
FROM FP_FUNCIONARIOFOLHASCALCULADAS A
    INNER JOIN FP_FUNCIONARIOFOLHAVERBAS B ON B.FOLHAFUNCIONARIO = A.HANDLE
    LEFT JOIN FP_VERBAS C ON C.HANDLE = B.VERBA
    LEFT JOIN Z_FLAGSITENS D ON D.HANDLE = A.TIPOFOLHA
    LEFT JOIN FP_COMPETENCIAS E ON E.HANDLE = A.COMPETENCIA
    LEFT JOIN DO_FUNCIONARIOS F ON F.HANDLE = A.FUNCIONARIO
    LEFT JOIN ADM_EMPRESAS G ON G.HANDLE = F.EMPRESA
WHERE 1=1
/*SITUACAO FOLHA*/		  AND A.SITUACAO = 2
--/*TIPO DE FOLHA*/         AND D.HANDLE IN (37)
/*VERBA*/                 AND C.CODIGO IN (3345)
/*MEPRESA*/				  AND F.EMPRESA = FUNC.EMPRESA
/*MATRICULA FUNCIONARIO*/ AND F.MATRICULA = FUNC.MATRICULA
/*COMPETENCIA FOLHA*/     AND SUBSTRING(CONVERT(VARCHAR, E.COMPETENCIA, 103),4,7) IN ('12/2022')
),0) AS FeriasSaldoAtualPIS
FROM DO_FUNCIONARIOS FUNC
WHERE 1=1
AND FUNC.EMPRESA = 3
AND FUNC.MATRICULA = 458
