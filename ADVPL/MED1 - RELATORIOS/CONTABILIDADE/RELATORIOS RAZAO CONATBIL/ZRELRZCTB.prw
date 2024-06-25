//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELRZCTB()

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
	Local cQueryE1 
	Local cQueryE2
	Local cArqBem
	Private _cAlias := GetNextAlias()
	Private _cAliasE1 := GetNextAlias()
	Private _cAliasE2 := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	oExcel:AddworkSheet("CONTABIL")
	oExcel:AddTable ("CONTABIL","LISTCTB",.F.)
	oExcel:AddColumn("CONTABIL","LISTCTB", "FILIAL", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "DTLANC", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "CTADEB", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "CTACRD", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "VALOR", 		1,3,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "HISTORICO", 	1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "ROTINA", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "TITULO", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "IDENT", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "IDENTCANC", 	1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "CLVLDB", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "CLVLCR", 		1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "CCD", 			1,1,.F.,"")
	oExcel:AddColumn("CONTABIL","LISTCTB", "CCC", 			1,1,.F.,"")
	
	oExcel:AddworkSheet("RECEBER")
	oExcel:AddTable ("RECEBER","LISTREC",.F.)
	oExcel:AddColumn("RECEBER","LISTREC", "CHAVERECEBER", 	1,1,.F.,"")
	oExcel:AddColumn("RECEBER","LISTREC", "CC", 			1,1,.F.,"")
	oExcel:AddColumn("RECEBER","LISTREC", "CLVL", 			1,1,.F.,"")
	oExcel:AddColumn("RECEBER","LISTREC", "VALOR", 			1,3,.F.,"")

	oExcel:AddworkSheet("PAGAR")
	oExcel:AddTable ("PAGAR","LISTREC",.F.)
	oExcel:AddColumn("PAGAR","LISTREC", "CHAVEPAGAR", 	1,1,.F.,"")
	oExcel:AddColumn("PAGAR","LISTREC", "CC", 			1,1,.F.,"")
	oExcel:AddColumn("PAGAR","LISTREC", "CLVL", 		1,1,.F.,"")
	oExcel:AddColumn("PAGAR","LISTREC", "VALOR", 		1,3,.F.,"")

	
		cQuery := " SELECT "
		cQuery += " A.CT2_FILIAL		AS FILIAL, "
		cQuery += " A.CT2_DATA			AS DTLANC, "
		cQuery += " A.CT2_DEBITO		AS CTADEB, "
		cQuery += " A.CT2_CREDIT		AS CTACRD, "
		cQuery += " A.CT2_VALOR			AS VALOR, "
		cQuery += " A.CT2_HIST			AS HISTORICO, "
		cQuery += " A.CT2_ROTINA		AS ROTINA, "
		cQuery += " CASE "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA460' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,15,3), ' - ', SUBSTRING(A.CT2_KEY,18,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA040' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,15,3), ' - ', SUBSTRING(A.CT2_KEY,18,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA330' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,7,3), ' - ',  SUBSTRING(A.CT2_KEY,10,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA050' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,7,3), ' - ',  SUBSTRING(A.CT2_KEY,10,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA070' AND A.CT2_KEY LIKE '%VL%' 		THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA070' AND A.CT2_KEY LIKE '%MIG%' 		THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA070' AND A.CT2_KEY NOT LIKE '%MIG%' 	THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,7,3), ' - ',  SUBSTRING(A.CT2_KEY,9,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA200' AND A.CT2_KEY LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA200' AND A.CT2_KEY NOT LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,7,3), ' - ',  SUBSTRING(A.CT2_KEY,10,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA370' AND A.CT2_KEY LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA370' AND A.CT2_KEY NOT LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA370' AND A.CT2_ORIGEM LIKE '%510/001%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA470' AND A.CT2_KEY LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA470' AND A.CT2_KEY NOT LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA100' AND A.CT2_KEY LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA100' AND A.CT2_KEY NOT LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA080' AND A.CT2_KEY LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA080' AND A.CT2_KEY NOT LIKE '%MIG%' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'CTBANFS' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,16,3), ' - ', SUBSTRING(A.CT2_KEY,7,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'MATA103' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,16,3), ' - ', SUBSTRING(A.CT2_KEY,7,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'CTBANFE' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,16,3), ' - ', SUBSTRING(A.CT2_KEY,7,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA290' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ', SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	WHEN A.CT2_ROTINA = 'FINA090' THEN CONCAT( SUBSTRING(A.CT2_KEY,1,6), ' - ', SUBSTRING(A.CT2_KEY,9,3), ' - ',  SUBSTRING(A.CT2_KEY,12,9)) "
		cQuery += " 	ELSE '' "
		cQuery += " END 						AS TITULO, "
		cQuery += " CASE "
		cQuery += " 	WHEN SUBSTRING(CT2_CREDIT,1,1) = '3' AND CTCR.CT1_NORMAL = '2' THEN 'RECEBER - SE1' "
		cQuery += " 	WHEN SUBSTRING(CT2_DEBITO,1,1) = '4' AND CTCR.CT1_NORMAL = '1' THEN 'PAGAR - SE2' "
		cQuery += " 	WHEN SUBSTRING(CT2_DEBITO,1,1) = '3' AND CTCR.CT1_NORMAL = '1' THEN 'PAGAR - SE2' "
		cQuery += " 	WHEN SUBSTRING(CT2_DEBITO,1,1) = '1' AND CTCR.CT1_NORMAL = '1' THEN 'RECEBER - SE1' "
		cQuery += " 	WHEN SUBSTRING(CT2_CREDIT,1,1) = '2' AND CTCR.CT1_NORMAL = '2' THEN 'PAGAR - SE2' "
		cQuery += " ELSE '' "
		cQuery += " END AS IDENT, "
		cQuery += " CASE "
		cQuery += " 	WHEN SUBSTRING(CT2_DEBITO,1,1) = '3' AND CTCR.CT1_NORMAL = '2' THEN 'RECEBER - SE1' "
		cQuery += " 	WHEN SUBSTRING(CT2_CREDIT,1,1) = '4' AND CTCR.CT1_NORMAL = '1' THEN 'PAGAR - SE2' "
		cQuery += " 	WHEN SUBSTRING(CT2_CREDIT,1,1) = '3' AND CTCR.CT1_NORMAL = '1' THEN 'PAGAR - SE2' "
		cQuery += " 	WHEN SUBSTRING(CT2_CREDIT,1,1) = '1' AND CTCR.CT1_NORMAL = '1' THEN 'RECEBER - SE1' "
		cQuery += " 	WHEN SUBSTRING(CT2_DEBITO,1,1) = '2' AND CTCR.CT1_NORMAL = '2' THEN 'PAGAR - SE2' "
		cQuery += " ELSE '' "
		cQuery += " END AS IDENTCANC, "
		cQuery += " CT2_CLVLDB		AS CLVLDB, "
		cQuery += " CT2_CLVLCR		AS CLVLCR, "
		cQuery += " CT2_CCD			AS CCD, "
		cQuery += " CT2_CCC			AS CCC "
		cQuery += " FROM CT2010 A "
		cQuery += " LEFT JOIN CT1010 CTCR ON CTCR.D_E_L_E_T_ = '' AND CTCR.CT1_CONTA = CT2_CREDIT "
		cQuery += " LEFT JOIN CT1010 CTDB ON CTDB.D_E_L_E_T_ = '' AND CTDB.CT1_CONTA = CT2_DEBITO "
		cQuery += " WHERE 1=1 "
		cQuery += " AND A.D_E_L_E_T_ = '' "
		cQuery += " AND A.CT2_TPSALD <> '9' "
		cQuery += " AND A.CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "

	
		cQueryE1 := " SELECT "
		cQueryE1 += " CONCAT(A.E1_FILIAL, ' - ', A.E1_PREFIXO, ' - ', A.E1_NUM) AS CHAVERECEBER, "
		cQueryE1 += " CASE "
		cQueryE1 += " 	WHEN B.D2_CCUSTO <> '' THEN B.D2_CCUSTO "
		cQueryE1 += " 	ELSE A.E1_CCUSTO "
		cQueryE1 += " END AS CC, "
		cQueryE1 += " CASE "
		cQueryE1 += " 	WHEN B.D2_CLVL <> '' THEN B.D2_CLVL "
		cQueryE1 += " 	ELSE A.E1_CLVL "
		cQueryE1 += " END AS CLVL, "
		cQueryE1 += " A.E1_VALOR		AS VALOR "
		cQueryE1 += " FROM SE1010 A  "
		cQueryE1 += " LEFT JOIN SD2010 B ON B.D_E_L_E_T_ = '' AND B.D2_FILIAL = A.E1_FILIAL AND B.D2_SERIE = A.E1_PREFIXO AND B.D2_DOC = A.E1_NUM AND B.D2_CLIENTE = A.E1_CLIENTE AND B.D2_LOJA = A.E1_LOJA "
		cQueryE1 += " WHERE 1=1 "
		cQueryE1 += " AND A.D_E_L_E_T_ = '' "
		cQueryE1 += " AND A.E1_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
		cQueryE1 += " GROUP BY A.E1_FILIAL,A.E1_PREFIXO,A.E1_NUM,A.E1_CCUSTO,A.E1_CLVL,B.D2_CCUSTO,B.D2_CLVL,A.E1_VALOR "


		cQueryE2 := " SELECT "
		cQueryE2 += " CONCAT(A.E2_FILIAL, ' - ', A.E2_PREFIXO, ' - ', A.E2_NUM) AS CHAVEPAGAR, "
		cQueryE2 += " CASE "
		cQueryE2 += " 	WHEN B.D1_CC <> '' THEN B.D1_CC "
		cQueryE2 += " 	ELSE A.E2_CCUSTO "
		cQueryE2 += " END AS CC, "
		cQueryE2 += " CASE "
		cQueryE2 += " 	WHEN B.D1_CLVL <> '' THEN B.D1_CLVL "
		cQueryE2 += " 	ELSE A.E2_CLVL "
		cQueryE2 += " END AS CLVL, "
		cQueryE2 += " A.E2_VALOR	AS VALOR "
		cQueryE2 += " FROM SE2010 A  "
		cQueryE2 += " LEFT JOIN SD1010 B ON B.D_E_L_E_T_ = '' AND B.D1_FILIAL = A.E2_FILIAL AND B.D1_SERIE = A.E2_PREFIXO AND B.D1_DOC = A.E2_NUM AND B.D1_FORNECE = A.E2_FORNECE AND B.D1_LOJA = A.E2_LOJA "
		cQueryE2 += " WHERE 1=1 "
		cQueryE2 += " AND A.D_E_L_E_T_ = '' "
		cQueryE2 += " AND A.E2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
		cQueryE2 += " GROUP BY A.E2_FILIAL,A.E2_PREFIXO,A.E2_NUM,A.E2_CCUSTO,A.E2_CLVL,B.D1_CC,B.D1_CLVL,A.E2_VALOR "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)
	TCQUERY cQueryE1 NEW ALIAS (_cAliasE1)
	TCQUERY cQueryE2 NEW ALIAS (_cAliasE2)

	DbSelectArea(_cAlias)
	DbSelectArea(_cAliasE1)
	DbSelectArea(_cAliasE2)


	While (_cAlias)->(!Eof())

		oExcel:AddRow("CONTABIL","LISTCTB",{(_cAlias)->FILIAL,(_cAlias)->DTLANC,(_cAlias)->CTADEB,(_cAlias)->CTACRD,(_cAlias)->VALOR,(_cAlias)->HISTORICO,(_cAlias)->ROTINA,(_cAlias)->TITULO,(_cAlias)->IDENT,(_cAlias)->IDENTCANC,(_cAlias)->CLVLDB,(_cAlias)->CLVLCR,(_cAlias)->CCD,(_cAlias)->CCC})

		(_cAlias)->(dBskip())

	EndDo


	While (_cAliasE1)->(!Eof())

		oExcel:AddRow("RECEBER","LISTREC",{(_cAliasE1)->CHAVERECEBER,(_cAliasE1)->CC,(_cAliasE1)->CLVL,(_cAliasE1)->VALOR})

		(_cAliasE1)->(dBskip())

	EndDo


	While (_cAliasE2)->(!Eof())

		oExcel:AddRow("PAGAR","LISTPAG",{(_cAliasE2)->CHAVEPAGAR,(_cAliasE2)->CC,(_cAliasE2)->CLVL,(_cAliasE2)->VALOR})

		(_cAliasE2)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())
	(_cAliasE1)->(DbCloseArea())
	(_cAliasE2)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'RAZAOCTB' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
