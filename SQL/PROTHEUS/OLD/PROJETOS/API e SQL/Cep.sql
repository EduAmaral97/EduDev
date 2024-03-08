
DECLARE 
	@TOKEN INT,
	@IMPUT VARCHAR(MAX),
	@URL AS VARCHAR(MAX),
	@RESULTADO AS VARCHAR(8000),
	@vchStatus AS VARCHAR(MAX),
	@intQtdeResultados AS INT;
	
DECLARE @CEP VARCHAR(MAX)
DECLARE @RUA VARCHAR(MAX)
DECLARE @BAIRRO VARCHAR(MAX)
DECLARE @CIDADE VARCHAR(MAX)
DECLARE @UF VARCHAR(MAX)
 
   	SET @IMPUT = '50800320';
   	SET @URL = 'https://viacep.com.br/ws/' + @IMPUT +'/json/';
 
	EXEC sp_OACreate 'MSXML2.XMLHTTP', @TOKEN OUT;
	EXEC sp_OAMethod @TOKEN, 'open', NULL, 'get', @URL, 'false';
	EXEC sp_OAMethod @TOKEN, 'send';
	EXEC sp_OAMethod @TOKEN, 'responseText', @RESULTADO OUTPUT;;


--SELECT * FROM openjson(@RESULTADO)


SET @CEP = 		ISNULL((SELECT value FROM openjson(@RESULTADO) WHERE [key] = 'cep'),'')
SET @RUA = 		ISNULL((SELECT value FROM openjson(@RESULTADO) WHERE [key] = 'logradouro'),'')
SET @BAIRRO = 	ISNULL((SELECT value FROM openjson(@RESULTADO) WHERE [key] = 'bairro'),'')
SET @CIDADE =	ISNULL((SELECT value FROM openjson(@RESULTADO) WHERE [key] = 'localidade'),'')
SET @UF = 		ISNULL((SELECT value FROM openjson(@RESULTADO) WHERE [key] = 'uf'),'')


SELECT @CEP AS CEP, @RUA AS RUA, @BAIRRO AS BAIRRO, @CIDADE AS CIDADE, @UF AS ESTADO


