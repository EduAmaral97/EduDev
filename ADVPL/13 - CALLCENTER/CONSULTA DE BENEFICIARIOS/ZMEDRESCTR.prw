#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Complemento da Rotina desenvolvida para consulta facilitada de beneficiarios cadastrados (BA1).

------------------------------------------------------------------------------- */

User function ZMEDRESCTR(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)

    Local aArea := GetArea()
    Private AliasCtr := GetNextAlias()

    //MsgAlert("Dados: " + cFilialCtr + cCodint + cCodemp + cConemp + cVercon + cSubcon + cVersub + cMatemp)

	//Monta arquivo de trabalho temporário
	//Processa({||MontaQuery(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)},"Obtendo Dados...")
    MsAguarde({|| MontaQuery(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp) },"Aguarde","Obtendo dados do Contrato...")
    
    RestArea( aArea )

return


Static Function MontaQuery(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)

    Local cQuery


    IF cSubcon = '000000001' 

        cQuery := " SELECT "
        cQuery += " CASE  "
        cQuery += "   WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP'  "
        cQuery += "   WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP'  "
        cQuery += "   WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP'  "
        cQuery += "   WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH'  "
        cQuery += "   WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL'  "
        cQuery += "   WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI'  "
        cQuery += "   WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD'  "
        cQuery += "   WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ'  "
        cQuery += " ELSE ''  "
        cQuery += " END             AS FILIAL, "
        cQuery += " CASE  "
        cQuery += "   WHEN B.BA3_ESPTEL = '1' THEN 'SIM'  "
        cQuery += " ELSE 'NAO'  "
        cQuery += " END             AS ESPETEL, "
        cQuery += " B.BA3_MATEMP    AS IDCONTRATO,  "
        cQuery += " B.BA3_XCARTE    AS NUMERO,  "
        cQuery += " E.BT5_NOME      AS PERFIL,  "
        cQuery += " F.BQL_DESCRI    AS FORMAPAG,  "
        cQuery += " G.ZI0_DESCRI    AS CONDPAG,  "
        cQuery += " CONCAT(SUBSTRING(B.BA3_DATBAS,7,2),'/',SUBSTRING(B.BA3_DATBAS,5,2),'/',SUBSTRING(B.BA3_DATBAS,1,4)) AS DTBASE,  "
        cQuery += " I.A1_COD        AS CODCLI,  "
        cQuery += " I.A1_LOJA       AS LOJACLI, "
        cQuery += " I.A1_NREDUZ     AS CLIENTE, "
        cQuery += " CASE "
        cQuery += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
        cQuery += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
        cQuery += " END             AS CGC, "
        cQuery += " H.A3_NOME       AS VENDEDOR,  "
        cQuery += " CONCAT(SUBSTRING(B.BA3_DATBLO,7,2),'/',SUBSTRING(B.BA3_DATBLO,5,2),'/',SUBSTRING(B.BA3_DATBLO,1,4)) AS DATBLOCTR,  "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU = 'T' "
        cQuery += " ),0) AS VLR_TIT, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU <> 'T' "
        cQuery += " ),0) AS VLR_DEP, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO <> '' "
        cQuery += " ),0) AS VLR_BLO, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " ),0) AS VLR_TOTAL, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU = 'T' "
        cQuery += " ),0) AS QTD_TIT, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU <> 'T' "
        cQuery += " ),0) AS QTD_DEP, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO <> '' "
        cQuery += " ),0) AS QTD_BLO, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " ),0) AS QTD_TOTAL "
        cQuery += " FROM BQC010 A  "
        cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB "
        cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "      
        cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG "
        cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI "
        cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_ZZVEND "
        cQuery += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = B.BA3_CODCLI AND I.A1_LOJA = B.BA3_LOJA "
        cQuery += " WHERE 1=1  "
        cQuery += " AND A.D_E_L_E_T_ = ''  "
        cQuery += " AND A.BQC_CODINT = '"+cCodint+"'  "
        cQuery += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
        cQuery += " AND A.BQC_NUMCON = '"+cConemp+"'  "
        cQuery += " AND A.BQC_VERSUB = '"+cVercon+"'  "
        cQuery += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQuery += " AND A.BQC_VERCON = '"+cVersub+"'  "
        cQuery += " AND B.BA3_MATEMP = '"+cMatemp+"'  "

    ELSE

        cQuery := " SELECT "
        cQuery += " ISNULL(( "
        cQuery += " SELECT TOP 1 "
        cQuery += " CASE  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '001' THEN '001 - MEDICAR RP'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '003' THEN '003 - MEDICAR SP'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '014' THEN '014 - LOCAMEDI'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '016' THEN '016 - N1 CARD'  "
        cQuery += "   WHEN BA3.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ'  "
        cQuery += " ELSE ''  "
        cQuery += " END             AS FIL "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " ),'')           AS FILIAL, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT TOP 1 "
        cQuery += " CASE  "
        cQuery += "   WHEN BA3.BA3_ESPTEL = '1' THEN 'SIM'  "
        cQuery += " ELSE 'NAO'  "
        cQuery += " END             AS TELEESP "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " ),'')           AS ESPETEL, "
        cQuery += " A.BQC_SUBCON    AS IDCONTRATO,  "
        cQuery += " A.BQC_ANTCON    AS NUMERO,  "
        cQuery += " E.BT5_NOME      AS PERFIL,  "
        cQuery += " F.BQL_DESCRI    AS FORMAPAG,  "
        cQuery += " G.ZI0_DESCRI    AS CONDPAG,  "
        cQuery += " CONCAT(SUBSTRING(A.BQC_DATCON,7,2),'/',SUBSTRING(A.BQC_DATCON,5,2),'/',SUBSTRING(A.BQC_DATCON,1,4)) AS DTBASE,  "
        cQuery += " I.A1_COD        AS CODCLI,  "
        cQuery += " I.A1_LOJA       AS LOJACLI,  "
        cQuery += " I.A1_NREDUZ     AS CLIENTE,  "
        cQuery += " CASE "
        cQuery += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
        cQuery += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
        cQuery += " END             AS CGC, "
        cQuery += " H.A3_NOME       AS VENDEDOR,  "
        cQuery += " CONCAT(SUBSTRING(A.BQC_DATBLO,7,2),'/',SUBSTRING(A.BQC_DATBLO,5,2),'/',SUBSTRING(A.BQC_DATBLO,1,4)) AS DATBLOCTR,  "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU = 'T' "
        cQuery += " ),0) AS VLR_TIT, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU <> 'T' "
        cQuery += " ),0) AS VLR_DEP, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO <> '' "
        cQuery += " ),0) AS VLR_BLO, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " SUM(D.BDK_VALOR) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " ),0) AS VLR_TOTAL, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU = 'T' "
        cQuery += " ),0) AS QTD_TIT, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " AND C.BA1_TIPUSU <> 'T' "
        cQuery += " ),0) AS QTD_DEP, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO <> '' "
        cQuery += " ),0) AS QTD_BLO, "
        cQuery += " ISNULL(( "
        cQuery += " SELECT "
        cQuery += " COUNT(*) "
        cQuery += " FROM BA3010 BA3 "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = BA3.BA3_FILIAL AND C.BA1_CODINT = BA3.BA3_CODINT AND C.BA1_CODEMP = BA3.BA3_CODEMP AND C.BA1_CONEMP = BA3.BA3_CONEMP AND C.BA1_VERCON = BA3.BA3_VERCON AND C.BA1_SUBCON = BA3.BA3_SUBCON AND C.BA1_VERSUB = BA3.BA3_VERSUB AND C.BA1_MATEMP = BA3.BA3_MATEMP  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND BA3.D_E_L_E_T_ = ''  "
        cQuery += " AND BA3.BA3_CODINT = A.BQC_CODINT  "
        cQuery += " AND BA3.BA3_CODEMP = A.BQC_CODEMP  "
        cQuery += " AND BA3.BA3_CONEMP = A.BQC_NUMCON  "
        cQuery += " AND BA3.BA3_VERCON = A.BQC_VERCON  "
        cQuery += " AND BA3.BA3_SUBCON = A.BQC_SUBCON  "
        cQuery += " AND BA3.BA3_VERSUB = A.BQC_VERSUB  "
        cQuery += " AND C.BA1_DATBLO = '' "
        cQuery += " ),0) AS QTD_TOTAL "
        cQuery += " FROM BQC010 A  "
        cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
        cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
        cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
        cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_ZZVEND "
        cQuery += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = A.BQC_CODCLI AND I.A1_LOJA = A.BQC_LOJA "
        cQuery += " WHERE 1=1  "
        cQuery += " AND A.D_E_L_E_T_ = ''  "
        cQuery += " AND A.BQC_CODINT = '"+cCodint+"'  "
        cQuery += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
        cQuery += " AND A.BQC_NUMCON = '"+cConemp+"'  "
        cQuery += " AND A.BQC_VERSUB = '"+cVercon+"'  "
        cQuery += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQuery += " AND A.BQC_VERCON = '"+cVersub+"'  "
      
    ENDIF


    TCQUERY cQuery NEW ALIAS (AliasCtr)


	//Verifica resultado da query
	DbSelectArea(AliasCtr)
    (AliasCtr)->(DbGoTop())

    //Define o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
    (AliasCtr)->(DbGoTop())


    //MsAguarde({||MontaTela()},"Aguarde","Gerando Arquivo em Excel...")
    MontaTela()


Return 


Static Function MontaTela()

    Local oDlg as object

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
    
        TButton():New( 155, 220 , "Titulos", oDlg, {|| U_ZMEDTITCLI((AliasCtr)->CODCLI,"01",(AliasCtr)->CLIENTE) }, 025,012, ,,,.T.,,,,,,)

        DEFINE SBUTTON FROM 155,250 TYPE 1 ACTION ( oDlg:End() ) ENABLE OF oDlg
        

        ACTIVATE MSDIALOG oDlg CENTER

    Endif


    (AliasCtr)->(DbCloseArea())   

Return

