#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

/*

-----------------------------------------------------------------------------# 
							 U_RESUMOCONTATO							     #
-----------------------------------------------------------------------------# 
Funcao: U_RESUMOCONTATO														 #
Autor: Eduardo Jorge 													     #
Data: 15/01/2023														     #
Descricao: RESUMO DE VALORES E QUANTIDDADDE DE VIDAS DE UM CONTTRATO         #
*****************************************************************************#

*/

User function RESUMOCONTRATO()

    Local aArea   	:= GetArea()
    local cCodint   := BQC->BQC_CODINT
    local cCodemp   := BQC->BQC_CODEMP
    local cConemp   := BQC->BQC_NUMCON
    local cVercon   := BQC->BQC_VERCON
    Local cSubcon	:= BQC->BQC_SUBCON
    local cVersub   := BQC->BQC_VERSUB
   
    MsAguarde({|| fMontaTela(cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub)  },"Aguarde","Buscando Dados do Contrato...")
   
    RestArea(aArea)

Return


Static Function fMontaTela(cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub)


    Local cQueryResumo
    Private AliasCtr	    := GetNextAlias()

    cQueryResumo := " SELECT "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT TOP 1 "
    cQueryResumo += " CASE  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '001' THEN '001 - MEDICAR RP'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '003' THEN '003 - MEDICAR SP'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '014' THEN '014 - LOCAMEDI'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '016' THEN '016 - N1 CARD'  "
    cQueryResumo += "   WHEN BA3.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ'  "
    cQueryResumo += " ELSE ''  "
    cQueryResumo += " END             AS FIL "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " ),'')           AS FILIAL, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT TOP 1 "
    cQueryResumo += " CASE  "
    cQueryResumo += "   WHEN BA3.BA3_ESPTEL = '1' THEN 'SIM'  "
    cQueryResumo += " ELSE 'NAO'  "
    cQueryResumo += " END             AS TELEESP "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " ),'')           AS ESPETEL, "
    cQueryResumo += " A.BQC_SUBCON    AS IDCONTRATO,  "
    cQueryResumo += " A.BQC_ANTCON    AS NUMERO,  "
    cQueryResumo += " E.BT5_NOME      AS PERFIL,  "
    cQueryResumo += " F.BQL_DESCRI    AS FORMAPAG,  "
    cQueryResumo += " G.ZI0_DESCRI    AS CONDPAG,  "
    cQueryResumo += " CONCAT(SUBSTRING(A.BQC_DATCON,7,2),'/',SUBSTRING(A.BQC_DATCON,5,2),'/',SUBSTRING(A.BQC_DATCON,1,4)) AS DTBASE,  "
    cQueryResumo += " I.A1_COD        AS CODCLI,  "
    cQueryResumo += " I.A1_LOJA       AS LOJACLI,  "
    cQueryResumo += " I.A1_NREDUZ     AS CLIENTE,  "
    cQueryResumo += " CASE "
    cQueryResumo += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
    cQueryResumo += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
    cQueryResumo += " END             AS CGC, "
    cQueryResumo += " H.A3_NOME       AS VENDEDOR,  "
    cQueryResumo += " CONCAT(SUBSTRING(A.BQC_DATBLO,7,2),'/',SUBSTRING(A.BQC_DATBLO,5,2),'/',SUBSTRING(A.BQC_DATBLO,1,4)) AS DATBLOCTR,  "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " SUM(D.BDK_VALOR) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO = '' "
    cQueryResumo += " AND C.BA1_TIPUSU = 'T' "
    cQueryResumo += " ),0) AS VLR_TIT, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " SUM(D.BDK_VALOR) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO = '' "
    cQueryResumo += " AND C.BA1_TIPUSU <> 'T' "
    cQueryResumo += " ),0) AS VLR_DEP, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " SUM(D.BDK_VALOR) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO <> '' "
    cQueryResumo += " ),0) AS VLR_BLO, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " SUM(D.BDK_VALOR) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO = '' "
    cQueryResumo += " ),0) AS VLR_TOTAL, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " COUNT(*) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO = '' "
    cQueryResumo += " AND C.BA1_TIPUSU = 'T' "
    cQueryResumo += " ),0) AS QTD_TIT, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " COUNT(*) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO = '' "
    cQueryResumo += " AND C.BA1_TIPUSU <> 'T' "
    cQueryResumo += " ),0) AS QTD_DEP, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " COUNT(*) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO <> '' "
    cQueryResumo += " ),0) AS QTD_BLO, "
    cQueryResumo += " ISNULL(( "
    cQueryResumo += " SELECT "
    cQueryResumo += " COUNT(*) "
    cQueryResumo += " FROM BA3010 BA3 "
    cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
    cQueryResumo += " WHERE 1=1 "
    cQueryResumo += " AND BA3.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
    cQueryResumo += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
    cQueryResumo += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
    cQueryResumo += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
    cQueryResumo += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
    cQueryResumo += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
    cQueryResumo += " AND C.BA1_DATBLO = '' "
    cQueryResumo += " ),0) AS QTD_TOTAL "
    cQueryResumo += " FROM BQC010 A  "
    cQueryResumo += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
    cQueryResumo += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
    cQueryResumo += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
    cQueryResumo += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_ZZVEND "
    cQueryResumo += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = A.BQC_CODCLI AND I.A1_LOJA = A.BQC_LOJA "
    cQueryResumo += " WHERE 1=1  "
    cQueryResumo += " AND A.D_E_L_E_T_ = ''  "
    cQueryResumo += " AND A.BQC_CODINT = '"+cCodint+"'  "
    cQueryResumo += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
    cQueryResumo += " AND A.BQC_NUMCON = '"+cConemp+"'  "
    cQueryResumo += " AND A.BQC_VERCON = '"+cVercon+"'  "
    cQueryResumo += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
    cQueryResumo += " AND A.BQC_VERSUB = '"+cVersub+"'  "

    TCQUERY cQueryResumo NEW ALIAS (AliasCtr)
        
	//Verifica resultado da query
	DbSelectArea(AliasCtr)
    (AliasCtr)->(DbGoTop())


    If (AliasCtr)->(Eof())

        MsgInfo("Sem dados disponiveis.", "Contratos Medicar")

    Else

        DEFINE MSDIALOG oDlg FROM 05,10 TO 400,1050 TITLE " Resumo Contrato Medicar " PIXEL

            @ 010,020 TO 185,300 LABEL " Dados do Contrato " OF oDlg PIXEL

            @ 025, 025 SAY oTitQtdVidas PROMPT "Filial "                        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 025 MSGET oGrupo VAR (AliasCtr)->FILIAL                      SIZE 080, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 025, 110 SAY oTitQtdVidas PROMPT "Id. Contrato "                   SIZE 070, 020 OF oDlg PIXEL
            @ 035, 110 MSGET oGrupo VAR (AliasCtr)->IDCONTRATO                   SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 025, 170 SAY oTitQtdVidas PROMPT "Numero "                         SIZE 070, 020 OF oDlg PIXEL
            @ 035, 170 MSGET oGrupo VAR (AliasCtr)->NUMERO                       SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 025, 240 SAY oTitQtdVidas PROMPT "Especialidade "                  SIZE 070, 020 OF oDlg PIXEL
            @ 035, 240 MSGET oGrupo VAR (AliasCtr)->ESPETEL                      SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 055, 025 SAY oTitQtdVidas PROMPT "Perfil "                         SIZE 070, 020 OF oDlg PIXEL
            @ 065, 025 MSGET oGrupo VAR (AliasCtr)->PERFIL                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
            
            @ 055, 130 SAY oTitQtdVidas PROMPT "Dt. Base "                       SIZE 070, 020 OF oDlg PIXEL
            @ 065, 130 MSGET oGrupo VAR (AliasCtr)->DTBASE                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 055, 190 SAY oTitQtdVidas PROMPT "Dt. Bloqueio "                   SIZE 070, 020 OF oDlg PIXEL
            @ 065, 190 MSGET oGrupo VAR (AliasCtr)->DATBLOCTR                    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
            @ 085, 025 SAY oTitQtdVidas PROMPT "Forma Pg "                       SIZE 070, 020 OF oDlg PIXEL
            @ 095, 025 MSGET oGrupo VAR (AliasCtr)->FORMAPAG                     SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 085, 100 SAY oTitQtdVidas PROMPT "Cond. Pg "                       SIZE 070, 020 OF oDlg PIXEL
            @ 095, 100 MSGET oGrupo VAR (AliasCtr)->CONDPAG                      SIZE 110, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 115, 025 SAY oTitQtdVidas PROMPT "Cpf/Cnpj "                       SIZE 070, 020 OF oDlg PIXEL
            @ 125, 025 MSGET oGrupo VAR (AliasCtr)->CGC                          SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
    
            @ 115, 100 SAY oTitQtdVidas PROMPT "Cod. Cliente "                   SIZE 070, 020 OF oDlg PIXEL
            @ 125, 100 MSGET oGrupo VAR (AliasCtr)->CODCLI                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 115, 160 SAY oTitQtdVidas PROMPT "Cliente "                        SIZE 070, 020 OF oDlg PIXEL
            @ 125, 160 MSGET oGrupo VAR (AliasCtr)->CLIENTE                      SIZE 120, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 145, 025 SAY oTitQtdVidas PROMPT "Vendedor "                       SIZE 070, 020 OF oDlg PIXEL
            @ 155, 025 MSGET oGrupo VAR (AliasCtr)->VENDEDOR                     SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


            @ 010,320 TO 185,500 LABEL " Quantidade e Valores " OF oDlg PIXEL
            @ 030, 400 SAY oTitQtdVidas PROMPT " Qtd  "                        SIZE 070, 020 OF oDlg PIXEL
            @ 030, 445 SAY oTitQtdVidas PROMPT " Vlr R$  "                      SIZE 070, 020 OF oDlg PIXEL
            
            @ 045, 325 SAY oTitQtdVidas PROMPT " Titular  "                      SIZE 070, 020 OF oDlg PIXEL
            @ 060, 325 SAY oTitQtdVidas PROMPT " Depedente  "                    SIZE 070, 020 OF oDlg PIXEL
            @ 075, 325 SAY oTitQtdVidas PROMPT " Bloquados "                     SIZE 070, 020 OF oDlg PIXEL
            @ 090, 325 SAY oTitQtdVidas PROMPT " Total (Ativos) "                SIZE 070, 020 OF oDlg PIXEL

            @ 040, 385 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->QTD_TIT  ,9,0) )    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999999"
            @ 040, 440 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->VLR_TIT  ,14,2))    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
            @ 055, 385 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->QTD_DEP  ,9,0) )    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999999"
            @ 055, 440 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->VLR_DEP  ,14,2))    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
            @ 070, 385 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->QTD_BLO  ,9,0) )    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999999"
            @ 070, 440 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->VLR_BLO  ,14,2))    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
            @ 085, 385 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->QTD_TOTAL,9,0) )    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999999"
            @ 085, 440 MSGET oTitQtdVidas VAR val(Str((AliasCtr)->VLR_TOTAL,14,2))    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
    
        DEFINE SBUTTON FROM 155,250 TYPE 1 ACTION ( oDlg:End() ) ENABLE OF oDlg

        ACTIVATE MSDIALOG oDlg CENTER

    Endif


    (AliasCtr)->(DbCloseArea())

Return
