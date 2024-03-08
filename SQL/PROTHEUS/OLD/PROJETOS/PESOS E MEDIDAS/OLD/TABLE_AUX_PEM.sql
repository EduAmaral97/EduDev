
/*------------------------CREAT TABLE-------------------------*/

CREATE TABLE #AUX
    (
     AUX_CODPROD VARCHAR(15),
   	 AUX_PRODUTO VARCHAR(70),
	 AUX_APREPLAN VARCHAR(20),
	 AUX_APRETOTV VARCHAR(20),
	 AUX_FORNECEDOR VARCHAR(40),
	 AUX_ALTURA FLOAT,
	 AUX_LARGURA FLOAT,
	 AUX_PROFUNDIDADE FLOAT,
	 AUX_PESO FLOAT,
	 AUX_RECNOPLAN VARCHAR(20),
	 AUX_RECNOTOTV VARCHAR(20)
	)


/*------------------------SELECT-------------------------*/


SELECT * FROM #AUX


/*---------------------DROP TABLE------------------------*/


DROP TABLE #AUX


