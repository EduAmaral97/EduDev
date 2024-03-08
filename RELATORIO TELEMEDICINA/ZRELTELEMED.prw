//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function ZRELTELEMED()

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
	oExcel:AddColumn("TELEMEDINC","TELEMED","EMPRESA"		,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","TIPOCONTRATO"	,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","TELEESP"		,1,1,.F., "")
	
	cQuery := " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BA3.BA3_ESPTEL	AS TELEESP  "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BA3010 BA3 ON BA3.D_E_L_E_T_ = '' AND BA3.BA3_FILIAL = BA1.BA1_FILIAL AND BA3.BA3_CODINT = BA1.BA1_CODINT AND BA3.BA3_CODEMP = BA1.BA1_CODEMP AND BA3.BA3_MATRIC = BA1.BA1_MATRIC AND BA3.BA3_CONEMP = BA1.BA1_CONEMP AND BA3.BA3_VERCON = BA1.BA1_VERCON AND BA3.BA3_SUBCON = BA1.BA1_SUBCON AND BA3.BA3_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BA3.BA3_CODCLI AND SA1.A1_LOJA = BA3.BA3_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BA3.BA3_CODINT AND BT5.BT5_CODIGO = BA3.BA3_CODEMP AND BT5.BT5_NUMCON = BA3.BA3_CONEMP AND BT5.BT5_VERSAO = BA3.BA3_VERCON    "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO = ''   "
	cQuery += " AND BA1.BA1_MOTBLO = ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0003','0006')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000006','000000000003','000000000004','000000000007','000000000008')  "
	cQuery += " UNION  "
	cQuery += " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BQC.BQC_ESPTEL	AS TELEESP  "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = '' AND BQC.BQC_NUMCON = BA1.BA1_CONEMP AND BQC.BQC_VERCON = BA1.BA1_VERCON AND BQC.BQC_CODINT = BA1.BA1_CODINT AND BQC.BQC_CODEMP = BA1.BA1_CODEMP AND BQC.BQC_SUBCON = BA1.BA1_SUBCON AND BQC.BQC_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BQC.BQC_CODINT AND BT5.BT5_CODIGO = BQC.BQC_CODEMP AND BT5.BT5_NUMCON = BQC.BQC_NUMCON AND BT5.BT5_VERSAO = BQC.BQC_VERCON    "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO = ''   "
	cQuery += " AND BA1.BA1_MOTBLO = ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0004','0005')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000028','000000000017','000000000031','000000000014','000000000012','000000000002') "
	cQuery += " UNION "
	cQuery += " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  " 
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BA3.BA3_ESPTEL	AS TELEESP "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BA3010 BA3 ON BA3.D_E_L_E_T_ = '' AND BA3.BA3_FILIAL = BA1.BA1_FILIAL AND BA3.BA3_CODINT = BA1.BA1_CODINT AND BA3.BA3_CODEMP = BA1.BA1_CODEMP AND BA3.BA3_MATRIC = BA1.BA1_MATRIC AND BA3.BA3_CONEMP = BA1.BA1_CONEMP AND BA3.BA3_VERCON = BA1.BA1_VERCON AND BA3.BA3_SUBCON = BA1.BA1_SUBCON AND BA3.BA3_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BA3.BA3_CODCLI AND SA1.A1_LOJA = BA3.BA3_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BA3.BA3_CODINT AND BT5.BT5_CODIGO = BA3.BA3_CODEMP AND BT5.BT5_NUMCON = BA3.BA3_CONEMP AND BT5.BT5_VERSAO = BA3.BA3_VERCON    "
	cQuery += " LEFT JOIN BF4010 BF4 ON BF4.D_E_L_E_T_ = '' AND	BF4.BF4_FILIAL = BA1.BA1_FILIAL AND BF4.BF4_CODINT = BA1.BA1_CODINT AND BF4.BF4_CODEMP = BA1.BA1_CODEMP AND BF4.BF4_MATRIC = BA1.BA1_MATRIC AND BF4.BF4_TIPREG = BA1.BA1_TIPREG "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO = ''   "
	cQuery += " AND BA1.BA1_MOTBLO = ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0003','0006')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000005')  "
	cQuery += " AND BF4.BF4_CODPRO IN ('0036','0040','0071','0066') "
	cQuery += " UNION  "
	cQuery += " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BQC.BQC_ESPTEL	AS TELEESP  "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = '' AND BQC.BQC_NUMCON = BA1.BA1_CONEMP AND BQC.BQC_VERCON = BA1.BA1_VERCON AND BQC.BQC_CODINT = BA1.BA1_CODINT AND BQC.BQC_CODEMP = BA1.BA1_CODEMP AND BQC.BQC_SUBCON = BA1.BA1_SUBCON AND BQC.BQC_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BQC.BQC_CODINT AND BT5.BT5_CODIGO = BQC.BQC_CODEMP AND BT5.BT5_NUMCON = BQC.BQC_NUMCON AND BT5.BT5_VERSAO = BQC.BQC_VERCON    "
	cQuery += " LEFT JOIN BF4010 BF4 ON BF4.D_E_L_E_T_ = '' AND	BF4.BF4_FILIAL = BA1.BA1_FILIAL AND BF4.BF4_CODINT = BA1.BA1_CODINT AND BF4.BF4_CODEMP = BA1.BA1_CODEMP AND BF4.BF4_MATRIC = BA1.BA1_MATRIC AND BF4.BF4_TIPREG = BA1.BA1_TIPREG "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO = ''   "
	cQuery += " AND BA1.BA1_MOTBLO = ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0004','0005')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000010')  "
	cQuery += " AND BF4.BF4_CODPRO IN ('0036','0040','0071','0066') "
	cQuery += " GROUP BY BA1.BA1_NOMUSR	,BA1.BA1_CPFUSR, SA1.A1_CGC, BA1.BA1_FILIAL, BT5.BT5_NOME, BQC.BQC_ESPTEL "

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TELEMEDINC","TELEMED",{(_cAlias)->NOME,(_cAlias)->CPF,(_cAlias)->CNPJ,(_cAlias)->EMPRESA,(_cAlias)->TIPOCONTRATO,(_cAlias)->TELEESP})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TELEMEDINC_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
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
	oExcel:AddColumn("TELEMEDINC","TELEMED","EMPRESA"		,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","TIPOCONTRATO"	,1,1,.F., "")
	oExcel:AddColumn("TELEMEDINC","TELEMED","TELEESP"		,1,1,.F., "")
	
	cQuery := " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BA3.BA3_ESPTEL	AS TELEESP  "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BA3010 BA3 ON BA3.D_E_L_E_T_ = '' AND BA3.BA3_FILIAL = BA1.BA1_FILIAL AND BA3.BA3_CODINT = BA1.BA1_CODINT AND BA3.BA3_CODEMP = BA1.BA1_CODEMP AND BA3.BA3_MATRIC = BA1.BA1_MATRIC AND BA3.BA3_CONEMP = BA1.BA1_CONEMP AND BA3.BA3_VERCON = BA1.BA1_VERCON AND BA3.BA3_SUBCON = BA1.BA1_SUBCON AND BA3.BA3_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BA3.BA3_CODCLI AND SA1.A1_LOJA = BA3.BA3_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BA3.BA3_CODINT AND BT5.BT5_CODIGO = BA3.BA3_CODEMP AND BT5.BT5_NUMCON = BA3.BA3_CONEMP AND BT5.BT5_VERSAO = BA3.BA3_VERCON    "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO >= CONVERT(DATE, '2024-02-01') "
	cQuery += " AND BA1.BA1_MOTBLO <> ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0003','0006')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000006','000000000003','000000000004','000000000007','000000000008')  "
	cQuery += " UNION  "
	cQuery += " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BQC.BQC_ESPTEL	AS TELEESP  "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = '' AND BQC.BQC_NUMCON = BA1.BA1_CONEMP AND BQC.BQC_VERCON = BA1.BA1_VERCON AND BQC.BQC_CODINT = BA1.BA1_CODINT AND BQC.BQC_CODEMP = BA1.BA1_CODEMP AND BQC.BQC_SUBCON = BA1.BA1_SUBCON AND BQC.BQC_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BQC.BQC_CODINT AND BT5.BT5_CODIGO = BQC.BQC_CODEMP AND BT5.BT5_NUMCON = BQC.BQC_NUMCON AND BT5.BT5_VERSAO = BQC.BQC_VERCON    "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO >= CONVERT(DATE, '2024-02-01') "
	cQuery += " AND BA1.BA1_MOTBLO <> '' "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0004','0005')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000028','000000000017','000000000031','000000000014','000000000012','000000000002') "
	cQuery += " UNION "
	cQuery += " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BA3.BA3_ESPTEL	AS TELEESP "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BA3010 BA3 ON BA3.D_E_L_E_T_ = '' AND BA3.BA3_FILIAL = BA1.BA1_FILIAL AND BA3.BA3_CODINT = BA1.BA1_CODINT AND BA3.BA3_CODEMP = BA1.BA1_CODEMP AND BA3.BA3_MATRIC = BA1.BA1_MATRIC AND BA3.BA3_CONEMP = BA1.BA1_CONEMP AND BA3.BA3_VERCON = BA1.BA1_VERCON AND BA3.BA3_SUBCON = BA1.BA1_SUBCON AND BA3.BA3_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BA3.BA3_CODCLI AND SA1.A1_LOJA = BA3.BA3_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BA3.BA3_CODINT AND BT5.BT5_CODIGO = BA3.BA3_CODEMP AND BT5.BT5_NUMCON = BA3.BA3_CONEMP AND BT5.BT5_VERSAO = BA3.BA3_VERCON    "
	cQuery += " LEFT JOIN BF4010 BF4 ON BF4.D_E_L_E_T_ = '' AND	BF4.BF4_FILIAL = BA1.BA1_FILIAL AND BF4.BF4_CODINT = BA1.BA1_CODINT AND BF4.BF4_CODEMP = BA1.BA1_CODEMP AND BF4.BF4_MATRIC = BA1.BA1_MATRIC AND BF4.BF4_TIPREG = BA1.BA1_TIPREG "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO >= CONVERT(DATE, '2024-02-01') "
	cQuery += " AND BA1.BA1_MOTBLO <> ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0003','0006')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000005')  "
	cQuery += " AND BF4.BF4_CODPRO IN ('0036','0040','0071','0066') "
	cQuery += " UNION  "
	cQuery += " SELECT  "
	cQuery += " BA1.BA1_NOMUSR	AS NOME,  "
	cQuery += " BA1.BA1_CPFUSR	AS CPF,  "
	cQuery += " SA1.A1_CGC		AS CNPJ,  "
	cQuery += " CASE  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '001' THEN 'MEDICAR RIBEIRAO PRETO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '002' THEN 'MEDICAR CAMPINAS'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '003' THEN 'MEDICAR SAO PAULO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '016' THEN 'N1 CARD'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '021' THEN 'MEDICAR RIO DE JANEIRO'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '006' THEN 'MEDICAR TECH'  "
	cQuery += " 	WHEN BA1.BA1_FILIAL = '008' THEN 'MEDICAR LITORAL'  "
	cQuery += " 	ELSE ''  "
	cQuery += " END				AS EMPRESA,  "
	cQuery += " BT5.BT5_NOME	AS TIPOCONTRATO,  "
	cQuery += " BQC.BQC_ESPTEL	AS TELEESP  "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = '' AND BQC.BQC_NUMCON = BA1.BA1_CONEMP AND BQC.BQC_VERCON = BA1.BA1_VERCON AND BQC.BQC_CODINT = BA1.BA1_CODINT AND BQC.BQC_CODEMP = BA1.BA1_CODEMP AND BQC.BQC_SUBCON = BA1.BA1_SUBCON AND BQC.BQC_VERSUB = BA1.BA1_VERSUB  "
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA  "
	cQuery += " LEFT JOIN BT5010 BT5 ON BT5.D_E_L_E_T_ = '' AND BT5.BT5_CODINT = BQC.BQC_CODINT AND BT5.BT5_CODIGO = BQC.BQC_CODEMP AND BT5.BT5_NUMCON = BQC.BQC_NUMCON AND BT5.BT5_VERSAO = BQC.BQC_VERCON    "
	cQuery += " LEFT JOIN BF4010 BF4 ON BF4.D_E_L_E_T_ = '' AND	BF4.BF4_FILIAL = BA1.BA1_FILIAL AND BF4.BF4_CODINT = BA1.BA1_CODINT AND BF4.BF4_CODEMP = BA1.BA1_CODEMP AND BF4.BF4_MATRIC = BA1.BA1_MATRIC AND BF4.BF4_TIPREG = BA1.BA1_TIPREG "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_ZATEND = '1'  "
	cQuery += " AND BA1.BA1_DATBLO >= CONVERT(DATE, '2024-02-01') "
	cQuery += " AND BA1.BA1_MOTBLO <> ''  "
	cQuery += " AND BA1.BA1_FILIAL IN ('001','002','003','016','021','006','008')  "
	cQuery += " AND BA1.BA1_CODEMP IN ('0004','0005')  "
	cQuery += " AND BA1.BA1_CONEMP IN ('000000000010')  "
	cQuery += " AND BF4.BF4_CODPRO IN ('0036','0040','0071','0066') "
	cQuery += " GROUP BY BA1.BA1_NOMUSR	,BA1.BA1_CPFUSR, SA1.A1_CGC, BA1.BA1_FILIAL, BT5.BT5_NOME, BQC.BQC_ESPTEL "

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TELEMEDINC","TELEMED",{(_cAlias)->NOME,(_cAlias)->CPF,(_cAlias)->CNPJ,(_cAlias)->EMPRESA,(_cAlias)->TIPOCONTRATO,(_cAlias)->TELEESP})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqExc := cPasta + '\' + 'TELEMEDEXC_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqExc)
	
	oExcel:DeActivate()

Return
