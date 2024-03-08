


DECLARE @HTML  NVARCHAR(MAX)  
DECLARE @DATA  		NVARCHAR(30)  
DECLARE @ASSUNTO 	VARCHAR(200)


SET @DATA = convert(varchar, getdate() - 1, 103)	
SET @ASSUNTO = CONCAT('[Contas a Receber] Titulos recebidos em dinheiro emitidos em: ', @DATA)

  
SET @HTML =  
    N'<H1>Titulos Recebido em Dinheiro</H1>' +  
    N'<H3>Relatorio relacionado aos titulos recebido em dinheiro emitidos em: ' + @DATA + '</H3>' +
    N'<body>' +
    N'<iframe width="1024" height="1060" src="https://app.powerbi.com/view?r=eyJrIjoiOWIyNTA2YTMtMjhiOS00YWM1LTkwOGQtYjBkODFiNDBkYjhmIiwidCI6IjhhNGRhOGM1LTA0YmQtNGZlOC04NzJjLTRlYzI2MmM3YmJmNyJ9&pageName=ReportSection812ee063b033cb046079" frameborder="0" allowFullScreen="true"></iframe> ' +
    N'</body>';
  
		
	 
  		 		
  		
	
	execute msdb.dbo.sp_send_dbmail
	
	-- Profile Cofigurado da Zanotti 
    @profile_name = 'Zanotti Relatorios',
    -- Email que vai receber o relatorio
    @recipients = 'ti.suporte2@zanottirefrigeracao.com.br',
    --@recipients = 'contasareceber@zanottirefrigeracao.com.br;guilherme@zanottirefrigeracao.com.br',
    -- Assunto do Email
    @subject = @ASSUNTO,
    -- Parametro do envio
 	@body = @HTML,
 	@body_format = 'HTML'


