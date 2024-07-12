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
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "VALORFAT",	1,3,.F.,"@E 999,999,999.99")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CC",			1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "DESCCC",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "CLVL",		1,1,.F.,"")
	oExcel:AddColumn("FATURAMENTO","LISTFAT", "DESCCLVL",	1,1,.F.,"")

	oExcel:AddworkSheet("CADCLI")
	oExcel:AddTable ("CADCLI","LISTCLI",.F.)
	oExcel:AddColumn("CADCLI","LISTCLI", "FILIAL",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "IDCONTRATO",	1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "NUMERO",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "PERFIL",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "CODCLI",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "CLIENTE",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "DTINC",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "DTALT",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "STATUSC",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "DTBLOQ",		1,1,.F.,"")
	oExcel:AddColumn("CADCLI","LISTCLI", "VALOR",		1,3,.F.,"@E 999,999,999.99")
	oExcel:AddColumn("CADCLI","LISTCLI", "TIPOCTR",		1,1,.F.,"")


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
		cQueryCLI += " ISNULL(( SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB ),'')   AS FILIAL, "
		cQueryCLI += " A.BQC_SUBCON     AS IDCONTRATO,  "
		cQueryCLI += " A.BQC_ANTCON     AS NUMERO,  "
		cQueryCLI += " E.BT5_NOME       AS PERFIL,  "
		cQueryCLI += " SA1.A1_COD       AS CODCLI,  "
		cQueryCLI += " SA1.A1_NOME      AS CLIENTE,  "
		cQueryCLI += " CASE WHEN SUBSTRING(A.BQC_USERGI, 03, 1) != ' ' AND A.BQC_USERGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(A.BQC_USERGI,12,1)) - 50, ASCII(SUBSTRING(A.BQC_USERGI,16,1)) - 50) + IIF(SUBSTRING(A.BQC_USERGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '01/01/1900' END AS DTINC, "
		cQueryCLI += " ISNULL(( SELECT MAX(CASE WHEN SUBSTRING(BA3DT.BA3_USERGA, 03, 1) != ' ' AND BA3DT.BA3_USERGA != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(BA3DT.BA3_USERGA,12,1)) - 50, ASCII(SUBSTRING(BA3DT.BA3_USERGA,16,1)) - 50) + IIF(SUBSTRING(BA3DT.BA3_USERGA,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '01/01/1900' END) FROM BA3010 BA3DT WHERE 1=1 AND BA3DT.D_E_L_E_T_ = '' AND BA3DT.BA3_CODINT = A.BQC_CODINT AND BA3DT.BA3_CODEMP = A.BQC_CODEMP AND BA3DT.BA3_CONEMP = A.BQC_NUMCON AND BA3DT.BA3_VERCON = A.BQC_VERCON AND BA3DT.BA3_SUBCON = A.BQC_SUBCON AND BA3DT.BA3_VERSUB = A.BQC_VERSUB ),'01/01/1900') AS DTALT, "
		cQueryCLI += " CASE  "
		cQueryCLI += " 	WHEN A.BQC_DATBLO <> '' THEN 'BLOQUEADO'  "
		cQueryCLI += " 	ELSE 'ATIVO'  "
		cQueryCLI += " END             AS STATUSC,  "
		cQueryCLI += " CONCAT(SUBSTRING(CAST(A.BQC_DATBLO AS VARCHAR),7,2),'/',SUBSTRING(CAST(A.BQC_DATBLO AS VARCHAR),5,2),'/',SUBSTRING(CAST(A.BQC_DATBLO AS VARCHAR),1,4)) AS DTBLOQ,  "
		cQueryCLI += " ISNULL(( "
		cQueryCLI += " SELECT  "
		cQueryCLI += " SUM(D.BDK_VALOR)  "
		cQueryCLI += " FROM BA3010 BA3  "
		cQueryCLI += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP   "
		cQueryCLI += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
		cQueryCLI += " WHERE 1=1  "
		cQueryCLI += " AND BA3.D_E_L_E_T_ = ''   "
		cQueryCLI += " AND BA3.BA3_CODINT = A.BQC_CODINT   "
		cQueryCLI += " AND BA3.BA3_CODEMP = A.BQC_CODEMP   "
		cQueryCLI += " AND BA3.BA3_CONEMP = A.BQC_NUMCON   "
		cQueryCLI += " AND BA3.BA3_VERCON = A.BQC_VERCON   "
		cQueryCLI += " AND BA3.BA3_SUBCON = A.BQC_SUBCON   "
		cQueryCLI += " AND BA3.BA3_VERSUB = A.BQC_VERSUB   "
		cQueryCLI += " ),0) 	 AS VALOR, "
		cQueryCLI += " 'PRIVADO' AS TIPOCTR "
		cQueryCLI += " FROM BQC010 A  "
		cQueryCLI += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
		cQueryCLI += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = A.BQC_CODCLI AND SA1.A1_LOJA = A.BQC_LOJA "
		cQueryCLI += " WHERE 1=1   "
		cQueryCLI += " AND A.D_E_L_E_T_ = ''  "
		cQueryCLI += " AND A.BQC_CODEMP IN ('0004','0005') "
		cQueryCLI += " AND ISNULL(( SELECT MAX(CASE WHEN SUBSTRING(BA3DT.BA3_USERGA, 03, 1) != ' ' AND BA3DT.BA3_USERGA != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(BA3DT.BA3_USERGA,12,1)) - 50, ASCII(SUBSTRING(BA3DT.BA3_USERGA,16,1)) - 50) + IIF(SUBSTRING(BA3DT.BA3_USERGA,08,1) = '<',10000,0)),'19000101'), 103) ELSE '19000101' END) FROM BA3010 BA3DT WHERE 1=1 AND BA3DT.D_E_L_E_T_ = '' AND BA3DT.BA3_CODINT = A.BQC_CODINT AND BA3DT.BA3_CODEMP = A.BQC_CODEMP AND BA3DT.BA3_CONEMP = A.BQC_NUMCON AND BA3DT.BA3_VERCON = A.BQC_VERCON AND BA3DT.BA3_SUBCON = A.BQC_SUBCON AND BA3DT.BA3_VERSUB = A.BQC_VERSUB ),'19000101') BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "

		cQueryCLI += " UNION ALL "
				
		cQueryCLI += " SELECT "
		cQueryCLI += " B.BA3_FILIAL     AS FILIAL,  "
		cQueryCLI += " B.BA3_MATEMP     AS IDCONTRATO, "
		cQueryCLI += " B.BA3_XCARTE     AS NUMERO,   "
		cQueryCLI += " E.BT5_NOME       AS PERFIL,  "
		cQueryCLI += " SA1.A1_COD       AS CODCLI,  "
		cQueryCLI += " SA1.A1_NOME      AS CLIENTE,  "
		cQueryCLI += " CASE WHEN SUBSTRING(B.BA3_USERGI, 03, 1) != ' ' AND B.BA3_USERGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(B.BA3_USERGI,12,1)) - 50, ASCII(SUBSTRING(B.BA3_USERGI,16,1)) - 50) + IIF(SUBSTRING(B.BA3_USERGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '01/01/1900' END AS DTINC, "
		cQueryCLI += " CASE WHEN SUBSTRING(B.BA3_USERGA, 03, 1) != ' ' AND B.BA3_USERGA != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(B.BA3_USERGA,12,1)) - 50, ASCII(SUBSTRING(B.BA3_USERGA,16,1)) - 50) + IIF(SUBSTRING(B.BA3_USERGA,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '01/01/1900' END AS DTIALT, "
		cQueryCLI += " CASE  "
		cQueryCLI += " 	WHEN B.BA3_DATBLO <> '' THEN 'BLOQUEADO'  "
		cQueryCLI += " 	ELSE 'ATIVO'  "
		cQueryCLI += " END             AS STATUSC,  "
		cQueryCLI += " CONCAT(SUBSTRING(CAST(B.BA3_DATBLO AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA3_DATBLO AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA3_DATBLO AS VARCHAR),1,4)) AS DTBLOQ,  "
		cQueryCLI += " ISNULL(( "
		cQueryCLI += " SELECT  "
		cQueryCLI += " SUM(D.BDK_VALOR)  "
		cQueryCLI += " FROM BA3010 BA3  "
		cQueryCLI += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP   "
		cQueryCLI += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
		cQueryCLI += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = B.BA3_CODCLI AND SA1.A1_LOJA = B.BA3_LOJA "
		cQueryCLI += " WHERE 1=1  "
		cQueryCLI += " AND BA3.D_E_L_E_T_ = ''   "
		cQueryCLI += " AND BA3.BA3_CODINT = A.BQC_CODINT   "
		cQueryCLI += " AND BA3.BA3_CODEMP = A.BQC_CODEMP   "
		cQueryCLI += " AND BA3.BA3_CONEMP = A.BQC_NUMCON   "
		cQueryCLI += " AND BA3.BA3_VERCON = A.BQC_VERCON   "
		cQueryCLI += " AND BA3.BA3_SUBCON = A.BQC_SUBCON   "
		cQueryCLI += " AND BA3.BA3_VERSUB = A.BQC_VERSUB   "
		cQueryCLI += " AND BA3.BA3_MATEMP = B.BA3_MATEMP   "
		cQueryCLI += " ),0) AS VALOR, "
		cQueryCLI += " 'PRIVADO' AS TIPOCTR "
		cQueryCLI += " FROM BQC010 A   "
		cQueryCLI += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB  "
		cQueryCLI += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON   "
		cQueryCLI += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = B.BA3_CODCLI AND SA1.A1_LOJA = B.BA3_LOJA "
		cQueryCLI += " WHERE 1=1   "
		cQueryCLI += " AND A.D_E_L_E_T_ = ''   "
		cQueryCLI += " AND A.BQC_CODEMP IN ('0003','0006') "
		cQueryCLI += " AND CASE WHEN SUBSTRING(B.BA3_USERGA, 03, 1) != ' ' AND B.BA3_USERGA != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(B.BA3_USERGA,12,1)) - 50, ASCII(SUBSTRING(B.BA3_USERGA,16,1)) - 50) + IIF(SUBSTRING(B.BA3_USERGA,08,1) = '<',10000,0)),'1996-01-01'), 112) ELSE '19000101' END BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "

		cQueryCLI += " UNION ALL "

		SELECT 
		A.CN9_FILIAL	AS FILIAL, 
		A.CN9_NUMERO	AS IDCONTRATO, 
		''				AS NUMERO, 
		D.CN1_DESCRI	AS PERFIL, 
		E.A1_COD		AS CODCLI, 
		E.A1_NOME		AS CLIENTE, 
		C.CND_DTINIC	AS DTINC, 
		C.CND_COMPET	AS DTALT, 
		''				AS STATUSC, 
		''				AS DTBLOQ, 
		C.CND_VLTOT		AS VALOR, 
		'PUBLICO'		AS TIPOCTR 
		FROM CN9010 A 
		LEFT JOIN CNC010 B ON B.D_E_L_E_T_ = '' AND B.CNC_FILIAL = A.CN9_FILIAL AND B.CNC_NUMERO = A.CN9_NUMERO 
		LEFT JOIN CND010 C ON C.D_E_L_E_T_ = '' AND C.CND_FILIAL = A.CN9_FILIAL AND C.CND_CONTRA = A.CN9_NUMERO 
		LEFT JOIN CN1010 D ON D.D_E_L_E_T_ = '' AND D.CN1_FILIAL = A.CN9_FILIAL AND D.CN1_CODIGO = A.CN9_TPCTO 
		LEFT JOIN SA1010 E ON E.D_E_L_E_T_ = '' AND E.A1_COD = B.CNC_CLIENT AND E.A1_LOJA = B.CNC_LOJACL 
		WHERE 1=1 
		AND A.D_E_L_E_T_ = '' 





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

		oExcel:AddRow("CADCLI","LISTCLI",{ (_cAliasCLI)->FILIAL,(_cAliasCLI)->IDCONTRATO,(_cAliasCLI)->NUMERO,(_cAliasCLI)->PERFIL,(_cAliasCLI)->CODCLI,(_cAliasCLI)->CLIENTE,(_cAliasCLI)->DTINC,(_cAliasCLI)->DTALT,(_cAliasCLI)->STATUSC,(_cAliasCLI)->DTBLOQ,(_cAliasCLI)->VALOR })

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



