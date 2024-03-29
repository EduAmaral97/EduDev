 


SELECT 
A.Z_FILIAL_ATM,
A.Z_NUM_ATM,
A.Z_PROD_REAL,
A.Z_PRODUTO,
C.UB_ITEM,
A.Z_VLR_TOTAL_ATM,
A.Z_COD_CLI,
A.Z_NOME_CLI,
A.Z_COD_FOR,
A.Z_FORNECEDOR,
A.Z_DT_EMI_ATM,
A.Z_DT_LIB_FAT,
A.Z_DATA_FAT,
A.Z_EMI_SC,
A.Z_DT_NOTA_ENTRADA,
A.Z_DT_NOTA_SAIDA,
A.Z_DT_ENT_CLI,
CASE
	WHEN A.Z_DATA_FAT <> '' AND A.Z_DT_NOTA_ENTRADA <> ''
THEN DATEDIFF ( DAY, CAST(CONCAT(SUBSTRING(A.Z_DATA_FAT,7,4),SUBSTRING(A.Z_DATA_FAT,4,2),SUBSTRING(A.Z_DATA_FAT,1,2)) AS DATE), CAST(CONCAT(SUBSTRING(A.Z_DT_NOTA_ENTRADA,7,4),SUBSTRING(A.Z_DT_NOTA_ENTRADA,4,2),SUBSTRING(A.Z_DT_NOTA_ENTRADA,1,2)) AS DATE))
ELSE 0
END AS Fin______Entrada,
CASE
	WHEN A.Z_DATA_FAT <> '' AND A.Z_DT_NOTA_SAIDA <> ''
THEN DATEDIFF ( DAY, CAST(CONCAT(SUBSTRING(A.Z_DATA_FAT,7,4),SUBSTRING(A.Z_DATA_FAT,4,2),SUBSTRING(A.Z_DATA_FAT,1,2)) AS DATE), CAST(CONCAT(SUBSTRING(A.Z_DT_NOTA_SAIDA,7,4),SUBSTRING(A.Z_DT_NOTA_SAIDA,4,2),SUBSTRING(A.Z_DT_NOTA_SAIDA,1,2)) AS DATE))
ELSE 0
END AS Fin______Saida
FROM ZCUBO A
LEFT JOIN SUA010 B ON B.D_E_L_E_T_ = '' AND B.UA_FILIAL = A.Z_FILIAL_ATM AND B.UA_NUM = A.Z_NUM_ATM
LEFT JOIN SUB010 C ON C.D_E_L_E_T_ = '' AND C.UB_FILIAL = A.Z_FILIAL_ATM AND C.UB_NUM = A.Z_NUM_ATM AND C.UB_PRODUTO = A.Z_CODPROD
WHERE 1=1
AND B.UA_ZTIPVND = '2'

