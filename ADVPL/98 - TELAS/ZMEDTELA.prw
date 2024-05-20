#include "protheus.ch"
#Include "Totvs.ch"
#Include "TOPCONN.CH"


USER FUNCTION ZMEDTELA()

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    //Local aList := {}
    Private _cAlias		 := GetNextAlias()
    

    MsAguarde({||PegaDados()},"Aguarde","Motando os dados...") 
    
    DbSelectArea(_cAlias)
    (_cAlias)->(DbGoTop())
 
    DEFINE DIALOG oDlg TITLE "Exemplo TCBrowse" FROM 180,180 TO 550,700 PIXEL
 
        aBrowse := {}

        
        While (_cAlias)->(!Eof())
        
            // Vetor com elementos do Browse
            aAdd(aBrowse, { IF((_cAlias)->STATUSC = 'ATIVO',.T.,.F.),(_cAlias)->FILIAL,(_cAlias)->IDCONTRATO,(_cAlias)->NUMERO,(_cAlias)->PERFIL,(_cAlias)->FORMPAG,(_cAlias)->CONDPAG,(_cAlias)->STATUSC,(_cAlias)->DTBASE,(_cAlias)->VENDEDOR }) // DADOS DA QUERY
        
            (_cAlias)->(dBskip())

        EndDo


        // Cria Browse
        oBrowse := TCBrowse():New( 01 , 01, 260, 156,, {'','Filial','Id Contrato','Numero','Perfil','Form. Pg.','Cond.Pg.','Status','Dt. Base','Vendedor'},{20,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
 
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
        TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 160, 052, "GoDown()" , oDlg,{|| oBrowse:GoDown(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 160, 102, "GoTop()" , oDlg,{|| oBrowse:GoTop(),oBrowse:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
        TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
 
    ACTIVATE DIALOG oDlg CENTERED

    (_cAlias)->(DbCloseArea())

RETURN


Static Function PegaDados()

	Local cQuery  

            cQuery := " SELECT TOP 15"
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
            cQuery += " H.A3_NOME       AS VENDEDOR "
            cQuery += " FROM BQC010 A "
            cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
            cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
            cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
            cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_CODVEN "
            cQuery += " WHERE 1=1  "
            cQuery += " AND A.D_E_L_E_T_ = '' "
            cQuery += " AND A.BQC_CODEMP IN ('0004','0005')  "
            cQuery += " AND A.BQC_COBNIV = '1' "
            //cQuery += " AND A.BQC_CODCLI = '"+cSA1cliente+"'"
            //cQuery += " AND A.BQC_LOJA = '"+cSA1lojacli+"' "
            cQuery += " GROUP BY A.BQC_CODINT,A.BQC_CODEMP,A.BQC_NUMCON,A.BQC_VERCON,A.BQC_VERSUB,A.BQC_SUBCON,A.BQC_ANTCON,E.BT5_NOME,F.BQL_DESCRI,G.ZI0_DESCRI,A.BQC_TIPBLO,A.BQC_DATBLO,A.BQC_DATCON,H.A3_NOME "

       
            //cQueryCtr += " FROM BQC010 A  "
            //cQueryCtr += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON   "
            //cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.BA1_MATRIC = B.BA3_MATRIC  "
            //cQueryCtr += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
            //cQueryCtr += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
            //cQueryCtr += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG  "
            //cQueryCtr += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI  "
            //cQueryCtr += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_CODVEN  "
            //cQueryCtr += " WHERE 1=1  "
            //cQueryCtr += " AND A.D_E_L_E_T_ = ''  "
            //cQueryCtr += " AND A.BQC_CODEMP IN ('0003','0006')  "
            //cQueryCtr += " AND B.BA3_COBNIV = '1'  "
            //cQueryCtr += " AND B.BA3_CODCLI = '"+cSA1cliente+"' "
            //cQueryCtr += " AND B.BA3_LOJA = '"+cSA1lojacli+"' "
            
    
	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

Return 
