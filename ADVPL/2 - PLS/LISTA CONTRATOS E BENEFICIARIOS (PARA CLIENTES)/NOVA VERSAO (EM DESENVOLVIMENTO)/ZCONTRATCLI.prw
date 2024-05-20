#include "protheus.ch"
#Include "Totvs.ch"
#Include "TOPCONN.CH"

/*

CLIENTE: 046569

*/


USER FUNCTION ZCONTRATCLI(cSA1cliente, cSA1lojacli, cTipCli)

    Private _cAlias		 := GetNextAlias()
    

    MsAguarde({||PegaDados(cSA1cliente, cSA1lojacli, cTipCli)},"Aguarde","Motando os dados...") 
    
    DbSelectArea(_cAlias)
    (_cAlias)->(DbGoTop())

    MsAguarde({||MontaTela()},"Aguarde","Montando Listagem...") 

    (_cAlias)->(DbCloseArea())

RETURN


Static Function PegaDados(cSA1cliente, cSA1lojacli, cTipCli)

	Local cQuery  

    IF cTipCli = 'J'

            cQuery := " SELECT "            
            cQuery += " CASE "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '001' THEN 'Medicar Ribeirao Preto' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '002' THEN 'Medicar Campinas' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '003' THEN 'Medicar Sao Paulo' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '006' THEN 'Medicar Tech' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '008' THEN 'Medicar Litoral' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '016' THEN 'N1 Card' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '021' THEN 'Medicar Rio de Janeiro' "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '014' THEN 'Locamedi Matriz'  "
            cQuery += "     ELSE '' "
            cQuery += " END              AS FILIAL, "
            cQuery += " CASE "
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '001' THEN '001'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '002' THEN '002'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '003' THEN '003'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '006' THEN '006'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '008' THEN '008'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '016' THEN '016'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '021' THEN '021'
            cQuery += "     WHEN ISNULL((SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = ''  AND BA1.BA1_CODINT = A.BQC_CODINT AND BA1.BA1_CODEMP = A.BQC_CODEMP AND BA1.BA1_CONEMP = A.BQC_NUMCON AND BA1.BA1_VERCON = A.BQC_VERCON AND BA1.BA1_SUBCON = A.BQC_SUBCON AND BA1.BA1_VERSUB = A.BQC_VERSUB),'') = '014' THEN '014'
            cQuery += "     ELSE '' "
            cQuery += " END              AS FILIALCTR, "
            cQuery += " A.BQC_SUBCON     AS IDCONTRATO, "
            cQuery += " A.BQC_ANTCON     AS NUMERO, "
            cQuery += " E.BT5_NOME       AS PERFIL, "
            cQuery += " F.BQL_DESCRI     AS FORMPAG, "
            cQuery += " G.ZI0_DESCRI     AS CONDPAG, "
            cQuery += " CASE "
            cQuery += "     WHEN A.BQC_TIPBLO = '0' AND A.BQC_DATBLO <> '' THEN 'BLOQUEADO' "
            cQuery += "     ELSE 'ATIVO' "
            cQuery += " END             AS STATUSC, "
            cQuery += " CONCAT(SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),7,2),'/',SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),5,2),'/',SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),1,4)) AS DTBASE, "
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
            cQuery += " WHERE 1=1  "
            cQuery += " AND A.D_E_L_E_T_ = '' "
            cQuery += " AND A.BQC_CODEMP IN ('0004','0005')  "
            cQuery += " AND A.BQC_COBNIV = '1' "
            cQuery += " AND A.BQC_CODCLI = '"+cSA1cliente+"'"
            cQuery += " AND A.BQC_LOJA = '"+cSA1lojacli+"' "
            cQuery += " GROUP BY A.BQC_CODINT,A.BQC_CODEMP,A.BQC_NUMCON,A.BQC_VERCON,A.BQC_VERSUB,A.BQC_SUBCON,A.BQC_ANTCON,E.BT5_NOME,F.BQL_DESCRI,G.ZI0_DESCRI,A.BQC_TIPBLO,A.BQC_DATBLO,A.BQC_DATCON,H.A3_NOME "

    ELSE

            cQuery := " SELECT "            
            cQuery += " CASE "
            cQuery += "     WHEN B.BA3_FILIAL = '001' THEN 'Medicar Ribeirao Preto' "
            cQuery += "     WHEN B.BA3_FILIAL = '002' THEN 'Medicar Campinas' "
            cQuery += "     WHEN B.BA3_FILIAL = '003' THEN 'Medicar Sao Paulo' "
            cQuery += "     WHEN B.BA3_FILIAL = '006' THEN 'Medicar Tech' "
            cQuery += "     WHEN B.BA3_FILIAL = '008' THEN 'Medicar Litoral' "
            cQuery += "     WHEN B.BA3_FILIAL = '016' THEN 'N1 Card' "
            cQuery += "     WHEN B.BA3_FILIAL = '021' THEN 'Medicar Rio de Janeiro' "
            cQuery += "     WHEN B.BA3_FILIAL = '014' THEN 'Locamedi Matriz'  "
            cQuery += "     ELSE '' "
            cQuery += " END              AS FILIAL, "
            cQuery += " B.BA3_FILIAL     AS FILIALCTR, "
            cQuery += " CASE  "
            cQuery += "     WHEN B.BA3_IDBENN <> '' THEN B.BA3_IDBENN  "
            cQuery += "     WHEN B.BA3_IDBENN = '' AND B.BA3_ZIRIS < 2000000000 THEN B.BA3_ZIRIS  "
            cQuery += "     ELSE B.BA3_MATEMP  "
            cQuery += " END             AS IDCONTRATO,  "
            cQuery += " B.BA3_XCARTE    AS NUMERO,  "
            cQuery += " E.BT5_NOME       AS PERFIL, "
            cQuery += " F.BQL_DESCRI     AS FORMPAG, "
            cQuery += " G.ZI0_DESCRI     AS CONDPAG, "
            cQuery += " CASE "
            cQuery += "     WHEN B.BA3_MOTBLO = '0' AND B.BA3_DATBLO <> '' THEN 'BLOQUEADO' "
            cQuery += "     ELSE 'ATIVO' "
            cQuery += " END             AS STATUSC, "
            cQuery += " CONCAT(SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),1,4)) AS DTBASE, "
            cQuery += " H.A3_NOME       AS VENDEDOR, "
            cQuery += " B.BA3_CODINT    AS CODINT, "
            cQuery += " B.BA3_CODEMP    AS CODEMP, "
            cQuery += " B.BA3_CONEMP    AS CONEMP, "
            cQuery += " B.BA3_VERCON    AS VERCON, "
            cQuery += " B.BA3_SUBCON    AS SUBCON, "
            cQuery += " B.BA3_VERSUB    AS VERSUB, "            
            cQuery += " B.BA3_MATEMP    AS MATEMP "
            cQuery += " FROM BQC010 A  "
            cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON   "
            cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
            cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG  "
            cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI  "
            cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_CODVEN  "
            cQuery += " WHERE 1=1  "
            cQuery += " AND A.D_E_L_E_T_ = ''  "
            cQuery += " AND A.BQC_CODEMP IN ('0003','0006')  "
            cQuery += " AND B.BA3_COBNIV = '1'  "
            cQuery += " AND B.BA3_CODCLI = '"+cSA1cliente+"' "
            cQuery += " AND B.BA3_LOJA = '"+cSA1lojacli+"' "
            cQuery += " GROUP BY B.BA3_FILIAL,B.BA3_IDBENN,B.BA3_ZIRIS,B.BA3_XCARTE,E.BT5_NOME,F.BQL_DESCRI,G.ZI0_DESCRI,B.BA3_MOTBLO,B.BA3_DATBLO,B.BA3_DATBAS,H.A3_NOME,B.BA3_CODINT,B.BA3_CODEMP,B.BA3_CONEMP,B.BA3_VERCON,B.BA3_SUBCON,B.BA3_VERSUB,B.BA3_MATEMP "
    
    ENDIF
    
	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

Return 


Static Function MontaTela()

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local aCoors as array


    aCoors := FWGetDialogSize()

    //DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL
    DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM aCoors[1], aCoors[2] TO aCoors[3] - (aCoors[3]/4), aCoors[4] - (aCoors[4]/3) PIXEL
 
        aBrowse := {}

        
        While (_cAlias)->(!Eof())
        
            // Vetor com elementos do Browse
            aAdd(aBrowse, { IF((_cAlias)->STATUSC = 'ATIVO',.T.,.F.),(_cAlias)->FILIAL,(_cAlias)->IDCONTRATO,(_cAlias)->NUMERO,(_cAlias)->PERFIL,(_cAlias)->FORMPAG,(_cAlias)->CONDPAG,(_cAlias)->STATUSC,(_cAlias)->DTBASE,(_cAlias)->VENDEDOR,(_cAlias)->FILIALCTR,(_cAlias)->CODINT,(_cAlias)->CODEMP,(_cAlias)->CONEMP,(_cAlias)->VERCON,(_cAlias)->SUBCON,(_cAlias)->VERSUB,(_cAlias)->MATEMP }) // DADOS DA QUERY

            (_cAlias)->(dBskip())

        EndDo


        // Cria Browse
        oBrowse := TCBrowse():New( aCoors[1] , aCoors[1], aCoors[3] - (aCoors[3]/2.75), aCoors[4] - (aCoors[4]/1.21),, {'','Filial','Id Contrato','Numero','Perfil','Form. Pg.','Cond.Pg.','Status','Dt. Base','Vendedor'},{20,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
 
        // Seta vetor para a browse
        oBrowse:SetArray(aBrowse)
 
        // Monta a linha a ser exibina no Browse
        //Transform(aBrowse[oBrowse:nAT,04],'@E 99,999,999,999.99') 
        oBrowse:bLine := {||{ If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07],aBrowse[oBrowse:nAt,08],aBrowse[oBrowse:nAt,09],aBrowse[oBrowse:nAt,10] }}

             
        // Evento de clique no cabeçalho da browse
        oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }

 
        // Evento de duplo click na celula
        oBrowse:bLDblClick := {|| alert('bLDblClick') }
 
        // Cria Botoes com metodos básicos
        
        TButton():New( aCoors[1]+10, aCoors[3] - (aCoors[3]/2.77), "Resumo Contrato",   oDlg,{|| ResumoCtr( aBrowse[oBrowse:nAt,11],aBrowse[oBrowse:nAt,12],aBrowse[oBrowse:nAt,13],aBrowse[oBrowse:nAt,14],aBrowse[oBrowse:nAt,15],aBrowse[oBrowse:nAt,16],aBrowse[oBrowse:nAt,17],aBrowse[oBrowse:nAt,18] ) , oBrowse:setFocus() },50,018,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( aCoors[1]+35, aCoors[3] - (aCoors[3]/2.77), "Beneficiarios",     oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },50,018,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( aCoors[1]+55, aCoors[3] - (aCoors[3]/2.77), "Titulos Cliente",   oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },50,018,,,.F.,.T.,.F.,,.F.,,,.F. )
        //TButton():New( aCoors[1]+55, aCoors[3] - (aCoors[3]/2.77), "Sair",              oDlg,{|| oDlg:End() },50,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New(aCoors[1]+70, aCoors[3] - (aCoors[3]/2.77), "Sair"              , oDlg, {|| oDlg:End()}, 50,018, ,,,.T.,,,,,,)


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


Static Function ResumoCtr(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)

    Local cQueryResumo
    Local nAtual := 0
    Local nTotal := 0
    
    Local cQtdTit   := 0   
    Local cQtdDep   := 0   
    Local cQtdBloq  := 0   
    Local cQtdTotal := 0   
    
    Local cValorTit   := 0
    Local cValorDep   := 0
    Local cValorBloq  := 0
    Local cValorTotal := 0

    Private AliasCtr	    := GetNextAlias()

    IF cSubcon = '000000001' 

        cQueryResumo := " SELECT "
        cQueryResumo +="  CASE "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ' "
        cQueryResumo +="     ELSE '' "
        cQueryResumo +="  END             AS FILIAL, "
        cQueryResumo += " CASE WHEN B.BA3_IDBENN <> '' THEN B.BA3_IDBENN ELSE B.BA3_MATEMP END AS IDCONTRATO,  "
        cQueryResumo += " B.BA3_XCARTE    AS NUMERO,  "
        cQueryResumo += " E.BT5_NOME      AS PERFIL,  "
        cQueryResumo += " F.BQL_DESCRI    AS FORMAPAG,  "
        cQueryResumo += " G.ZI0_DESCRI    AS CONDPAG,  "
        cQueryResumo += " CONCAT(SUBSTRING(B.BA3_DATBAS,7,2),'/',SUBSTRING(B.BA3_DATBAS,5,2),'/',SUBSTRING(B.BA3_DATBAS,1,4))    AS DTBASE,  "
        cQueryResumo += " I.A1_COD        AS CODCLI,  "
        cQueryResumo += " I.A1_LOJA       AS LOJACLI,  "
        cQueryResumo += " I.A1_NREDUZ     AS CLIENTE,  "
        cQueryResumo += " CASE "
        cQueryResumo += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
        cQueryResumo += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
        cQueryResumo += " END             AS CGC, "
        cQueryResumo += " H.A3_NOME       AS VENDEDOR,  "
        cQueryResumo += " B.BA3_MOTBLO    AS MOTBLOCTR,  "
        cQueryResumo += " CONCAT(SUBSTRING(B.BA3_DATBLO,7,2),'/',SUBSTRING(B.BA3_DATBLO,5,2),'/',SUBSTRING(B.BA3_DATBLO,1,4)) AS DATBLOCTR,  "
        cQueryResumo += " CASE "
        cQueryResumo += "     WHEN C.BA1_DATBLO = '' THEN 'ATIVO' "
        cQueryResumo += "     ELSE 'INATIVO' "
        cQueryResumo += " END             AS STATUSBENE, "
        cQueryResumo += " C.BA1_ZATEND    AS ATEND,  "
        cQueryResumo += " CASE "
        cQueryResumo += "    WHEN B.BA3_ESPTEL = '1' THEN 'SIM' "
        cQueryResumo += "    ELSE 'NAO' "
        cQueryResumo += " END             AS ESPETEL, "
        cQueryResumo += " C.BA1_TIPUSU    AS TIPO,  "
        cQueryResumo += " D.BDK_VALOR     AS VALOR  "
        cQueryResumo += " FROM BQC010 A  "
        cQueryResumo += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
        cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = C.BA1_SUBCON AND B.BA3_VERCON = C.BA1_VERCON AND C.BA1_VERSUB = B.BA3_VERSUB AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQueryResumo += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG "
        cQueryResumo += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
        cQueryResumo += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
        cQueryResumo += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
        cQueryResumo += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_ZZVEND "
        cQueryResumo += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = B.BA3_CODCLI AND I.A1_LOJA = B.BA3_LOJA "
        cQueryResumo += " WHERE 1=1  "
        cQueryResumo += " AND A.D_E_L_E_T_ = ''  "
        cQueryResumo += " AND B.BA3_FILIAL = '"+cFilialCtr+"'  "
        cQueryResumo += " AND A.BQC_CODINT = '"+cCodint+"'  "
        cQueryResumo += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
        cQueryResumo += " AND A.BQC_NUMCON = '"+cConemp+"'  "
        cQueryResumo += " AND A.BQC_VERSUB = '"+cVercon+"'  "
        cQueryResumo += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQueryResumo += " AND A.BQC_VERCON = '"+cVersub+"'  "
        cQueryResumo += " AND B.BA3_MATEMP = '"+cMatemp+"'  "
    
    ELSE

        cQueryResumo := " SELECT "
        cQueryResumo +="  CASE "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD' "
        cQueryResumo +="     WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ' "
        cQueryResumo +="     ELSE '' "
        cQueryResumo +="  END AS FILIAL, "
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
        cQueryResumo += " A.BQC_CODBLO    AS MOTBLOCTR,  "
        cQueryResumo += " CONCAT(SUBSTRING(A.BQC_DATBLO,7,2),'/',SUBSTRING(A.BQC_DATBLO,5,2),'/',SUBSTRING(A.BQC_DATBLO,1,4)) AS DATBLOCTR,  "
        cQueryResumo += " CASE "
        cQueryResumo += "     WHEN C.BA1_DATBLO = '' THEN 'ATIVO' "
        cQueryResumo += "     ELSE 'INATIVO' "
        cQueryResumo += " END             AS STATUSBENE, "
        cQueryResumo += " C.BA1_ZATEND    AS ATEND,  "
        cQueryResumo += " CASE "
        cQueryResumo += "    WHEN A.BQC_ESPTEL = '1' THEN 'SIM' "
        cQueryResumo += "    ELSE 'NAO' "
        cQueryResumo += " END              AS ESPETEL, "
        cQueryResumo += " C.BA1_TIPUSU    AS TIPO,  "
        cQueryResumo += " D.BDK_VALOR     AS VALOR  "
        cQueryResumo += " FROM BQC010 A  "
        cQueryResumo += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
        cQueryResumo += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = C.BA1_SUBCON AND B.BA3_VERCON = C.BA1_VERCON AND C.BA1_VERSUB = B.BA3_VERSUB AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQueryResumo += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG "
        cQueryResumo += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
        cQueryResumo += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
        cQueryResumo += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
        cQueryResumo += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_ZZVEND "
        cQueryResumo += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = A.BQC_CODCLI AND I.A1_LOJA = A.BQC_LOJA "
        cQueryResumo += " WHERE 1=1  "
        cQueryResumo += " AND A.D_E_L_E_T_ = ''  "
        cQueryResumo += " AND B.BA3_FILIAL = '"+cFilialCtr+"'  "
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

    //Define o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
    (AliasCtr)->(DbGoTop())


 	While (AliasCtr)->(!Eof())
    
    nAtual++
    IncProc("Carregando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

        IF (AliasCtr)->STATUSBENE = 'ATIVO'

            IF (AliasCtr)->TIPO = 'T'

                cQtdTit   := cQtdTit  + 1
                cValorTit := cValorTit + (AliasCtr)->VALOR

            ELSE

                cQtdDep   := cQtdDep  + 1
                cValorDep := cValorDep + (AliasCtr)->VALOR

            ENDIF

        ELSE

            cQtdBloq := cQtdBloq + 1
            cValorBloq := cValorBloq + (AliasCtr)->VALOR

        ENDIF

        (AliasCtr)->(dBskip())

	EndDo

    cQtdTotal   := cQtdTit + cQtdDep
    cValorTotal := cValorTit + cValorDep

    (AliasCtr)->(DbGoTop())


    DEFINE MSDIALOG oDlg FROM 05,10 TO 400,1050 TITLE " RESUMO DO CONTRATO " PIXEL

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

        @ 040, 385 MSGET oTitQtdVidas VAR cQtdTit                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 040, 440 MSGET oTitQtdVidas VAR cValorTit                     SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        @ 055, 385 MSGET oTitQtdVidas VAR cQtdDep                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 055, 440 MSGET oTitQtdVidas VAR cValorDep                     SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        @ 070, 385 MSGET oTitQtdVidas VAR cQtdBloq                      SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 070, 440 MSGET oTitQtdVidas VAR cValorBloq                    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        @ 085, 385 MSGET oTitQtdVidas VAR cQtdTotal                     SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 085, 440 MSGET oTitQtdVidas VAR cValorTotal                   SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        
        //@ 110,325 Button "Titulos Cliente"                              SIZE 037,012  ACTION U_ZMEDTITCLI((AliasCtr)->CODCLI, (AliasCtr)->LOJACLI,(AliasCtr)->CLIENTE) PIXEL OF oDlg
        

    DEFINE SBUTTON FROM 155,250 TYPE 1 ACTION ( oDlg:End() ) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

    (AliasCtr)->(DbCloseArea())      
    //RestArea( aArea )


Return


