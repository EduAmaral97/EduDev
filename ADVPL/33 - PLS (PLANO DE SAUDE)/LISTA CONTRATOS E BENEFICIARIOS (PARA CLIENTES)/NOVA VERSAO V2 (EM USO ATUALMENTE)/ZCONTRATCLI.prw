#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "FWMVCDEF.CH"


/* ----------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/04/2024
Objetivo: Devenvolvido para facilitar consulta de contratos/beneficiarios e valores por cliente em tela.

---------------------------------------------------------------------------- */


/* ------------------------------------ CONTRATOS DO CLIENTE ------------------------------------ */

USER FUNCTION ZCONTRATCLI(cSA1cliente, cSA1lojacli, cTipCli)
    
    Local aArea     := GetArea()
    Private _cAlias := GetNextAlias()
    
    //MsAguarde({||PegaDados(cSA1cliente, cSA1lojacli, cTipCli)},"Aguarde","Buscando Contratos...") 
    PegaDados(cSA1cliente, cSA1lojacli, cTipCli)
    
    DbSelectArea(_cAlias)
    (_cAlias)->(DbGoTop())

    IF (_cAlias)->(Eof())
        MsgInfo("Cliente nao possui contrato.", "Contratos Medicar.")
    Else        
        MontaTela(cSA1cliente, cSA1lojacli, cTipCli)
    EndIF
    
    (_cAlias)->(DbCloseArea())
    
    DbSelectArea('SA1')
    SA1->(DbSetOrder(1))
    If SA1->(DbSeek(FWxFilial("SA1")+cSA1cliente+cSA1lojacli))
        RestArea(aArea)
    EndIF

    
    
RETURN


Static Function PegaDados(cSA1cliente, cSA1lojacli, cTipCli)

	Local cQuery  

            cQuery := " SELECT "            
            cQuery += " CASE "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '001' THEN 'Medicar Ribeirao Preto' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '002' THEN 'Medicar Campinas' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '003' THEN 'Medicar Sao Paulo' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '006' THEN 'Medicar Tech' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '008' THEN 'Medicar Litoral' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '016' THEN 'N1 Card' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '021' THEN 'Medicar Rio de Janeiro' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '014' THEN 'Locamedi Matriz'  "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '022' THEN 'Medicar Goiania'  "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '023' THEN 'Medicar Belo Horizonte'  "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '024' THEN 'Medicar Brasilia'  "
            cQuery += "     ELSE '' "
            cQuery += " END              AS FILIAL, "
            cQuery += " CASE "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '001' THEN '001'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '002' THEN '002'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '003' THEN '003'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '006' THEN '006'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '008' THEN '008'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '016' THEN '016'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '021' THEN '021'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '014' THEN '014'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '022' THEN '022'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '023' THEN '023'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB AND BA1.BA1_DATBLO = ''),'') = '024' THEN '024'  
            cQuery += "     ELSE '' "
            cQuery += " END              AS FILIALCTR, "
            cQuery += " CASE "
            cQuery += "     WHEN A.BQC_CODEMP = '0003' THEN '0003 - PESSOA FISICA' "
            cQuery += "     WHEN A.BQC_CODEMP = '0004' THEN '0004 - PESSOA JURIDICA' "
            cQuery += "     WHEN A.BQC_CODEMP = '0005' THEN '0005 - PESSOA JURIDICA EXCESSAO' "
            cQuery += "     WHEN A.BQC_CODEMP = '0006' THEN '0006 - PESSOA FISICA EXCESSAO' "
            cQuery += " ELSE '' "
            cQuery += " END              AS GRUPOEMP, "    
            cQuery += " A.BQC_SUBCON     AS IDCONTRATO, "
            cQuery += " A.BQC_ANTCON     AS NUMERO, "
            cQuery += " E.BT5_NOME       AS PERFIL, "
            cQuery += " F.BQL_DESCRI     AS FORMPAG, "
            cQuery += " G.ZI0_DESCRI     AS CONDPAG, "
            cQuery += " CASE "
            cQuery += "     WHEN A.BQC_DATBLO <> '' THEN 'BLOQUEADO' "
            cQuery += "     ELSE 'ATIVO' "
            cQuery += " END             AS STATUSC, "
            cQuery += " CONCAT(SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),7,2),'/',SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),5,2),'/',SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),1,4)) AS DTBASE, "
            cQuery += " CONCAT(SUBSTRING(CAST(A.BQC_DATBLO AS VARCHAR),7,2),'/',SUBSTRING(CAST(A.BQC_DATBLO AS VARCHAR),5,2),'/',SUBSTRING(CAST(A.BQC_DATBLO AS VARCHAR),1,4)) AS DTBLOQ, "
            cQuery += " I.BG1_DESBLO    AS DESCBLO, "
            cQuery += " H.A3_NOME       AS VENDEDOR, "
            cQuery += " A.BQC_CODINT    AS CODINT, "
            cQuery += " A.BQC_CODEMP    AS CODEMP, "
            cQuery += " A.BQC_NUMCON    AS CONEMP, "
            cQuery += " A.BQC_VERCON    AS VERCON, "
            cQuery += " A.BQC_SUBCON    AS SUBCON, "
            cQuery += " A.BQC_VERSUB    AS VERSUB, "            
            cQuery += " ''              AS MATEMP "
            cQuery += " FROM BQC010 A "
            cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
            cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
            cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
            cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_CODVEN "
            cQuery += " LEFT JOIN BG1010 I ON I.D_E_L_E_T_ = '' AND I.BG1_FILIAL = A.BQC_FILIAL AND I.BG1_CODBLO = A.BQC_CODBLO "
            cQuery += " WHERE 1=1  "
            cQuery += " AND A.D_E_L_E_T_ = '' "
            cQuery += " AND A.BQC_CODEMP IN ('0004','0005')  "
            cQuery += " AND A.BQC_COBNIV = '1' "
            cQuery += " AND A.BQC_CODCLI = '"+cSA1cliente+"'"
            cQuery += " AND A.BQC_LOJA = '"+cSA1lojacli+"' "
            cQuery += " GROUP BY A.BQC_CODINT,A.BQC_CODEMP,A.BQC_NUMCON,A.BQC_VERCON,A.BQC_VERSUB,A.BQC_SUBCON,A.BQC_ANTCON,E.BT5_NOME,F.BQL_DESCRI,G.ZI0_DESCRI,A.BQC_TIPBLO,A.BQC_DATBLO,A.BQC_DATCON,I.BG1_DESBLO,H.A3_NOME "

            cQuery += "UNION ALL "

            cQuery += " SELECT "            
            cQuery += " CASE "
            cQuery += "     WHEN B.BA3_FILIAL = '001' THEN 'Medicar Ribeirao Preto' "
            cQuery += "     WHEN B.BA3_FILIAL = '002' THEN 'Medicar Campinas' "
            cQuery += "     WHEN B.BA3_FILIAL = '003' THEN 'Medicar Sao Paulo' "
            cQuery += "     WHEN B.BA3_FILIAL = '006' THEN 'Medicar Tech' "
            cQuery += "     WHEN B.BA3_FILIAL = '008' THEN 'Medicar Litoral' "
            cQuery += "     WHEN B.BA3_FILIAL = '016' THEN 'N1 Card' "
            cQuery += "     WHEN B.BA3_FILIAL = '021' THEN 'Medicar Rio de Janeiro' "
            cQuery += "     WHEN B.BA3_FILIAL = '014' THEN 'Locamedi Matriz'  "
            cQuery += "     WHEN B.BA3_FILIAL = '022' THEN 'Medicar Goiania'  "
            cQuery += "     WHEN B.BA3_FILIAL = '023' THEN 'Medicar Belo Horizonte'  "
            cQuery += "     WHEN B.BA3_FILIAL = '024' THEN 'Medicar Brasilia'  "
            cQuery += "     ELSE '' "
            cQuery += " END               AS FILIAL, "
            cQuery += " B.BA3_FILIAL      AS FILIALCTR, "
            cQuery += " CASE "
            cQuery += "     WHEN B.BA3_CODEMP = '0003' THEN '0003 - PESSOA FISICA' "
            cQuery += "     WHEN B.BA3_CODEMP = '0004' THEN '0004 - PESSOA JURIDICA' "
            cQuery += "     WHEN B.BA3_CODEMP = '0005' THEN '0005 - PESSOA JURIDICA EXCESSAO' "
            cQuery += "     WHEN B.BA3_CODEMP = '0006' THEN '0006 - PESSOA FISICA EXCESSAO' "
            cQuery += " ELSE '' "
            cQuery += " END              AS GRUPOEMP, " 
            cQuery += " B.BA3_MATEMP     AS IDCONTRATO,  "
            cQuery += " B.BA3_XCARTE     AS NUMERO,  "
            cQuery += " E.BT5_NOME       AS PERFIL, "
            cQuery += " F.BQL_DESCRI     AS FORMPAG, "
            cQuery += " G.ZI0_DESCRI     AS CONDPAG, "
            cQuery += " CASE "
            cQuery += "     WHEN B.BA3_DATBLO <> '' THEN 'BLOQUEADO' "
            cQuery += "     ELSE 'ATIVO' "
            cQuery += " END             AS STATUSC, "
            cQuery += " CONCAT(SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),1,4)) AS DTBASE, "
            cQuery += " CONCAT(SUBSTRING(CAST(B.BA3_DATBLO AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA3_DATBLO AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA3_DATBLO AS VARCHAR),1,4)) AS DTBLOQ, "
            cQuery += " I.BG1_DESBLO    AS DESCBLO, "
            cQuery += " H.A3_NOME       AS VENDEDOR, "
            cQuery += " B.BA3_CODINT    AS CODINT, "
            cQuery += " B.BA3_CODEMP    AS CODEMP, "
            cQuery += " B.BA3_CONEMP    AS CONEMP, "
            cQuery += " B.BA3_VERCON    AS VERCON, "
            cQuery += " B.BA3_SUBCON    AS SUBCON, "
            cQuery += " B.BA3_VERSUB    AS VERSUB, "            
            cQuery += " B.BA3_MATEMP    AS MATEMP "
            cQuery += " FROM BQC010 A  "
            cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB "
            cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
            cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG  "
            cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI  "
            cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_CODVEN  "
            cQuery += " LEFT JOIN BG1010 I ON I.D_E_L_E_T_ = '' AND I.BG1_FILIAL = B.BA3_FILIAL AND I.BG1_CODBLO = B.BA3_MOTBLO "
            cQuery += " WHERE 1=1  "
            cQuery += " AND A.D_E_L_E_T_ = ''  "
            cQuery += " AND A.BQC_CODEMP IN ('0003','0006')  "
            cQuery += " AND B.BA3_COBNIV = '1' "
            cQuery += " AND B.BA3_CODCLI = '"+cSA1cliente+"' "
            cQuery += " AND B.BA3_LOJA = '"+cSA1lojacli+"' "
            cQuery += " GROUP BY B.BA3_FILIAL,B.BA3_XCARTE,E.BT5_NOME,F.BQL_DESCRI,G.ZI0_DESCRI,B.BA3_MOTBLO,B.BA3_DATBLO,B.BA3_DATBAS,I.BG1_DESBLO,H.A3_NOME,B.BA3_CODINT,B.BA3_CODEMP,B.BA3_CONEMP,B.BA3_VERCON,B.BA3_SUBCON,B.BA3_VERSUB,B.BA3_MATEMP "
    
	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)



    

Return


Static Function MontaTela(cSA1cliente, cSA1lojacli, cTipCli)
    
    
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oBrowse as object
    Local oDlg as object
    Local aCoors as array
    Local cCli

    DbSelectArea('SA1')
    SA1->(DbSetOrder(1))
    
    cCli := SA1->A1_NREDUZ

    SA1->(DbCloseArea())

    aCoors := FWGetDialogSize()


    //DEFINE DIALOG oDlg TITLE "Contratos Cliente" FROM aCoors[1], aCoors[2] TO aCoors[3]/1.6 , aCoors[4] - (aCoors[4]/3)PIXEL
    DEFINE DIALOG oDlg TITLE "Contratos Cliente" FROM 0, 0 TO 470 , 980 PIXEL
 
        aBrowse := {}

        @ 010, 020 SAY oTitParametro PROMPT "Cliente: "      SIZE 070, 020 OF oDlg PIXEL
        @ 006, 040 MSGET oGrupo VAR  cCli                    SIZE 120, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
   
        While (_cAlias)->(!Eof())
        
            // Vetor com elementos do Browse
            aAdd(aBrowse, { IF((_cAlias)->STATUSC = 'ATIVO',.T.,.F.),(_cAlias)->FILIAL,(_cAlias)->GRUPOEMP,(_cAlias)->IDCONTRATO,(_cAlias)->NUMERO,(_cAlias)->PERFIL,(_cAlias)->FORMPAG,(_cAlias)->CONDPAG,(_cAlias)->STATUSC,(_cAlias)->DTBASE,(_cAlias)->DTBLOQ,(_cAlias)->DESCBLO,(_cAlias)->VENDEDOR,(_cAlias)->FILIALCTR,(_cAlias)->CODINT,(_cAlias)->CODEMP,(_cAlias)->CONEMP,(_cAlias)->VERCON,(_cAlias)->SUBCON,(_cAlias)->VERSUB,(_cAlias)->MATEMP }) // DADOS DA QUERY

            (_cAlias)->(dBskip())

        EndDo

        // Cria Browse
        oBrowse := TCBrowse():New( 30 , 5, 420, 200,, {'','Filial','Grupo Empresa','Id Contrato','Numero','Perfil','Form. Pg.','Cond.Pg.','Status','Dt. Base','Dt. Bloqueio','Motivo Bloqueio','Vendedor'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
        
        // Seta vetor para a browse
        oBrowse:SetArray(aBrowse)
 
        // Monta a linha a ser exibina no Browse
        //Transform(aBrowse[oBrowse:nAT,04],'@E 99,999,999,999.99')
        oBrowse:bLine := {||{ If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07],aBrowse[oBrowse:nAt,08],aBrowse[oBrowse:nAt,09],aBrowse[oBrowse:nAt,10],aBrowse[oBrowse:nAt,11],aBrowse[oBrowse:nAt,12],aBrowse[oBrowse:nAt,13] }}


        // Evento de clique no cabeçalho da browse
        //oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }


        // Evento de duplo click na celula
        //oBrowse:bLDblClick := {|| alert('bLDblClick') }

        // Cria Botoes com metodos básicos
        TButton():New( 010, 430, "Resumo Contrato",   oDlg,{|| MsAguarde({|| ResumoCtr( aBrowse[oBrowse:nAt,14],aBrowse[oBrowse:nAt,15],aBrowse[oBrowse:nAt,16],aBrowse[oBrowse:nAt,17],aBrowse[oBrowse:nAt,18],aBrowse[oBrowse:nAt,19],aBrowse[oBrowse:nAt,20],aBrowse[oBrowse:nAt,21] )  },"Aguarde","Buscando Dados do Contrato...")  },50,018,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 035, 430, "Beneficiarios ",    oDlg,{|| MsAguarde({|| BenefiCtr( aBrowse[oBrowse:nAt,14],aBrowse[oBrowse:nAt,15],aBrowse[oBrowse:nAt,16],aBrowse[oBrowse:nAt,17],aBrowse[oBrowse:nAt,18],aBrowse[oBrowse:nAt,19],aBrowse[oBrowse:nAt,20],aBrowse[oBrowse:nAt,21] )  },"Aguarde","Buscando Beneficiarios...")  },50,018,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 060, 430, "Titulos ",          oDlg,{|| MsAguarde({|| fTituloCli(cSA1cliente, cSA1lojacli)  },"Aguarde","Buscando Titulos...")  },50,018,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 085, 430, "Sair",              oDlg,{|| oDlg:End()}, 50,018, ,,,.T.,,,,,,)

        //TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        //TButton():New( 160, 052, "GoDown()" , oDlg,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        //TButton():New( 160, 102, "GoTop()" , oDlg,{|| oBrowse:GoTop(),oBrowse:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
        //TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        //TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        //TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        //TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        //TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
 
    ACTIVATE DIALOG oDlg CENTERED

    
    

Return


/* ------------------------------------ RESUMO DE CONTRATO ------------------------------------ */

Static Function ResumoCtr(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)   

    Local cQueryResumo
    Private AliasCtr := GetNextAlias()

    IF cSubcon = '000000001' 

        cQueryResumo := " SELECT "
        cQueryResumo += " CASE  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '022' THEN '022 - MEDICAR GOIANIA'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '023' THEN '023 - MEDICAR BH'  "
        cQueryResumo += "   WHEN B.BA3_FILIAL = '024' THEN '024 - MEDICAR BRASILIA'  "
        cQueryResumo += " ELSE ''  "
        cQueryResumo += " END             AS FILIAL, "
        cQueryResumo += " CASE  "
        cQueryResumo += "   WHEN B.BA3_ESPTEL = '1' THEN 'SIM'  "
        cQueryResumo += " ELSE 'NAO'  "
        cQueryResumo += " END             AS ESPETEL, "
        cQueryResumo += " B.BA3_MATEMP    AS IDCONTRATO,  "
        cQueryResumo += " B.BA3_XCARTE    AS NUMERO,  "
        cQueryResumo += " E.BT5_NOME      AS PERFIL,  "
        cQueryResumo += " F.BQL_DESCRI    AS FORMAPAG,  "
        cQueryResumo += " G.ZI0_DESCRI    AS CONDPAG,  "
        cQueryResumo += " CONCAT(SUBSTRING(B.BA3_DATBAS,7,2),'/',SUBSTRING(B.BA3_DATBAS,5,2),'/',SUBSTRING(B.BA3_DATBAS,1,4)) AS DTBASE,  "
        cQueryResumo += " I.A1_COD        AS CODCLI,  "
        cQueryResumo += " I.A1_LOJA       AS LOJACLI, "
        cQueryResumo += " I.A1_NREDUZ     AS CLIENTE, "
        cQueryResumo += " CASE "
        cQueryResumo += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
        cQueryResumo += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
        cQueryResumo += " END             AS CGC, "
        cQueryResumo += " H.A3_NOME       AS VENDEDOR,  "
        cQueryResumo += " CONCAT(SUBSTRING(B.BA3_DATBLO,7,2),'/',SUBSTRING(B.BA3_DATBLO,5,2),'/',SUBSTRING(B.BA3_DATBLO,1,4)) AS DATBLOCTR,  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
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
        cQueryResumo += " AND BA3.BA3_MATEMP = B.BA3_MATEMP  "
        cQueryResumo += " AND C.BA1_DATBLO = '' "
        cQueryResumo += " ),0) AS QTD_TOTAL "
        cQueryResumo += " FROM BQC010 A  "
        cQueryResumo += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_VERCON = A.BQC_VERCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.BA3_VERSUB = A.BQC_VERSUB "
        cQueryResumo += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "      
        cQueryResumo += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG "
        cQueryResumo += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI "
        cQueryResumo += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_ZZVEND "
        cQueryResumo += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = B.BA3_CODCLI AND I.A1_LOJA = B.BA3_LOJA "
        cQueryResumo += " WHERE 1=1  "
        cQueryResumo += " AND A.D_E_L_E_T_ = ''  "
        cQueryResumo += " AND A.BQC_CODINT = '"+cCodint+"'  "
        cQueryResumo += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
        cQueryResumo += " AND A.BQC_NUMCON = '"+cConemp+"'  "
        cQueryResumo += " AND A.BQC_VERSUB = '"+cVercon+"'  "
        cQueryResumo += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQueryResumo += " AND A.BQC_VERCON = '"+cVersub+"'  "
        cQueryResumo += " AND B.BA3_MATEMP = '"+cMatemp+"'  "

    ELSE

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
        cQueryResumo += "   WHEN BA3.BA3_FILIAL = '022' THEN '022 - MEDICAR GOIANIA'  "
        cQueryResumo += "   WHEN BA3.BA3_FILIAL = '023' THEN '023 - MEDICAR BH'  "
        cQueryResumo += "   WHEN BA3.BA3_FILIAL = '024' THEN '024 - MEDICAR BRASILIA'  "
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
        cQueryResumo += "   WHEN A.BQC_ESPTEL = '1' THEN 'SIM'  "
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
        cQueryResumo += " AND A.BQC_VERSUB = '"+cVercon+"'  "
        cQueryResumo += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQueryResumo += " AND A.BQC_VERCON = '"+cVersub+"'  "
      
    ENDIF

    TCQUERY cQueryResumo NEW ALIAS (AliasCtr)

        
	//Verifica resultado da query
	DbSelectArea(AliasCtr)
    (AliasCtr)->(DbGoTop())


    If (AliasCtr)->(Eof())

        MsgInfo("Sem dados disponiveis.", "Contratos Medicar")

    Else

        DEFINE MSDIALOG oDlg FROM 05,10 TO 415,1050 TITLE " Resumo Contrato Medicar " PIXEL

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
            @ 075, 325 SAY oTitQtdVidas PROMPT " Bloqueados "                     SIZE 070, 020 OF oDlg PIXEL
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


/* ------------------------------------ BENEFICIARIOS DO CONTRATO ------------------------------------ */

Static Function BenefiCtr(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local aCoors as array
    Local cQueryBenefi
    Local cPesq := Space(80)
    Local oRadMenu1
    Local oDlg as object
    Local oBrowse as object
    Local cOpc := 1
    Local nAtual := 0
    Private AliasBeneCtr := GetNextAlias()

    aCoors := FWGetDialogSize()

        cQueryBenefi := " SELECT " 
        cQueryBenefi += " B.BA1_XCARTE AS CARTEIRA, "
        cQueryBenefi += " B.BA1_NOMUSR AS BENEFI, "
        cQueryBenefi += " CASE WHEN LEN(B.BA1_CPFUSR) > 11 THEN CONCAT(SUBSTRING(B.BA1_CPFUSR,1,2),'.',SUBSTRING(B.BA1_CPFUSR,3,3),'.',SUBSTRING(B.BA1_CPFUSR,6,3),'/',SUBSTRING(B.BA1_CPFUSR,9,4),'-',SUBSTRING(B.BA1_CPFUSR,13,2)) ELSE CONCAT(SUBSTRING(B.BA1_CPFUSR,1,3),'.',SUBSTRING(B.BA1_CPFUSR,4,3),'.',SUBSTRING(B.BA1_CPFUSR,7,3),'-',SUBSTRING(B.BA1_CPFUSR,10,2)) END AS CPF, "
        cQueryBenefi += " CASE WHEN B.BA1_ZATEND = '1' THEN 'Sim' WHEN B.BA1_ZATEND = '0' THEN 'Não' ELSE '' END AS ATEND, "
        cQueryBenefi += " CASE WHEN B.BA1_DATBLO <> '' AND B.BA1_MOTBLO <> '' THEN 'INATIVO' ELSE 'ATIVO' END AS STATUSB, "        
        cQueryBenefi += " CONCAT(SUBSTRING(CAST(B.BA1_DATBLO AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA1_DATBLO AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA1_DATBLO AS VARCHAR),1,4)) AS DTBLOQ, "
        cQueryBenefi += " D.BG1_DESBLO AS DESCBLO, "
        cQueryBenefi += " SUM(C.BDK_VALOR) AS VALOR, "
        cQueryBenefi += " B.BA1_TIPUSU AS TIPO, "
        cQueryBenefi += " B.BA1_MATRIC AS MATRIC, "
        cQueryBenefi += " B.BA1_TIPREG AS TIPREG, "
        cQueryBenefi += " E.BXL_CODEQU AS CODEQUIP, "
        cQueryBenefi += " E.BXL_DESEQU AS REGRACOMI "
        cQueryBenefi += " FROM BA3010 A  "
        cQueryBenefi += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND B.BA1_FILIAL = A.BA3_FILIAL AND B.BA1_CODINT = A.BA3_CODINT AND B.BA1_CODEMP = A.BA3_CODEMP AND B.BA1_CONEMP = A.BA3_CONEMP AND B.BA1_SUBCON = A.BA3_SUBCON AND B.BA1_VERCON = A.BA3_VERCON AND B.BA1_VERSUB = A.BA3_VERSUB AND B.BA1_MATEMP = A.BA3_MATEMP "
        cQueryBenefi += " LEFT JOIN BDK010 C ON C.D_E_L_E_T_ = '' AND C.BDK_FILIAL = B.BA1_FILIAL AND C.BDK_CODINT = B.BA1_CODINT AND C.BDK_CODEMP = B.BA1_CODEMP AND C.BDK_MATRIC = B.BA1_MATRIC AND C.BDK_TIPREG = B.BA1_TIPREG "
        cQueryBenefi += " LEFT JOIN BG1010 D ON D.D_E_L_E_T_ = '' AND D.BG1_FILIAL = B.BA1_FILIAL AND D.BG1_CODBLO = B.BA1_MOTBLO "
        cQueryBenefi += " LEFT JOIN BXL010 E ON E.D_E_L_E_T_ = '' AND E.BXL_CODEQU = B.BA1_EQUIPE "
        cQueryBenefi += " WHERE 1=1 "
        cQueryBenefi += " AND A.D_E_L_E_T_ = '' "
        cQueryBenefi += " AND A.BA3_FILIAL = '"+cFilialCtr+"' "
        cQueryBenefi += " AND A.BA3_CODINT = '"+cCodint+"' "
        cQueryBenefi += " AND A.BA3_CODEMP = '"+cCodemp+"' "
        cQueryBenefi += " AND A.BA3_CONEMP = '"+cConemp+"' "
        cQueryBenefi += " AND A.BA3_VERCON = '"+cVercon+"' "
        cQueryBenefi += " AND A.BA3_SUBCON = '"+cSubcon+"' "
        cQueryBenefi += " AND A.BA3_VERSUB = '"+cVersub+"' "
        IF cSubcon = "000000001"
            cQueryBenefi += " AND A.BA3_MATEMP = '"+cMatemp+"' "
        ENDIF
        cQueryBenefi += " GROUP BY B.BA1_XCARTE,B.BA1_NOMUSR,B.BA1_CPFUSR,B.BA1_ZATEND,B.BA1_DATBLO,D.BG1_DESBLO,B.BA1_MOTBLO,B.BA1_TIPUSU,B.BA1_MATRIC,B.BA1_TIPREG,E.BXL_CODEQU,E.BXL_DESEQU "

    TCQUERY cQueryBenefi NEW ALIAS (AliasBeneCtr)

        
    //Verifica resultado da query
	DbSelectArea(AliasBeneCtr)
    (AliasBeneCtr)->(DbGoTop())


    If (AliasBeneCtr)->(Eof())

        MsgInfo("Contrato Sem Beneficiarios Vinculados.", "Contratos Medicar")

    Else

        //DEFINE DIALOG oDlg TITLE "Beneficiarios - Contrato Medicar " FROM aCoors[1], aCoors[2] TO aCoors[3] - (aCoors[3]/4.3), aCoors[4] - (aCoors[4]/3) PIXEL
        DEFINE DIALOG oDlg TITLE "Beneficiarios - Contrato Medicar " FROM 0, 0 TO 470, 980 PIXEL
        
            aGrade := {}

            @ 015, 020 SAY oTitParametro PROMPT "Pesquisa: "        SIZE 070, 020 OF oDlg PIXEL
            @ 010, 050 MSGET oGrupo VAR  cPesq                      SIZE 150, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
            
            @ 005, 210 RADIO oRadMenu1 VAR cOpc ITEMS "Nome","Cpf" SIZE 092, 020 OF oDlg COLOR 0, 16777215 PIXEL

            While (AliasBeneCtr)->(!Eof())

                //Incrementa a mensagem na régua
                MsProcTxt("Carregando Registros: " + cValToChar(nAtual) + ".")
    
                aAdd(aGrade, { IF((AliasBeneCtr)->STATUSB = 'ATIVO',.T.,.F.),(AliasBeneCtr)->CARTEIRA,(AliasBeneCtr)->BENEFI,(AliasBeneCtr)->CPF,(AliasBeneCtr)->ATEND,(AliasBeneCtr)->STATUSB,(AliasBeneCtr)->DTBLOQ,(AliasBeneCtr)->DESCBLO,(AliasBeneCtr)->VALOR,(AliasBeneCtr)->TIPO,(AliasBeneCtr)->MATRIC,(AliasBeneCtr)->TIPREG,(AliasBeneCtr)->CODEQUIP,(AliasBeneCtr)->REGRACOMI }) // DADOS DA GRADE
            
                (AliasBeneCtr)->(dBskip())

            EndDo
 
            
            //nRow        numérico            Indica a coordenada vertical.
            //nCol        numérico            Indica a coordenada horizontal.
            //nWidth      numérico            Indica a largura em pixels do objeto.
            //nHeight     numérico            Indica a altura em pixels do objeto.
            //bLine       bloco de código     Indica o bloco de código da lista de campos. Observação: Esse parâmetro é utilizado somente quando o browse trabalha com array.
            //aHeaders    vetor               Indica o título dos campos no cabeçalho.
            //aColSizes   vetor               Indica a largura das colunas.
            //oWnd        objeto              Indica o controle visual onde o divisor será criado.
            //cField      caractere           Indica os campos necessários para o filtro.
            //uValue1     qualquer            Indica o início do intervalo para o filtro.
            //uValue2     qualquer            Indica o fim do intervalo para o filtro.
            //bChange     bloco de código     Indica o bloco de código que será executado ao mudar de linha.
            //bLDblClick  bloco de código     Indica o bloco de código que será executado quando clicar duas vezes, com o botão esquerdo do mouse, sobre o objeto.
            //bRClicked   bloco de código     Indica o bloco de código que será executado quando clicar, com o botão direito do mouse, sobre o objeto.
            //oFont       objeto              Indica o objeto do tipo TFont utilizado para definir as características da fonte aplicada na exibição do conteúdo do controle visual.
            //oCursor     objeto              Indica o tipo de ponteiro do mouse.
            //nClrFore    numérico            Indica a cor do texto da janela.
            //nClrBack    numérico            Indica a cor de fundo da janela.
            //cMsg        caractere           Indica a mensagem ao posicionar o ponteiro do mouse sobre o objeto.
            //uParam20    lógico              Compatibilidade.
            //cAlias      caractere           Indica se o objeto é utilizado com array (opcional) ou tabela (obrigatório).
            //lPixel      lógico              Indica se considera as coordenadas passadas em pixels (.T.) ou caracteres (.F.).
            //bWhen       bloco de código     Indica o bloco de código que será executado quando a mudança de foco da entrada de dados, na janela em que o controle foi criado, estiver sendo efetuada. Observação: O bloco de código retornará verdadeiro (.T.) se o controle permanecer habilitado; caso contrário, retornará falso (.F.).
            //uParam24    lógico              Compatibilidade.
            //bValid      bloco de código     Indica o bloco de código de validação que será executado quando o conteúdo do objeto for modificado. Retorna verdadeiro (.T.), se o conteúdo é válido; caso contrário, falso (.F.).
            //lHScroll    lógico              Indica se habilita(.T.)/desabilita(.F.) a barra de rolagem horizontal.
            //lVScroll    lógico              Indica se habilita(.T.)/desabilita(.F.) a barra de rolagem vertical.
            oBrowse := TCBrowse():New( 30 , 5, 420, 200,, {'','Carteira','Beneficiario','Cpf','Tem Atend.','Status','Dt. Bloqueio','Motivo Bloqueio','Valor','Tipo','Cod. Equipe','Regra Comissao'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,"aGrade",.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGrade)
            oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,13],aGrade[oBrowse:nAt,14] }} //EXIBICAO DA GRADE

            TButton():New( 010, 430 , "Pesquisar"         , oDlg, {|| fPesquisa(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp,cPesq,cOpc,aGrade,oBrowse) }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 035, 430 , "Produtos"          , oDlg, {|| fProdBenefi(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp,aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12]) }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 060, 430 , "Regra Comissao"    , oDlg, {|| fRegraComis(aGrade[oBrowse:nAt,13],aGrade[oBrowse:nAt,14]) }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 085, 430 , "Exportar Excel"    , oDlg, {|| fExcelBenef(aGrade) }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 110, 430 , "Voltar"            , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)
        
        ACTIVATE DIALOG oDlg CENTERED
        

    Endif
    
    (AliasBeneCtr)->(DbCloseArea())
       

Return


Static Function fPesquisa(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp,cPesq,cOpc,aGrade,oBrowse)

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local cQueryAtt
    Local aCoors as array
    Local aGradeTT := {}
    Local oDlg as object
    Private AliasAttBene := GetNextAlias()

    aCoors := FWGetDialogSize()

        If cOpc = 2
           cPesq := STRTRAN(cPesq,".","")
           cPesq := STRTRAN(cPesq,"-","")
        Endif

        cQueryAtt := " SELECT " 
        cQueryAtt += " B.BA1_XCARTE AS CARTEIRA, "
        cQueryAtt += " B.BA1_NOMUSR AS BENEFI, "
        cQueryAtt += " CASE WHEN LEN(B.BA1_CPFUSR) > 11 THEN CONCAT(SUBSTRING(B.BA1_CPFUSR,1,2),'.',SUBSTRING(B.BA1_CPFUSR,3,3),'.',SUBSTRING(B.BA1_CPFUSR,6,3),'/',SUBSTRING(B.BA1_CPFUSR,9,4),'-',SUBSTRING(B.BA1_CPFUSR,13,2)) ELSE CONCAT(SUBSTRING(B.BA1_CPFUSR,1,3),'.',SUBSTRING(B.BA1_CPFUSR,4,3),'.',SUBSTRING(B.BA1_CPFUSR,7,3),'-',SUBSTRING(B.BA1_CPFUSR,10,2)) END AS CPF, "
        cQueryAtt += " CASE WHEN B.BA1_ZATEND = '1' THEN 'Sim' WHEN B.BA1_ZATEND = '0' THEN 'Não' ELSE '' END AS ATEND, "
        cQueryAtt += " CASE WHEN B.BA1_DATBLO <> '' AND B.BA1_MOTBLO <> '' THEN 'INATIVO' ELSE 'ATIVO' END AS STATUSB, "
        cQueryAtt += " CONCAT(SUBSTRING(CAST(B.BA1_DATBLO AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA1_DATBLO AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA1_DATBLO AS VARCHAR),1,4)) AS DTBLOQ, "
        cQueryAtt += " D.BG1_DESBLO AS DESCBLO, "
        cQueryAtt += " SUM(C.BDK_VALOR) AS VALOR, "
        cQueryAtt += " B.BA1_TIPUSU AS TIPO, "
        cQueryAtt += " E.BXL_CODEQU AS CODEQUIP, "
        cQueryAtt += " E.BXL_DESEQU AS REGRACOMI "
        cQueryAtt += " FROM BA3010 A  "
        cQueryAtt += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND B.BA1_FILIAL = A.BA3_FILIAL AND B.BA1_CODINT = A.BA3_CODINT AND B.BA1_CODEMP = A.BA3_CODEMP AND B.BA1_CONEMP = A.BA3_CONEMP AND B.BA1_SUBCON = A.BA3_SUBCON AND B.BA1_VERCON = A.BA3_VERCON AND B.BA1_VERSUB = A.BA3_VERSUB AND B.BA1_MATEMP = A.BA3_MATEMP "
        cQueryAtt += " LEFT JOIN BDK010 C ON C.D_E_L_E_T_ = '' AND C.BDK_FILIAL = B.BA1_FILIAL AND C.BDK_CODINT = B.BA1_CODINT AND C.BDK_CODEMP = B.BA1_CODEMP AND C.BDK_MATRIC = B.BA1_MATRIC AND C.BDK_TIPREG = B.BA1_TIPREG "
        cQueryAtt += " LEFT JOIN BG1010 D ON D.D_E_L_E_T_ = '' AND D.BG1_FILIAL = B.BA1_FILIAL AND D.BG1_CODBLO = B.BA1_MOTBLO "
        cQueryAtt += " LEFT JOIN BXL010 E ON E.D_E_L_E_T_ = '' AND E.BXL_CODEQU = B.BA1_EQUIPE "
        cQueryAtt += " WHERE 1=1 "
        cQueryAtt += " AND A.D_E_L_E_T_ = '' "
        cQueryAtt += " AND A.BA3_FILIAL = '"+cFilialCtr+"' "
        cQueryAtt += " AND A.BA3_CODINT = '"+cCodint+"' "
        cQueryAtt += " AND A.BA3_CODEMP = '"+cCodemp+"' "
        cQueryAtt += " AND A.BA3_CONEMP = '"+cConemp+"' "
        cQueryAtt += " AND A.BA3_VERCON = '"+cVercon+"' "
        cQueryAtt += " AND A.BA3_SUBCON = '"+cSubcon+"' "
        cQueryAtt += " AND A.BA3_VERSUB = '"+cVersub+"' "
        IF cSubcon = "000000001"
            cQueryAtt += " AND A.BA3_MATEMP = '"+cMatemp+"' "
        ENDIF
        If cOpc = 1
            cQueryAtt += " AND UPPER(B.BA1_NOMUSR) LIKE '%"+ALLTRIM(cPesq)+"%' "
        Else
            cQueryAtt += " AND B.BA1_CPFUSR LIKE '%"+ALLTRIM(cPesq)+"%' "
        Endif
        cQueryAtt += " GROUP BY B.BA1_XCARTE,B.BA1_NOMUSR,B.BA1_CPFUSR,B.BA1_ZATEND,B.BA1_DATBLO,D.BG1_DESBLO,B.BA1_MOTBLO,B.BA1_TIPUSU,E.BXL_CODEQU,E.BXL_DESEQU "

    TCQUERY cQueryAtt NEW ALIAS (AliasAttBene)


    If (AliasAttBene)->(Eof())

        MsgInfo("Beneficiario nao encontrato", "Contratos Medicar")

    
    Elseif empty(alltrim(cPesq))
    
        oBrowse := TCBrowse():New( 30 , 5, 420, 200,, {'','Carteira','Beneficiario','Cpf','Tem Atend.','Status','Dt. Bloqueio','Motivo Bloqueio','Valor','Tipo','Cod. Equipe','Regra Comissao'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,"aGrade",.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGrade)
        oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,13],aGrade[oBrowse:nAt,14] }} //EXIBICAO DA GRADE

    
    Else

        (AliasAttBene)->(DbGoTop())
    
        

        While (AliasAttBene)->(!Eof())

            aAdd(aGradeTT, { IF((AliasAttBene)->STATUSB = 'ATIVO',.T.,.F.),(AliasAttBene)->CARTEIRA,(AliasAttBene)->BENEFI,(AliasAttBene)->CPF,(AliasAttBene)->ATEND,(AliasAttBene)->STATUSB,(AliasAttBene)->DTBLOQ,(AliasAttBene)->DESCBLO,(AliasAttBene)->VALOR,(AliasAttBene)->TIPO,(AliasAttBene)->CODEQUIP,(AliasAttBene)->REGRACOMI }) // DADOS DA GRADE
        
            (AliasAttBene)->(dBskip())

        EndDo

        oBrowse := TCBrowse():New( 30 , 5, 420, 200,, {'','Carteira','Beneficiario','Cpf','Tem Atend.','Status','Dt. Bloqueio','Motivo Bloqueio','Valor','Tipo','Cod. Equipe','Regra Comissao'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGradeTT)
        oBrowse:bLine := {||{ If(aGradeTT[oBrowse:nAt,01],oOK,oNO),aGradeTT[oBrowse:nAt,02],aGradeTT[oBrowse:nAt,03],aGradeTT[oBrowse:nAt,04],aGradeTT[oBrowse:nAt,05],aGradeTT[oBrowse:nAt,06],aGradeTT[oBrowse:nAt,07],aGradeTT[oBrowse:nAt,08],aGradeTT[oBrowse:nAt,09],aGradeTT[oBrowse:nAt,10],aGradeTT[oBrowse:nAt,11],aGradeTT[oBrowse:nAt,12] }} //EXIBICAO DA GRADE

        (AliasAttBene)->(DbCloseArea())
        //oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08] }} //EXIBICAO DA GRADE


    Endif
    
Return


/* ------------------------------------ TITULOS DO CLIENTE ------------------------------------ */
Static Function fTituloCli(cSA1cliente, cSA1lojacli)

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local aCoors as array
    Local cQueryTit
    Private AliasTit := GetNextAlias()

    aCoors := FWGetDialogSize()

		cQueryTit := "	SELECT "
		cQueryTit += "	SE1.E1_FILIAL   	AS FILIAL,  "
		cQueryTit += "	SE1.E1_PREFIXO  	AS PREFIXO,  "
		cQueryTit += "	SE1.E1_NUM	    	AS NUMTIT,  "
		cQueryTit += "	CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS DTEMI, "
		cQueryTit += "	CONCAT(SUBSTRING(SE1.E1_VENCTO,7,2),'/',SUBSTRING(SE1.E1_VENCTO,5,2),'/',SUBSTRING(SE1.E1_VENCTO,1,4)) AS DTVENC, "
        cQueryTit += "	CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS DTVENCREA, "
        cQueryTit += "	CONCAT(SUBSTRING(SE1.E1_BAIXA,7,2),'/',SUBSTRING(SE1.E1_BAIXA,5,2),'/',SUBSTRING(SE1.E1_BAIXA,1,4)) AS DTBAIXA, "
		cQueryTit += "	SE1.E1_VALOR    	AS VALOR,  "
		cQueryTit += "	(SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0) AS VALORLIQ,  "
		cQueryTit += "	((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) AS SALDO,  "
		cQueryTit += " ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) AS VALORBX, "
        cQueryTit += " CASE "
        cQueryTit += "     WHEN ((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) > 1 THEN 'ABERTO' "
        cQueryTit += "     ELSE 'BAIXADO' "
        cQueryTit += " END AS STATUSTIT "
        cQueryTit += "	FROM SE1010 SE1  "
		cQueryTit += "	WHERE 1=1    "
		cQueryTit += "	AND SE1.D_E_L_E_T_ = ''  "
		cQueryTit += "	AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
        cQueryTit += "	AND SE1.E1_CLIENTE = '"+cSA1cliente+"' "
        cQueryTit += "	AND SE1.E1_LOJA = '"+cSA1lojacli+"' "
		cQueryTit += " ORDER BY SE1.E1_VENCREA DESC"


    TCQUERY cQueryTit NEW ALIAS (AliasTit)


    //Verifica resultado da query
	DbSelectArea(AliasTit)
    (AliasTit)->(DbGoTop())


    If (AliasTit)->(Eof())

        MsgInfo("Cliente nao possui titulos.", "Contratos Medicar")

    Else


        DEFINE DIALOG oDlg TITLE "Titulos Cliente - Contrato Medicar " FROM 0, 0 TO 470, 980 PIXEL
        
            aGradeTit := {}

            //@ 012, 020 SAY oTitParametro PROMPT "Pesquisa: "        SIZE 070, 020 OF oDlg PIXEL
            //@ 010, 050 MSGET oGrupo VAR  cPesq                      SIZE 150, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
            

            While (AliasTit)->(!Eof())

                aAdd(aGradeTit, { IF((AliasTit)->STATUSTIT = 'ABERTO',.T.,.F.),(AliasTit)->FILIAL,(AliasTit)->PREFIXO,(AliasTit)->NUMTIT,(AliasTit)->DTEMI,(AliasTit)->DTVENC,(AliasTit)->DTVENCREA,(AliasTit)->VALOR,(AliasTit)->VALORLIQ,(AliasTit)->SALDO,(AliasTit)->VALORBX,(AliasTit)->DTBAIXA }) // DADOS DA GRADE
            
                (AliasTit)->(dBskip())

            EndDo

            oBrowse := TCBrowse():New( 5 , 5, 420, 225,, {'Status','Filial','Prefixo','Titulo','Dt Emissao','Vencimento','Vencimento Real','Valor','Valor Liq','Saldo','Valor Baixado','Dt Baixa'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGradeTit)
            oBrowse:bLine := {||{ If(aGradeTit[oBrowse:nAt,01],oOK,oNO),aGradeTit[oBrowse:nAt,02],aGradeTit[oBrowse:nAt,03],aGradeTit[oBrowse:nAt,04],aGradeTit[oBrowse:nAt,05],aGradeTit[oBrowse:nAt,06],aGradeTit[oBrowse:nAt,07],aGradeTit[oBrowse:nAt,08],aGradeTit[oBrowse:nAt,09],aGradeTit[oBrowse:nAt,10],aGradeTit[oBrowse:nAt,11],aGradeTit[oBrowse:nAt,12] }} //EXIBICAO DA GRADE

            TButton():New( aCoors[1]+10, 430 , "Voltar"            , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)
        
        ACTIVATE DIALOG oDlg CENTERED


    EndIF


    (AliasTit)->(DbCloseArea())

Return


/* ------------------------------------ PRODUTOS DOS BENEFICIARIOS ------------------------------------ */
Static Function fProdBenefi(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp,cMatric,cTipreg)


    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oDlg as object
    Local aCoors as array
    Local cCodprodMain
    Local cProdMain
    Local cQueryBenefiProd
    Private AliasBeneProd := GetNextAlias()

    aCoors := FWGetDialogSize()

        cQueryBenefiProd := " SELECT " 
        cQueryBenefiProd += " B.BA1_NOMUSR AS BENEFI, "
        cQueryBenefiProd += " B.BA1_MATRIC AS MATRICULA, "
        cQueryBenefiProd += " B.BA1_TIPREG AS TIPREG, "
        cQueryBenefiProd += " A.BA3_CODPLA AS CODPRODMAIN, "
        cQueryBenefiProd += " PROD.BI3_DESCRI AS PRODMAIN, "
        cQueryBenefiProd += " D.BF4_CODPRO AS CODPRODOPC, "
        cQueryBenefiProd += " OPC.BI3_DESCRI AS PRODOPC "
        cQueryBenefiProd += " FROM BA3010 A  "
        cQueryBenefiProd += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND B.BA1_FILIAL = A.BA3_FILIAL AND B.BA1_CODINT = A.BA3_CODINT AND B.BA1_CODEMP = A.BA3_CODEMP AND B.BA1_CONEMP = A.BA3_CONEMP AND B.BA1_SUBCON = A.BA3_SUBCON AND B.BA1_VERCON = A.BA3_VERCON AND B.BA1_VERSUB = A.BA3_VERSUB AND B.BA1_MATEMP = A.BA3_MATEMP "
        cQueryBenefiProd += " LEFT JOIN BF4010 D ON D.D_E_L_E_T_ = '' AND D.BF4_FILIAL = B.BA1_FILIAL AND D.BF4_CODINT = B.BA1_CODINT AND D.BF4_CODEMP = B.BA1_CODEMP AND D.BF4_MATRIC = B.BA1_MATRIC AND D.BF4_TIPREG = B.BA1_TIPREG "
        cQueryBenefiProd += " LEFT JOIN BI3010 PROD ON PROD.D_E_L_E_T_ = '' AND PROD.BI3_CODIGO = A.BA3_CODPLA AND PROD.BI3_CODINT = A.BA3_CODINT "
        cQueryBenefiProd += " LEFT JOIN BI3010 OPC ON OPC.D_E_L_E_T_ = '' AND OPC.BI3_CODIGO = D.BF4_CODPRO AND OPC.BI3_CODINT = D.BF4_CODINT "
        cQueryBenefiProd += " WHERE 1=1 "
        cQueryBenefiProd += " AND A.D_E_L_E_T_ = '' "
        cQueryBenefiProd += " AND A.BA3_FILIAL = '"+cFilialCtr+"' "
        cQueryBenefiProd += " AND A.BA3_CODINT = '"+cCodint+"' "
        cQueryBenefiProd += " AND A.BA3_CODEMP = '"+cCodemp+"' "
        cQueryBenefiProd += " AND A.BA3_CONEMP = '"+cConemp+"' "
        cQueryBenefiProd += " AND A.BA3_VERCON = '"+cVercon+"' "
        cQueryBenefiProd += " AND A.BA3_SUBCON = '"+cSubcon+"' "
        cQueryBenefiProd += " AND A.BA3_VERSUB = '"+cVersub+"' "
        cQueryBenefiProd += " AND B.BA1_MATRIC = '"+cMatric+"' "
        cQueryBenefiProd += " AND B.BA1_TIPREG = '"+cTipreg+"' "
        IF cSubcon = "000000001"
            cQueryBenefiProd += " AND A.BA3_MATEMP = '"+cMatemp+"' "
        ENDIF

    TCQUERY cQueryBenefiProd NEW ALIAS (AliasBeneProd)

        
    //Verifica resultado da query
	DbSelectArea(AliasBeneProd)
    (AliasBeneProd)->(DbGoTop())

    cCodProdMain := (AliasBeneProd)->CODPRODMAIN
    cProdMain := (AliasBeneProd)->PRODMAIN

    If (AliasBeneProd)->(Eof())

        MsgInfo("Beneficiario Sem Produtos Vinculados.", "Contratos Medicar")

    Else

        //DEFINE DIALOG oDlg TITLE " Produtos Beneficiario " FROM aCoors[1], aCoors[2] TO aCoors[3]/2 , aCoors[3]/1.2  PIXEL
        DEFINE DIALOG oDlg TITLE " Produtos Beneficiario " FROM aCoors[1], aCoors[2] TO 410 , 750  PIXEL
        
            aGradeProd := {}

            @ 010,020 TO 060,250 LABEL " Produto Principal " OF oDlg PIXEL

            @ 025, 025 SAY oTitParametro PROMPT "Codigo: "        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 025 MSGET oGrupo VAR cCodprodMain  SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 025, 075 SAY oTitParametro PROMPT "Produto: "        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 075 MSGET oGrupo VAR cProdMain  SIZE 150, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
               
            @ 070,020 TO 200,350 LABEL " Opcionais do Beneficiario " OF oDlg PIXEL

            
            While (AliasBeneProd)->(!Eof())

                //aAdd(aGradeProd, { IF((AliasBeneProd)->STATUSB = 'ATIVO',.T.,.F.),(AliasBeneProd)->CARTEIRA }) // DADOS DA GRADE
                aAdd(aGradeProd, { .T.,(AliasBeneProd)->CODPRODOPC,(AliasBeneProd)->PRODOPC }) // DADOS DA GRADE
            
                (AliasBeneProd)->(dBskip())

            EndDo
            
            //nRow        numérico            Indica a coordenada vertical.
            //nCol        numérico            Indica a coordenada horizontal.
            //nWidth      numérico            Indica a largura em pixels do objeto.
            //nHeight     numérico            Indica a altura em pixels do objeto.
            oBrowse := TCBrowse():New( aCoors[1]+80 ,aCoors[1]+25, aCoors[1]+315, aCoors[1]+115,, {'','Codigo','Descricao'},{20,50,50}, oDlg,,,,,{||},,,,,,,.F.,"",.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGradeProd)
            oBrowse:bLine := {||{ If(aGradeProd[oBrowse:nAt,01],oOK,oNO),aGradeProd[oBrowse:nAt,02],aGradeProd[oBrowse:nAt,03] }} //EXIBICAO DA GRADE
            

            TButton():New( aCoors[1]+30, 300 , "Voltar"            , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)
            
        
        ACTIVATE DIALOG oDlg CENTERED
        
    Endif
    
    (AliasBeneProd)->(DbCloseArea())


Return


/* ------------------------------------ REGRA DE COMISSAO DOS BENEFICIARIOS ------------------------------------ */
Static Function fRegraComis(cCodEqui,cCodRegraComi)

    Local oDlg as object
    Local aCoors as array

    aCoors := FWGetDialogSize()

    IF empty(alltrim(cCodEqui))

        MsgInfo("Beneficiario sem regra de comissao cadastrada.", "Contratos Medicar.")

    Else

        DEFINE DIALOG oDlg TITLE " Regra Comissao - Beneficiario " FROM aCoors[1], aCoors[2] TO 150 , 670  PIXEL
            
            @ 010,020 TO 060,250 LABEL " Regra Comissao Cadastrada " OF oDlg PIXEL

            @ 025, 025 SAY oTitParametro PROMPT "Cod. Equipe: "        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 025 MSGET oGrupo VAR cCodEqui  SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 025, 075 SAY oTitParametro PROMPT "Regra Comissao: "        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 075 MSGET oGrupo VAR cCodRegraComi  SIZE 150, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            TButton():New( aCoors[1]+25, 265 , "Voltar"            , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)
            
        ACTIVATE DIALOG oDlg CENTERED


    Endif


        


Return


/* ------------------------------------ EXPORTAR BENEFICIARIOS PARA EXCEL ------------------------------------ */
Static Function fExcelBenef(aBenefi)

	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.


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
        
    IF empty(alltrim(cPasta))

        MsgInfo("Diretorio vazio operacao cancelada", "Contratos Medicar.")

    ELSE

        MsAguarde({|| fGeraExcel(cPasta, aBenefi) },"Aguarde","Gerando Excel...") 

    ENDIF


Return


Static Function fGeraExcel(cPasta,aBenefi)

	Local cArqBem
    Local nAtual := 0

        /* ---------------------------- ARQUIVO EXCEL ---------------------------- */

        oExcel := FwMsExcelXlsx():New()

        lRet := oExcel:IsWorkSheet("BENEFMED")
        oExcel:AddworkSheet("BENEFMED")

        oExcel:AddTable ("BENEFMED","DADOS",.F.)
        oExcel:AddColumn("BENEFMED","DADOS", "CARTEIRA",	    1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "BENEFICIARIO",    1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "CPF",     	    1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "ATENDIMENTO",	    1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "STATUS",	        1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "DTBLOQ",	        1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "MOTBLOQ",	        1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "VALOR",	        1,3,.F., "@E 99999.99")
        oExcel:AddColumn("BENEFMED","DADOS", "TIPO",	        1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "CODEQUIP",        1,1,.F., "")
        oExcel:AddColumn("BENEFMED","DADOS", "REGRACOMIS",      1,1,.F., "")

        For nAtual := 1 To Len(aBenefi)

            oExcel:AddRow("BENEFMED","DADOS",{ aBenefi[nAtual,2],aBenefi[nAtual,3],aBenefi[nAtual,4],aBenefi[nAtual,5],aBenefi[nAtual,6],aBenefi[nAtual,7],aBenefi[nAtual,8],aBenefi[nAtual,9],aBenefi[nAtual,10],aBenefi[nAtual,13],aBenefi[nAtual,14] })

        Next

        oExcel:SetFont("Calibri")
        oExcel:SetFontSize(11)
        oExcel:SetItalic(.F.)
        oExcel:SetBold(.F.)
        oExcel:SetUnderline(.F.)

        oExcel:Activate()
        cArqBem := cPasta + '\' + 'BENEFMED' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
        oExcel:GetXMLFile(cArqBem)

        oExcel:DeActivate()


Return
