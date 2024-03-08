/*

Querry: Update de medidas   

Autor: Eduardo Jorge

Data: 06/11/2020

Descrição:Update de medidas dos produtos nas tabelas SB5 (Altura, largura, comprimento) e SB1 (Peso), passo a passo

*/


-- | Passo 1 - Reset na tabela AUX_MEDIDAS


DELETE FROM AUX_MEDIDAS


-- | Passo 2 - Inserir CSV na tabeela AUX_MEDIDAS, OBS: Colar o CSV aqui: \\192.168.1.15\c$\Temp\
		
		
	BULK 
INSERT AUX_MEDIDAS
        FROM 'C:\TEMP\MEDIDAS.csv'   --> NOME DO ARQUIVO AQUI
            WITH
    (
                FIELDTERMINATOR = ';',
                ROWTERMINATOR = '\n'
    )
GO


-- | Passo 3 - Update nas tabelas do Protheus SB5 e SB1

-- | Primeira: SB5

UPDATE SB5010 SET
B5_ALTURA = A.ALTURA,
B5_LARG = A.LARGURA,
B5_COMPR = A.COMPRIMENTO
FROM AUX_MEDIDAS A 
LEFT JOIN SB5010 B ON B.D_E_L_E_T_ = '' AND B.B5_COD = A.CODPROD

-- | Segunda: SB1

UPDATE SB1010 SET
B1_PESBRU = A.PESO
FROM AUX_MEDIDAS A
LEFT JOIN SB1010 B ON B.D_E_L_E_T_ = '' AND B.B1_COD = A.CODPROD 


-- | Passo 4 - Select de teste (conferir se os dados foram atualizados)


SELECT 
A.CODPROD		AS CODPROD,
B.B5_ALTURA		AS ALTURA,
B.B5_LARG		AS LARGURA,
B.B5_COMPR		AS COMPRIMENTO,
C.B1_PESBRU		AS PESO
FROM AUX_MEDIDAS A 
LEFT JOIN SB5010 B ON B.D_E_L_E_T_ = '' AND B.B5_COD = A.CODPROD
LEFT JOIN SB1010 C ON C.D_E_L_E_T_ = '' AND C.B1_COD = A.CODPROD


/*---------------------------FIM-------------------------------*/


