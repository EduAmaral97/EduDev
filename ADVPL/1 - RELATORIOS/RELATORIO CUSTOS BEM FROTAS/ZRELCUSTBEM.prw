//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*


TABELAS

BEM/VEICULO - ST9
CABECARIO OS - STJ		(223)
INSUMOS DA OS - STL		()
SOLICITACAO DE COMPRAS - SC1
PEDIDO DE COMPRAS - SC7

ST9 -> STJ -> STL -> SC1 -> SC7 -> SD1 -> SE2

OS FINALIZADA = TJ_TERMINO = 'S'
OS ABERTA = TJ_TERMINO = 'N'

COLUNAS

- FILIAL				(COD + NOME)
- BEM/PLACA	
- NOME DO BEM
- INSUMO 				(COD PROD + NOME)
- QUANTIDADE 			(QTD DO INSUMO)
- UNIDADE DE MEDIDA 	(DO INSUMO)
- VALOR POR PRODUTO 	(ISUSMOS)
- FORNECEDOR 			(COD + NOME)
- DATA ABERTURA			(OS)
- DATA FIM				(OS)
- SITUAÇÃO				(OS)
- NUMERO SC 
- NUMERO PC 
- NUMERO NF 			(SERIE + NUM)
- COND. PG				(PEGAR DO PC - SC7)
- CENTRO DE CUSTO 		(PEGAR DO PC - SC7)
- CLASSE VALOR 			(PAGAR DO PC - SC7)


*/


User Function ZRELCUSTBEM()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRCUSTBEM" // Nome do grupo de perguntas
 

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

	lRet := oExcel:IsWorkSheet("CUSTBEM")
	oExcel:AddworkSheet("CUSTBEM")
	

	oExcel:AddTable ("CUSTBEM","CUSTBEMOS",.F.)
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","FILIAL"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DESCFILIAL"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","CODBEM"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","BEM"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","INSUMO"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DESCINSUMO"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","QTD"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","UNIDADE"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","VLROS"			,1,3,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","VLRUNI"			,1,3,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","VLRTOTAL"		,1,3,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","CODFOR"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","FORNECEDOR"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DTINI"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","HRINI"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DTFIM"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","HRFIM"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","SITUACAO"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","EMABERTO"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","NUMOS"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","NUMSC"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","NUMPC"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","SERIENF"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DOCNF"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","CONDPG"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DESCCOND"		,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","CCUSTO"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DESCCC"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","CLVL"			,1,1,.F., "")
	oExcel:AddColumn("CUSTBEM","CUSTBEMOS","DESCCLVL"		,1,1,.F., "")


	cQuery := " SELECT "
	cQuery += " A.TJ_FILIAL		AS FILIAL, "
	cQuery += " L.M0_FILIAL		AS DESCFILIAL, "
	cQuery += " A.TJ_CODBEM		AS CODBEM, "
	cQuery += " B.T9_NOME		AS BEM, "
	cQuery += " C.TL_CODIGO		AS INSUMO, "
	cQuery += " CASE "
	cQuery += " 	WHEN C.TL_TIPOREG = 'T' THEN 'TERCEIROS' "
	cQuery += " 	ELSE  D.B1_DESC "
	cQuery += " END				AS DESCINSUMO, "
	cQuery += " C.TL_QUANTID	AS QTD, "
	cQuery += " C.TL_UNIDADE	AS UNIDADE, "
	cQuery += " C.TL_CUSTO		AS VLROS, "
	cQuery += " G.C7_PRECO		AS VLRUNI, "
	cQuery += " G.C7_TOTAL		AS VLRTOTAL, "
	cQuery += " C.TL_FORNEC		AS CODFOR, "
	cQuery += " E.A2_NOME		AS FORNECEDOR, "
	cQuery += " A.TJ_DTPRINI	AS DTINI, "
	cQuery += " A.TJ_HOPRINI	AS HRINI, "
	cQuery += " A.TJ_DTPRFIM	AS DTFIM, "
	cQuery += " A.TJ_HOPRFIM	AS HRFIM, "
	cQuery += " A.TJ_SITUACA	AS SITUACAO, "
	cQuery += " A.TJ_TERMINO	AS EMABERTO, "
	cQuery += " A.TJ_ORDEM		AS NUMOS, "
	cQuery += " F.C1_NUM		AS NUMSC, "
	cQuery += " G.C7_NUM		AS NUMPC, "
	cQuery += " H.D1_SERIE		AS SERIENF, "
	cQuery += " H.D1_DOC		AS DOCNF, "
	cQuery += " G.C7_COND		AS CONDPG, "
	cQuery += " I.E4_DESCRI		AS DESCCOND, "
	cQuery += " G.C7_CC			AS CCUSTO, "
	cQuery += " J.CTT_DESC01	AS DESCCC, "
	cQuery += " G.C7_CLVL		AS CLVL, "
	cQuery += " K.CTH_DESC01	AS DESCCLVL "
	cQuery += " FROM STJ010 A "
	cQuery += " LEFT JOIN ST9010 B ON B.D_E_L_E_T_ = '' AND B.T9_CODBEM = A.TJ_CODBEM "
	cQuery += " LEFT JOIN STL010 C ON C.D_E_L_E_T_ = '' AND C.TL_FILIAL = A.TJ_FILIAL AND C.TL_ORDEM = A.TJ_ORDEM "
	cQuery += " LEFT JOIN SB1010 D ON D.D_E_L_E_T_ = '' AND D.B1_COD = C.TL_CODIGO "
	cQuery += " LEFT JOIN SA2010 E ON E.D_E_L_E_T_ = '' AND E.A2_COD = C.TL_FORNEC AND E.A2_LOJA = C.TL_LOJA "
	cQuery += " LEFT JOIN SC1010 F ON F.D_E_L_E_T_ = '' AND F.C1_FILIAL = C.TL_FILIAL AND F.C1_NUM = C.TL_NUMSC AND F.C1_PRODUTO = CASE WHEN C.TL_TIPOREG = 'T' THEN 'TERCEIROS' ELSE C.TL_CODIGO END AND F.C1_ITEM = C.TL_ITEMSC "
	cQuery += " LEFT JOIN SC7010 G ON G.D_E_L_E_T_ = '' AND G.C7_FILIAL = F.C1_FILIAL AND G.C7_NUMSC = F.C1_NUM AND G.C7_PRODUTO = F.C1_PRODUTO AND G.C7_ITEMSC = F.C1_ITEM "
	cQuery += " LEFT JOIN SD1010 H ON H.D_E_L_E_T_ = '' AND H.D1_FILIAL = G.C7_FILIAL AND H.D1_PEDIDO = G.C7_NUM AND H.D1_COD = G.C7_PRODUTO AND H.D1_ITEMPC = G.C7_ITEM "
	cQuery += " LEFT JOIN SE4010 I ON I.D_E_L_E_T_ = '' AND I.E4_CODIGO = G.C7_COND "
	cQuery += " LEFT JOIN CTT010 J ON J.D_E_L_E_T_ = '' AND J.CTT_CUSTO = G.C7_CC "
	cQuery += " LEFT JOIN CTH010 K ON K.D_E_L_E_T_ = '' AND K.CTH_CLVL = G.C7_CLVL "
	cQuery += " LEFT JOIN SYS_COMPANY L ON L.D_E_L_E_T_ = '' AND L.M0_CODFIL = A.TJ_FILIAL "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND C.TL_NUMOP = '' "
	cQuery += " AND A.TJ_FILIAL >= '"+MV_PAR01+"' "
	cQuery += " AND A.TJ_FILIAL <= '"+MV_PAR02+"' "
	cQuery += " AND A.TJ_CODBEM >= '"+MV_PAR03+"' "
	cQuery += " AND A.TJ_CODBEM <= '"+MV_PAR04+"' "
	cQuery += " AND A.TJ_DTORIGI BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
	IF MV_PAR07 = 1
		cQuery += " AND A.TJ_SITUACA = 'P' "
	ELSEIF MV_PAR07 = 2
		cQuery += " AND A.TJ_SITUACA = 'C' "
	ELSEIF MV_PAR07 = 3
		cQuery += " AND A.TJ_SITUACA = 'L' "
	ELSEIF MV_PAR07 = 4
		cQuery += " AND A.TJ_TERMINO = 'S' "
	ELSE
		cQuery += " AND A.TJ_SITUACA IN ('P','C','L') "
		cQuery += " AND A.TJ_TERMINO IN ('S','N') "
	ENDIF

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("CUSTBEM","CUSTBEMOS",{(_cAlias)->FILIAL,(_cAlias)->DESCFILIAL,(_cAlias)->CODBEM,(_cAlias)->BEM,(_cAlias)->INSUMO,(_cAlias)->DESCINSUMO,(_cAlias)->QTD,(_cAlias)->UNIDADE,(_cAlias)->VLROS,(_cAlias)->VLRUNI,(_cAlias)->VLRTOTAL,(_cAlias)->CODFOR,(_cAlias)->FORNECEDOR,(_cAlias)->DTINI,(_cAlias)->HRINI,(_cAlias)->DTFIM,(_cAlias)->HRFIM,(_cAlias)->SITUACAO,(_cAlias)->EMABERTO,(_cAlias)->NUMOS,(_cAlias)->NUMSC,(_cAlias)->NUMPC,(_cAlias)->SERIENF,(_cAlias)->DOCNF,(_cAlias)->CONDPG,(_cAlias)->DESCCOND,(_cAlias)->CCUSTO,(_cAlias)->DESCCC,(_cAlias)->CLVL,(_cAlias)->DESCCLVL})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'CUSTO_BEM_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
