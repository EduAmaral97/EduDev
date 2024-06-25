//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*

TITULO - 002355

*/


User Function ZRACOMPNF()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZFILFXC" // Nome do grupo de perguntas
 

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

	lRet := oExcel:IsWorkSheet("ACOMPNF")
	oExcel:AddworkSheet("ACOMPNF")
	
	oExcel:AddTable ("ACOMPNF","D_ACOMPNF",.F.)
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "FILIAL"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "PEFIXO"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "TITULO"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "DATA_CONTPG"	,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "NUMERO_NOTA"	,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "DATA_DOCENT"	,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "PEDIDO"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "DATA_PC"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "NUMERO_OS"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "DATA_OS"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "CODFOR"		,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "FORNECEDOR"	,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "VENCIMENTO"	,1,1,.F., "")
	oExcel:AddColumn("ACOMPNF","D_ACOMPNF", "VALOR"			,1,3,.F., "@E 999,999,999.99")


	// ST9 -> STJ -> STL -> SC1 -> SC7 -> SD1 -> SE2
	cQuery := " SELECT  "
	cQuery += " A.E2_FILIAL		AS FILIAL, "
	cQuery += " A.E2_PREFIXO	AS PREFIXO, "
	cQuery += " A.E2_NUM		AS TITULO, "
 	cQuery += " CASE WHEN SUBSTRING(A.E2_USERLGI, 03, 1) != ' ' AND A.E2_USERLGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(A.E2_USERLGI,12,1)) - 50, ASCII(SUBSTRING(A.E2_USERLGI,16,1)) - 50) + IIF(SUBSTRING(A.E2_USERLGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '' END  AS DTCTPG, "
	cQuery += " B.D1_DOC		AS NUMNOTA, "
	cQuery += " CASE WHEN SUBSTRING(B.D1_USERLGI, 03, 1) != ' ' AND B.D1_USERLGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(B.D1_USERLGI,12,1)) - 50, ASCII(SUBSTRING(B.D1_USERLGI,16,1)) - 50) + IIF(SUBSTRING(B.D1_USERLGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '' END  AS DTDOCENT, "
 	cQuery += " C.C7_NUM		AS PEDIDO, "
	cQuery += " CASE WHEN SUBSTRING(C.C7_USERLGI, 03, 1) != ' ' AND C.C7_USERLGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(C.C7_USERLGI,12,1)) - 50, ASCII(SUBSTRING(C.C7_USERLGI,16,1)) - 50) + IIF(SUBSTRING(C.C7_USERLGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '' END  AS DTPEDIDO, "
	cQuery += " F.TJ_ORDEM			AS NUMOS, "
	cQuery += " CONCAT(SUBSTRING(F.TJ_DTORIGI,7,2),'/',SUBSTRING(F.TJ_DTORIGI,5,2),'/',SUBSTRING(F.TJ_DTORIGI,1,4)) AS DTOS, "
	cQuery += " G.A2_COD		AS CODFOR, "
	cQuery += " G.A2_NOME		AS FORNECEDOR, "
	cQuery += " CONCAT(SUBSTRING(A.E2_VENCREA,7,2),'/',SUBSTRING(A.E2_VENCREA,5,2),'/',SUBSTRING(A.E2_VENCREA,1,4)) AS VENCIMENTO, "
	cQuery += " A.E2_VALOR		AS VALOR "
	cQuery += " FROM SE2010 A "
	cQuery += " LEFT JOIN SD1010 B ON B.D_E_L_E_T_ = '' AND B.D1_FILIAL = A.E2_FILIAL AND B.D1_SERIE = A.E2_PREFIXO AND B.D1_DOC = A.E2_NUM AND B.D1_FORNECE = A.E2_FORNECE AND B.D1_LOJA = A.E2_LOJA "
	cQuery += " LEFT JOIN SC7010 C ON C.D_E_L_E_T_ = '' AND C.C7_FILIAL = B.D1_FILIAL AND C.C7_NUM = B.D1_PEDIDO AND C.C7_PRODUTO = B.D1_COD AND C.C7_ITEM  = B.D1_ITEMPC "
	cQuery += " LEFT JOIN SC1010 D ON D.D_E_L_E_T_ = '' AND D.C1_FILIAL = C.C7_FILIAL AND D.C1_NUM = C.C7_NUMSC AND D.C1_PRODUTO = C.C7_PRODUTO AND D.C1_ITEM = C.C7_ITEMSC "
	cQuery += " LEFT JOIN STL010 E ON E.D_E_L_E_T_ = '' AND E.TL_FILIAL = D.C1_FILIAL AND E.TL_NUMSC = D.C1_NUM AND CASE WHEN E.TL_TIPOREG = 'T' THEN 'TERCEIROS' ELSE E.TL_CODIGO END = D.C1_PRODUTO AND E.TL_ITEMSC = D.C1_ITEM "
	cQuery += " LEFT JOIN STJ010 F ON F.D_E_L_E_T_ = '' AND F.TJ_FILIAL = E.TL_FILIAL AND F.TJ_ORDEM = E.TL_ORDEM "
	cQuery += " LEFT JOIN SA2010 G ON G.D_E_L_E_T_ = '' AND G.A2_COD = A.E2_FORNECE AND G.A2_LOJA = A.E2_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	cQuery += " AND A.E2_FORNECE NOT IN ('000004','006471','006487','006491','006494','007084','007085','007087','007089','MUNIC;') "
	cQuery += " GROUP BY A.E2_FILIAL,A.E2_PREFIXO,A.E2_NUM,A.E2_USERLGI,B.D1_DOC,B.D1_USERLGI,C.C7_NUM,C.C7_USERLGI,F.TJ_ORDEM,F.TJ_DTORIGI,G.A2_COD,G.A2_NOME,A.E2_VENCREA,A.E2_VALOR "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("ACOMPNF","D_ACOMPNF",{ (_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->TITULO,(_cAlias)->DTCTPG,(_cAlias)->NUMNOTA,(_cAlias)->DTDOCENT,(_cAlias)->PEDIDO,(_cAlias)->DTPEDIDO,(_cAlias)->NUMOS,(_cAlias)->DTOS,(_cAlias)->CODFOR,(_cAlias)->FORNECEDOR,(_cAlias)->VENCIMENTO,(_cAlias)->VALOR })



		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'ACOMPANHAMENTO_NF_ENTRADA' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
