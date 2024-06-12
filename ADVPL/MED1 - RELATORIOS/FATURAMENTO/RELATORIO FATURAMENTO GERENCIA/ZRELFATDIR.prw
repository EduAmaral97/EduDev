//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELFATDIR()
	
	DEFAULT cForn := ""
	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.

	/* ---------------------------- GRUPO DE PERGUNTAS/FILTRO ---------------------------- */


	Private cPerg := "ZFORNPG" // Nome do grupo de perguntas


	If !Empty(cForn)
		Pergunte(cPerg,.F.)
		cForn := MV_PAR04 + MV_PAR05 
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
		MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	else
		MsgAlert('Caminho nao selecionado fim da execução.')
	Endif
	
Return

Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqInc
	Local cForn
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("FORNPG")
	oExcel:AddworkSheet("FORNPG")

	oExcel:AddTable ("FORNPG","ZFORNPG",.F.)
	oExcel:AddColumn("FORNPG","ZFORNPG","FILIAL" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","PREFIXO" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","TITULO" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","PARCELA" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","TIPO" 			,1,1,.F., "")	
	oExcel:AddColumn("FORNPG","ZFORNPG","CNPJ" 			,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","FORNECEDOR" 	,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","EMISSAO" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","VENCIMENTO" 	,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","VALOR" 		,1,3,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","SALDO" 		,1,3,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","DTBAIXA" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","HISTORICO" 	,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","SITUACAO" 		,1,1,.F., "")
	
	cQuery := " SELECT  "
	cQuery += " A.E2_FILIAL		AS FILIAL, "
	cQuery += " A.E2_PREFIXO	AS PREFIXO, "
	cQuery += " A.E2_NUM		AS TITULO, "
	cQuery += " A.E2_PARCELA	AS PARCELA, "
	cQuery += " A.E2_TIPO 		AS TIPO, "
	cQuery += " B.A2_CGC 		AS CNPJ, "
	cQuery += " B.A2_NREDUZ		AS FORNECEDOR, "
	cQuery += " A.E2_EMISSAO	AS EMISSAO, "
	cQuery += " A.E2_VENCREA 	AS VENCIMENTO, "
	cQuery += " A.E2_VALOR 		AS VALOR, "
	cQuery += " A.E2_SALDO 		AS SALDO, "
	cQuery += " A.E2_BAIXA 		AS DTBAIXA, "
	cQuery += " A.E2_HIST		AS HISTORICO, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E2_SALDO = 0 AND A.E2_BAIXA <> '' THEN 'BAIXADO' "
	cQuery += " 	WHEN A.E2_SALDO > 0 AND A.E2_BAIXA <> '' THEN 'BAIXADO PARCIALMENTE' "
	cQuery += " 	WHEN A.E2_SALDO > 0 AND A.E2_BAIXA = '' THEN 'EM ABERTO' "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS SITUACAO "
	cQuery += " FROM SE2010 A "
	cQuery += " LEFT JOIN SA2010 B ON B.D_E_L_E_T_ = '' AND B.A2_COD = A.E2_FORNECE AND B.A2_LOJA = A.E2_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E2_FILIAL = '"+MV_PAR01+"' "
	cQuery += " AND A.E2_VENCREA BETWEEN '"+Dtos(MV_PAR02)+"' AND '"+Dtos(MV_PAR03)+"' " "
	cQuery += " AND A.E2_FORNECE = '"+MV_PAR04+"' "
	cQuery += " AND A.E2_LOJA = '"+MV_PAR05+"' "
	If MV_PAR06 = 1
		cQuery += " AND A.SALDO > 0 "
		cQuery += " AND A.E2_BAIXA <> '' "
	Elseif MV_PAR06 = 2
		cQuery += " AND A.SALDO = 0 "
		cQuery += " AND A.E2_BAIXA = '' "
	Endif
	

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	cForn := (_cAlias)->FORNECEDOR

	While (_cAlias)->(!Eof())

		oExcel:AddRow("FORNPG","ZFORNPG",{(_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->TITULO,(_cAlias)->PARCELA,(_cAlias)->TIPO,SubStr( (_cAlias)->CNPJ,1,2 ) + '.' + SubStr( (_cAlias)->CNPJ,3,3 ) + '.' + SubStr( (_cAlias)->CNPJ,6,3 ) + '/' + SubStr( (_cAlias)->CNPJ,9,4 ) + '-' + SubStr( (_cAlias)->CNPJ,12,2),(_cAlias)->FORNECEDOR,SubStr((_cAlias)->EMISSAO,7,2) + "/" + SubStr((_cAlias)->EMISSAO,5,2) + "/" + SubStr((_cAlias)->EMISSAO,1,4),SubStr((_cAlias)->VENCIMENTO,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),(_cAlias)->VALOR,(_cAlias)->SALDO,SubStr((_cAlias)->DTBAIXA,7,2) + "/" + SubStr((_cAlias)->DTBAIXA,5,2) + "/" + SubStr((_cAlias)->DTBAIXA,1,4),(_cAlias)->HISTORICO,(_cAlias)->SITUACAO})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + cForn + '_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

	- PERFIL DO CONTRATO
	- DATA EMISSAO
	- NUMERO DOCUMENTO
	- VENCIMENTO (REAL)
	- VALOR BRUTO
	- VALOR LIQUIDO
	- CLIEMTE (CGC)
	- NOME CLIENTE

	- FILTRO POR EMISSAO (DE - ATE)


	SELECT
	A.E1_FILIAL		AS FILIAL,
	A.E1_PREFIXO	AS PREFIXO,
	A.E1_NUM		AS TITULO,
	A.E1_PARCELA	AS PARCELA,
	A.E1_CLIENTE	AS CODCLI,
	A.E1_NOMCLI		AS CLIENTE,
	A.E1_EMISSAO	AS EMISSAO,
	A.E1_VENCREA	AS VENCIMENTO,
	A.E1_VALOR		AS VALORBRUTO,
	(A.E1_VALOR - A.E1_VRETIRF - E1_CSLL - E1_COFINS - E1_PIS) AS VALORLIQ,
	CASE
		WHEN B.BQC_SUBCON <> '' THEN B.BQC_SUBCON
		WHEN D.BA3_IDBENN <> '' THEN D.BA3_IDBENN
		WHEN D.BA3_IDBENN = '' AND BA3_MATEMP <> '' THEN D.BA3_MATEMP
		ELSE ''
	END 			AS IDCONTRATO,
	CASE
		WHEN B.BQC_SUBCON <> '' THEN B.BQC_ANTCON
		WHEN D.BA3_IDBENN <> '' THEN D.BA3_XCARTE
		WHEN D.BA3_IDBENN = '' AND BA3_MATEMP <> '' THEN D.BA3_XCARTE
		ELSE ''
	END 			AS NUMEROCTR,
	CASE
		WHEN B.BQC_SUBCON <> '' THEN C.BT5_NOME
		WHEN D.BA3_IDBENN <> '' THEN F.BT5_NOME
		WHEN D.BA3_IDBENN = '' AND BA3_MATEMP <> '' THEN F.BT5_NOME
		ELSE ''
	END 			AS PERFILCTR,
	A.E1_CCUSTO		AS CENTROCUSTO,
	A.E1_CLVL		AS CLASSEVALOR
	FROM SE1010 A
	LEFT JOIN BQC010 B ON B.D_E_L_E_T_ = '' AND B.BQC_CODCLI = A.E1_CLIENTE AND B.BQC_LOJA = A.E1_LOJA AND B.BQC_COBNIV = '1'
	LEFT JOIN BT5010 C ON C.D_E_L_E_T_ = '' AND C.BT5_CODINT = B.BQC_CODINT AND C.BT5_CODIGO = B.BQC_CODEMP AND C.BT5_NUMCON = B.BQC_NUMCON AND C.BT5_VERSAO = B.BQC_VERCON
	LEFT JOIN BA3010 D ON D.D_E_L_E_T_ = '' AND D.BA3_CODCLI = A.E1_CLIENTE AND D.BA3_LOJA = A.E1_LOJA AND D.BA3_COBNIV = '1'
	LEFT JOIN BQC010 E ON E.D_E_L_E_T_ = '' AND E.BQC_CODINT = D.BA3_CODINT AND E.BQC_CODEMP = D.BA3_CODEMP AND E.BQC_NUMCON = D.BA3_CONEMP AND E.BQC_VERCON = D.BA3_VERCON AND E.BQC_SUBCON = D.BA3_SUBCON AND E.BQC_VERSUB = D.BA3_VERSUB
	LEFT JOIN BT5010 F ON F.D_E_L_E_T_ = '' AND F.BT5_CODINT = E.BQC_CODINT AND F.BT5_CODIGO = E.BQC_CODEMP AND F.BT5_NUMCON = E.BQC_NUMCON AND F.BT5_VERSAO = E.BQC_VERCON
	WHERE 1=1
	AND A.D_E_L_E_T_ = ''
	AND A.E1_PREFIXO IN ('MIG','1','FAT')
	AND A.E1_TIPO NOT IN ('IR-','CF-','PI-','CS-','IS-')
	AND YEAR(A.E1_EMISSAO) = 2024
	AND A.E1_CLIENTE = '046569'
	

Return


