/*Passar dados por parametros ($)*/

/*-----------------Sem imput-----------------*/

DECLARE @cod VARCHAR(6), @nome VARCHAR(70);  
SET @cod = '000001';  
SET @nome = '%EDUARDO%'; 
SELECT A1_COD, A1_NOME  
FROM SA1010  
WHERE A1_COD like @cod or A1_NOME like @nome;  

/*-----------------Com imput-----------------*/
--Utilizar '%' na janela de imput de dados para pesquisas compostas

DEFINE @cod  VARCHAR(6)
DEFINE @nome VARCHAR(70)
DECLARE @cod VARCHAR(6)
DECLARE @nome VARCHAR(70)
SET @cod =  $(@cod)
SET @nome = $(@nome)
SELECT A1_COD, A1_NOME
FROM SA1010 
WHERE A1_COD LIKE @cod OR A1_NOME LIKE @nome;

/*------------Tabela para consulta-----------*/

SELECT A1_COD, A1_NOME  FROM SA1010



