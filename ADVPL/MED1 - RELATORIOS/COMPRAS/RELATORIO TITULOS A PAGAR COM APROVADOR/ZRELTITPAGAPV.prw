//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*

Objetivo: Relatorio de conferencia de aprovação dos pedidos de compras no contas a pagar
Autor: Eduardo Amaral
Data: 15/04/2024


TABELAS:
SE2 - CONTAS A PAGAR
SD1/SF1 - DOCUMENTO DE ENTRADA
SC7 - PEIDDO DE COMPRAS
SCR - APROVACAO PEDIDO DE COMPRAS

PEDIDOS PARA TESTAR

015001 - 000373
001001 - 000072

*/


User Function ZRELTITPAGAPV()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRTITPGAPV" // Nome do grupo de perguntas
 

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

	lRet := oExcel:IsWorkSheet("TITPGAPV")
	oExcel:AddworkSheet("TITPGAPV")
	
	oExcel:AddTable ("TITPGAPV","TITULOS",.F.)
	oExcel:AddColumn("TITPGAPV","TITULOS", "CODFILIAL",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "FILIAL",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "PREFIXO",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "NUMTIT",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "PARCELA",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "TIPO",			1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "CGC",			1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "PORTADO",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "CODFOR",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "RAZSOC",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "NOMFANT",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "EMISSAO",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "VENCIMENTO",	1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "EMISSAOPC",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "DTCLASSIF",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "DTINCPC",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "VALOR",			1,3,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "HISTORICO",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "PEDIDO",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "CODUSSER",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "APROVADOR",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "CCUSTO",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "DESCCC",		1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "CLVL",			1,1,.F.,"")
	oExcel:AddColumn("TITPGAPV","TITULOS", "DESCCLVL",		1,1,.F.,"")

		cQuery := " SELECT "
		cQuery += " A.E2_FILIAL		AS CODFILIAL, "
		cQuery += " J.M0_FILIAL		AS FILIAL, "
		cQuery += " A.E2_PREFIXO	AS PREFIXO, "
		cQuery += " A.E2_NUM		AS NUMTIT, "
		cQuery += " A.E2_PARCELA	AS PARCELA, "
		cQuery += " A.E2_TIPO		AS TIPO, "
		cQuery += " A.E2_PORTADO	AS PORTADO, "
		cQuery += " CASE "
        cQuery += "     WHEN B.A2_TIPO = 'F' THEN CONCAT(SUBSTRING(B.A2_CGC,1,3),'.',SUBSTRING(B.A2_CGC,4,3),'.',SUBSTRING(B.A2_CGC,7,3),'-',SUBSTRING(B.A2_CGC,10,2)) "
        cQuery += "     ELSE CONCAT(SUBSTRING(B.A2_CGC,1,2),'.',SUBSTRING(B.A2_CGC,3,3),'.',SUBSTRING(B.A2_CGC,6,3),'/',SUBSTRING(B.A2_CGC,9,4),'-',SUBSTRING(B.A2_CGC,13,2)) "
        cQuery += " END             	AS CGC, "
		cQuery += " B.A2_COD		AS CODFOR, "
		cQuery += " B.A2_NOME		AS RAZSOC, "
		cQuery += " B.A2_NREDUZ		AS NOMFANT, "
		cQuery += " CONCAT(SUBSTRING(A.E2_EMISSAO,7,2),'/',SUBSTRING(A.E2_EMISSAO,5,2),'/',SUBSTRING(A.E2_EMISSAO,1,4)) AS EMISSAO,  "
		cQuery += " CONCAT(SUBSTRING(A.E2_VENCREA,7,2),'/',SUBSTRING(A.E2_VENCREA,5,2),'/',SUBSTRING(A.E2_VENCREA,1,4)) AS VENCIMENTO, "
		cQuery += " CONCAT(SUBSTRING(I.C7_EMISSAO,7,2),'/',SUBSTRING(I.C7_EMISSAO,5,2),'/',SUBSTRING(I.C7_EMISSAO,1,4)) AS EMISSAOPC, "
		cQuery += " CONCAT(SUBSTRING(C.D1_DTDIGIT,7,2),'/',SUBSTRING(C.D1_DTDIGIT,5,2),'/',SUBSTRING(C.D1_DTDIGIT,1,4)) AS DTCLASSIF, "
 		cQuery += " CASE WHEN SUBSTRING(I.C7_USERLGI, 03, 1) != ' ' AND I.C7_USERLGI != '' THEN "
    	cQuery += "     CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(I.C7_USERLGI,12,1)) - 50, ASCII(SUBSTRING(I.C7_USERLGI,16,1)) - 50) + IIF(SUBSTRING(I.C7_USERLGI,08,1) = '<',10000,0)),'1996-01-01'), 103) "
    	cQuery += " ELSE '' "
    	cQuery += " END AS DTINCPC, "
		cQuery += " (A.E2_VALOR + A.E2_ACRESC) - A.E2_DECRESC	AS VALOR, "
		cQuery += " A.E2_HIST		AS HISTORICO, "
		cQuery += " C.D1_PEDIDO		AS PEDIDO, "
		cQuery += " D.CR_USER		AS CODUSSER, "
		cQuery += " E.USR_CODIGO 	AS APROVADOR, "
		cQuery += " C.D1_CC			AS CCUSTO, "
		cQuery += " G.CTT_DESC01    AS DESCCC, "
		cQuery += " C.D1_CLVL		AS CLVL, "
		cQuery += " H.CTH_DESC01    AS DESCCLVL "
		cQuery += " FROM SE2010 A "
		cQuery += " LEFT JOIN SA2010 B ON B.D_E_L_E_T_ = '' AND B.A2_COD = A.E2_FORNECE AND B.A2_LOJA = A.E2_LOJA "
		cQuery += " LEFT JOIN SD1010 C ON C.D_E_L_E_T_ = '' AND C.D1_FILIAL = A.E2_FILIAL AND C.D1_SERIE = A.E2_PREFIXO AND C.D1_DOC = A.E2_NUM AND C.D1_FORNECE = A.E2_FORNECE AND C.D1_LOJA = A.E2_LOJA "
		cQuery += " LEFT JOIN SCR010 D ON D.D_E_L_E_T_ = '' AND D.CR_FILIAL = C.D1_FILIAL AND D.CR_NUM = C.D1_PEDIDO "
		cQuery += " LEFT JOIN SYS_USR E ON E.D_E_L_E_T_ = '' AND E.USR_ID = D.CR_USER "
		cQuery += " LEFT JOIN SB1010 F ON F.D_E_L_E_T_ = '' AND F.B1_COD = C.D1_COD "
		cQuery += " LEFT JOIN CTT010 G ON G.D_E_L_E_T_ = '' AND G.CTT_CUSTO = C.D1_CC "
		cQuery += " LEFT JOIN CTH010 H ON H.D_E_L_E_T_ = '' AND H.CTH_CLVL = C.D1_CLVL "
		cQuery += " LEFT JOIN SC7010 I ON I.D_E_L_E_T_ = '' AND I.C7_FILIAL = C.D1_FILIAL AND I.C7_NUM = C.D1_PEDIDO AND I.C7_FORNECE = C.D1_FORNECE AND I.C7_LOJA = C.D1_LOJA "
		cQuery += " LEFT JOIN SYS_COMPANY J ON J.D_E_L_E_T_ = '' AND J.M0_CODFIL = A.E2_FILIAL "
		cQuery += " WHERE 1=1 "
		cQuery += " AND A.D_E_L_E_T_ = '' "
		cQuery += " AND A.E2_BAIXA = '' "
		cQuery += " AND A.E2_FILIAL >= '"+MV_PAR01+"' "
		cQuery += " AND A.E2_FILIAL <= '"+MV_PAR02+"' "
		cQuery += " AND A.E2_VENCREA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		cQuery += " GROUP BY A.E2_FILIAL,J.M0_FILIAL,A.E2_PREFIXO,A.E2_NUM,A.E2_PARCELA,A.E2_TIPO,A.E2_PORTADO,B.A2_TIPO,B.A2_CGC,B.A2_COD,B.A2_NOME,B.A2_NREDUZ,A.E2_EMISSAO,A.E2_VENCREA,I.C7_EMISSAO,C.D1_DTDIGIT,I.C7_USERLGI,A.E2_VALOR,A.E2_ACRESC,A.E2_DECRESC,A.E2_HIST,C.D1_PEDIDO,D.CR_USER,E.USR_CODIGO,C.D1_CC,G.CTT_DESC01,C.D1_CLVL,H.CTH_DESC01 "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TITPGAPV","TITULOS",{(_cAlias)->CODFILIAL,(_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->NUMTIT,(_cAlias)->PARCELA,(_cAlias)->TIPO,(_cAlias)->CGC,(_cAlias)->PORTADO,(_cAlias)->CODFOR,(_cAlias)->RAZSOC,(_cAlias)->NOMFANT,(_cAlias)->EMISSAO,(_cAlias)->VENCIMENTO,(_cAlias)->EMISSAOPC,(_cAlias)->DTCLASSIF,(_cAlias)->DTINCPC,(_cAlias)->VALOR,(_cAlias)->HISTORICO,(_cAlias)->PEDIDO,(_cAlias)->CODUSSER,(_cAlias)->APROVADOR,(_cAlias)->CCUSTO,(_cAlias)->DESCCC,(_cAlias)->CLVL,(_cAlias)->DESCCLVL})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'TITULOSAPAGAR' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
