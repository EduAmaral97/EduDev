

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
 	@Query  = 
 	'
 	
SELECT TOP 10 * FROM PROTHEUS_ZANOTTI_PRODUCAO.dbo.ZCUBO

	',
 	
 	-- Parametros de envio
   	@attach_query_result_as_file = 1,
	@query_attachment_filename = @filename,
   	@query_result_header = 1
   	--@query_result_separator = '',
	--@append_query_error = 1,
	--@query_no_truncate = 1;
