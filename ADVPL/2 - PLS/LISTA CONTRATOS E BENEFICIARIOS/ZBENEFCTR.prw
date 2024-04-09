#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"

/* ---------------------------------------------------------- */
//
//      TELA DE CONSULTA DE BENEFICIARIOS POR CONTRATO
//
// EMPRESA: MEDICAR
// POR: EDUARDO AMARAL
// DATA: 16/02/2024
// CONTRATOS PJ BQC - TIPBLO = 0  E DATBLO <> ''(É BLOEUQADO/INATIVO)
// CONTRATOS PF BA3 - MOTBLO <> '' E DATBLO <> '' (É BLOQUEADO/INATIVO)
//
// lib: https://tdn.totvs.com/display/public/framework/FWTemporaryTable
/* --------------------------------------------------------- */

/* -------------------------------------------------- BENEFICIARIOS -------------------------------------------------- */

User Function ZBENEFCTR(cSA1cliente, cSA1lojacli, cIdcontrato, cIdent, cCodint, cCodemp, cConemp, cVercon, cVersub)
   
    Local aArea := GetArea()
    
    fMontaBeneficiario(cSA1cliente, cSA1lojacli, cIdcontrato, cIdent, cCodint, cCodemp, cConemp, cVercon, cVersub)
    
    RestArea(aArea)

Return
 
Static Function fMontaBeneficiario(cSA1cliente, cSA1lojacli, cIdcontrato, cIdent, cCodint, cCodemp, cConemp, cVercon, cVersub)

    Local nLargBtn      := 45
    Local lDimPixels    := .T. 
    //VARIAVEL DE PESQUISA
    Private cPesq := Space(70)
    Private aItems 		:= {"Nome","Cpf/Cnpj"}   
    Private cCombo 		:= aItems[1]
    //Objetos e componentes
    Private oDlgCtrBen
    Private oFwLayer
    Private oPanTitulo
    Private oPanGrid
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
    Private aCamposBen := {}
    Private cAliasTmpBen := "TST_" + RetCodUsr() + "_BENE"
    Private aColunasBen := {}
    
    Private cFontNome   := 'Tahoma'
    Private oFontPadrao := TFont():New(cFontNome, , -12)

    //Campos da Temporária
    aAdd(aCamposBen, { "CARTEIRA",      "C", 25, 0 })
    aAdd(aCamposBen, { "BENEFI",        "C", 70, 0 })
    aAdd(aCamposBen, { "CPF",           "C", 18, 0 })
    aAdd(aCamposBen, { "ATEND",         "C", 3,  0 })
    aAdd(aCamposBen, { "STATUSB",       "C", 7,  0 })
    aAdd(aCamposBen, { "VALOR",         "C", 12, 0 })
    aAdd(aCamposBen, { "TIPO",          "C", 1,  0 })
 
    //Cria a tabela temporária
    //IF oTempTableBen:GetRealName() <> ''
    //    oTempTableBen:Delete()
    //Endif
    
    oTempTableBen:= FWTemporaryTable():New(cAliasTmpBen)
    oTempTableBen:SetFields( aCamposBen )
    oTempTableBen:Create()

    //Busca as colunas do browse
    aColunasBen := fCriaColsBen()
 
    //Popula a tabela temporária
    Processa({|| fPopulaBen(cSA1cliente, cSA1lojacli, cIdcontrato, cIdent, cCodint, cCodemp, cConemp, cVercon, cVersub)}, "Processando...")

    //Cria a janela
    DEFINE MSDIALOG oDlgCtrBen TITLE "Lista de Beneficiarios"  FROM 0, 0 TO nJanAltu, nJanLarg PIXEL
 
        //Criando a camada
        oFwLayer := FwLayer():New()
        oFwLayer:init(oDlgCtrBen,.F.)
 
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

        //Barra de pesquisa
        oSayTpPesq := TSay():New(003, 003, {|| "Pesquisar Por: "},, "", oFontSay,  , , , .T., RGB(149, 179, 215), , 060, 020, , , , , , .F., , )
        oCombo := TComboBox():New(002,045,,aItems,050,012,oDlgCtrBen,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cCombo,cCombo:=u)}

        oSayPesq := TSay():New(017,003,{|| "Pesquisa: "},, "", oFontSay,  , , , .T., RGB(149, 179, 215), , 060, 020, , , , , , .F., , )
        oGetPesq := TGet():New(015, 030, {|u| Iif(PCount() > 0 , cPesq := u, cPesq)}, oGetPesq, 150, 010, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)

        oBtnPesq  := TButton():New(015, 185, "Pesquisar",                        , {|| fPesquisa(cCombo,cPesq)}, nLargBtn, 012, , oFontBtn, , .T., , , , , , )

        //Criando os botões
        oBtnSair := TButton():New(006, 001, "Fechar", oPanSair, {|| fFechatela()}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )
 
        //Cria a grid
        oGetGrid := FWBrowse():New()
        oGetGrid:SetDataTable()
        oGetGrid:SetInsert(.F.)
        oGetGrid:SetDelete(.F., { || .F. })
        oGetGrid:SetAlias(cAliasTmpBen)
        oGetGrid:DisableReport()
        oGetGrid:DisableFilter()
        oGetGrid:DisableConfig()
        oGetGrid:DisableReport()
        oGetGrid:DisableSeek()
        oGetGrid:DisableSaveConfig()
        oGetGrid:SetFontBrowse(oFontSay)
        oGetGrid:SetColumns(aColunasBen)
        oGetGrid:SetOwner(oPanGrid)
        oGetGrid:Activate()
    Activate MsDialog oDlgCtrBen Centered
    oTempTableBen:Delete()
Return
 
Static Function fCriaColsBen()
    Local nAtual   := 0
    Local aColunasBen := {}
    Local aEstrutBen  := {}
    Local oColumn
     
    //Adicionando campos que serão mostrados na tela
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    aAdd(aEstrutBen, {"CARTEIRA", "Carteirinha",                   "C", 25,   0, ""})
    aAdd(aEstrutBen, {"BENEFI", "Beneficiario",                    "C", 70,   0, ""})
    aAdd(aEstrutBen, {"CPF", "Cpf",                                "C", 18,   0, ""})
    aAdd(aEstrutBen, {"ATEND", "Tem Atend.",                       "C", 3,    0, ""})
    aAdd(aEstrutBen, {"STATUSB", "Status",                         "C", 7,    0, ""})
    aAdd(aEstrutBen, {"VALOR", "Valor",                            "C", 12,   0, ""})
    aAdd(aEstrutBen, {"TIPO", "Tipo",                              "C", 1,    0, ""})
 
    //Percorrendo todos os campos da estrutura
    For nAtual := 1 To Len(aEstrutBen)
        //Cria a coluna
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| (cAliasTmpBen)->" + aEstrutBen[nAtual][1] +"}"))
        oColumn:SetTitle(aEstrutBen[nAtual][2])
        oColumn:SetType(aEstrutBen[nAtual][3])
        oColumn:SetSize(aEstrutBen[nAtual][4])
        oColumn:SetDecimal(aEstrutBen[nAtual][5])
        oColumn:SetPicture(aEstrutBen[nAtual][6])
        //oColumn:bHeaderClick := &("{|| fOrdena('" + aEstrutBen[nAtual][1] + "') }")
 
        //Adiciona a coluna
        aAdd(aColunasBen, oColumn)
    Next
Return aColunasBen
 
Static Function fPopulaBen(cSA1cliente, cSA1lojacli, cIdcontrato, cIdent, cCodint, cCodemp, cConemp, cVercon, cVersub)

    Local nAtual := 0
    Local nTotal := 0
    local cQueryCtrBen := ""
    local cQueryCli := ""
    Private cAliasCtrBen := GetNextAlias()
    Private cAliasCli	 := GetNextAlias()
    

    cQueryCli := "SELECT SA1.A1_PESSOA AS TIPO_PESSOA FROM SA1010 SA1 WHERE 1=1 AND SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = '"+cSA1cliente+"' AND SA1.A1_LOJA = '"+cSA1lojacli+"' "

    TCQUERY cQueryCli NEW ALIAS (cAliasCli)
    DbSelectArea(cAliasCli)

        cQueryCtrBen := " SELECT " 
        cQueryCtrBen += " C.BA1_XCARTE AS CARTEIRA, "
        cQueryCtrBen += " C.BA1_NOMUSR AS BENEFI, "
        cQueryCtrBen += " CASE WHEN LEN(C.BA1_CPFUSR) > 11 THEN CONCAT(SUBSTRING(C.BA1_CPFUSR,1,2),'.',SUBSTRING(C.BA1_CPFUSR,3,3),'.',SUBSTRING(C.BA1_CPFUSR,6,3),'/',SUBSTRING(C.BA1_CPFUSR,9,4),'-',SUBSTRING(C.BA1_CPFUSR,13,2)) ELSE CONCAT(SUBSTRING(C.BA1_CPFUSR,1,3),'.',SUBSTRING(C.BA1_CPFUSR,4,3),'.',SUBSTRING(C.BA1_CPFUSR,7,3),'-',SUBSTRING(C.BA1_CPFUSR,10,2)) END AS CPF, "
        cQueryCtrBen += " CASE WHEN C.BA1_ZATEND = '1' THEN 'Sim' WHEN C.BA1_ZATEND = '0' THEN 'Não' ELSE '' END AS ATEND, "
        cQueryCtrBen += " CASE WHEN BA1_DATBLO <> '' AND BA1_MOTBLO <> '' THEN 'INATIVO' ELSE 'ATIVO' END AS STATUSB, "
        cQueryCtrBen += " SUM(D.BDK_VALOR) AS VALOR, "
        cQueryCtrBen += " C.BA1_TIPUSU AS TIPO "
        cQueryCtrBen += " FROM BQC010 A "
        cQueryCtrBen += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON  "
        cQueryCtrBen += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQueryCtrBen += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG  "
        cQueryCtrBen += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
        cQueryCtrBen += " WHERE 1=1  "
        cQueryCtrBen += " AND A.D_E_L_E_T_ = '' "
        If (cAliasCli)->TIPO_PESSOA = 'J'
            cQueryCtrBen += " AND A.BQC_SUBCON = '"+cIdcontrato+"' "
            cQueryCtrBen += " AND A.BQC_CODINT = '"+Alltrim(cCodint)+"' "
            cQueryCtrBen += " AND A.BQC_CODEMP = '"+Alltrim(cCodemp)+"' "
            cQueryCtrBen += " AND A.BQC_NUMCON = '"+Alltrim(cConemp)+"' "
            cQueryCtrBen += " AND A.BQC_VERCON = '"+Alltrim(cVercon)+"' "
            cQueryCtrBen += " AND A.BQC_VERSUB = '"+Alltrim(cVersub)+"' "
        Else
            If cIdent = '1'
                cQueryCtrBen += " AND B.BA3_IDBENN = '"+cIdcontrato+"' "
                cQueryCtrBen += " AND B.BA3_CODINT = '"+Alltrim(cCodint)+"' "
                cQueryCtrBen += " AND B.BA3_CODEMP = '"+Alltrim(cCodemp)+"' "
                cQueryCtrBen += " AND B.BA3_CONEMP = '"+Alltrim(cConemp)+"' "
                cQueryCtrBen += " AND B.BA3_VERCON = '"+Alltrim(cVercon)+"' "
                cQueryCtrBen += " AND B.BA3_VERSUB = '"+Alltrim(cVersub)+"' "
            Else
                cQueryCtrBen += " AND B.BA3_MATEMP = '"+cIdcontrato+"' "
                cQueryCtrBen += " AND B.BA3_CODINT = '"+Alltrim(cCodint)+"' "
                cQueryCtrBen += " AND B.BA3_CODEMP = '"+Alltrim(cCodemp)+"' "
                cQueryCtrBen += " AND B.BA3_CONEMP = '"+Alltrim(cConemp)+"' "
                cQueryCtrBen += " AND B.BA3_VERCON = '"+Alltrim(cVercon)+"' "
                cQueryCtrBen += " AND B.BA3_VERSUB = '"+Alltrim(cVersub)+"' "
            EndIf
        EndIf
        cQueryCtrBen += " GROUP BY C.BA1_XCARTE,C.BA1_NOMUSR,C.BA1_CPFUSR,C.BA1_ZATEND,BA1_DATBLO,BA1_MOTBLO,C.BA1_TIPUSU "


    //Criar alias temporário
    TCQUERY cQueryCtrBen NEW ALIAS (cAliasCtrBen)
    DbSelectArea(cAliasCtrBen)

    (cAliasCtrBen)->(DbGoTop())
 
    //Define o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
    (cAliasCtrBen)->(DbGoTop())
 
    //Enquanto houver itens
    While ! (cAliasCtrBen)->(EoF())
        //Incrementa a régua
        nAtual++
        IncProc("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
 
        //Grava na temporária
        RecLock(cAliasTmpBen, .T.)
            (cAliasTmpBen)->CARTEIRA      := (cAliasCtrBen)->CARTEIRA
            (cAliasTmpBen)->BENEFI        := (cAliasCtrBen)->BENEFI
            (cAliasTmpBen)->CPF           := (cAliasCtrBen)->CPF
            (cAliasTmpBen)->ATEND         := (cAliasCtrBen)->ATEND
            (cAliasTmpBen)->STATUSB       := (cAliasCtrBen)->STATUSB
            (cAliasTmpBen)->VALOR         := "R$ " + Alltrim(Transform((cAliasCtrBen)->VALOR, "@E 999,999,999.99"))
            (cAliasTmpBen)->TIPO          := (cAliasCtrBen)->TIPO
        (cAliasTmpBen)->(MsUnlock())
        (cAliasCtrBen)->(DbSkip())
    EndDo

    (cAliasCtrBen)->(DbCloseArea())
    (cAliasCli)->(DbCloseArea())

Return

Static Function fPesquisa(cCombo,cPesq)
    
    Local cFiltro

    IF cCombo = "Cpf/Cnpj"
      
        //(cAliasTmpBen)->(DbGoTop())

        If Alltrim(cPesq) $ (cAliasTmpBen)->CPF

            //EXPRESSAO EM SQL
            cFiltro := "CPF LIKE '%" + Alltrim(cPesq) + "%'"
            oGetGrid:SetFilterDefault( "@"  + cFiltro ) 
            oGetGrid:GoTop(.T.)
            oGetGrid:Refresh(.T.) 

        ElseIf cPesq = Space(18)

            oGetGrid:GoTop(.T.)
            oGetGrid:SetFilterDefault("")
            oGetGrid:Refresh(.T.)

        Else

            //EXPRESSAO EM SQL
            cFiltro := "CPF LIKE '%" + Alltrim(cPesq) + "%'"
            oGetGrid:SetFilterDefault( "@"  + cFiltro ) 
            oGetGrid:GoTop(.T.)
            oGetGrid:Refresh(.T.) 


        Endif

    ELSE

        //(cAliasTmpBen)->(DbGoTop())

        If Upper(Alltrim(cPesq)) $  (cAliasTmpBen)->BENEFI

            //EXPRESSAO EM SQL
            cFiltro := "BENEFI LIKE '%" + Upper(Alltrim(cPesq)) + "%'"
            oGetGrid:SetFilterDefault( "@"  + cFiltro ) 
            oGetGrid:GoTop(.T.)
            oGetGrid:Refresh(.T.)

        ElseIF cPesq = Space(70)

            oGetGrid:GoTop(.T.)
            oGetGrid:SetFilterDefault("")
            oGetGrid:Refresh(.T.)

        Else

            //EXPRESSAO EM SQL
            cFiltro := "BENEFI LIKE '%" + Upper(Alltrim(cPesq)) + "%'"
            oGetGrid:SetFilterDefault( "@"  + cFiltro ) 
            oGetGrid:GoTop(.T.)
            oGetGrid:Refresh(.T.)

        Endif

    ENDIF

Return

Static Function fFechatela()

   oDlgCtrBen:End()

Return
