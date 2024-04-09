#INCLUDE "PROTHEUS.CH"
#Include "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
 
/* ---------------------------------------------------------- */

//        TELA DE CONSULTA DE CADASTRO POR CLIENTES
//
// EMPRESA: MEDICAR
// POR: EDUARDO AMARAL
// DATA: 16/02/2024
//
// CONTRATOS PJ BQC - TIPBLO = 0  E DATBLO <> ''(É BLOEUQADO/INATIVO)
// CONTRATOS PF BA3 - MOTBLO <> '' E DATBLO <> '' (É BLOQUEADO/INATIVO)
//
// lib: https://tdn.totvs.com/display/public/framework/FWTemporaryTable

//  044909

/* --------------------------------------------------------- */

/* -------------------------------------------------- CONTRATOS (CAPA) -------------------------------------------------- */

User Function ZCONTRATCLI(cSA1cliente, cSA1lojacli)

    Local aArea := GetArea()
    Local aAreaSA1	:= ("SA1") -> ( GetArea() )
    
    fMontaTela(cSA1cliente, cSA1lojacli)

    RestArea(aArea)
    RestArea(aAreaSA1)

Return
 
Static Function fMontaTela(cSA1cliente, cSA1lojacli)
    Local nLargBtn      := 45
    //Objetos e componentes
    Private oDlgCtr
    Private oFwLayer
    Private oPanTitulo
    Private oPanGrid
    //Cabeçalho
    Private oSayModulo, cSayModulo := 'Medicar'
    Private oSayTitulo, cSayTitulo := 'Lista de Contratos'
    Private oSaySubTit, cSaySubTit := 'Cliente: '
    //Tamanho da janela
    Private aSize := MsAdvSize(.F.)
    Private nJanLarg := aSize[5]
    Private nJanAltu := aSize[6]
    //Fontes
    Private cFontUti    := "Tahoma"
    Private oFontMod    := TFont():New(cFontUti, , -38)
    Private oFontSub    := TFont():New(cFontUti, , -20)
    Private oFontSubN   := TFont():New(cFontUti, , -20, , .T.)
    Private oFontBtn    := TFont():New(cFontUti, , -14)
    Private oFontSay    := TFont():New(cFontUti, , -12)
    //Grid
    Private aCampos := {}
    Private cAliasTmp := "TST_" + RetCodUsr()
    Private aColunas := {}
 
    //Campos da Temporária
    aAdd(aCampos, { "FILIAL"      , "C", 25, 0 })
    aAdd(aCampos, { "IDCONTRATO" , "C", TamSX3("BQC_SUBCON")[1],  0 })
    aAdd(aCampos, { "NUMERO"      , "C", TamSX3("BQC_ANTCON")[1],  0 })
    aAdd(aCampos, { "PERFIL"      , "C", 40,  0 })
    aAdd(aCampos, { "FORMPAG"      , "C", TamSX3("BQL_DESCRI")[1],  0 })
    aAdd(aCampos, { "CONDPAG"      , "C", 40,  0 })
    aAdd(aCampos, { "STATUSC"       , "C", 10,  0 })
    aAdd(aCampos, { "QTDVIDAS"   , "N", 9,  0 })
    aAdd(aCampos, { "VALOR"       , "C", 12,  0 })
    aAdd(aCampos, { "IDENT"       , "C", 12,  0 })
    aAdd(aCampos, { "DTBASE"       , "C", 10,  0 })
    aAdd(aCampos, { "VENDEDOR"       , "C", 30,  0 })
    aAdd(aCampos, { "CODINT"       , "C", 4,  0 })
    aAdd(aCampos, { "CODEMP"       , "C", 4,  0 })
    aAdd(aCampos, { "CONEMP"       , "C", 20,  0 })
    aAdd(aCampos, { "VERCON"       , "C", 3,  0 })
    aAdd(aCampos, { "VERSUB"       , "C", 3,  0 })
    
    //Cria a tabela temporária
    //IF oTempTableCtr:GetRealName() <> ''
    //    oTempTableCtr:Delete()
    //Endif

    If Select(cAliasTmp)>0
        (cAliasTmp)->(dbCloseArea())
    EndIf

    oTempTableCtr:= FWTemporaryTable():New(cAliasTmp)
    oTempTableCtr:SetFields( aCampos )
    oTempTableCtr:Create()
    
    
    //Busca as colunas do browse
    aColunas := fCriaCols()
 
    //Popula a tabela temporária
    Processa({|| fPopula(cSA1cliente, cSA1lojacli)}, "Processando...")
 
    DbSelectArea("SA1")
    SA1->(dbSetOrder(1))
    DBSEEK(XFILIAL("SA1") + cSA1cliente + cSA1lojacli)

    cSaySubTit := cSaySubTit  + SA1->A1_NREDUZ

    //SA1->(DbCloseArea())

    //Cria a janela
    DEFINE MSDIALOG oDlgCtr TITLE "Lista de Contratos"  FROM 0, 0 TO nJanAltu, nJanLarg PIXEL
 
        //Criando a camada
        oFwLayer := FwLayer():New()
        oFwLayer:init(oDlgCtr,.F.)
 
        //Adicionando 3 linhas, a de título, a superior e a do calendário
        oFWLayer:addLine("TIT", 10, .F.)
        oFWLayer:addLine("COR", 110, .F.)
 
        //Adicionando as colunas das linhas
        oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
        oFWLayer:addCollumn("BLANKBTN",     040, .T., "TIT")
        oFWLayer:addCollumn("BTNSAIR",      020, .T., "TIT")
        oFWLayer:addCollumn("COLGRID",      110, .T., "COR")
 
        //Criando os paineis
        oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
        oPanSair   := oFWLayer:GetColPanel("BTNSAIR",    "TIT")
        oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")
 
        //Títulos e SubTítulos
        //oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oPanHeader, "", oFontMod,  , , , .T., RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
        oSayTitulo := TSay():New(003, 080, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
        oSaySubTit := TSay():New(013, 080, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 300, 30, , , , , , .F., , )
        
        //Criando os botões
        oBtnSair := TButton():New(006, 001, "Fechar",                      oPanSair, {|| fFechatela()}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )
        oBtnBen  := TButton():New(006, 020, "Beneficiarios",              oPanHeader, {|| listabeneficiarios(cSA1cliente, cSA1lojacli)}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )
        //oBtnBen  := TButton():New(006, 750, "TESTE",                        , {|| pegadados()}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )

        //Cria a grid
        oGetGrid := FWBrowse():New()
        oGetGrid:SetDataTable()
        oGetGrid:SetInsert(.F.)
        oGetGrid:SetDelete(.F., { || .F. })
        oGetGrid:SetAlias(cAliasTmp)
        oGetGrid:DisableReport()
        oGetGrid:DisableFilter()
        oGetGrid:DisableConfig()
        oGetGrid:DisableReport()
        oGetGrid:DisableSeek()
        oGetGrid:DisableSaveConfig()
        oGetGrid:SetFontBrowse(oFontSay)
        oGetGrid:SetColumns(aColunas)
        oGetGrid:SetOwner(oPanGrid)
        oGetGrid:Activate()
    Activate MsDialog oDlgCtr Centered
    //oTempTableCtr:Delete()
Return
 
Static Function fCriaCols()
    Local nAtual   := 0 
    Local aColunas := {}
    Local aEstrut  := {}
    Local oColumn
     
    //Adicionando campos que serão mostrados na tela
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    aAdd(aEstrut, {"FILIAL", "Filial",                "C", 25,   0, ""})
    aAdd(aEstrut, {"IDCONTRATO", "Id Contrato",       "C", TamSX3('BQC_SUBCON')[01],    0, ""})
    aAdd(aEstrut, {"NUMERO", "Numero",                "C", TamSX3('BQC_ANTCON')[01],    0, ""})
    aAdd(aEstrut, {"PERFIL", "Perfil",                "C", 40,    0, ""})
    aAdd(aEstrut, {"FORMPAG", "Form. Pagamento",      "C", TamSX3('BQL_DESCRI')[01],    0, ""})
    aAdd(aEstrut, {"CONDPAG", "Cond. Pagamento",      "C", 40,    0, ""})
    aAdd(aEstrut, {"STATUSC", "Status",               "C", 10,    0, ""})
    aAdd(aEstrut, {"QTDVIDAS", "Qtd. Vidas",          "N",9,    0, ""})
    aAdd(aEstrut, {"VALOR", "Valor Total",            "C", 12,    0, ""})
    aAdd(aEstrut, {"DTBASE", "Data Base",            "C", 10,    0, ""})
    aAdd(aEstrut, {"VENDEDOR", "Vendedor",            "C", 30,    0, ""})
 
    //Percorrendo todos os campos da estrutura
    For nAtual := 1 To Len(aEstrut)
        //Cria a coluna
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| (cAliasTmp)->" + aEstrut[nAtual][1] +"}"))
        oColumn:SetTitle(aEstrut[nAtual][2])
        oColumn:SetType(aEstrut[nAtual][3])
        oColumn:SetSize(aEstrut[nAtual][4])
        oColumn:SetDecimal(aEstrut[nAtual][5])
        oColumn:SetPicture(aEstrut[nAtual][6])
        //oColumn:bHeaderClick := &("{|| fOrdena('" + aEstrut[nAtual][1] + "') }")
 
        //Adiciona a coluna
        aAdd(aColunas, oColumn)
    Next
Return aColunas
 
Static Function fPopula(cSA1cliente, cSA1lojacli)

    Local nAtual := 0
    Local nTotal := 0
    local cQueryCtr := ""
    local cQueryCli := ""
    Private cAliasCtr	 := GetNextAlias()
    Private cAliasCli	 := GetNextAlias()
    

        cQueryCli := "SELECT SA1.A1_PESSOA AS TIPO_PESSOA FROM SA1010 SA1 WHERE 1=1 AND SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = '"+cSA1cliente+"' AND SA1.A1_LOJA = '"+cSA1lojacli+"' "

    TCQUERY cQueryCli NEW ALIAS (cAliasCli)
    DbSelectArea(cAliasCli)

        If (cAliasCli)->TIPO_PESSOA = 'J'

            cQueryCtr += " SELECT "
            cQueryCtr += " CASE "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '001' THEN 'Medicar Ribeirao Preto' "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '002' THEN 'Medicar Campinas' "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '003' THEN 'Medicar Sao Paulo' "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '006' THEN 'Medicar Tech' "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '008' THEN 'Medicar Litoral' "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '016' THEN 'N1 Card' "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '021' THEN 'Medicar Rio de Janeiro' "
            cQueryCtr += "     ELSE '' "
            cQueryCtr += " END              AS FILIAL, "
            cQueryCtr += " A.BQC_SUBCON     AS IDCONTRATO, "
            cQueryCtr += " A.BQC_ANTCON     AS NUMERO, "
            cQueryCtr += " E.BT5_NOME       AS PERFIL, "
            cQueryCtr += " F.BQL_DESCRI     AS FORMPAG, "
            cQueryCtr += " G.ZI0_DESCRI     AS CONDPAG, "
            cQueryCtr += " COUNT(CONCAT(C.BA1_FILIAL,C.BA1_CODINT,C.BA1_CODEMP,C.BA1_MATRIC,C.BA1_TIPUSU,C.BA1_TIPREG,C.BA1_DIGITO,C.BA1_NOMUSR)) AS QTDVIDAS, "
            cQueryCtr += " SUM(D.BDK_VALOR) AS VALOR, "
            cQueryCtr += " ''               AS IDENT, "
            cQueryCtr += " CASE "
            cQueryCtr += "     WHEN A.BQC_TIPBLO = '0' AND A.BQC_DATBLO <> '' THEN 'BLOQUEADO' "
            cQueryCtr += "     ELSE 'ATIVO' "
            cQueryCtr += " END             AS STATUSC, "
            cQueryCtr += " CONCAT(SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),7,2),'/',SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),5,2),'/',SUBSTRING(CAST(A.BQC_DATCON AS VARCHAR),1,4)) AS DTBASE, "
            cQueryCtr += " H.A3_NOME       AS VENDEDOR, "
            cQueryCtr += " A.BQC_CODINT    AS CODINT, "
            cQueryCtr += " A.BQC_CODEMP    AS CODEMP, "
            cQueryCtr += " A.BQC_NUMCON    AS CONEMP, "
            cQueryCtr += " A.BQC_VERCON    AS VERCON, "
            cQueryCtr += " A.BQC_VERSUB    AS VERSUB "
            cQueryCtr += " FROM BQC010 A "
            cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = A.BQC_CODINT AND C.BA1_CODEMP = A.BQC_CODEMP AND C.BA1_CONEMP = A.BQC_NUMCON AND C.BA1_SUBCON = A.BQC_SUBCON AND C.BA1_VERCON = A.BQC_VERCON"
            cQueryCtr += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG "
            cQueryCtr += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
            cQueryCtr += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
            cQueryCtr += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
            cQueryCtr += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_CODVEN "
            cQueryCtr += " WHERE 1=1  "
            cQueryCtr += " AND A.D_E_L_E_T_ = '' "
            cQueryCtr += " AND A.BQC_COBNIV = '1' "
            cQueryCtr += " AND C.BA1_MOTBLO = '' "
            cQueryCtr += " AND C.BA1_DATBLO = '' "
            cQueryCtr += " AND A.BQC_CODCLI = '"+cSA1cliente+"'"
            cQueryCtr += " AND A.BQC_LOJA = '"+cSA1lojacli+"' "
            cQueryCtr += " GROUP BY C.BA1_FILIAL,A.BQC_SUBCON,E.BT5_NOME,A.BQC_DESCRI,A.BQC_ZNFANT,A.BQC_ANTCON,F.BQL_DESCRI,G.ZI0_DESCRI, A.BQC_TIPBLO, A.BQC_DATBLO, A.BQC_DATCON, H.A3_NOME,A.BQC_CODINT,A.BQC_CODEMP,A.BQC_NUMCON,A.BQC_VERCON,A.BQC_VERSUB "
        
        Else

            cQueryCtr += " SELECT  "
            cQueryCtr += " CASE  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '001' THEN 'Medicar Ribeirao Preto'  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '002' THEN 'Medicar Campinas'  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '003' THEN 'Medicar Sao Paulo'  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '006' THEN 'Medicar Tech'  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '008' THEN 'Medicar Litoral'  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '016' THEN 'N1 Card'  "
            cQueryCtr += "     WHEN C.BA1_FILIAL = '021' THEN 'Medicar Rio de Janeiro'  "
            cQueryCtr += "     ELSE ''  "
            cQueryCtr += " END             AS FILIAL,  "
            cQueryCtr += " CASE  "
            cQueryCtr += "     WHEN B.BA3_IDBENN <> '' THEN B.BA3_IDBENN  "
            cQueryCtr += "     ELSE B.BA3_MATEMP  "
            cQueryCtr += " END             AS IDCONTRATO,  "
            cQueryCtr += " B.BA3_XCARTE    AS NUMERO,  "
            cQueryCtr += " E.BT5_NOME      AS PERFIL,  "
            cQueryCtr += " F.BQL_DESCRI    AS FORMPAG,  "
            cQueryCtr += " G.ZI0_DESCRI    AS CONDPAG,  "
            cQueryCtr += " COUNT(CONCAT(C.BA1_FILIAL,C.BA1_CODINT,C.BA1_CODEMP,C.BA1_MATRIC,C.BA1_TIPUSU,C.BA1_TIPREG,C.BA1_DIGITO,C.BA1_NOMUSR)) AS QTDVIDAS, "
            cQueryCtr += " SUM(D.BDK_VALOR) AS VALOR,  "
            cQueryCtr += " CASE  "
            cQueryCtr += "     WHEN B.BA3_IDBENN <> '' THEN '1'  "
            cQueryCtr += "     ELSE '0'  "
            cQueryCtr += " END             AS IDENT,  "
            cQueryCtr += " CASE  "
            cQueryCtr += "     WHEN B.BA3_MOTBLO <> ''  "
            cQueryCtr += "     AND B.BA3_DATBLO <> '' THEN 'BLOQUEADO'  "
            cQueryCtr += "     ELSE 'ATIVO'  "
            cQueryCtr += " END AS STATUSC,  "
            cQueryCtr += " CONCAT(SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),7,2),'/',SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),5,2),'/',SUBSTRING(CAST(B.BA3_DATBAS AS VARCHAR),1,4)) AS DTBASE,  "
            cQueryCtr += " H.A3_NOME AS VENDEDOR,  "
            cQueryCtr += " B.BA3_CODINT    AS CODINT, "
            cQueryCtr += " B.BA3_CODEMP    AS CODEMP, "
            cQueryCtr += " B.BA3_CONEMP    AS CONEMP, "
            cQueryCtr += " B.BA3_VERCON    AS VERCON, "
            cQueryCtr += " B.BA3_VERSUB    AS VERSUB "
            cQueryCtr += " FROM BQC010 A  "
            cQueryCtr += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON   "
            cQueryCtr += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.BA1_MATRIC = B.BA3_MATRIC  "
            cQueryCtr += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
            cQueryCtr += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
            cQueryCtr += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = B.BA3_TIPPAG  "
            cQueryCtr += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = B.BA3_XCONDI  "
            cQueryCtr += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_CODVEN  "
            cQueryCtr += " WHERE 1=1  "
            cQueryCtr += " AND A.D_E_L_E_T_ = ''  "
            cQueryCtr += " AND B.BA3_COBNIV = '1'  "
            cQueryCtr += " AND C.BA1_MOTBLO = '' "
            cQueryCtr += " AND C.BA1_DATBLO = '' "
            cQueryCtr += " AND B.BA3_CODCLI = '"+cSA1cliente+"' "
            cQueryCtr += " AND B.BA3_LOJA = '"+cSA1lojacli+"' "
            cQueryCtr += " GROUP BY C.BA1_FILIAL,B.BA3_IDBENN,B.BA3_MATEMP,B.BA3_XCARTE,E.BT5_NOME,F.BQL_DESCRI,G.ZI0_DESCRI, B.BA3_MOTBLO, B.BA3_DATBLO, B.BA3_DATBAS, H.A3_NOME,B.BA3_CODINT,B.BA3_CODEMP,B.BA3_CONEMP,B.BA3_VERCON,B.BA3_VERSUB  "

        EndIF

    //Criar alias temporário
    TCQUERY cQueryCtr NEW ALIAS (cAliasCtr)
    DbSelectArea(cAliasCtr)

    (cAliasCtr)->(DbGoTop())

    //Define o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
    (cAliasCtr)->(DbGoTop())

    //Enquanto houver itens
    While ! (cAliasCtr)->(EoF())
        //Incrementa a régua
        nAtual++
        IncProc("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

        //Grava na temporária
        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->FILIAL := (cAliasCtr)->FILIAL
            (cAliasTmp)->IDCONTRATO := (cAliasCtr)->IDCONTRATO
            (cAliasTmp)->NUMERO := (cAliasCtr)->NUMERO
            (cAliasTmp)->PERFIL := (cAliasCtr)->PERFIL
            (cAliasTmp)->FORMPAG := (cAliasCtr)->FORMPAG
            (cAliasTmp)->CONDPAG := (cAliasCtr)->CONDPAG
            (cAliasTmp)->QTDVIDAS := (cAliasCtr)->QTDVIDAS
            (cAliasTmp)->VALOR := "R$ " + Alltrim(Transform((cAliasCtr)->VALOR, "@E 999,999,999.99")) //57.485,34
            (cAliasTmp)->IDENT := (cAliasCtr)->IDENT
            (cAliasTmp)->STATUSC := (cAliasCtr)->STATUSC
            (cAliasTmp)->DTBASE := (cAliasCtr)->DTBASE
            (cAliasTmp)->VENDEDOR := (cAliasCtr)->VENDEDOR
            (cAliasTmp)->CODINT := (cAliasCtr)->CODINT
            (cAliasTmp)->CODEMP := (cAliasCtr)->CODEMP
            (cAliasTmp)->CONEMP := (cAliasCtr)->CONEMP
            (cAliasTmp)->VERCON := (cAliasCtr)->VERCON
            (cAliasTmp)->VERSUB := (cAliasCtr)->VERSUB
        (cAliasTmp)->(MsUnlock())
        (cAliasCtr)->(DbSkip())
    EndDo

    (cAliasCtr)->(DbCloseArea())
    (cAliasCli)->(DbCloseArea())

Return

Static Function listabeneficiarios(cSA1cliente, cSA1lojacli)

    If (cAliasTmp)->(Eof()) 
        MsgAlert("Nehum Contrato Selecionado!","Atenção") 
    Else 
        U_ZBENEFCTR(cSA1cliente, cSA1lojacli, (cAliasTmp)->IDCONTRATO, (cAliasTmp)->IDENT,(cAliasTmp)->CODINT,(cAliasTmp)->CODEMP,(cAliasTmp)->CONEMP,(cAliasTmp)->VERCON,(cAliasTmp)->VERSUB) 
    EndIf 

Return 

Static Function fFechatela()

    oDlgCtr:End()

Return
