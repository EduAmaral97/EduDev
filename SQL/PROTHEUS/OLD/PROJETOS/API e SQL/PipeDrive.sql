
DECLARE 
	@intToken INT,
	
	@idpipe VARCHAR(MAX),
	@vchURL AS VARCHAR(MAX),
	@vchJSON AS IMAGE(),
	@vchStatus AS VARCHAR(MAX),
	@intQtdeResultados AS INT;
   
   	SET @idpipe = '11331';
   	--SET @vchURL = 'https://viacep.com.br/ws/14300148/json/';
	SET @vchURL = 'https://zanottirefrigeracao.pipedrive.com/api/v1/deals/' + @idpipe +'/?api_token=bfcd16dace990379a45036ab9fb32f48738e3aa2';


	EXEC sp_OACreate 'MSXML2.XMLHTTP', @intToken OUT;
	EXEC sp_OAMethod @intToken, 'open', NULL, 'get', @vchURL, 'false';
	EXEC sp_OAMethod @intToken, 'send';
	EXEC sp_OAMethod @intToken, 'responseText', @vchJSON OUTPUT;

	--Site para visualizar JSON http://jsonviewer.stack.hu/
	
	
	SELECT @intToken AS TOKEN, @vchURL AS URL, @vchJSON AS RESULTADO;
	
	
	
	
	
	
	
/*
CONVERT(VARCHAR(MAX), CONVERT(VARBINARY(MAX),UA_ZINFCOM)) 
*/	
	
	
	