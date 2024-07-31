//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELSMSCOB()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRSMSCOB" // Nome do grupo de perguntas
 

	/* ---------------------------- PERGUNTAS E FILTROS ---------------------------- */
	
	If !Empty(cCustBem)
		Pergunte(cPerg,.F.)
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif


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

	
	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	
	
Return

Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqBem
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("SMSCOB")
	oExcel:AddworkSheet("SMSCOB")
	
	oExcel:AddTable ("SMSCOB","TITULOS",.F.)
	oExcel:AddColumn("SMSCOB","TITULOS", "FILIAL",		,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "SERIE",		,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "NUMERONF",	,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "CGC",			,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "RAZAOSOC",	,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "NOMEFANT",	,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "TIPOCLI",		,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "VALOR",		,3,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "VALORLIQ",	,3,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "SALDO",		,3,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "EMISSAO",		,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "VENCTO",		,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "VENCTOREAL",	,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "FORMPAG",		,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "TELEFONE1",	,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "TELEFONE2",	,1,1,.F., "")
	oExcel:AddColumn("SMSCOB","TITULOS", "TELEFONE3",	,1,1,.F., "")


		cQuery := "	SELECT "
		cQuery += " CASE "
		cQuery += "     WHEN SE1.E1_FILIAL = '001001' THEN 'Medicar Ribeirao Preto' "
		cQuery += "     WHEN SE1.E1_FILIAL = '002001' THEN 'Medicar Campinas' "
		cQuery += "     WHEN SE1.E1_FILIAL = '003001' THEN 'Medicar Sao Paulo' "
		cQuery += "     WHEN SE1.E1_FILIAL = '006001' THEN 'Medicar Tech' "
		cQuery += "     WHEN SE1.E1_FILIAL = '008001' THEN 'Medicar Litoral' "
		cQuery += "     WHEN SE1.E1_FILIAL = '016002' THEN 'N1 Card' "
		cQuery += "     WHEN SE1.E1_FILIAL = '021001' THEN 'Medicar Rio de Janeiro' "
		cQuery += "     WHEN SE1.E1_FILIAL = '014001' THEN 'Locamedi Matriz'  "
		cQuery += "     ELSE '' "
		cQuery += " END              	AS FILIAL, "
		cQuery += "	SE1.E1_PREFIXO  	AS SERIE,  "
		cQuery += "	SE1.E1_NUM	    	AS NUMERONF,  "
		cQuery += "	CASE  "
		cQuery += "		WHEN SA1.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(SA1.A1_CGC,1,3),'.',SUBSTRING(SA1.A1_CGC,4,3),'.',SUBSTRING(SA1.A1_CGC,7,3),'-',SUBSTRING(SA1.A1_CGC,10,2))  "
		cQuery += "		ELSE CONCAT(SUBSTRING(SA1.A1_CGC,1,2),'.',SUBSTRING(SA1.A1_CGC,3,3),'.',SUBSTRING(SA1.A1_CGC,6,3),'/',SUBSTRING(SA1.A1_CGC,9,4),'-',SUBSTRING(SA1.A1_CGC,13,2))  "
		cQuery += "	END             	AS CGC,  "
		cQuery += "	SA1.A1_NOME		   	AS RAZAOSOC,  "
		cQuery += "	SA1.A1_NREDUZ   	AS NOMEFANT,  "
		cQuery += "	SA1.A1_PESSOA   	AS TIPOCLI,  "
		cQuery += "	SE1.E1_VALOR    	AS VALOR,  "
		cQuery += "	(SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0) AS VALORLIQ,  "
		cQuery += "	((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) AS SALDO,  "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS EMISSAO,   "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_VENCTO,7,2),'/',SUBSTRING(SE1.E1_VENCTO,5,2),'/',SUBSTRING(SE1.E1_VENCTO,1,4)) AS VENCTO,   "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS VENCTOREAL,   "
		cQuery += " CASE "
		cQuery += " 	WHEN SE1.E1_FORRECE = '0' THEN 'Debito Automatico'   "
		cQuery += " 	WHEN SE1.E1_FORRECE = '1' THEN 'Carne' "
		cQuery += " 	WHEN SE1.E1_FORRECE = '3' THEN 'Boleto' "
		cQuery += " 	WHEN SE1.E1_FORRECE = '4' THEN 'Deposito Bancario' "
		cQuery += " 	WHEN SE1.E1_FORRECE = '5' THEN 'Cartao de Credito' "
		cQuery += " ELSE '' "
		cQuery += " END 			AS FORMPAG, "
		cQuery += "	CONCAT(SA1.A1_DDD, ' ', SA1.A1_TEL) AS TELEFONE1,  "
		cQuery += "	CONCAT(SA1.A1_ZZDDD2, ' ', SA1.A1_ZZTEL2) AS TELEFONE2,  "
		cQuery += "	CONCAT(SA1.A1_ZZDDD3, ' ', SA1.A1_ZZTEL3) AS TELEFONE3  "
		cQuery += "	FROM SE1010 SE1  "
		cQuery += "	LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA    "
		cQuery += "	WHERE 1=1    "
		cQuery += "	AND SE1.D_E_L_E_T_ = ''  "
		cQuery += "	AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
		cQuery += "	AND SE1.E1_PREFIXO IN ('1','MIG')  "
		cQuery += " AND SE1.E1_FILIAL >= '"+MV_PAR01+"' "
		cQuery += " AND SE1.E1_FILIAL <= '"+MV_PAR02+"' "
		cQuery += " AND SE1.E1_VENCREA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		cQuery += " AND ((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) > 1 "
		cQuery += " ORDER BY SE1.E1_VENCREA "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("SMSCOB","TITULOS",{ (_cAlias)->FILIAL,(_cAlias)->SERIE,(_cAlias)->NUMERONF,(_cAlias)->CGC,(_cAlias)->RAZAOSOC,(_cAlias)->NOMEFANT,(_cAlias)->TIPOCLI,(_cAlias)->VALOR,(_cAlias)->VALORLIQ,(_cAlias)->SALDO,(_cAlias)->EMISSAO,(_cAlias)->VENCTO,(_cAlias)->VENCTOREAL,(_cAlias)->FORMPAG,(_cAlias)->TELEFONE1,(_cAlias)->TELEFONE2,(_cAlias)->TELEFONE3 })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'SMSCOB' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
