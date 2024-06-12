//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function ZRELCLICKLIFE()

	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
    //Local cPasta  := ""
 
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
	
	MsAguarde({||fInclusao(cPasta)},"Aguarde","Motando os Dados do Relatorio de Inclusao...") 
	MsAguarde({||fExclusao(cPasta)},"Aguarde","Motando os Dados do Relatorio de Exclusao...")
	
Return

Static Function fInclusao(cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TELEMEDINC")
	oExcel:AddworkSheet("TELEMEDINC")

	lRet := oExcel:IsWorkSheet("PLANILHA1")
	//oExcel:AddTable ("TELEMEDINC","TELEMED")
	oExcel:AddTable ("TELEMEDINC","TELEMED",.F.)
	oExcel:AddColumn("TELEMEDINC","TELEMED","NOME"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","CPF"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","CNPJ"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","EMPRESACLI"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","EMPRESA"		,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","TIPOCONTRATO"	,1,1,.F., "")

	cQuery := " SELECT   "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,   "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,   "
	cQuery += " SA1.A1_CGC		AS CNPJ,   "
	cQuery += " SA1.A1_NREDUZ	AS EMPRESACLI, "
	cQuery += " CASE   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'   "
	cQuery += " 	ELSE ''   "
	cQuery += " END				AS EMPRESA,   "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO "
	cQuery += " FROM BA1010 BA1   "
	cQuery += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = '' AND BQC.BQC_NUMCON = BA1.BA1_CONEMP AND BQC.BQC_VERCON = BA1.BA1_VERCON AND BQC.BQC_CODINT = BA1.BA1_CODINT AND BQC.BQC_CODEMP = BA1.BA1_CODEMP AND BQC.BQC_SUBCON = BA1.BA1_SUBCON AND BQC.BQC_VERSUB = BA1.BA1_VERSUB   "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA   "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BQC.BQC_CODINT AND BT5.BT5_CODIGO = BQC.BQC_CODEMP AND BT5.BT5_NUMCON = BQC.BQC_NUMCON AND BT5.BT5_VERSAO = BQC.BQC_VERCON     "
	cQuery += " WHERE 1=1   "
	cQuery += " AND BA1.D_E_L_E_T_ = ''   "
	cQuery += " AND BA1.BA1_ZATEND = '1'   "
	cQuery += " AND BA1.BA1_DATBLO = ''    "
	cQuery += " AND BA1.BA1_MOTBLO = ''   "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')     "
    cQuery += " AND BA1.BA1_SUBCON IN ('001021545','001022375','001021834','001022019','001023645','001022033','001024685','001025239','001025321','001020615') "
	cQuery += " GROUP BY BA1.BA1_NOMUSR	,BA1.BA1_CPFUSR, SA1.A1_CGC, SA1.A1_NREDUZ, BA1.BA1_FILIAL, BT5.BT5_NOME, BQC.BQC_ESPTEL  "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TELEMEDINC","TELEMED",{(_cAlias)->NOME,(_cAlias)->CPF,(_cAlias)->CNPJ,(_cAlias)->EMPRESACLI,(_cAlias)->EMPRESA,(_cAlias)->TIPOCONTRATO})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'CLICKLIFE_INC_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return

Static Function fExclusao(cPasta)
	
	Local cQuery 
	Local cArqExc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TELEMEDINC")
	oExcel:AddworkSheet("TELEMEDINC")

	lRet := oExcel:IsWorkSheet("PLANILHA1")
	//oExcel:AddTable ("TELEMEDINC","TELEMED")
	oExcel:AddTable ("TELEMEDINC","TELEMED",.F.)
	oExcel:AddColumn("TELEMEDINC","TELEMED","NOME"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","CPF"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","CNPJ"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","EMPRESACLI"	,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","EMPRESA"		,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","TIPOCONTRATO"	,1,1,.F., "")
	
	cQuery := " SELECT   "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,   "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,   "
	cQuery += " SA1.A1_CGC		AS CNPJ,   "
	cQuery += " SA1.A1_NREDUZ	AS EMPRESACLI, "
	cQuery += " CASE   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'   "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'   "
	cQuery += " 	ELSE ''   "
	cQuery += " END				AS EMPRESA,   "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO "
	cQuery += " FROM BA1010 BA1   "
	cQuery += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = '' AND BQC.BQC_NUMCON = BA1.BA1_CONEMP AND BQC.BQC_VERCON = BA1.BA1_VERCON AND BQC.BQC_CODINT = BA1.BA1_CODINT AND BQC.BQC_CODEMP = BA1.BA1_CODEMP AND BQC.BQC_SUBCON = BA1.BA1_SUBCON AND BQC.BQC_VERSUB = BA1.BA1_VERSUB   "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA   "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BQC.BQC_CODINT AND BT5.BT5_CODIGO = BQC.BQC_CODEMP AND BT5.BT5_NUMCON = BQC.BQC_NUMCON AND BT5.BT5_VERSAO = BQC.BQC_VERCON     "
	cQuery += " WHERE 1=1   "
	cQuery += " AND BA1.D_E_L_E_T_ = ''   "
	cQuery += " AND BA1.BA1_ZATEND = '1'   "
	cQuery += " AND BA1.BA1_DATBLO <> ''    "
	cQuery += " AND BA1.BA1_MOTBLO <> ''   "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')     "
    cQuery += " AND BA1.BA1_SUBCON IN ('001021545','001022375','001021834','001022019','001023645','001022033','001024685','001025239','001025321','001020615') "
	cQuery += " GROUP BY BA1.BA1_NOMUSR	,BA1.BA1_CPFUSR, SA1.A1_CGC, SA1.A1_NREDUZ, BA1.BA1_FILIAL, BT5.BT5_NOME, BQC.BQC_ESPTEL  "
	
	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TELEMEDINC","TELEMED",{(_cAlias)->NOME,(_cAlias)->CPF,(_cAlias)->CNPJ, (_cAlias)->EMPRESACLI,(_cAlias)->EMPRESA,(_cAlias)->TIPOCONTRATO})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqExc := cPasta + '\' + 'CLICKLIFE_EXC_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqExc)
	
	oExcel:DeActivate()

Return
