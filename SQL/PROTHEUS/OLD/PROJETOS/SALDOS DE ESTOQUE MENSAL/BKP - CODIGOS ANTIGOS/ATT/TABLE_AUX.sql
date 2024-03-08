/--------------------------CREAT TABLE------------------------/


CREATE TABLE #AUX
    (
     AUX_CODPROD VARCHAR(15),
   	 AUX_PRODUTO VARCHAR(70),
	 AUX_UND	 VARCHAR(2),
	 AUX_CODFOR VARCHAR(6),
	 AUX_LOJFOR VARCHAR(2),
	 AUX_GRUPPROD VARCHAR(4),
     AUX_CODLIN VARCHAR(2),
     AUX_CODFAM VARCHAR(6),
   	 AUX_DATSLD VARCHAR(6),
   	 AUX_CUST_UNI FLOAT,
   	 AUX_CUST_ATU FLOAT,
   	 AUX_ULT_CUST FLOAT,
   	 AUX_CUST_ATT FLOAT,   	 
   	 AUX_CSTUNI FLOAT,
   	 AUX_ANO INT,
   	 AUX_MES INT,
	 AUX_SALDO FLOAT,
	 AUX_CUSTO FLOAT,
	 R_E_C_N_O_ INT IDENTITY(1,1),
	 R_E_C_D_E_L_ INT,
	 FILIAL VARCHAR(4)
	)



/*---------------------------------------------------------*/

	DROP TABLE #AUX

/*---------------------------------------------------------*/

	SELECT * FROM #AUX 