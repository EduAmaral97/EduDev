//Vou incluir algumas bibliotecas
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "TOPCONN.CH"

User function ZCBENCTRMED()

    local lRet as logical
    local aArea as array
    local cQuery as character
    local oBrw as object
    local oTable as object
    local aTamX3Flds as array
    local aFields as array
    local aIndex as array
    local aSeek as array
    local oDlg as object
    local aCoors as array
    Local aBrowse := {}
    Local cTitulo := "Contratos Medicar"

    lRet := .F.
    aArea := GetArea()
    aTamX3Flds := {}
    aFields := {}
    aIndex := {}
    aSeek := {}

    aAdd(aTamX3Flds, TamSX3("BQC_SUBCON"))
    aAdd(aTamX3Flds, TamSX3("BQC_ANTCON"))
    aAdd(aTamX3Flds, TamSX3("BT5_NOME"))
    aAdd(aTamX3Flds, TamSX3("BQL_DESCRI"))
    aAdd(aTamX3Flds, TamSX3("ZI0_DESCRI"))
    aAdd(aTamX3Flds, TamSX3("A3_NOME"))
    aAdd(aTamX3Flds, TamSX3("BQC_CODINT"))
    aAdd(aTamX3Flds, TamSX3("BQC_CODEMP"))
    aAdd(aTamX3Flds, TamSX3("BQC_NUMCON"))
    aAdd(aTamX3Flds, TamSX3("BQC_VERCON"))
    aAdd(aTamX3Flds, TamSX3("BQC_VERSUB"))
       

    aAdd(aFields, {"FILIAL",        "C",              22,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"IDCONTRATO",    aTamX3Flds[1][3], aTamX3Flds[1][1],  aTamX3Flds[1][2]})
    aAdd(aFields, {"NUMERO",        aTamX3Flds[2][3], aTamX3Flds[2][1],  aTamX3Flds[2][2]})
    aAdd(aFields, {"PERFIL",        aTamX3Flds[3][3], aTamX3Flds[3][1],  aTamX3Flds[3][2]})
    aAdd(aFields, {"FORMPAG",       aTamX3Flds[4][3], aTamX3Flds[4][1],  aTamX3Flds[4][2]})
    aAdd(aFields, {"CONDPAG",       aTamX3Flds[5][3], aTamX3Flds[5][1],  aTamX3Flds[5][2]})
    aAdd(aFields, {"QTDVIDAS",      "N",              10,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"VALOR",         "N",              12,                2}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"IDENT",         "C",              1 ,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"STATUSC",       "C",              10,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"DTBASE",        "C",              10,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"VENDEDOR",     aTamX3Flds[6][3],  aTamX3Flds[6][1],  aTamX3Flds[6][2]})
    aAdd(aFields, {"CODINT",       aTamX3Flds[7][3],  aTamX3Flds[7][1],  aTamX3Flds[7][2]})
    aAdd(aFields, {"CODEMP",       aTamX3Flds[8][3],  aTamX3Flds[8][1],  aTamX3Flds[8][2]})
    aAdd(aFields, {"NUMCOM",       aTamX3Flds[9][3],  aTamX3Flds[9][1],  aTamX3Flds[9][2]})
    aAdd(aFields, {"VERCON",       aTamX3Flds[10][3], aTamX3Flds[10][1], aTamX3Flds[10][2]})
    aAdd(aFields, {"VERSUB",       aTamX3Flds[11][3], aTamX3Flds[11][1], aTamX3Flds[11][2]})


    aAdd(aIndex, {"IDCONTRATO"})
    aAdd(aIndex, {"NUMERO"})
    aAdd(aIndex, {"PERFIL"})


    aAdd(aSeek, {"Id Contrato", {{"LookUp", "C", aTamX3Flds[1][1], 0, "",,}} , 1, .T. }) // TIPO | TAMANHO | 0


    oTable := FWTemporaryTable():New()
    oTable:setFields(aFields)
    oTable:addIndex("1", {"IDCONTRATO"})
    oTable:create()


    cQuery := "INSERT INTO " + oTable:getRealName()
    cQuery += " (FILIAL,IDCONTRATO,NUMERO,PERFIL,FORMPAG,CONDPAG,QTDVIDAS,VALOR,IDENT,STATUSC,DTBASE,VENDEDOR,CODINT,CODEMP,NUMCOM,VERCON,VERSUB) "
    cQuery += " SELECT "
    cQuery += " CASE "
    cQuery += "     WHEN C.BA1_FILIAL = '001' THEN 'Medicar Ribeirao Preto' "
    cQuery += "     WHEN C.BA1_FILIAL = '002' THEN 'Medicar Campinas' "
    cQuery += "     WHEN C.BA1_FILIAL = '003' THEN 'Medicar Sao Paulo' "
    cQuery += "     WHEN C.BA1_FILIAL = '006' THEN 'Medicar Tech' "
    cQuery += "     WHEN C.BA1_FILIAL = '008' THEN 'Medicar Litoral' "
    cQuery += "     WHEN C.BA1_FILIAL = '016' THEN 'N1 Card' "
    cQuery += "     WHEN C.BA1_FILIAL = '021' THEN 'Medicar Rio de Janeiro' "
    cQuery += "     ELSE '' "
    cQuery += " END              AS FILIAL, "
    cQuery += " A.BQC_SUBCON     AS IDCONTRATO, "
    cQuery += " A.BQC_ANTCON     AS NUMERO, "
    cQuery += " E.BT5_NOME       AS PERFIL, "
    cQuery += " F.BQL_DESCRI     AS FORMPAG, "
    cQuery += " G.ZI0_DESCRI     AS CONDPAG, "
    cQuery += " CASE
    cQuery += "      WHEN C.BA1_DATBLO = '' THEN COUNT(CONCAT(C.BA1_FILIAL,C.BA1_CODINT,C.BA1_CODEMP,C.BA1_MATRIC,C.BA1_TIPUSU,C.BA1_TIPREG,C.BA1_DIGITO,C.BA1_NOMUSR)) "
    cQuery += "      ELSE 0 "
    cQuery += " END             AS QTDVIDAS, "
    cQuery += " CASE
    cQuery += "      WHEN C.BA1_DATBLO = '' THEN SUM(D.BDK_VALOR) "
    cQuery += "      ELSE 0 "
    cQuery += " END             AS VALOR, "
    cQuery += " ''              AS IDENT, "
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
    cQuery += " A.BQC_VERSUB    AS VERSUB "
    cQuery += " FROM BQC010 A "
    cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = A.BQC_CODINT AND C.BA1_CODEMP = A.BQC_CODEMP AND C.BA1_CONEMP = A.BQC_NUMCON AND C.BA1_SUBCON = A.BQC_SUBCON AND C.BA1_VERCON = A.BQC_VERCON"
    cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG "
    cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
    cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
    cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
    cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_CODVEN "
    cQuery += " WHERE 1=1  "
    cQuery += " AND A.D_E_L_E_T_ = '' "
    cQuery += " AND A.BQC_CODEMP IN ('0004','0005')  "
    cQuery += " AND A.BQC_COBNIV = '1' "
    //cQuery += " AND A.BQC_CODCLI = '044909' "
    //cQuery += " AND A.BQC_LOJA = '01' "
    cQuery += " GROUP BY C.BA1_FILIAL,A.BQC_SUBCON,E.BT5_NOME,A.BQC_DESCRI,A.BQC_ZNFANT,A.BQC_ANTCON,F.BQL_DESCRI,G.ZI0_DESCRI, A.BQC_TIPBLO, A.BQC_DATBLO, A.BQC_DATCON, H.A3_NOME,A.BQC_CODINT,A.BQC_CODEMP,A.BQC_NUMCON,A.BQC_VERCON,A.BQC_VERSUB,C.BA1_DATBLO "

    if TCSqlExec(cQuery) >= 0

        aAdd(aBrowse, {"Filial",        "FILIAL",       "C",22                  ,0,"@!"})
        aAdd(aBrowse, {"Id Contrato",   "IDCONTRATO",   "C",aTamX3Flds[1][1]    ,0,"@!"})
        aAdd(aBrowse, {"Numero",        "NUMERO",       "C",aTamX3Flds[2][1]    ,0,"@!"})
        aAdd(aBrowse, {"Perfil",        "PERFIL",       "C",aTamX3Flds[3][1]    ,0,"@!"})
        aAdd(aBrowse, {"Forma Pg.",     "FORMPAG",      "C",aTamX3Flds[4][1]    ,0,"@!"})
        aAdd(aBrowse, {"Cond. Pg,",     "CONDPAG",      "C",aTamX3Flds[5][1]    ,0,"@!"})
        aAdd(aBrowse, {"Qtd Vidas",     "QTDVIDAS",     "N",10                  ,0,"@!"})
        aAdd(aBrowse, {"Valor",         "VALOR",        "N",12                  ,2,"@!"})
        aAdd(aBrowse, {"Status",        "STATUSC",      "C",10                  ,0,"@!"})
        aAdd(aBrowse, {"Dt. Base",      "DTBASE",       "C",10                  ,0,"@!"})

        aCoors := FWGetDialogSize()

        //Se os botões de Ok e Fecha devem fechar o browse, então você deve ser o responsável pelo oOwner do browse
        oDlg = MsDialog():New( aCoors[1], aCoors[2], aCoors[3], aCoors[4], "",,,.F., nOR(WS_VISIBLE, WS_POPUP),,,,,.T.,, ,.F. )

        oBrw := FWMBrowse():New(oDlg)
        oBrw:SetDescription(cTitulo)
        oBrw:SetDataTable()
        oBrw:SetTemporary(.T.)
        oBrw:SetAlias(oTable:getAlias())

        oBrw:AddButton( "Beneficiarios"    , {|| lRet := .T., oDlg:end() } ,, 2 )
        oBrw:AddButton( "Resumo Contrato"  , {|| oDlg:end() } ,, 2 ) 

        oBrw:SetQueryIndex(aIndex)
        oBrw:SetSeek(.T.,aSeek)
        oBrw:SetFields(aBrowse)

        oBrw:Activate(oDlg)
        oDlg:Activate()

        oBrw:deActivate()
        oBrw:destroy()
        FreeObj(oBrw)
        oBrw := nil
    else

        lRet := .F.
        // Caso deseja gerar exceção...
        // UserException(TCSqlError())

    endif

    oTable:delete()
    FreeObj(oTable)
    oTable := nil

    RestArea(aArea)

Return lRet


