//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
TITULO - 002355
*/


User Function ZRELAGRUPCTR()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRCTRAGRUP" // Nome do grupo de perguntas
 

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

	lRet := oExcel:IsWorkSheet("AGRUPCTR")
	oExcel:AddworkSheet("AGRUPCTR")


	/* -------------------------------------------------------------------------
	cWorkSheet	 - 	Caracteres - 	Nome da planilha	
	cTable		 - 	Caracteres - 	Nome da tabela	
	cColumn		 - 	Caracteres - 	Titulo da tabela que será adicionada	
	nAlign		 - 	Numérico   -	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	
	nFormat		 - 	Numérico   -	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	
	lTotal		 - 	Lógico	   -	Indica se a coluna deve ser totalizada	
	 -------------------------------------------------------------------------*/
	oExcel:AddTable ("AGRUPCTR","DADOSCTR",.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "AGRUPAMENTO"	,1,1,.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "RAZAOSOC"		,1,1,.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "NOMEFANT"		,1,1,.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "CNPJ"			,1,1,.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "QTDCTR"		,3,2,.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "QTDVIDAS"		,3,2,.F.)
	oExcel:AddColumn("AGRUPCTR","DADOSCTR", "VALORCTR"		,3,3,.F.)


		cQuery := " SELECT  "
		cQuery += " F.AOV_DESSEG		AS AGRUPAMENTO, "
		cQuery += " E.A1_NOME			AS RAZAOSOC, "
		cQuery += " E.A1_NREDUZ			AS NOMFANT, "
		cQuery += " E.A1_CGC			AS CNPJ, "
		cQuery += " COUNT(A.BQC_SUBCON) AS QTDCTR, "
		cQuery += " ISNULL((SELECT COUNT(*) AS QTDVIDAS FROM BA3010 B  LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = C.BA1_SUBCON AND B.BA3_VERCON = C.BA1_VERCON AND C.BA1_VERSUB = B.BA3_VERSUB AND C.BA1_MATEMP = B.BA3_MATEMP WHERE 1=1 AND B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND C.BA1_MOTBLO = '' AND C.BA1_DATBLO = ''),0) AS QTDVID, "
		cQuery += " ISNULL((SELECT ROUND(SUM(D.BDK_VALOR),2) AS VALOR FROM BA3010 B LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = C.BA1_SUBCON AND B.BA3_VERCON = C.BA1_VERCON AND C.BA1_VERSUB = B.BA3_VERSUB AND C.BA1_MATEMP = B.BA3_MATEMP LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG WHERE 1=1 AND B.D_E_L_E_T_ = ''  AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND C.BA1_MOTBLO = '' AND C.BA1_DATBLO = ''),0) AS VALORCTR "
		cQuery += " FROM BQC010 A   "
		cQuery += " LEFT JOIN SA1010 E ON E.D_E_L_E_T_ = '' AND E.A1_COD = A.BQC_CODCLI AND E.A1_LOJA = A.BQC_LOJA "
		cQuery += " LEFT JOIN AOV010 F ON F.D_E_L_E_T_ = '' AND F.AOV_CODSEG = E.A1_CODSEG "
		cQuery += " WHERE 1=1 "
		cQuery += " AND A.D_E_L_E_T_ = ''    "
		cQuery += " AND E.A1_CODSEG = '"+MV_PAR01+"' "
		cQuery += " GROUP BY F.AOV_DESSEG,E.A1_NOME,E.A1_NREDUZ,E.A1_CGC,A.BQC_CODINT,A.BQC_CODEMP,A.BQC_NUMCON,A.BQC_SUBCON "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("AGRUPCTR","DADOSCTR",{(_cAlias)->AGRUPAMENTO,(_cAlias)->RAZAOSOC,(_cAlias)->NOMFANT,(_cAlias)->CNPJ,(_cAlias)->QTDCTR,(_cAlias)->QTDVID,(_cAlias)->VALORCTR})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'AGRUPAMENTOCTR' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
