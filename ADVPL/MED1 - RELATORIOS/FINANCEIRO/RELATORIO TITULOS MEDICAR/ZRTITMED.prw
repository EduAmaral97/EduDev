//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRTITMED()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRTMED" // Nome do grupo de perguntas
 

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

	lRet := oExcel:IsWorkSheet("TITMED")
	oExcel:AddworkSheet("TITMED")
	
	oExcel:AddTable ("TITMED","TITULOS",.F.)
	oExcel:AddColumn("TITMED","TITULOS", "FILIAL",		1,1,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "PREFIXO",		1,1,.F., "")
    oExcel:AddColumn("TITMED","TITULOS", "NUMTIT",		1,1,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "CODCLI",		1,1,.F., "")
    oExcel:AddColumn("TITMED","TITULOS", "CLIENTE",		1,1,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "CGC",			1,1,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "EMISSAO",		1,1,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "VENCIMENTO",	1,1,.F., "")
    oExcel:AddColumn("TITMED","TITULOS", "VENCTOREAL",	1,1,.F., "")
    oExcel:AddColumn("TITMED","TITULOS", "DTBAIXA",		1,1,.F., "")
    oExcel:AddColumn("TITMED","TITULOS", "VALORLIQ",	1,3,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "VLRBAIXA",	1,3,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "SALDO",		1,3,.F., "")
	oExcel:AddColumn("TITMED","TITULOS", "STATUSTIT",	1,1,.F., "")


		cQuery := "	SELECT "
		cQuery += "	SE1.E1_FILIAL   	AS FILIAL,  "
	    cQuery += "	SE1.E1_PREFIXO  	AS PREFIXO,  "
        cQuery += "	SE1.E1_NUM	    	AS NUMTIT,  "
		cQuery += "	SA1.A1_COD	   		AS CODCLI,  "
		cQuery += "	SA1.A1_NREDUZ   	AS CLIENTE,  "
		cQuery += "	CASE  "
		cQuery += "		WHEN SA1.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(SA1.A1_CGC,1,3),'.',SUBSTRING(SA1.A1_CGC,4,3),'.',SUBSTRING(SA1.A1_CGC,7,3),'-',SUBSTRING(SA1.A1_CGC,10,2))  "
		cQuery += "		ELSE CONCAT(SUBSTRING(SA1.A1_CGC,1,2),'.',SUBSTRING(SA1.A1_CGC,3,3),'.',SUBSTRING(SA1.A1_CGC,6,3),'/',SUBSTRING(SA1.A1_CGC,9,4),'-',SUBSTRING(SA1.A1_CGC,13,2))  "
		cQuery += "	END             	AS CGC,  "
        cQuery += "	CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS EMISSAO,   "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_VENCTO,7,2),'/',SUBSTRING(SE1.E1_VENCTO,5,2),'/',SUBSTRING(SE1.E1_VENCTO,1,4)) AS VENCIMENTO,   "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS VENCTOREAL,   "
        cQuery += "	CONCAT(SUBSTRING(SE1.E1_BAIXA,7,2),'/',SUBSTRING(SE1.E1_BAIXA,5,2),'/',SUBSTRING(SE1.E1_BAIXA,1,4)) AS DTBAIXA,   "
	    cQuery += "	SE1.E1_VALOR    AS VLRTIT,  "
		cQuery += "	(SE1.E1_VALOR - SE1.E1_SALDO) AS VLRBAIXA, "
        cQuery += "	SE1.E1_SALDO    AS SALDO, "
		cQuery += " CASE "
		cQuery += " 	WHEN SE1.E1_ZSTSLD  = '1' THEN '1 - Protestado' "
		cQuery += " 	WHEN SE1.E1_ZSTSLD  = '2' THEN '2 - Protestado / TMK' "
		cQuery += " 	WHEN SE1.E1_ZSTSLD  = '3' THEN '3 - Judicializado' "
		cQuery += " 	WHEN SE1.E1_ZSTSLD  = '4' THEN '4 - Interno' "
		cQuery += " 	WHEN SE1.E1_ZSTSLD  = '5' THEN '5 - Glosa' "
		cQuery += " 	WHEN SE1.E1_ZSTSLD  = '6' THEN '6 - TMK' "
		cQuery += " ELSE '' "
		cQuery += " END 			AS STATUSTIT "
		cQuery += "	FROM SE1010 SE1  "
		cQuery += "	LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA    "
		cQuery += "	WHERE 1=1    "
		cQuery += "	AND SE1.D_E_L_E_T_ = ''  "
		cQuery += "	AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
		cQuery += " AND SE1.E1_FILIAL >= '"+MV_PAR01+"' "
		cQuery += " AND SE1.E1_FILIAL <= '"+MV_PAR02+"' "
		IF MV_PAR05 = 1
			cQuery += " AND SE1.E1_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ELSEIF MV_PAR05 = 2
			cQuery += " AND SE1.E1_VENCREA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ELSE
			cQuery += " AND SE1.E1_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ENDIF
		cQuery += " ORDER BY SE1.E1_VENCREA "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TITMED","TITULOS",{ (_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->NUMTIT,(_cAlias)->CODCLI,(_cAlias)->CLIENTE,(_cAlias)->CGC,(_cAlias)->EMISSAO,(_cAlias)->VENCIMENTO,(_cAlias)->VENCTOREAL,(_cAlias)->DTBAIXA,(_cAlias)->VLRTIT,(_cAlias)->VLRBAIXA,(_cAlias)->SALDO,(_cAlias)->STATUSTIT })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'TITULOSMEDICAR' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
