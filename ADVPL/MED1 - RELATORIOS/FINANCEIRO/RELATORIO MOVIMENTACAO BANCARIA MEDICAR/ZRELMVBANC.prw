//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*

Autor: Eduardo Amaral
Data: 13/06/2024
Objetivo: Peronalização do relatorio de movimentação bancaria com colunas e filtros personalizados.

*/


User Function ZRELMVBANC()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRMVBC" // Nome do grupo de perguntas
 

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

	
	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio - Mov. Bancario...") 
	
	
Return


Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqBem
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()
	
	lRet := oExcel:IsWorkSheet("MVBANC")
	oExcel:AddworkSheet("MVBANC")
	
	oExcel:AddTable ("MVBANC","TABMVBC",.F.)
	oExcel:AddColumn("MVBANC","TABMVBC", "FILIAL",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "DTMVBANC",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "BANCO",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "AGENCIA",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CONTA",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CODCLIFOR",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CLIFOR",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CGCCLIFOR",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "NATUREZA",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "TITULO",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "TIPO",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "NFRA",		 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "VALOR",		 1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("MVBANC","TABMVBC", "CCCREDITO",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CLVLCREDITO",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CCDEBITO",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "CLVLDEBITO",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "MOVIMENTACAO", 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "HISTORICO",	 1,1,.F., "")
	oExcel:AddColumn("MVBANC","TABMVBC", "DOCUMENTO",	 1,1,.F., "")


	cQuery := " SELECT  "
    cQuery += " A.E5_FILIAL		AS FILIAL, "
    cQuery += " CONCAT(SUBSTRING(A.E5_DATA,7,2),'/',SUBSTRING(A.E5_DATA,5,2),'/',SUBSTRING(A.E5_DATA,1,4)) AS DTMVBANC, "
    cQuery += " A.E5_BANCO		AS BANCO, "
    cQuery += " A.E5_AGENCIA	AS AGENCIA, "
    cQuery += " A.E5_CONTA		AS CONTA, "
    cQuery += " CASE "
    cQuery += " 	WHEN A.E5_RECPAG = 'R' THEN B.A1_COD "
    cQuery += " 	WHEN A.E5_RECPAG = 'P' THEN C.A2_COD "
    cQuery += " 	ELSE '' "
    cQuery += " END 			AS CODCLIFOR, "
	cQuery += " CASE "
    cQuery += " 	WHEN A.E5_RECPAG = 'R' THEN B.A1_NOME "
    cQuery += " 	WHEN A.E5_RECPAG = 'P' THEN C.A2_NOME "
    cQuery += " 	ELSE '' "
    cQuery += " END 			AS CLIFOR, "
	cQuery += " CASE "
    cQuery += " 	WHEN A.E5_RECPAG = 'R' THEN B.A1_CGC "
    cQuery += " 	WHEN A.E5_RECPAG = 'P' THEN C.A2_CGC "
    cQuery += " 	ELSE '' "
    cQuery += " END 			AS CGCCLIFOR, "
	cQuery += " A.E5_NATUREZ	AS NATUREZA, "
	cQuery += " A.E5_NUMERO		AS TITULO, "
	cQuery += " A.E5_TIPO		AS TIPO, "
	cQuery += " ISNULL((SELECT TOP 1 SE5.E5_DOCUMEN FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_RECONC <> 'x'AND SE5.E5_TIPO = 'RA' AND SE5.E5_FILIAL = A.E5_FILIAL AND SE5.E5_NUMERO = A.E5_NUMERO AND SE5.E5_TIPO = A.E5_TIPO	AND SE5.E5_CLIFOR = A.E5_CLIFOR	AND SE5.E5_LOJA = A.E5_LOJA),'') AS NFRA, "
	cQuery += " A.E5_VALOR		AS VALOR, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E5_CCC <> '' THEN A.E5_CCC "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 E.D2_CCUSTO FROM SD2010 E WHERE E.D_E_L_E_T_ = '' AND E.D2_FILIAL = A.E5_FILIAL AND E.D2_SERIE = A.E5_PREFIXO AND E.D2_DOC = A.E5_NUMERO AND E.D2_CLIENTE = A.E5_CLIFOR AND E.D2_LOJA = A.E5_LOJA), '') <> '' THEN ISNULL((SELECT TOP 1 E.D2_CCUSTO FROM SD2010 E WHERE E.D_E_L_E_T_ = '' AND E.D2_FILIAL = A.E5_FILIAL AND E.D2_SERIE = A.E5_PREFIXO AND E.D2_DOC = A.E5_NUMERO AND E.D2_CLIENTE = A.E5_CLIFOR AND E.D2_LOJA = A.E5_LOJA), '') "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS CCCREDITO, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E5_CLVLCR <> '' THEN A.E5_CLVLCR "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 E.D2_CLVL FROM SD2010 E WHERE E.D_E_L_E_T_ = '' AND E.D2_FILIAL = A.E5_FILIAL AND E.D2_SERIE = A.E5_PREFIXO AND E.D2_DOC = A.E5_NUMERO AND E.D2_CLIENTE = A.E5_CLIFOR AND E.D2_LOJA = A.E5_LOJA), '') <> '' THEN ISNULL((SELECT TOP 1 E.D2_CLVL FROM SD2010 E WHERE E.D_E_L_E_T_ = '' AND E.D2_FILIAL = A.E5_FILIAL AND E.D2_SERIE = A.E5_PREFIXO AND E.D2_DOC = A.E5_NUMERO AND E.D2_CLIENTE = A.E5_CLIFOR AND E.D2_LOJA = A.E5_LOJA), '') "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS CLVLCREDITO, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E5_CCD <> '' THEN A.E5_CCD "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 D.D1_CC FROM SD1010 D WHERE D.D_E_L_E_T_ = '' AND D.D1_FILIAL = A.E5_FILIAL AND D.D1_SERIE = A.E5_PREFIXO AND D.D1_DOC = A.E5_NUMERO AND D.D1_FORNECE = A.E5_CLIFOR AND D.D1_LOJA = A.E5_LOJA), '') <> '' THEN ISNULL((SELECT TOP 1 D.D1_CC FROM SD1010 D WHERE D.D_E_L_E_T_ = '' AND D.D1_FILIAL = A.E5_FILIAL AND D.D1_SERIE = A.E5_PREFIXO AND D.D1_DOC = A.E5_NUMERO AND D.D1_FORNECE = A.E5_CLIFOR AND D.D1_LOJA = A.E5_LOJA), '') "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS CCDEBITO, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E5_CLVLDB <> '' THEN A.E5_CLVLDB "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 D.D1_CLVL FROM SD1010 D WHERE D.D_E_L_E_T_ = '' AND D.D1_FILIAL = A.E5_FILIAL AND D.D1_SERIE = A.E5_PREFIXO AND D.D1_DOC = A.E5_NUMERO AND D.D1_FORNECE = A.E5_CLIFOR AND D.D1_LOJA = A.E5_LOJA), '') <> '' THEN ISNULL((SELECT TOP 1 D.D1_CLVL FROM SD1010 D WHERE D.D_E_L_E_T_ = '' AND D.D1_FILIAL = A.E5_FILIAL AND D.D1_SERIE = A.E5_PREFIXO AND D.D1_DOC = A.E5_NUMERO AND D.D1_FORNECE = A.E5_CLIFOR AND D.D1_LOJA = A.E5_LOJA), '') "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS CLVLDEBITO, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E5_RECPAG = 'R' THEN 'ENTRADA' "
	cQuery += " 	WHEN A.E5_RECPAG = 'P' THEN 'SAIDA' "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS MOVIMENTACAO, "
	cQuery += " A.E5_HISTOR		AS HISTORICO, "
	cQuery += " A.E5_DOCUMEN	AS DOCUMENTO "
	cQuery += " FROM SE5010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E5_CLIFOR AND B.A1_LOJA = A.E5_LOJA AND A.E5_RECPAG = 'R' "
	cQuery += " LEFT JOIN SA2010 C ON C.D_E_L_E_T_ = '' AND C.A2_COD = A.E5_CLIFOR AND C.A2_LOJA = A.E5_LOJA AND A.E5_RECPAG = 'P' "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E5_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	//cQuery += " AND A.E5_RECONC = 'x' "
	IF MV_PAR03 = 1
		cQuery += " AND A.E5_RECONC = 'x' "
	ELSE
		cQuery += " AND A.E5_RECONC = '' "
	ENDIF
	

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)



	While (_cAlias)->(!Eof())

		oExcel:AddRow("MVBANC","MVBANCMED",{ (_cAlias)->FILIAL,(_cAlias)->DTMVBANC,(_cAlias)->BANCO,(_cAlias)->AGENCIA,(_cAlias)->CONTA,(_cAlias)->CODCLIFOR,(_cAlias)->CLIFOR,(_cAlias)->CGCCLIFOR,(_cAlias)->NATUREZA,(_cAlias)->TITULO,(_cAlias)->TIPO,(_cAlias)->NFRA,(_cAlias)->VALOR,(_cAlias)->CCCREDITO,(_cAlias)->CLVLCREDITO,(_cAlias)->CCDEBITO,(_cAlias)->CLVLDEBITO,(_cAlias)->MOVIMENTACAO,(_cAlias)->HISTORICO,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'MOVBANC' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()


Return
