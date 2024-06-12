//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELCTRCAD()

    Local dDataDe  := ctod("01/01/1900")
    //Local dDataAte := ctod("01/01/08")
    Local dDataAte := date()

    /* FILIAIS */
    Local lRP   := .F.
	Local lCAMP := .F.
	Local lSP   := .F.
	Local lLIT  := .F.
	Local lTECH := .F.
	Local lRIO  := .F.
    Local lLOC  := .F.

    /* PERFIS PJ */
    Local lColetivo             := .F.
    Local lTotalColetivo        := .F.
    Local lEssencialColetivo    := .F.
    Local lAreaProtegida        := .F.
    Local lLocacao              := .F.
    Local lAmbulatorio          := .F.
    Local lTelemedicina         := .F.
    Local lRemocao              := .F.
    Local lHomecare             := .F.
    Local lOMT                  := .F.
    Local lAssociacao           := .F.
    Local lTotalAssociacao      := .F.

    /* PERFIS PF */
    Local lFamiliar               := .F.
    Local lTotalFamiliar          := .F.
    Local lEssencialFamiliar      := .F.
    Local lFuncionario            := .F.
    Local lTotalFamiliarAnual     := .F.
    Local lEssencialFamiliarAnual := .F.

    /* GRUPO EMPRESA */
    Local LExcessao               := .T.
    Local lNaoExcessao            := .T.
    

    DEFINE MSDIALOG oDlg FROM 05,10 TO 585,645 TITLE " Contratos Cadastrados Medicar " PIXEL

        @ 010,020 TO 050,210 LABEL " Data de cadastro " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Data de: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 022, 050 MSGET oGrupo  VAR dDataDe  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"

        @ 025, 110 SAY oTitQtdVidas PROMPT "Data ate: "                 SIZE 070, 020 OF oDlg PIXEL
        @ 022, 135 MSGET oGrupo  VAR dDataAte  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"
	   	
		@ 060,020 TO 210,110 LABEL " Selecione as Filiais " OF oDlg PIXEL

		TButton():New( 072, 030 , "Marcar Todos" , oDlg, {|| lRP:= .T.,lCAMP := .T.,lSP := .T.,lLIT := .T.,lTECH := .T.,lRIO := .T.,lLOC := .T. }, 035,011, ,,,.T.,,,,,,)
        TButton():New( 072, 070 , "Desmarcar Todos" , oDlg, {|| lRP:= .F.,lCAMP := .F.,lSP := .F.,lLIT := .F.,lTECH := .F.,lRIO := .F.,lLOC := .F. }, 035,011, ,,,.T.,,,,,,)
        @ 090,025 CHECKBOX oSN VAR lRP          PROMPT "Medicar RP" 	            SIZE 85,8 PIXEL OF oDlg
		@ 105,025 CHECKBOX oSN VAR lCAMP        PROMPT "Medicar Camp" 	            SIZE 85,8 PIXEL OF oDlg
		@ 120,025 CHECKBOX oSN VAR lSP          PROMPT "Medicar SP " 	            SIZE 85,8 PIXEL OF oDlg
		@ 135,025 CHECKBOX oSN VAR lLIT         PROMPT "Medicar Litoral" 	        SIZE 85,8 PIXEL OF oDlg
		@ 150,025 CHECKBOX oSN VAR lTECH        PROMPT "Medicar Tech" 	            SIZE 85,8 PIXEL OF oDlg
		@ 165,025 CHECKBOX oSN VAR lRIO         PROMPT "Medicar Rio" 	            SIZE 85,8 PIXEL OF oDlg
        @ 180,025 CHECKBOX oSN VAR lLOC         PROMPT "Locamedi" 		            SIZE 85,8 PIXEL OF oDlg
        
        @ 220,020 TO 280,110 LABEL " Selecione o Grupo Empresa " OF oDlg PIXEL

        @ 235,025 CHECKBOX oSN VAR LExcessao      PROMPT "Excessao" 	            SIZE 85,8 PIXEL OF oDlg
		@ 250,025 CHECKBOX oSN VAR lNaoExcessao   PROMPT "Nao Excessao"           SIZE 85,8 PIXEL OF oDlg
		

        @ 060,130 TO 280,300 LABEL " Selecione os Perfis " OF oDlg PIXEL
    
		TButton():New( 072, 140 , "Marcar Todos"    , oDlg, {|| lColetivo := .T.,lTotalColetivo := .T.,lEssencialColetivo := .T.,lAreaProtegida := .T.,lLocacao := .T.,lAmbulatorio := .T.,lTelemedicina := .T.,lRemocao := .T.,lHomecare := .T.,lOMT := .T.,lAssociacao := .T.,lTotalAssociacao := .T.,lFamiliar := .T.,lTotalFamiliar := .T.,lEssencialFamiliar := .T.,lFuncionario := .T.,lTotalFamiliarAnual := .T.,lEssencialFamiliarAnual := .T. }, 035,011, ,,,.T.,,,,,,)
        TButton():New( 072, 180 , "Desmarcar Todos" , oDlg, {|| lColetivo := .F.,lTotalColetivo := .F.,lEssencialColetivo := .F.,lAreaProtegida := .F.,lLocacao := .F.,lAmbulatorio := .F.,lTelemedicina := .F.,lRemocao := .F.,lHomecare := .F.,lOMT := .F.,lAssociacao := .F.,lTotalAssociacao := .F.,lFamiliar := .F.,lTotalFamiliar := .F.,lEssencialFamiliar := .F.,lFuncionario := .F.,lTotalFamiliarAnual := .F.,lEssencialFamiliarAnual := .F. }, 035,011, ,,,.T.,,,,,,)
        @ 090,135 CHECKBOX oSN VAR lColetivo            PROMPT "Coletivo" 	                SIZE 85,8 PIXEL OF oDlg
		@ 105,135 CHECKBOX oSN VAR lTotalColetivo       PROMPT "Total Coletivo"             SIZE 85,8 PIXEL OF oDlg
		@ 120,135 CHECKBOX oSN VAR lEssencialColetivo   PROMPT "Essencial Coletivo "        SIZE 85,8 PIXEL OF oDlg
        @ 135,135 CHECKBOX oSN VAR lAreaProtegida       PROMPT "Area Protegida "            SIZE 85,8 PIXEL OF oDlg
        @ 150,135 CHECKBOX oSN VAR lLocacao             PROMPT "Locacao "                   SIZE 85,8 PIXEL OF oDlg
        @ 165,135 CHECKBOX oSN VAR lAmbulatorio         PROMPT "Ambulatorio "               SIZE 85,8 PIXEL OF oDlg
        @ 180,135 CHECKBOX oSN VAR lTelemedicina        PROMPT "Telemedicina "              SIZE 85,8 PIXEL OF oDlg
        @ 195,135 CHECKBOX oSN VAR lRemocao             PROMPT "Remocao "                   SIZE 85,8 PIXEL OF oDlg
        @ 210,135 CHECKBOX oSN VAR lHomecare            PROMPT "Home Care "                 SIZE 85,8 PIXEL OF oDlg
        @ 225,135 CHECKBOX oSN VAR lOMT                 PROMPT "OMT "                       SIZE 85,8 PIXEL OF oDlg
        @ 240,135 CHECKBOX oSN VAR lAssociacao          PROMPT "Associacao "                SIZE 85,8 PIXEL OF oDlg
        @ 255,135 CHECKBOX oSN VAR lTotalAssociacao     PROMPT "Total Associacao "          SIZE 85,8 PIXEL OF oDlg

        @ 090,210 CHECKBOX oSN VAR lFamiliar                PROMPT "Familiar" 	                SIZE 85,8 PIXEL OF oDlg
		@ 105,210 CHECKBOX oSN VAR lTotalFamiliar           PROMPT "Total Familiar"             SIZE 85,8 PIXEL OF oDlg
		@ 120,210 CHECKBOX oSN VAR lEssencialFamiliar       PROMPT "Essencial Familiar "        SIZE 85,8 PIXEL OF oDlg
        @ 135,210 CHECKBOX oSN VAR lFuncionario             PROMPT "Funcionario "               SIZE 85,8 PIXEL OF oDlg
		@ 150,210 CHECKBOX oSN VAR lTotalFamiliarAnual      PROMPT "Total Familiar Anual"       SIZE 85,8 PIXEL OF oDlg
		@ 165,210 CHECKBOX oSN VAR lEssencialFamiliarAnual  PROMPT "Essencial Familiar Anual "  SIZE 85,8 PIXEL OF oDlg

		TButton():New( 020, 240 , "Gerar" , oDlg, {|| fPegaDir(dDataDe,dDataAte,LExcessao,lNaoExcessao,lRP,lCAMP,lSP,lLIT,lTECH,lRIO,lLOC,lColetivo,lTotalColetivo,lEssencialColetivo,lAreaProtegida,lLocacao,lAmbulatorio,lTelemedicina,lRemocao,lHomecare,lOMT,lAssociacao,lTotalAssociacao,lFamiliar,lTotalFamiliar,lEssencialFamiliar,lFuncionario,lTotalFamiliarAnual,lEssencialFamiliarAnual) }, 030,011, ,,,.T.,,,,,,)



    DEFINE SBUTTON FROM 020,280 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER
	
Return


Static Function fPegaDir(dDataDe,dDataAte,LExcessao,lNaoExcessao,lRP,lCAMP,lSP,lLIT,lTECH,lRIO,lLOC,lColetivo,lTotalColetivo,lEssencialColetivo,lAreaProtegida,lLocacao,lAmbulatorio,lTelemedicina,lRemocao,lHomecare,lOMT,lAssociacao,lTotalAssociacao,lFamiliar,lTotalFamiliar,lEssencialFamiliar,lFuncionario,lTotalFamiliarAnual,lEssencialFamiliarAnual)


	Local cPasta := ""  

	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
    
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

    MsAguarde({|| fMontaExcel(cPasta,dDataDe,dDataAte,LExcessao,lNaoExcessao,lRP,lCAMP,lSP,lLIT,lTECH,lRIO,lLOC,lColetivo,lTotalColetivo,lEssencialColetivo,lAreaProtegida,lLocacao,lAmbulatorio,lTelemedicina,lRemocao,lHomecare,lOMT,lAssociacao,lTotalAssociacao,lFamiliar,lTotalFamiliar,lEssencialFamiliar,lFuncionario,lTotalFamiliarAnual,lEssencialFamiliarAnual) },"Aguarde","Motando os Dados do Relatorio...") 
        
Return


Static Function fMontaExcel(cPasta,dDataDe,dDataAte,LExcessao,lNaoExcessao,lRP,lCAMP,lSP,lLIT,lTECH,lRIO,lLOC,lColetivo,lTotalColetivo,lEssencialColetivo,lAreaProtegida,lLocacao,lAmbulatorio,lTelemedicina,lRemocao,lHomecare,lOMT,lAssociacao,lTotalAssociacao,lFamiliar,lTotalFamiliar,lEssencialFamiliar,lFuncionario,lTotalFamiliarAnual,lEssencialFamiliarAnual)
	
	Local cQuery 
	Local cArqBem

    Local cFilialRP := ""
    Local cFilialCAMP := ""
    Local cFilialSP := ""
    Local cFilialLIT := ""
    Local cFilialTECH := ""
    Local cFilialRIO := ""
    Local cFilialLOC := ""

    Local cPFExc  := ""
    Local cPFNExc := ""
    Local cPJExc  := ""
    Local cPJNExc := ""
    
    Local cColetivo := ""
    Local cTotalColetivo := ""
    Local cEssencColetivo := ""
    Local cAreaProtegida := ""
    Local cLocacao := ""
    Local cAmbulatorio := ""
    Local cTelemedicina := ""
    Local cRemocao := ""
    Local cHomeCare := ""
    Local cOMT := ""
    Local cAssociacao := ""
    Local cTotalAssociacao := ""

    Local cFamiliar := ""
    Local cTFamiliar := ""
    Local cEFamiliar := ""
    Local cFuncionario := ""
    Local cTFamiAnual := ""
    Local cEFamiAnual := ""
    

    Private _cAlias := GetNextAlias()
    

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
    oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("CADCTR")
	oExcel:AddworkSheet("CADCTR")
	
	oExcel:AddTable ("CADCTR","CADCTRMED",.F.)
	oExcel:AddColumn("CADCTR","CADCTRMED", "FILIAL",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "GRUPOEMP",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "IDCONTRATO",	,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "NUMERO",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "PERFIL",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "VENDEDOR",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "CODCLI",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "RAZAOSOC",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "NOMEFANT",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "CGC",		    ,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "DTBASE",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "DTINC",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "FORMAPAG",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "CONDPAG",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "CODUSU",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "USUARIO",		,1,1,.F., "")
    oExcel:AddColumn("CADCTR","CADCTRMED", "VLRTOTAL",		,1,2,.F., "@E 999,999,999.99")


    IF lRP == .T.
        cFilialRP += "001"
    EndIf

    IF lCAMP == .T.
        cFilialCAMP += "002"
    EndIf

    IF lSP == .T.
        cFilialSP += "003"
    EndIf

    IF lLIT == .T.
        cFilialLIT += "004"
    EndIf

    IF lTECH == .T.
        cFilialTECH += "006"
    EndIf

    IF lRIO == .T.
        cFilialRIO += "021"
    EndIf

    IF lLOC == .T.
        cFilialLOC += "014"
    EndIf


    If LExcessao == .T.

        cPFExc += "0003"
        cPJExc += "0004"

    EndIf
    

    If lNaoExcessao == .T.

        cPJNExc += "0005"
        cPFNExc += "0006"

    EndIf

    
    IF lColetivo == .T.
        cColetivo += "000000000010"
    EndIf
    
    IF lTotalColetivo == .T.
        cTotalColetivo += "000000000014"
    EndIf
    
    IF lEssencialColetivo == .T.
        cEssencColetivo += "000000000012"
    EndIf
    
    IF lAreaProtegida == .T.
        cAreaProtegida += "000000000008"
    EndIf
    
    IF lLocacao == .T.
        cLocacao += "000000000024"
    EndIf
    
    IF lAmbulatorio == .T.
        cAmbulatorio += "000000000004"
    EndIf
    
    IF lTelemedicina == .T.
        cTelemedicina += "000000000002"
    EndIf
    
    IF lRemocao == .T.
        cRemocao += "000000000007"
    EndIf
    
    IF lHomecare == .T.
        cHomeCare += "000000000006"
    EndIf
    
    IF lOMT == .T.
        cOMT += "000000000005"
    EndIf
    
    IF lAssociacao == .T.
        cAssociacao += "000000000030"
    EndIf
    
    IF lTotalAssociacao == .T.
        cTotalAssociacao += "000000000031"
    EndIf


    IF lFamiliar == .T.
        cFamiliar += "000000000005"
    EndIf
    
    IF lTotalFamiliar == .T.
        cTFamiliar += "000000000004"
    EndIf
    
    IF lEssencialFamiliar == .T.
        cEFamiliar += "000000000003"
    EndIf
    
    IF lFuncionario == .T.
        cFuncionario += "000000000006"
    EndIf
    
    IF lTotalFamiliarAnual == .T.
        cTFamiAnual += "000000000008"
    EndIf
    
    IF lEssencialFamiliarAnual == .T.
        cEFamiAnual += "000000000007"
    EndIf


        /* PESSOA JURIDICA */
        cQuery := " SELECT "
        cQuery += " CASE   "
        cQuery += " WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP'   "
        cQuery += " WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP'   "
        cQuery += " WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP'   "
        cQuery += " WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH'   "
        cQuery += " WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL'   "
        cQuery += " WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI'   "
        cQuery += " WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD'   "
        cQuery += " WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ'   "
        cQuery += " ELSE ''   "
        cQuery += " END             AS FILIAL,  "
        cQuery += " CASE "
        cQuery += "     WHEN A.BQC_CODEMP = '0003' THEN '0003 - PESSOA FISICA ' "
        cQuery += "     WHEN A.BQC_CODEMP = '0004' THEN '0004 - PESSOA JURIDICA ' "
        cQuery += "     WHEN A.BQC_CODEMP = '0005' THEN '0005 - PESSOA JURIDICA EXCESSAO ' "
        cQuery += "     WHEN A.BQC_CODEMP = '0006' THEN '0006 - PESSOA FISICA EXCESSAO ' "
        cQuery += " ELSE '' "
        cQuery += " END             AS GRUPOEMP, "
        cQuery += " A.BQC_SUBCON    AS IDCONTRATO, "
        cQuery += " A.BQC_ANTCON    AS NUMERO, "
        cQuery += " E.BT5_NOME      AS PERFIL, "
        cQuery += " H.A3_NOME       AS VENDEDOR, "
        cQuery += " I.A1_COD        AS CODCLI, "
        cQuery += " I.A1_NOME       AS RAZAOSOC, "
        cQuery += " I.A1_NREDUZ     AS NOMEFANT, "
        cQuery += " I.A1_CGC        AS CGC, "
        cQuery += " CONCAT(SUBSTRING(A.BQC_DATCON,7,2),'/',SUBSTRING(A.BQC_DATCON,5,2),'/',SUBSTRING(A.BQC_DATCON,1,4)) AS DTBASE, "
        cQuery += " CASE WHEN SUBSTRING(A.BQC_USERGI, 03, 1) != ' ' AND A.BQC_USERGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(A.BQC_USERGI,12,1)) - 50, ASCII(SUBSTRING(A.BQC_USERGI,16,1)) - 50) + IIF(SUBSTRING(A.BQC_USERGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '01/01/1900' END AS DTINC, "
        cQuery += " F.BQL_DESCRI    AS FORMAPAG,   "
        cQuery += " G.ZI0_DESCRI    AS CONDPAG, "
        cQuery += " SUBSTRING(A.BQC_USERGI, 11,1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 15,1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 2, 1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 6, 1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 10,1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 14,1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 1, 1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 5, 1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 9, 1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 13,1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 17,1)+ "
        cQuery += " SUBSTRING(A.BQC_USERGI, 4, 1) AS CODUSU, "
        cQuery += " UCRI.USR_CODIGO AS USUARIO, "
        cQuery += " ISNULL((  "
        cQuery += " SELECT  "
        cQuery += " SUM(D.BDK_VALOR)  "
        cQuery += " FROM BA3010 BA3  "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP   "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
        cQuery += " WHERE 1=1  "
        cQuery += " AND BA3.D_E_L_E_T_ = ''   "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT   "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP   "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON   "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON   "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON   "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB   "
        cQuery += " AND C.BA1_DATBLO = ''  "
        cQuery += " ),0) AS VLRTOTAL "
        cQuery += " FROM BQC010 A "
        cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
        cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG  "
        cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI  "
        cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_ZZVEND  "
        cQuery += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = A.BQC_CODCLI AND I.A1_LOJA = A.BQC_LOJA  "
        cQuery += " LEFT JOIN SYS_USR UCRI ON UCRI.D_E_L_E_T_ = '' AND UCRI.USR_ID = SUBSTRING(A.BQC_USERGI, 11,1)+SUBSTRING(A.BQC_USERGI, 15,1)+SUBSTRING(A.BQC_USERGI, 2, 1)+SUBSTRING(A.BQC_USERGI, 6, 1)+SUBSTRING(A.BQC_USERGI, 10,1)+SUBSTRING(A.BQC_USERGI, 14,1)+SUBSTRING(A.BQC_USERGI, 1, 1)+SUBSTRING(A.BQC_USERGI, 5, 1)+SUBSTRING(A.BQC_USERGI, 9, 1)+SUBSTRING(A.BQC_USERGI, 13,1)+SUBSTRING(A.BQC_USERGI, 17,1)+SUBSTRING(A.BQC_USERGI, 4, 1) "
        cQuery += " WHERE 1=1 "
        cQuery += " AND A.D_E_L_E_T_ = '' "
        cQuery += " AND A.BQC_DATBLO = '' "
        cQuery += " AND CASE WHEN SUBSTRING(A.BQC_USERGI, 03, 1) != ' ' AND A.BQC_USERGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(A.BQC_USERGI,12,1)) - 50, ASCII(SUBSTRING(A.BQC_USERGI,16,1)) - 50) + IIF(SUBSTRING(A.BQC_USERGI,08,1) = '<',10000,0)),'1996-01-01'), 112) ELSE '19000101' END BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
        //cQuery += " AND A.BQC_DATCON BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
        cQuery += " AND A.BQC_CODEMP IN ('"+cPJExc+"','"+cPJNExc+"') "
        cQuery += " AND B.BA3_FILIAL IN ('"+cFilialRP+"','"+cFilialCAMP+"','"+cFilialSP+"','"+cFilialLIT+"','"+cFilialTECH+"','"+cFilialRIO+"','"+cFilialLOC+"') "
        cQuery += " AND A.BQC_NUMCON IN ('"+cColetivo+"','"+cTotalColetivo+"','"+cEssencColetivo+"','"+cAreaProtegida+"','"+cLocacao+"','"+cAmbulatorio+"','"+cTelemedicina+"','"+cRemocao+"','"+cHomeCare+"','"+cOMT+"','"+cAssociacao+"','"+cTotalAssociacao+"') "
        cQuery += " GROUP BY B.BA3_FILIAL ,A.BQC_CODEMP,A.BQC_SUBCON,A.BQC_ANTCON,E.BT5_NOME  ,H.A3_NOME   ,I.A1_COD    ,I.A1_NOME   ,I.A1_NREDUZ ,I.A1_CGC    ,A.BQC_DATCON,F.BQL_DESCRI,G.ZI0_DESCRI,A.BQC_USERGI,UCRI.USR_CODIGO,A.BQC_CODINT,A.BQC_NUMCON,A.BQC_VERCON,A.BQC_VERSUB "

        cQuery += " UNION ALL "

        /* PESSOA FISICA */
        cQuery += " SELECT "
        cQuery += " CASE   "
        cQuery += " WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP'   "
        cQuery += " WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP'   "
        cQuery += " WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP'   "
        cQuery += " WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH'   "
        cQuery += " WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL'   "
        cQuery += " WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI'   "
        cQuery += " WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD'   "
        cQuery += " WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ'   "
        cQuery += " ELSE ''   "
        cQuery += " END             AS FILIAL,  "
        cQuery += " CASE "
        cQuery += "     WHEN A.BQC_CODEMP = '0003' THEN '0003 - PESSOA FISICA ' "
        cQuery += "     WHEN A.BQC_CODEMP = '0004' THEN '0004 - PESSOA JURIDICA ' "
        cQuery += "     WHEN A.BQC_CODEMP = '0005' THEN '0005 - PESSOA JURIDICA EXCESSAO ' "
        cQuery += "     WHEN A.BQC_CODEMP = '0006' THEN '0006 - PESSOA FISICA EXCESSAO ' "
        cQuery += " ELSE '' "
        cQuery += " END             AS GRUPOEMP, "
        cQuery += " B.BA3_MATEMP    AS IDCONTRATO, "
        cQuery += " B.BA3_XCARTE    AS NUMERO, "
        cQuery += " E.BT5_NOME      AS PERFIL, "
        cQuery += " H.A3_NOME       AS VENDEDOR, "
        cQuery += " I.A1_COD        AS CODCLI, "
        cQuery += " I.A1_NOME       AS RAZAOSOC, "
        cQuery += " I.A1_NREDUZ     AS NOMEFANT, "
        cQuery += " I.A1_CGC        AS CGC, "
        cQuery += " CONCAT(SUBSTRING(B.BA3_DATBAS,7,2),'/',SUBSTRING(B.BA3_DATBAS,5,2),'/',SUBSTRING(B.BA3_DATBAS,1,4)) AS DTBASE, "
        cQuery += " CASE WHEN SUBSTRING(B.BA3_USERGI, 03, 1) != ' ' AND B.BA3_USERGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(B.BA3_USERGI,12,1)) - 50, ASCII(SUBSTRING(B.BA3_USERGI,16,1)) - 50) + IIF(SUBSTRING(B.BA3_USERGI,08,1) = '<',10000,0)),'1996-01-01'), 103) ELSE '01/01/1900' END AS DTINC, "
        cQuery += " F.BQL_DESCRI    AS FORMAPAG, "
        cQuery += " G.ZI0_DESCRI    AS CONDPAG, "
        cQuery += " SUBSTRING(B.BA3_USERGI, 11,1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 15,1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 2, 1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 6, 1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 10,1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 14,1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 1, 1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 5, 1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 9, 1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 13,1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 17,1)+ "
        cQuery += " SUBSTRING(B.BA3_USERGI, 4, 1) AS CODUSU, "
        cQuery += " UCRI.USR_CODIGO AS USUARIO, "
        cQuery += " ISNULL((  "
        cQuery += " SELECT  "
        cQuery += " SUM(D.BDK_VALOR)  "
        cQuery += " FROM BA3010 BA3  "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP   "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
        cQuery += " WHERE 1=1  "
        cQuery += " AND BA3.D_E_L_E_T_ = ''   "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = ''  "
        cQuery += " ),0) AS VLRTOTAL "
        cQuery += " FROM BQC010 A   "
        cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "      "
        cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG  "
        cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI  "
        cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_ZZVEND  "
        cQuery += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = B.BA3_CODCLI AND I.A1_LOJA = B.BA3_LOJA  "
        cQuery += " LEFT JOIN SYS_USR UCRI ON UCRI.D_E_L_E_T_ = '' AND UCRI.USR_ID = SUBSTRING(B.BA3_USERGI, 11,1)+SUBSTRING(B.BA3_USERGI, 15,1)+SUBSTRING(B.BA3_USERGI, 2, 1)+SUBSTRING(B.BA3_USERGI, 6, 1)+SUBSTRING(B.BA3_USERGI, 10,1)+SUBSTRING(B.BA3_USERGI, 14,1)+SUBSTRING(B.BA3_USERGI, 1, 1)+SUBSTRING(B.BA3_USERGI, 5, 1)+SUBSTRING(B.BA3_USERGI, 9, 1)+SUBSTRING(B.BA3_USERGI, 13,1)+SUBSTRING(B.BA3_USERGI, 17,1)+SUBSTRING(B.BA3_USERGI, 4, 1) "
        cQuery += " WHERE 1=1 "
        cQuery += " AND A.D_E_L_E_T_ = '' "
        cQuery += " AND B.BA3_DATBLO = '' "
        cQuery += " AND CASE WHEN SUBSTRING(B.BA3_USERGI, 03, 1) != ' ' AND B.BA3_USERGI != '' THEN CONVERT(VARCHAR,DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(B.BA3_USERGI,12,1)) - 50, ASCII(SUBSTRING(B.BA3_USERGI,16,1)) - 50) + IIF(SUBSTRING(B.BA3_USERGI,08,1) = '<',10000,0)),'1996-01-01'), 112) ELSE '19000101' END BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
        //cQuery += " AND B.BA3_DATBAS BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
        cQuery += " AND B.BA3_CODEMP IN ('"+cPFExc+"','"+cPFNExc+"') "
        cQuery += " AND B.BA3_FILIAL IN ('"+cFilialRP+"','"+cFilialCAMP+"','"+cFilialSP+"','"+cFilialLIT+"','"+cFilialTECH+"','"+cFilialRIO+"','"+cFilialLOC+"') "
        cQuery += " AND B.BA3_CONEMP IN ('"+cFamiliar+"','"+cTFamiliar+"','"+cEFamiliar+"','"+cFuncionario+"','"+cTFamiAnual+"','"+cEFamiAnual+"') "

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("CADCTR","CADCTRMED",{ (_cAlias)->FILIAL,(_cAlias)->GRUPOEMP,(_cAlias)->IDCONTRATO,(_cAlias)->NUMERO,(_cAlias)->PERFIL,(_cAlias)->VENDEDOR,(_cAlias)->CODCLI,(_cAlias)->RAZAOSOC,(_cAlias)->NOMEFANT,(_cAlias)->CGC,(_cAlias)->DTBASE,(_cAlias)->DTINC,(_cAlias)->FORMAPAG,(_cAlias)->CONDPAG,(_cAlias)->CODUSU,(_cAlias)->USUARIO,(_cAlias)->VLRTOTAL })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'CTRCAD' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
