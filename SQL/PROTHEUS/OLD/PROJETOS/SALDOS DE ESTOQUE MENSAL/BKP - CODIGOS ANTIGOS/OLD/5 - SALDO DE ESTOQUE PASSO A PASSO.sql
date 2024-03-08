
/*-------------CREAT TABLE--------------*/

EXECUTE CREAT_TABLE_SALDO_ESTOQUE

/*-----------------2018-----------------*/

EXECUTE SALDO_ESTOQUE_2018

/*-----------------2019-----------------*/

EXECUTE SALDO_ESTOQUE_2019

/*-----------------2020-----------------*/

EXECUTE SALDO_ESTOQUE_2020

/*---------------SELECT-----------------*/

SELECT * FROM #AUX

SELECT * FROM #AUX WHERE AUX_CODPROD = 'LB012F'

/*---------------DELETE-----------------*/

DROP TABLE #AUX

/*----------------FIM------------------*/
