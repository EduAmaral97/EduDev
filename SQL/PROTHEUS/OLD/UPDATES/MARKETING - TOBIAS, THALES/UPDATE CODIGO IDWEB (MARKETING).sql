/*-------------------ZERAR O IDWEB (TODOS OS PRODUTOS)----------------------*/

UPDATE SB1010 
SET B1_ZIDWEB = 0
WHERE 1=1


/*------------------CRIAR TABELA TEMPORARIA DA PLANILHA-----------------------*/


CREATE TABLE MKTTMP
    (
     AUX_CODPROD VARCHAR(15),
     --AUX_CODAPRE VARCHAR(40),
     AUX_IDWEB FLOAT,    
	)

/*-------------------ISERIR NA TABELA TEMPORARIA DA PLANILHA----------------------*/

	BULK 
INSERT MKTTMP
        FROM 'C:\TEMP\ID_produtos_site.csv'
            WITH
    (
                FIELDTERMINATOR = ';',
                ROWTERMINATOR = '\n'
    )
GO

/*----------------UPDATE DO IDWEB DA PLANILHA PARA TABELA DO BANCO---------------------------*/


UPDATE SB1010 SET B1_ZIDWEB = AUX_IDWEB
FROM SB1010, MKTTMP 
WHERE B1_COD = AUX_CODPROD





/*----------------SELECTS DE TESTE---------------------------*/

SELECT * FROM MKTTMP

SELECT
A.B1_COD, 
A.B1_ZIDWEB, 
B.AUX_IDWEB 
FROM SB1010 A, MKTTMP B 
WHERE 1=1
AND A.B1_COD = B.AUX_CODPROD


DELETE FROM MKTTMP

DROP TABLE MKTTMP

