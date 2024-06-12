//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELFATXCLI()

	DEFAULT cCPergTrue := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZFILFXC" // Nome do grupo de perguntas
 

	/* ---------------------------- PERGUNTAS E FILTROS ---------------------------- */

	If !Empty(cCPergTrue)
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
	
	Local cQueryFAT 
	Local cQueryCLI 
	Local cArqBem
	Private _cAliasFAT := GetNextAlias()
	Private _cAliasCLI := GetNextAlias()


	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */

	oExcel := FwMsExcelXlsx():New()

	oExcel:AddworkSheet("FATURAMENTO")
	oExcel:AddTable ("FATURAMENTO","LISTFAT",.F.)
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "FILIAL",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "SERIE",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "DOC",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "EMISSAO",	1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "VENCTO",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "VENCTOREAL",	1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CODCLI",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CLIENTE",	1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CGC",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "VALORFAT",	1,3,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CC",			1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "DESCCC",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CLVL",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "DESCCLVL",	1,1,.F.,"")

	oExcel:AddworkSheet("CADCLI")
	oExcel:AddTable ("CADCLI","LISTCLI",.F.)
	oExcel:AddColumn("CADCLI","LISTCLI", "CODCLI",	1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "CLIENTE",	1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "CGC",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "DATAINC",	1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "USERCRI",	1,1,.F.,"")


		cQueryFAT := " SELECT "
		cQueryFAT += " A.D2_FILIAL		AS FILIAL, "
		cQueryFAT += " A.D2_SERIE		AS SERIE, "
		cQueryFAT += " A.D2_DOC			AS DOC, "
		cQueryFAT += " CONCAT(SUBSTRING(A.D2_EMISSAO,7,2),'/',SUBSTRING(A.D2_EMISSAO,5,2),'/',SUBSTRING(A.D2_EMISSAO,1,4)) AS EMISSAO, "
		cQueryFAT += " CONCAT(SUBSTRING(B.E1_VENCTO,7,2),'/',SUBSTRING(B.E1_VENCTO,5,2),'/',SUBSTRING(B.E1_VENCTO,1,4)) AS VENCTO, "
		cQueryFAT += " CONCAT(SUBSTRING(B.E1_VENCREA,7,2),'/',SUBSTRING(B.E1_VENCREA,5,2),'/',SUBSTRING(B.E1_VENCREA,1,4)) AS VENCTOREAL, "
		cQueryFAT += " C.A1_COD			AS CODCLI, "
		cQueryFAT += " C.A1_NREDUZ		AS CLIENTE, "
		cQueryFAT += " CASE "
		cQueryFAT += " 	WHEN C.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(C.A1_CGC,1,3), '.', SUBSTRING(C.A1_CGC,4,3), '.', SUBSTRING(C.A1_CGC,7,3), '-', SUBSTRING(C.A1_CGC,10,2)) "
		cQueryFAT += " 	ELSE CONCAT(SUBSTRING(C.A1_CGC,1,2), '.', SUBSTRING(C.A1_CGC,3,3), '.', SUBSTRING(C.A1_CGC,6,3), '/', SUBSTRING(C.A1_CGC,9,4), '-', SUBSTRING(C.A1_CGC,13,2)) "
		cQueryFAT += " END 				AS CGC, "
		cQueryFAT += " A.D2_TOTAL		AS VALORFAT, "
		cQueryFAT += " A.D2_CCUSTO		AS CC, "
		cQueryFAT += " D.CTT_DESC01		AS DESCCC, "
		cQueryFAT += " A.D2_CLVL		AS CLVL, "
		cQueryFAT += " E.CTH_DESC01		AS DESCCLVL "
		cQueryFAT += " FROM SD2010 A "
		cQueryFAT += " LEFT JOIN SE1010 B ON B.D_E_L_E_T_ = '' AND B.E1_FILIAL = A.D2_FILIAL AND B.E1_PREFIXO = A.D2_SERIE AND B.E1_NUM = A.D2_DOC AND B.E1_CLIENTE = A.D2_CLIENTE AND B.E1_LOJA = A.D2_LOJA "
		cQueryFAT += " LEFT JOIN SA1010 C ON C.D_E_L_E_T_ = '' AND C.A1_COD = A.D2_CLIENTE AND C.A1_LOJA = A.D2_LOJA "
		cQueryFAT += " LEFT JOIN CTT010 D ON D.D_E_L_E_T_ = '' AND D.CTT_CUSTO = A.D2_CCUSTO "
		cQueryFAT += " LEFT JOIN CTH010 E ON E.D_E_L_E_T_ = '' AND E.CTH_CLVL = A.D2_CLVL "
		cQueryFAT += " WHERE 1=1 "
		cQueryFAT += " AND A.D_E_L_E_T_ = '' "
		cQueryFAT += " AND B.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
		cQueryFAT += " AND A.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "


		cQueryCLI := " SELECT "
		cQueryCLI += " A.A1_COD		AS CODCLI, "
		cQueryCLI += " A.A1_NREDUZ	AS CLIENTE, "
		cQueryCLI += " CASE "																											
		cQueryCLI += " 	WHEN A.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(A.A1_CGC,1,3), '.', SUBSTRING(A.A1_CGC,4,3), '.', SUBSTRING(A.A1_CGC,7,3), '-', SUBSTRING(A.A1_CGC,10,2))  "
		cQueryCLI += " 	ELSE CONCAT(SUBSTRING(A.A1_CGC,1,2), '.', SUBSTRING(A.A1_CGC,3,3), '.', SUBSTRING(A.A1_CGC,6,3), '/', SUBSTRING(A.A1_CGC,9,4), '-', SUBSTRING(A.A1_CGC,13,2))  "
		cQueryCLI += " END 			AS CGC,  "
		cQueryCLI += " CASE  "
		cQueryCLI += " 	WHEN SUBSTRING(A.A1_USERLGI, 03, 1) != ' ' AND A.A1_USERLGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(A.A1_USERLGI,12,1)) - 50, ASCII(SUBSTRING(A.A1_USERLGI,16,1)) - 50) + IIF(SUBSTRING(A.A1_USERLGI,08,1) = '<',10000,0)),'1996-01-01'), 103) "
    	cQueryCLI += " 	ELSE '' "
    	cQueryCLI += " END 			AS DATAINC "
		cQueryCLI += " FROM SA1010 A "
		cQueryCLI += " WHERE 1=1 "
		cQueryCLI += " AND A.D_E_L_E_T_ = '' "
		cQueryCLI += " AND CONVERT(datetime, CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(A.A1_USERLGI,12,1)) - 50, ASCII(SUBSTRING(A.A1_USERLGI,16,1)) - 50) + IIF(SUBSTRING(A.A1_USERLGI,08,1) = '<',10000,0)),'1996-01-01'), 103), 103) BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "


	//Criar alias temporário
	TCQUERY cQueryFAT NEW ALIAS (_cAliasFAT)
	TCQUERY cQueryCLI NEW ALIAS (_cAliasCLI)


	DbSelectArea(_cAliasFAT)
	DbSelectArea(_cAliasCLI)
	

	While (_cAliasFAT)->(!Eof())

		oExcel:AddRow("FATURAMENTO","LISTFAT",{(_cAliasFAT)->FILIAL, (_cAliasFAT)->SERIE, (_cAliasFAT)->DOC, (_cAliasFAT)->EMISSAO, (_cAliasFAT)->VENCTO, (_cAliasFAT)->VENCTOREAL, (_cAliasFAT)->CODCLI, (_cAliasFAT)->CLIENTE, (_cAliasFAT)->CGC, (_cAliasFAT)->VALORFAT, (_cAliasFAT)->CC, (_cAliasFAT)->DESCCC, (_cAliasFAT)->CLVL, (_cAliasFAT)->DESCCLVL})

		(_cAliasFAT)->(dBskip())

	EndDo


	While (_cAliasCLI)->(!Eof())

		oExcel:AddRow("CADCLI","LISTCLI",{(_cAliasCLI)->CODCLI,(_cAliasCLI)->CLIENTE,(_cAliasCLI)->CGC,(_cAliasCLI)->DATAINC})

		(_cAliasCLI)->(dBskip())

	EndDo
	

	(_cAliasFAT)->(DbCloseArea())
	(_cAliasCLI)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'FATXCLI' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
