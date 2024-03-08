

/*///////////////////////////////////////////////////
/													/
/													/
/			         DETALHADO	 					/
/													/
/													/
*////////////////////////////////////////////////////


SELECT 
SE3.E3_FILIAL	AS FILIAL,
SE3.E3_NUM		AS TITULO,
SE3.E3_BASE		AS VALOR,
SE3.E3_CODCLI	AS COD_CLI,
SA1.A1_NOME		AS CLIENTE,
SE3.E3_VEND		AS COD_VEND,
SA3.A3_NOME		AS VENDEDOR,
SE3.E3_EMISSAO	AS DATA
FROM SE3010 SE3
LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE3.E3_CODCLI AND SA1.A1_LOJA = SE3.E3_LOJA
LEFT JOIN SA3010 SA3 ON SA3.D_E_L_E_T_ = '' AND SA3.A3_COD = SE3.E3_VEND
WHERE 1=1
AND SE3.D_E_L_E_T_ = ''
AND SE3.E3_EMISSAO BETWEEN '20210101' AND '20210131'



/*///////////////////////////////////////////////////
/													/
/													/
/			         DETALHADO	 					/
/													/
/													/
*////////////////////////////////////////////////////


SELECT 
SE3.E3_VEND		 AS COD_VEND,
SA3.A3_NOME	   	 AS VENDEDOR,
SUM(SE3.E3_BASE) AS VALOR
FROM SE3010 SE3
LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE3.E3_CODCLI AND SA1.A1_LOJA = SE3.E3_LOJA
LEFT JOIN SA3010 SA3 ON SA3.D_E_L_E_T_ = '' AND SA3.A3_COD = SE3.E3_VEND
WHERE 1=1
AND SE3.D_E_L_E_T_ = ''
AND SE3.E3_VEND = '000030', '000041'
AND SE3.E3_EMISSAO BETWEEN '20210101' AND '20210131'
GROUP BY 
SE3.E3_VEND,
SA3.A3_NOME	   