//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*

Objetivo: Relatorio criado para dados do Dashboard de faturamento de clientes (Clientes faturados e nao faturados)
Autor: Eduardo Amaral
Data: 11/07/2024


*/


User Function ZRBIFATCLI()

	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */


    //Se não estiver sendo executado via job
    If ! IsBlind()
 
        //Chama a função para buscar arquivos
        cPasta := tFileDialog(;
            cTipArq,;                  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;                  // Título da Janela para seleção dos arquivos
            ,;                         // Compatibilidade
            cDirIni,;                  // Diretório inicial da busca de arquivos
            lSalvar,;                  // Se for .T., será uma Save Dialog, senão será Open Dialog
            GETF_RETDIRECTORY;         // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
        )
 
    EndIf 

	
	MsAguarde({|| fClientes(cPasta)}	,"Aguarde","Gerando Clientes...") 
	MsAguarde({|| fTitulos(cPasta)}		,"Aguarde","Gerando Titulos...") 
	MsAguarde({|| fContratos(cPasta)}	,"Aguarde","Gerando Contratos...") 
	
Return


Static Function fClientes(cPasta)
	
	Local cQueryCli 
	Local cArqCli
	Private cAliasCli := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("CLIENTES")
	oExcel:AddworkSheet("CLIENTES")
	
	oExcel:AddTable ("CLIENTES","DADOS",.F.)
	oExcel:AddColumn("CLIENTES","DADOS", "CODCLI"		,1,1,.F., "")
	oExcel:AddColumn("CLIENTES","DADOS", "LOJA"			,1,1,.F., "")
	oExcel:AddColumn("CLIENTES","DADOS", "RAZAOSOC"		,1,1,.F., "")
	oExcel:AddColumn("CLIENTES","DADOS", "NOMEFANT"		,1,1,.F., "")
	oExcel:AddColumn("CLIENTES","DADOS", "CGC"			,1,1,.F., "")
	oExcel:AddColumn("CLIENTES","DADOS", "TIPOCLI"		,1,1,.F., "")

	cQueryCli := " SELECT "
	cQueryCli += " A.A1_COD		AS CODCLI, "
	cQueryCli += " A.A1_LOJA	AS LOJA, "
	cQueryCli += " A.A1_NOME	AS RAZAOSOC, "
	cQueryCli += " A.A1_NREDUZ	AS NOMEFANT, "
	cQueryCli += " A.A1_CGC		AS CGC, "
	cQueryCli += " A.A1_PESSOA	AS TIPOCLI "
	cQueryCli += " FROM SA1010 A "
	cQueryCli += " WHERE 1=1 "
	cQueryCli += " AND A.D_E_L_E_T_ = '' "


	//Criar alias temporário
	TCQUERY cQueryCli NEW ALIAS (cAliasCli)

	DbSelectArea(cAliasCli)

	While (cAliasCli)->(!Eof())

		oExcel:AddRow("CLIENTES","DADOS",{ (cAliasCli)->CODCLI,(cAliasCli)->LOJA,(cAliasCli)->RAZAOSOC,(cAliasCli)->NOMEFANT,(cAliasCli)->CGC,(cAliasCli)->TIPOCLI })

		(cAliasCli)->(dBskip())

	EndDo

	(cAliasCli)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqCli := cPasta + '\' + 'CLIENTES_BI.xlsx'
	oExcel:GetXMLFile(cArqCli)
	
	oExcel:DeActivate()

Return


Static Function fTitulos(cPasta)
	
	Local cQueryTit
	Local cArqTit
	Private cAliasTit := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TITULOS")
	oExcel:AddworkSheet("TITULOS")
	
	oExcel:AddTable ("TITULOS","DADOS",.F.)
	oExcel:AddColumn("TITULOS","DADOS", "FILIAL"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "PREFIXO"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "TITULO"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "TIPO"		,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "CODCLI"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "LOJA"		,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "EMISSAO"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "VENCIMENTO",1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "COMPEMI"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "COMPVENC"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "VALOR"		,1,3,.F., "@E 999999999.99")
	oExcel:AddColumn("TITULOS","DADOS", "PEDIDO"	,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "LOTE"		,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "BAIXA"		,1,1,.F., "")
	oExcel:AddColumn("TITULOS","DADOS", "SALDO"		,1,3,.F., "@E 999999999.99")

	cQueryTit := " SELECT "
	cQueryTit += " A.E1_FILIAL		AS FILIAL, "
	cQueryTit += " A.E1_PREFIXO		AS PREFIXO, "
	cQueryTit += " A.E1_NUM			AS TITULO, "
	cQueryTit += " A.E1_TIPO		AS TIPO, "
	cQueryTit += " A.E1_CLIENTE		AS CODCLI, "
	cQueryTit += " A.E1_LOJA		AS LOJA, "
	cQueryTit += " A.E1_EMISSAO		AS EMISSAO, "
	cQueryTit += " A.E1_VENCREA		AS VENCIMENTO, "
	cQueryTit += " CONCAT(SUBSTRING(A.E1_EMISSAO,1,4),'/',SUBSTRING(A.E1_EMISSAO,5,2)) AS COMPEMISSAO, "
	cQueryTit += " CONCAT(SUBSTRING(A.E1_VENCREA,1,4),'/',SUBSTRING(A.E1_VENCREA,5,2)) AS COMPEVENC, "
	cQueryTit += " A.E1_VALOR		AS VALOR, "
	cQueryTit += " A.E1_PEDIDO		AS PEDIDO, "
	cQueryTit += " A.E1_PLNUCOB		AS LOTECOB, "
	cQueryTit += " A.E1_BAIXA		AS BAIXA, "
	cQueryTit += " A.E1_SALDO		AS SALDO "
	cQueryTit += " FROM SE1010 A "
	cQueryTit += " WHERE 1=1 "
	cQueryTit += " AND A.D_E_L_E_T_ = '' "
	cQueryTit += " AND A.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR') "

	//Criar alias temporário
	TCQUERY cQueryTit NEW ALIAS (cAliasTit)

	DbSelectArea(cAliasTit)

	While (cAliasTit)->(!Eof())

		oExcel:AddRow("TITULOS","DADOS",{ (cAliasTit)->FILIAL,(cAliasTit)->PREFIXO,(cAliasTit)->TITULO,(cAliasTit)->TIPO,(cAliasTit)->CODCLI,(cAliasTit)->LOJA,(cAliasTit)->EMISSAO,(cAliasTit)->VENCIMENTO,(cAliasTit)->COMPEMISSAO,(cAliasTit)->COMPEVENC,(cAliasTit)->VALOR,(cAliasTit)->PEDIDO,(cAliasTit)->LOTECOB,(cAliasTit)->BAIXA,(cAliasTit)->SALDO })

		(cAliasTit)->(dBskip())

	EndDo

	(cAliasTit)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqTit := cPasta + '\' + 'TITULOS_BI.xlsx'
	oExcel:GetXMLFile(cArqTit)
	
	oExcel:DeActivate()

Return


Static Function fContratos(cPasta)
	
	Local cQueryCtr
	Local cArqCtr
	Private cAliasCtr := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("CONTRATOS")
	oExcel:AddworkSheet("CONTRATOS")
	
	oExcel:AddTable ("CONTRATOS","DADOS",.F.)
	oExcel:AddColumn("CONTRATOS","DADOS", "FILIAL"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "IDCONTRATO"	,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "NUMERO"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "PERFIL"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "DTBASE"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "CODCLI"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "LOJACLI"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "DTBLOQ"		,1,1,.F., "")
	oExcel:AddColumn("CONTRATOS","DADOS", "VLRTOTAL"	,1,3,.F., "@E 999999999.99")
	oExcel:AddColumn("CONTRATOS","DADOS", "QTDTOTAL"	,1,1,.F., "")

	cQueryCtr := " SELECT "
	cQueryCtr += " B.BA3_FILIAL    AS FILIAL, "
	cQueryCtr += " B.BA3_MATEMP    AS IDCONTRATO,  "
	cQueryCtr += " B.BA3_XCARTE    AS NUMERO,  "
	cQueryCtr += " E.BT5_NOME      AS PERFIL,  "
	cQueryCtr += " CONCAT(SUBSTRING(B.BA3_DATBAS,7,2),'/',SUBSTRING(B.BA3_DATBAS,5,2),'/',SUBSTRING(B.BA3_DATBAS,1,4)) AS DTBASE,  "
	cQueryCtr += " I.A1_COD        AS CODCLI,  "
	cQueryCtr += " I.A1_LOJA       AS LOJACLI, "
	cQueryCtr += " CONCAT(SUBSTRING(B.BA3_DATBLO,7,2),'/',SUBSTRING(B.BA3_DATBLO,5,2),'/',SUBSTRING(B.BA3_DATBLO,1,4)) AS DATBLOCTR,  "
	cQueryCtr += " ISNULL(( "
	cQueryCtr += " SELECT "
	cQueryCtr += " SUM(D.BDK_VALOR) "
	cQueryCtr += " FROM BA3010 BA3 "
	cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
	cQueryCtr += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
	cQueryCtr += " WHERE 1=1 "
	cQueryCtr += " AND BA3.D_E_L_E_T_ = ''  "
	cQueryCtr += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
	cQueryCtr += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
	cQueryCtr += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
	cQueryCtr += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
	cQueryCtr += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
	cQueryCtr += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
	cQueryCtr += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
	cQueryCtr += " AND C.BA1_DATBLO = '' "
	cQueryCtr += " ),0) AS VLRTOTAL, "
	cQueryCtr += " ISNULL(( "
	cQueryCtr += " SELECT "
	cQueryCtr += " COUNT(*) "
	cQueryCtr += " FROM BA3010 BA3 "
	cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
	cQueryCtr += " WHERE 1=1 "
	cQueryCtr += " AND BA3.D_E_L_E_T_ = ''  "
	cQueryCtr += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
	cQueryCtr += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
	cQueryCtr += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
	cQueryCtr += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
	cQueryCtr += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
	cQueryCtr += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
	cQueryCtr += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
	cQueryCtr += " AND C.BA1_DATBLO = '' "
	cQueryCtr += " ),0) AS QTDTOTAL "
	cQueryCtr += " FROM BQC010 A  "
	cQueryCtr += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB "
	cQueryCtr += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "      
	cQueryCtr += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = B.BA3_CODCLI AND I.A1_LOJA = B.BA3_LOJA "
	cQueryCtr += " WHERE 1=1  "
	cQueryCtr += " AND A.D_E_L_E_T_ = ''  "
	cQueryCtr += " AND A.BQC_CODEMP IN ('0003','0006') "
	cQueryCtr += " AND B.BA3_DATBLO = '' "

	cQueryCtr += " UNION ALL "

	cQueryCtr += " SELECT "
	cQueryCtr += " ISNULL(( SELECT TOP 1 BA3.BA3_FILIAL AS FIL FROM BA3010 BA3 WHERE 1=1 AND BA3.D_E_L_E_T_ = ''  AND BA3.BA3_CODINT = A.BQC_CODINT  AND BA3.BA3_CODEMP = A.BQC_CODEMP  AND BA3.BA3_CONEMP = A.BQC_NUMCON  AND BA3.BA3_VERCON = A.BQC_VERCON  AND BA3.BA3_SUBCON = A.BQC_SUBCON  AND BA3.BA3_VERSUB = A.BQC_VERSUB ), '') AS FILIAL, "
	cQueryCtr += " A.BQC_SUBCON    AS IDCONTRATO,  "
	cQueryCtr += " A.BQC_ANTCON    AS NUMERO,  "
	cQueryCtr += " E.BT5_NOME      AS PERFIL,  "
	cQueryCtr += " CONCAT(SUBSTRING(A.BQC_DATCON,7,2),'/',SUBSTRING(A.BQC_DATCON,5,2),'/',SUBSTRING(A.BQC_DATCON,1,4)) AS DTBASE,  "
	cQueryCtr += " I.A1_COD        AS CODCLI,  "
	cQueryCtr += " I.A1_LOJA       AS LOJACLI,  "
	cQueryCtr += " CONCAT(SUBSTRING(A.BQC_DATBLO,7,2),'/',SUBSTRING(A.BQC_DATBLO,5,2),'/',SUBSTRING(A.BQC_DATBLO,1,4)) AS DATBLOCTR,  "
	cQueryCtr += " ISNULL(( "
	cQueryCtr += " SELECT "
	cQueryCtr += " SUM(D.BDK_VALOR) "
	cQueryCtr += " FROM BA3010 BA3 "
	cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
	cQueryCtr += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
	cQueryCtr += " WHERE 1=1 "
	cQueryCtr += " AND BA3.D_E_L_E_T_ = ''  "
	cQueryCtr += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
	cQueryCtr += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
	cQueryCtr += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
	cQueryCtr += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
	cQueryCtr += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
	cQueryCtr += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
	cQueryCtr += " AND C.BA1_DATBLO = '' "
	cQueryCtr += " ),0) AS VLRTOTAL, "
	cQueryCtr += " ISNULL(( "
	cQueryCtr += " SELECT "
	cQueryCtr += " COUNT(*) "
	cQueryCtr += " FROM BA3010 BA3 "
	cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
	cQueryCtr += " WHERE 1=1 "
	cQueryCtr += " AND BA3.D_E_L_E_T_ = ''  "
	cQueryCtr += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
	cQueryCtr += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
	cQueryCtr += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
	cQueryCtr += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
	cQueryCtr += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
	cQueryCtr += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
	cQueryCtr += " AND C.BA1_DATBLO = '' "
	cQueryCtr += " ),0) AS QTDTOTAL "
	cQueryCtr += " FROM BQC010 A  "
	cQueryCtr += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
	cQueryCtr += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = A.BQC_CODCLI AND I.A1_LOJA = A.BQC_LOJA "
	cQueryCtr += " WHERE 1=1  "
	cQueryCtr += " AND A.D_E_L_E_T_ = ''  "
	cQueryCtr += " AND A.BQC_CODEMP IN ('0004','0005') "
	cQueryCtr += " AND A.BQC_DATBLO = '' "


	//Criar alias temporário
	TCQUERY cQueryCtr NEW ALIAS (cAliasCtr)

	DbSelectArea(cAliasCtr)

	While (cAliasCtr)->(!Eof())

		oExcel:AddRow("CONTRATOS","DADOS",{ (cAliasCtr)->FILIAL,(cAliasCtr)->IDCONTRATO,(cAliasCtr)->NUMERO,(cAliasCtr)->PERFIL,(cAliasCtr)->DTBASE,(cAliasCtr)->CODCLI,(cAliasCtr)->LOJACLI,(cAliasCtr)->DATBLOCTR,(cAliasCtr)->VLRTOTAL,(cAliasCtr)->QTDTOTAL })

		(cAliasCtr)->(dBskip())

	EndDo

	(cAliasCtr)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqCtr := cPasta + '\' + 'CONTRATOS_BI.xlsx'
	oExcel:GetXMLFile(cArqCtr)
	
	oExcel:DeActivate()

Return
