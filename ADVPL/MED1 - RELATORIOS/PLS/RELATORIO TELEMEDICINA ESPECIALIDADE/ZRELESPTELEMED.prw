//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function ZRELESPTELEMED()

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
	

	MsAguarde({||GeraRelatorio(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	
Return

Static Function GeraRelatorio(cPasta)
	
	Local cQuery 
	//Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TELEMEDESP")
	oExcel:AddworkSheet("TELEMEDESP")

	oExcel:AddTable ("TELEMEDESP","TELEMED",.F.)
	oExcel:AddColumn("TELEMEDESP","TELEMED","FILIAL"		,1,1,.F., "")
	oExcel:AddColumn("TELEMEDESP","TELEMED","IDCONTRATO"	,1,1,.F., "")
	oExcel:AddColumn("TELEMEDESP","TELEMED","NOME"			,1,1,.F., "")
	oExcel:AddColumn("TELEMEDESP","TELEMED","QTDVIDAS"		,1,1,.F., "")
	oExcel:AddColumn("TELEMEDESP","TELEMED","VALOR"			,1,3,.F., "")
	

    cQuery := " SELECT   "
	cQuery += " CASE "
	cQuery += " 	WHEN B.BA3_FILIAL = '001' THEN 'MEDICAR RP' "
	cQuery += " 	WHEN B.BA3_FILIAL = '002' THEN 'MEDICAR CAMP' "
	cQuery += " 	WHEN B.BA3_FILIAL = '003' THEN 'MEDICAR SP' "
	cQuery += " 	WHEN B.BA3_FILIAL = '006' THEN 'MEDICAR TECH' "
	cQuery += " 	WHEN B.BA3_FILIAL = '008' THEN 'MEDICAR LIT' "
	cQuery += " 	WHEN B.BA3_FILIAL = '016' THEN 'N1 CARD' "
	cQuery += " 	WHEN B.BA3_FILIAL = '021' THEN 'MEDICAR RJ' "
	cQuery += " ELSE '' "
	cQuery += " END AS FILIAL, "
	cQuery += " A.BQC_SUBCON		AS IDCONTRATO, "
	cQuery += " E.A1_NOME			AS NOME, "
	cQuery += " COUNT(*)			AS QTDVIDAS, "
	cQuery += " SUM(D.BDK_VALOR)	AS VALOR "
    cQuery += " FROM BQC010 A   "
    cQuery += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''   "
    cQuery += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''   "
    cQuery += " LEFT JOIN BDK010 D ON D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''   "
    cQuery += " LEFT JOIN SA1010 E ON E.A1_COD = A.BQC_CODCLI AND E.A1_LOJA = A.BQC_LOJA AND E.D_E_L_E_T_ = '' "
	cQuery += " WHERE 1=1   "
	cQuery += " AND A.D_E_L_E_T_ ='' "
	cQuery += " AND A.BQC_COBNIV = '1' "
	cQuery += " AND A.BQC_CODEMP IN ('0004','0005') "
	cQuery += " AND A.BQC_CODBLO = '' "
	cQuery += " AND A.BQC_DATBLO = '' "
	cQuery += " AND A.BQC_ESPTEL = '1' "
	cQuery += " GROUP BY B.BA3_FILIAL,A.BQC_SUBCON,E.A1_NOME "
	cQuery += " UNION ALL "
	cQuery += " SELECT "
	cQuery += " CASE "
	cQuery += " 	WHEN B.BA3_FILIAL = '001' THEN 'MEDICAR RP' "
	cQuery += " 	WHEN B.BA3_FILIAL = '002' THEN 'MEDICAR CAMP' "
	cQuery += " 	WHEN B.BA3_FILIAL = '003' THEN 'MEDICAR SP' "
	cQuery += " 	WHEN B.BA3_FILIAL = '006' THEN 'MEDICAR TECH' "
	cQuery += " 	WHEN B.BA3_FILIAL = '008' THEN 'MEDICAR LIT' "
	cQuery += " 	WHEN B.BA3_FILIAL = '016' THEN 'N1 CARD' "
	cQuery += " 	WHEN B.BA3_FILIAL = '021' THEN 'MEDICAR RJ' "
	cQuery += " ELSE '' "
	cQuery += " END AS FILIAL, "
	cQuery += " CASE "
	cQuery += " 	WHEN B.BA3_IDBENN <> '' THEN B.BA3_IDBENN "
	cQuery += " 	ELSE B.BA3_MATEMP "
	cQuery += " END 				AS IDCONTRATO, "
	cQuery += " E.A1_NOME			AS NOME, "
	cQuery += " COUNT(*)			AS QTDVIDAS, "
	cQuery += " SUM(D.BDK_VALOR)	AS VALOR "
    cQuery += " FROM BQC010 A   "
    cQuery += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''   "
    cQuery += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''   "
    cQuery += " LEFT JOIN BDK010 D ON D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''   "
    cQuery += " LEFT JOIN SA1010 E ON E.A1_COD = B.BA3_CODCLI AND E.A1_LOJA = B.BA3_LOJA AND E.D_E_L_E_T_ = '' "
	cQuery += " WHERE 1=1   "
	cQuery += " AND A.D_E_L_E_T_ ='' "
	cQuery += " AND B.BA3_COBNIV = '1' "
	cQuery += " AND B.BA3_CODEMP IN ('0003','0006') "
	cQuery += " AND B.BA3_MOTBLO = '' "
	cQuery += " AND B.BA3_DATBLO = '' "
	cQuery += " AND B.BA3_ESPTEL = '1' "
	cQuery += " GROUP BY B.BA3_FILIAL,B.BA3_IDBENN,BA3_MATEMP,E.A1_NOME "
	


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TELEMEDESP","TELEMED",{(_cAlias)->FILIAL,(_cAlias)->IDCONTRATO,(_cAlias)->NOME,(_cAlias)->QTDVIDAS,(_cAlias)->VALOR})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()

	oExcel:GetXMLFile(cPasta + '\TELEMEDESP_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx')
	
	oExcel:DeActivate()

Return

