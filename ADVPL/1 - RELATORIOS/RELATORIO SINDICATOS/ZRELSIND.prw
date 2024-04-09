//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELSIND()
	
	DEFAULT cCTR := ""
	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.

	/* ---------------------------- GRUPO DE PERGUNTAS/FILTRO ---------------------------- */


	Private cPerg := "ZRELAGRUP" // Nome do grupo de perguntas


	If !Empty(cCTR)
		Pergunte(cPerg,.F.)
		//cForn := MV_PAR04 + MV_PAR05 
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif


 
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

	
	if cPasta <> ''

		If MV_PAR05 = 2
			MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
		else
			MsgInfo("Este relatorio gera somente em Excel," + Chr(13) + Chr(10) + Chr(13) + Chr(10) + "Favor selecionar opção 2 - EXCEL", "Atenção")
		EndIF

	else
		MsgAlert('Caminho nao selecionado fim da execução.')
	Endif



	
Return

Static Function fMontaExcel(cPasta)
	
	Local cQueryCapaCtr 
	Local cQueryBeneCtr
	Local cQueryFin
	Local cArqInc

	Private _cAlias 	:= GetNextAlias()
	Private _cAliasBen 	:= GetNextAlias()
	Private _cAliasFin 	:= GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()
	
	//PRIMEIRA PLANILHA
	lRet := oExcel:IsWorkSheet("CAPA_CTR")
	oExcel:AddworkSheet("CAPA_CTR")

	oExcel:AddTable ("CAPA_CTR","LIT_CTR",.T.)
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","SINDICATO"		,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","CODIGO"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","RAZAO SOCIAL"	,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","NOME FANTASIA"	,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","CNPJ"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","TIPOCTR"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","DTCTR"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","NRVIDAS"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","VLRCTR"			,1,3,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","CONDPG"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","FORMPG"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","TELEFONE"		,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","ENDERECO"		,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","BAIRRO"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","MUNICIPIO"		,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","ESTADO"			,1,1,.F., "")
	oExcel:AddColumn("CAPA_CTR","LIT_CTR","VENCIMENTO"		,1,1,.F., "")

	//SESUNGA PLANILHA
	lRet := oExcel:IsWorkSheet("BENEF_CTR")
	oExcel:AddworkSheet("BENEF_CTR")
	
	oExcel:AddTable ("BENEF_CTR","LIST_BEN",.T.)
	oExcel:AddColumn("BENEF_CTR","LIST_BEN","RAZAO SOCIAL"		,1,1,.F., "")
	oExcel:AddColumn("BENEF_CTR","LIST_BEN","NOME FANTASIA"		,1,1,.F., "")
	oExcel:AddColumn("BENEF_CTR","LIST_BEN","NOME BENEF."		,1,1,.F., "")
	oExcel:AddColumn("BENEF_CTR","LIST_BEN","TITULAR OU DEP."	,1,1,.F., "")
	oExcel:AddColumn("BENEF_CTR","LIST_BEN","CPF"				,1,1,.F., "")
	oExcel:AddColumn("BENEF_CTR","LIST_BEN","DATA NASC"			,1,1,.F., "")

	//TERCEIRA PLANILHA
	lRet := oExcel:IsWorkSheet("FIN_CTR")
	oExcel:AddworkSheet("FIN_CTR")
	
	oExcel:AddTable ("FIN_CTR","LIST_FIN",.T.)
	oExcel:AddColumn("FIN_CTR","LIST_FIN","FILIAL"			,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","NUMERO"			,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","PREFIXO"			,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","PARCELA"			,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","RAZAO SOCIAL"	,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","NOME FANTASIA"	,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","VENCIMENTO"		,1,1,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","VALOR"			,1,3,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","VALOR BAIXADO"	,1,3,.F.,"")
	oExcel:AddColumn("FIN_CTR","LIST_FIN","SALDO"			,1,3,.F.,"")

	
	/* -------------------------------- QUERY CAPA -------------------------------- */

	cQueryCapaCtr := " SELECT "
	cQueryCapaCtr += " ISNULL((SELECT TOP 1 BA1.BA1_FILIAL AS FILIALBA1 FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND BA1.BA1_MOTBLO = '' AND BA1.BA1_DATBLO = '' AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),0) AS FILIAL, "
	cQueryCapaCtr += " E.AOV_DESSEG		AS AGRUPAMENTO, "
	cQueryCapaCtr += " A.BQC_SUBCON		AS IDCONTRATO, "
	cQueryCapaCtr += " B.A1_NOME		AS RAZSOC, "
	cQueryCapaCtr += " B.A1_NREDUZ		AS NOMEFANT, "
	cQueryCapaCtr += " B.A1_CGC			AS CNPJ, "
	cQueryCapaCtr += " D.BT5_NOME		AS TIPOCTR, "
	cQueryCapaCtr += " A.BQC_DATCON		AS DTCTR, "
	cQueryCapaCtr += " ISNULL((SELECT COUNT(*) AS QTDVD FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND BA1.BA1_MOTBLO = '' AND BA1.BA1_DATBLO = '' AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),0) AS NRVIDAS, "
	cQueryCapaCtr += " ISNULL((SELECT SUM(BDK_VALOR) AS QTDVD FROM BA1010 BA1 LEFT JOIN BDK010 BDK ON BDK.BDK_FILIAL = BA1.BA1_FILIAL AND BDK.BDK_CODINT = BA1.BA1_CODINT AND BDK.BDK_CODEMP = BA1.BA1_CODEMP AND BDK.BDK_MATRIC = BA1.BA1_MATRIC AND BDK.BDK_TIPREG = BA1.BA1_TIPREG AND BDK.D_E_L_E_T_ = ''	WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND BA1.BA1_MOTBLO = '' AND BA1.BA1_DATBLO = '' AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),0) AS VLRTOTAL, "
	cQueryCapaCtr += " F.ZI0_DESCRI	AS CONDIPG, "
	cQueryCapaCtr += " G.BQL_DESCRI    AS FORMPAG, "
	cQueryCapaCtr += " CONCAT(B.A1_DDD, B.A1_TEL) AS TELEFONE, "
	cQueryCapaCtr += " B.A1_END		AS ENDERECO, "
	cQueryCapaCtr += " B.A1_BAIRRO		AS BAIRRO, "
	cQueryCapaCtr += " B.A1_MUN		AS MUNICIPIO, "
	cQueryCapaCtr += " B.A1_EST		AS ESTADO, "
	cQueryCapaCtr += " F.ZI0_VENCTO	AS VENCIMENTO	 "
	cQueryCapaCtr += " FROM BQC010 A "
	cQueryCapaCtr += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.BQC_CODCLI AND B.A1_LOJA = A.BQC_LOJA "
	cQueryCapaCtr += " LEFT JOIN BT5010 D ON D.D_E_L_E_T_ = '' AND D.BT5_CODINT = A.BQC_CODINT AND D.BT5_CODIGO = A.BQC_CODEMP AND D.BT5_NUMCON = A.BQC_NUMCON "
	cQueryCapaCtr += " LEFT JOIN AOV010 E ON E.D_E_L_E_T_ = '' AND E.AOV_CODSEG = B.A1_CODSEG "
	cQueryCapaCtr += " LEFT JOIN ZI0010 F ON F.D_E_L_E_T_ = '' AND F.ZI0_CODIGO = A.BQC_XCONDI "
	cQueryCapaCtr += " LEFT JOIN BQL010 G ON G.D_E_L_E_T_ = '' AND G.BQL_CODIGO = A.BQC_TIPPAG "
	cQueryCapaCtr += " WHERE 1=1 "
	cQueryCapaCtr += " AND A.D_E_L_E_T_ = '' "
	cQueryCapaCtr += " AND A.BQC_COBNIV = '1' "
	cQueryCapaCtr += " AND A.BQC_CODBLO = '' "
	cQueryCapaCtr += " AND A.BQC_DATBLO = '' "
	cQueryCapaCtr += " AND B.A1_CODSEG = '"+MV_PAR04+"' "
	cQueryCapaCtr += " ORDER BY B.A1_NOME "


	/* -------------------------------- QUERY BENEFICIARIOS -------------------------------- */

	cQueryBeneCtr := " SELECT "
	cQueryBeneCtr += " SA1.A1_NOME 		AS RAZSOC, "
	cQueryBeneCtr += " SA1.A1_NREDUZ 	AS NOMEFANT, "
	cQueryBeneCtr += " BA1.BA1_NOMUSR 	AS BENEFICIARIO, "
	cQueryBeneCtr += " CASE "
	cQueryBeneCtr += " 	WHEN BA1.BA1_TIPREG = '00' THEN 'T' "
	cQueryBeneCtr += " 	ELSE 'D' "
	cQueryBeneCtr += " END 				AS TIPOBENE, "
	cQueryBeneCtr += " BA1.BA1_CPFUSR	AS CPF, "
	cQueryBeneCtr += " BA1.BA1_DATNAS	AS DTNASCIMENTO "
	cQueryBeneCtr += " FROM BA1010 BA1  "
	cQueryBeneCtr += " LEFT JOIN BQC010 BQC ON BQC.D_E_L_E_T_ = ''	AND BA1.BA1_CODINT = BQC.BQC_CODINT AND BA1.BA1_CODEMP = BQC.BQC_CODEMP AND BA1.BA1_CONEMP = BQC.BQC_NUMCON AND BA1.BA1_VERCON = BQC.BQC_VERCON AND BA1.BA1_SUBCON = BQC.BQC_SUBCON AND BA1.BA1_VERSUB = BQC.BQC_VERSUB "
	cQueryBeneCtr += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = BQC.BQC_CODCLI AND SA1.A1_LOJA = BQC.BQC_LOJA "
	cQueryBeneCtr += " WHERE 1=1  "
	cQueryBeneCtr += " AND BA1.D_E_L_E_T_ = ''  "
	cQueryBeneCtr += " AND BQC.BQC_COBNIV = '1' "
	cQueryBeneCtr += " AND BA1.BA1_MOTBLO = ''  "
	cQueryBeneCtr += " AND BA1.BA1_DATBLO = ''  "
	cQueryBeneCtr += " AND SA1.A1_CODSEG = '"+MV_PAR04+"' "
	cQueryBeneCtr += " ORDER BY SA1.A1_NOME, BA1.BA1_NOMUSR "
	

	/* -------------------------------- QUERY FINANCEIRO -------------------------------- */

	cQueryFin := " SELECT  "
	cQueryFin += " SE1.E1_FILIAL   AS FILIAL, "
	cQueryFin += " SE1.E1_NUM	    AS NUMERO, "
	cQueryFin += " SE1.E1_PREFIXO  AS PREFIXO, "
	cQueryFin += " SE1.E1_PARCELA  AS PARCELA, "
	cQueryFin += " SA1.A1_NREDUZ   AS NOMEFANT,	  "
	cQueryFin += " SA1.A1_NOME	   AS RAZSOC,	  "
	cQueryFin += " SE1.E1_VENCREA  AS VENCIMENTO,  "
	cQueryFin += " SE5.E5_TIPODOC  AS TIPODOC_SE5, "
	cQueryFin += " SE5.E5_MOTBX    AS MOTBX, "
	cQueryFin += " CASE "
	cQueryFin += "     WHEN SUM(SE1.E1_VALLIQ) = 0 THEN SUM(SE1.E1_VALOR) "
	cQueryFin += "     ELSE SUM(SE1.E1_VALLIQ) "
	cQueryFin += " END             AS VALOR, "
	cQueryFin += " SUM(SE5.E5_VALOR)    AS VALORES_BAIXADOS, "
	cQueryFin += " SUM(SE1.E1_SALDO)    AS SALDO "
	cQueryFin += " FROM SE1010 SE1 "
	cQueryFin += " LEFT JOIN SE5010 SE5 ON SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA  "
	cQueryFin += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA   "
	cQueryFin += " WHERE 1=1   "
	cQueryFin += " AND SE1.D_E_L_E_T_ = '' "
	cQueryFin += " AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-') "
	cQueryFin += " AND SE1.E1_FILIAL = '" +(MV_PAR01)+ "' "
	cQueryFin += " AND SE1.E1_VENCREA BETWEEN '"+Dtos(MV_PAR02)+"' AND '"+Dtos(MV_PAR03)+"' "
	cQueryFin += " AND SA1.A1_CODSEG = '"+(MV_PAR04)+"' "
	cQueryFin += " GROUP BY SE1.E1_FILIAL ,SE1.E1_NUM,SE1.E1_PREFIXO,SE1.E1_PARCELA,SA1.A1_NREDUZ,SA1.A1_NOME,SE1.E1_VENCREA,SE5.E5_TIPODOC,SE5.E5_MOTBX  "
	cQueryFin += "ORDER BY 5,6 "


	//Criar alias temporário
	TCQUERY cQueryCapaCtr NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("CAPA_CTR","LIT_CTR",{(_cAlias)->AGRUPAMENTO,(_cAlias)->IDCONTRATO,(_cAlias)->RAZSOC,(_cAlias)->NOMEFANT,SubStr( (_cAlias)->CNPJ,1,2 ) + '.' + SubStr( (_cAlias)->CNPJ,3,3 ) + '.' + SubStr( (_cAlias)->CNPJ,6,3 ) + '/' + SubStr( (_cAlias)->CNPJ,9,4 ) + '-' + SubStr( (_cAlias)->CNPJ,12,2),(_cAlias)->TIPOCTR,SubStr((_cAlias)->DTCTR,7,2) + "/" + SubStr((_cAlias)->DTCTR,5,2) + "/" + SubStr((_cAlias)->DTCTR,1,4),(_cAlias)->NRVIDAS,(_cAlias)->VLRTOTAL,(_cAlias)->CONDIPG,(_cAlias)->FORMPAG,(_cAlias)->TELEFONE,(_cAlias)->ENDERECO,(_cAlias)->BAIRRO,(_cAlias)->MUNICIPIO,(_cAlias)->ESTADO,(_cAlias)->VENCIMENTO})
			
		(_cAlias)->(dBskip())

	EndDo


	//Criar alias temporário
	TCQUERY cQueryBeneCtr NEW ALIAS (_cAliasBen)

	DbSelectArea(_cAliasBen)

	While (_cAliasBen)->(!Eof())

		oExcel:AddRow("BENEF_CTR","LIST_BEN",{(_cAliasBen)->RAZSOC,(_cAliasBen)->NOMEFANT,(_cAliasBen)->BENEFICIARIO,(_cAliasBen)->TIPOBENE,(_cAliasBen)->CPF,SubStr((_cAliasBen)->DTNASCIMENTO,7,2) + "/" + SubStr((_cAliasBen)->DTNASCIMENTO,5,2) + "/" + SubStr((_cAliasBen)->DTNASCIMENTO,1,4)})
			
		(_cAliasBen)->(dBskip())

	EndDo


	//Criar alias temporário
	TCQUERY cQueryFin NEW ALIAS (_cAliasFin)

	DbSelectArea(_cAliasFin)

	While (_cAliasFin)->(!Eof())

		oExcel:AddRow("FIN_CTR","LIST_FIN",{(_cAliasFin)->FILIAL,(_cAliasFin)->NUMERO,(_cAliasFin)->PREFIXO,(_cAliasFin)->PARCELA,(_cAliasFin)->RAZSOC,(_cAliasFin)->NOMEFANT,SubStr((_cAliasFin)->VENCIMENTO,7,2) + "/" + SubStr((_cAliasFin)->VENCIMENTO,5,2) + "/" + SubStr((_cAliasFin)->VENCIMENTO,1,4),(_cAliasFin)->VALOR,(_cAliasFin)->VALORES_BAIXADOS,(_cAliasFin)->SALDO})
			
		(_cAliasFin)->(dBskip())

	EndDo


	(_cAlias)->(DbCloseArea())
	(_cAliasBen)->(DbCloseArea())
	(_cAliasFin)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\SINDICATO_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return
