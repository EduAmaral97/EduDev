

/*
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-send-dbmail-transact-sql?view=sql-server-ver15
*/
	
/*

ENVIO DE EMAIL PELO SQL AUTOMATICO (HTML)

*/

DECLARE @tableHTML  NVARCHAR(MAX)  
  
SET @tableHTML =  
    N'<H1>Teste Email HTML</H1>' +  
    N'<table border="1">' +  
    N'<th>NOME</th><th>COMPRIMENTO</th><th>LARGURA</th><th>ALTURA</th>' +  
  	N' '+ CAST(( SELECT td = ZC.NOME,       '',  
                    	td = ZC.COMPRIMENTO, '',  
                    	td = ZC.LARGURA, '',  
                    	td = ZC.ALTURA, ''
              FROM ZCAIXAS AS ZC  		
  		 FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +  
    N'</table>'; 
	
	execute msdb.dbo.sp_send_dbmail 
	
	-- Profile Cofigurado da Zanotti 
    @profile_name = 'Zanotti Refrigeracao',
    -- Email que vai receber o relatorio
    @recipients = 'ti.suporte2@zanottirefrigeracao.com.br;marketing@zanottirefrigeracao.com.br',
   	--@recipients = 
    -- Assunto do Email
    @subject = 'Relatorio',
    -- Parametro do envio
 	@body = @tableHTML,
 	@body_format = 'HTML'
 	

/*

ENVIO DE EMAIL PELO SQL AUTOMATICO (ARQUIVO TEXTO ANEXO)

*/

DECLARE @filename VARCHAR(50)

SET @filename = 'TESTE.txt'

	execute msdb.dbo.sp_send_dbmail 
	
    -- Profile Cofigurado da Zanotti
    @profile_name = 'Zanotti Refrigeracao',
    
    -- email que vai receber o relatorio
    @recipients = 'ti.suporte2@zanottirefrigeracao.com.br',
    
    -- Assunto do email										
    @subject = 'Teste email SQL Automatic',	
    
    -- Corpo do Email				
 	@body = 'teste de envio de email com anexo de resultado SQL',
 	
 	-- Querry do Relatorio
 	@Query  = 'SELECT NOME AS NOME, ALTURA AS ALTURA FROM PROTHEUS_ZANOTTI_PRODUCAO.dbo.ZCAIXAS',
 	
 	-- Parametros de envio
   	@attach_query_result_as_file = 1,
	@query_attachment_filename = @filename,
   	@query_result_header = 1
   	--@query_result_separator = '',
	--@append_query_error = 1,
	--@query_no_truncate = 1;


