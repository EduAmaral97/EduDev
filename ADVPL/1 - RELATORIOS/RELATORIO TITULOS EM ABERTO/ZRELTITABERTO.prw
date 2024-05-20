//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*

TITULO - 002355

*/


User Function ZRELTITABERTO()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRTITABE" // Nome do grupo de perguntas
 

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

	lRet := oExcel:IsWorkSheet("TITABERTO")
	oExcel:AddworkSheet("TITABERTO")
	
	oExcel:AddTable ("TITABERTO","TITULOS",.F.)
	oExcel:AddColumn("TITABERTO","TITULOS", "FILIAL",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "CLIENTE",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "CGC",			,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "NUMTIT",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "PREFIXO",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "PARCELA",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "SERIENF",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "NUMNF",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "HISTORICO",	,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "EMISSAO",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "VENCIMENTO",	,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "VALORNF",		,1,3,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "VALORTIT",		,1,3,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "VALORLIQ",		,1,3,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "SALDO",		,1,3,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "CCUSTO",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "DESCCC",		,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "CLVL",			,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "DESCCLVL", 	,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "NATUREZA", 	,1,1,.F., "")
	oExcel:AddColumn("TITABERTO","TITULOS", "DESCNATURE", 	,1,1,.F., "")


		cQuery := "	SELECT "
		cQuery += "	SE1.E1_FILIAL   	AS FILIAL,  "
		cQuery += "	SA1.A1_NREDUZ   	AS CLIENTE,  "
		cQuery += "	CASE  "
		cQuery += "		WHEN SA1.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(SA1.A1_CGC,1,3),'.',SUBSTRING(SA1.A1_CGC,4,3),'.',SUBSTRING(SA1.A1_CGC,7,3),'-',SUBSTRING(SA1.A1_CGC,10,2))  "
		cQuery += "		ELSE CONCAT(SUBSTRING(SA1.A1_CGC,1,2),'.',SUBSTRING(SA1.A1_CGC,3,3),'.',SUBSTRING(SA1.A1_CGC,6,3),'/',SUBSTRING(SA1.A1_CGC,9,4),'-',SUBSTRING(SA1.A1_CGC,13,2))  "
		cQuery += "	END             	AS CGC,  "
		cQuery += "	SE1.E1_NUM	    	AS NUMTIT,  "
		cQuery += "	SE1.E1_PREFIXO  	AS PREFIXO,  "
		cQuery += "	SE1.E1_PARCELA  	AS PARCELA,  "
		cQuery += "	SD2.D2_SERIE  		AS SERIENF,  "
		cQuery += "	SD2.D2_DOC    		AS NUMNF,  "
		cQuery += "	SE1.E1_HIST  		AS HISTORICO,  "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS EMISSAO,   "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS VENCIMENTO,   "
		cQuery += "	SD2.D2_TOTAL    	AS VALORNF,  "
		cQuery += "	SE1.E1_VALOR    	AS VALORTIT,  "
		cQuery += "	(SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0) AS VALORLIQ,  "
		cQuery += "	((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) AS SALDO,  "
		cQuery += "	SD2.D2_CCUSTO    	AS CCUSTO,  "
		cQuery += "	CTT.CTT_DESC01    	AS DESCCC,  "
		cQuery += "	SD2.D2_CLVL    		AS CLVL,  "
		cQuery += "	CTH.CTH_DESC01    	AS DESCCLVL,  "
		cQuery += "	SED.ED_CODIGO    	AS NATUREZA,  "
		cQuery += "	SED.ED_DESCRIC    	AS DESCNATURE  "
		cQuery += "	FROM SE1010 SE1  "
		cQuery += "	LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA    "
		cQuery += "	LEFT JOIN SD2010 SD2 ON SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = SE1.E1_FILIAL AND SD2.D2_SERIE = SE1.E1_PREFIXO AND SD2.D2_DOC = SE1.E1_NUM AND SD2.D2_CLIENTE = SE1.E1_CLIENTE AND SD2.D2_LOJA = SE1.E1_LOJA  "
		cQuery += "	LEFT JOIN CTT010 CTT ON CTT.D_E_L_E_T_ = '' AND CTT.CTT_CUSTO = SD2.D2_CCUSTO  "
		cQuery += "	LEFT JOIN CTH010 CTH ON CTH.D_E_L_E_T_ = '' AND CTH.CTH_CLVL = SD2.D2_CLVL  "
		cQuery += "	LEFT JOIN SED010 SED ON SED.D_E_L_E_T_ = '' AND SED.ED_CODIGO = SE1.E1_NATUREZ  "
		cQuery += "	WHERE 1=1    "
		cQuery += "	AND SE1.D_E_L_E_T_ = ''  "
		cQuery += "	AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
		cQuery += " AND SE1.E1_FILIAL >= '"+MV_PAR01+"' "
		cQuery += " AND SE1.E1_FILIAL <= '"+MV_PAR02+"' "
		IF aRotina = "SIGATMK"
			cQuery += " AND SE1.E1_NATUREZ <> 'PUBLICOS' "
		ENDIF
		IF MV_PAR05 = 1
			cQuery += " AND SE1.E1_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ELSE
			cQuery += " AND SE1.E1_VENCREA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ENDIF
		cQuery += " AND ((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) > 1 "
		cQuery += " ORDER BY SE1.E1_VENCREA "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TITABERTO","TITULOS",{(_cAlias)->FILIAL,(_cAlias)->CLIENTE,(_cAlias)->CGC,(_cAlias)->NUMTIT,(_cAlias)->PREFIXO,(_cAlias)->PARCELA,(_cAlias)->SERIENF,(_cAlias)->NUMNF,(_cAlias)->HISTORICO,(_cAlias)->EMISSAO,(_cAlias)->VENCIMENTO,(_cAlias)->VALORTIT,(_cAlias)->VALORNF,(_cAlias)->VALORLIQ,(_cAlias)->SALDO,(_cAlias)->CCUSTO,(_cAlias)->DESCCC,(_cAlias)->CLVL,(_cAlias)->DESCCLVL,(_cAlias)->NATUREZA,(_cAlias)->DESCNATURE})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'TITULOSABERTOS' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
