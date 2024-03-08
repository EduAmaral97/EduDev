

DECLARE @tableHTML  NVARCHAR(MAX)  
DECLARE @DATA  		NVARCHAR(30)  
DECLARE @ASSUNTO 	VARCHAR(200)


SET @DATA = convert(varchar, getdate() - 1, 103)	
SET @ASSUNTO = CONCAT('[Contas a Receber] Titulos recebidos em dinheiro emitidos em: ', @DATA)

  
SET @tableHTML =  
    N'<H1>Titulos Recebido em Dinheiro</H1>' +  
    N'<H3>Relatorio relacionado aos titulos recebido em dinheiro emitidos em: ' + @DATA + '</H3>' +
    N' ' + 
    N' ' + 
    N' ' + 
    N'<table border="1">' +
    N'<th>NOME</th><th>PREFIXO</th><th>TITULO</th><th>TIPO</th><th>COD. CLI</th><th>CLIENTE</th><th>VENDEDOR</th><th>VENCIMENTO</th><th>HISTORICO</th><th>BAIXA</th><th>VALOR</th><th>JUROS</th><th>DESCONTO</th><th>VLR. BAIXA</th><th>BCO</th><th>MOT</th><th>FIL. ORIG.</th>' +
  	N' '+ CAST(( 
  	  		 		
  		SELECT
  		
		td = SE1.E1_FILIAL, '',
		td = SE1.E1_PREFIXO, '',
		td = SE1.E1_NUM, '',
		td = SE1.E1_TIPO, '',
		td = SE1.E1_CLIENTE, '',
		td = SA1.A1_NOME, '',
		td = SA3.A3_NOME, '',
	   	td = CONCAT(SUBSTRING(SE1.E1_EMISSAO ,7,2), '/',SUBSTRING(SE1.E1_EMISSAO ,5,2),'/',SUBSTRING(SE1.E1_EMISSAO ,1,4)), '', 
		td = SE5.E5_HISTOR, '',
		td = CONCAT(SUBSTRING(SE1.E1_BAIXA ,7,2), '/',SUBSTRING(SE1.E1_BAIXA ,5,2),'/',SUBSTRING(SE1.E1_BAIXA ,1,4)), '', 
		td = cast(SE1.E1_VALOR as decimal(10, 2)), '',
	   	td = cast(SE1.E1_VALJUR as decimal(10, 2)), '',
		td = cast(SE1.E1_DESCONT as decimal(10, 2)), '',
		td = cast(SE1.E1_VALOR as decimal(10, 2)), '',
		td = SE5.E5_BANCO, '',
		td = SE5.E5_MOTBX, '',
		td = SE1.E1_FILORIG, ''
		
		FROM SE1010 SE1
		LEFT JOIN SE5010 SE5 ON SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_TIPO = SE1.E1_TIPO
		LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA
		LEFT JOIN SA3010 SA3 ON SA3.D_E_L_E_T_ = '' AND SA3.A3_COD = SE1.E1_VEND1
		WHERE 1=1
		AND SE1.D_E_L_E_T_ = '' 
		AND SE1.E1_TIPO IN ('R$','DH')
		AND (SE1.E1_EMISSAO) = convert(varchar, getdate() - 1, 112)	
  		 		
  		
  		 FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX) ) +  
    N'</table>'; 
	
	execute msdb.dbo.sp_send_dbmail
	
	-- Profile Cofigurado da Zanotti 
    @profile_name = 'Zanotti Relatorios',
    -- Email que vai receber o relatorio
    --@recipients = 'ti.suporte2@zanottirefrigeracao.com.br',
    @recipients = 'contasareceber@zanottirefrigeracao.com.br;guilherme@zanottirefrigeracao.com.br',
    -- Assunto do Email
    @subject = @ASSUNTO,
    -- Parametro do envio
 	@body = @tableHTML,
 	@body_format = 'HTML'


