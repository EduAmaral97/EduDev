#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH"

    
User Function ZMEDTELA()
    Local aArea := GetArea()
    //Fontes
    Local cFontUti    := "Tahoma"
    Local oFontAno    := TFont():New(cFontUti,,-38)
    Local oFontSub    := TFont():New(cFontUti,,-20)
    Local oFontSubN   := TFont():New(cFontUti,,-20,,.T.)
    Local oFontBtn    := TFont():New(cFontUti,,-14)
    //Janela e componentes
    Private oDlgGrp
    Private oPanGrid
    Private oGetGrid
    Private aColunas := {}
    Private cAliasTab := "TMPSE1CLI"
    //Tamanho da janela
    //Private    aTamanho := MsAdvSize()
    //Private    nJanLarg := aTamanho[5]
    //Private    nJanAltu := aTamanho[6]

    Private    nJanLarg := 1200
    Private    nJanAltu := 600
    
    
    //Cria a temporária
    oTempTable := FWTemporaryTable():New(cAliasTab)
        
    //Adiciona no array das colunas as que serão incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
    aFields := {}
    aAdd(aFields, { "FILIAL",     "C",  6, 0 })
    aAdd(aFields, { "PREFIXO",    "C",  3, 0 })
    aAdd(aFields, { "TITULO",     "C",  9, 0 })
    aAdd(aFields, { "PARCELA",    "C",  2, 0 })
    aAdd(aFields, { "TIPO",       "C",  3, 0 })
    aAdd(aFields, { "EMISSAO",    "C", 10, 0 })
    aAdd(aFields, { "VENCIMENTO", "C", 10, 0 })
    aAdd(aFields, { "VENCREA",    "C", 10, 0 })
    aAdd(aFields, { "VLRTIT",     "N", 20, 2 })
    aAdd(aFields, { "VLRBAIXADO", "N", 20, 2 })
    aAdd(aFields, { "SALDO",      "N", 20, 2 })
    aAdd(aFields, { "SITUACAO",   "C", 10, 0 })


        
    //Define as colunas usadas, adiciona indice e cria a temporaria no banco
    oTempTable:SetFields( aFields )
    oTempTable:AddIndex("1", {"TITULO"} )
    oTempTable:Create()
    
    //Monta o cabecalho
    fMontaHead()
    
    //Montando os dados, eles devem ser montados antes de ser criado o FWBrowse
    FWMsgRun(, {|| fMontDados() }, "Processando", "Buscando grupos")
    //Processa({|| fMontDados()}, "Processando...")
    
    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE "Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 004, 003 SAY "Titulos"                     SIZE 200, 030 FONT oFontAno  OF oDlgGrp COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Listagem de Titulos"    SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Dados Temporários"       SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL
    
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
    
        //Dados
        @ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Browse" OF oDlgGrp COLOR 0, 16777215 PIXEL
        oGrpDad:oFont := oFontBtn
            oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
            oGetGrid := FWBrowse():New()
            oGetGrid:DisableFilter()
            oGetGrid:DisableConfig()
            oGetGrid:DisableReport()
            oGetGrid:DisableSeek()
            oGetGrid:DisableSaveConfig()
            oGetGrid:SetFontBrowse(oFontBtn)
            oGetGrid:SetAlias(cAliasTab)
            oGetGrid:SetDataTable()
            oGetGrid:SetEditCell(.T., {|| .T.}) 
            oGetGrid:lHeaderClick := .F.
            oGetGrid:AddLegend(cAliasTab + "->SALDO == 0", "RED", "Titulo Baixado")
            oGetGrid:AddLegend(cAliasTab + "->SALDO >  0", "GREEN",  "Titulo Aberto")
            oGetGrid:SetColumns(aColunas)
            oGetGrid:SetOwner(oPanGrid)
            oGetGrid:Activate()
    ACTIVATE MsDialog oDlgGrp CENTERED
    
    //Deleta a temporaria
    oTempTable:Delete()
    
    RestArea(aArea)
Return
    
Static Function fMontaHead()
    Local nAtual
    Local aHeadAux := {}
    
    //Adicionando colunas
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    //[7] - Editável? .T. = sim, .F. = não
    aAdd(aHeadAux, { "FILIAL",      "Flial",            "C",  6, 0, "@!", .F.})
    aAdd(aHeadAux, { "PREFIXO",     "Prefixo",          "C",  3, 0, "@!", .F.})
    aAdd(aHeadAux, { "TITULO",      "Titulo",           "C",  9, 0, "@!", .F.})
    aAdd(aHeadAux, { "PARCELA",     "Parcela",          "C",  2, 0, "@!", .F.})
    aAdd(aHeadAux, { "TIPO",        "Tipo",             "C",  3, 0, "@!", .F.})
    aAdd(aHeadAux, { "EMISSAO",     "Dt. Emissao",      "C", 10, 0, "@!", .F.})
    aAdd(aHeadAux, { "VENCIMENTO",  "Dt Vencimento",    "C", 10, 0, "@!", .F.})
    aAdd(aHeadAux, { "VENCREA",     "Venc. Real",       "C", 10, 0, "@!", .F.})
    aAdd(aHeadAux, { "VLRTIT",      "Valor",            "N", 10, 2, "@E 999,999.99", .F.})
    aAdd(aHeadAux, { "VLRBAIXADO",  "Vlr. Baixado",     "N", 10, 2, "@E 999,999.99", .F.})
    aAdd(aHeadAux, { "SALDO",       "Saldo",            "N", 10, 2, "@E 999,999.99", .F.})
    aAdd(aHeadAux, { "SITUACAO",    "Situacao",         "C", 10, 0, "@!", .F.})
    
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| " + cAliasTab + "->" + aHeadAux[nAtual][1] +"}"))
        oColumn:SetTitle(aHeadAux[nAtual][2])
        oColumn:SetType(aHeadAux[nAtual][3])
        oColumn:SetSize(aHeadAux[nAtual][4])
        oColumn:SetDecimal(aHeadAux[nAtual][5])
        oColumn:SetPicture(aHeadAux[nAtual][6])
  
        //Se for ser possível ter o duplo clique
        If aHeadAux[nAtual][7]
            oColumn:SetEdit(.T.)
            oColumn:SetReadVar(aHeadAux[nAtual][1])
            //oColumn:SetValid({|| fSuaValid()})
        EndIf
  
        aAdd(aColunas, oColumn)
    Next
Return
    
Static Function fMontDados()

    Local aArea   := GetArea()
    local cQueryTit := ""
    Private cAliasTit := GetNextAlias()
   
    cQueryTit +=" SELECT "
    cQueryTit +=" SE1.E1_FILIAL   	AS FILIAL,  "
    cQueryTit +=" SE1.E1_PREFIXO  	AS PREFIXO,  "
    cQueryTit +=" SE1.E1_NUM	        AS TITULO, 	 "
    cQueryTit +=" SE1.E1_PARCELA  	AS PARCELA,  "
    cQueryTit +=" SE1.E1_TIPO    	    AS TIPO,  "
    cQueryTit +=" CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS EMISSAO,   "
    cQueryTit +=" CONCAT(SUBSTRING(SE1.E1_VENCTO,7,2),'/',SUBSTRING(SE1.E1_VENCTO,5,2),'/',SUBSTRING(SE1.E1_VENCTO,1,4)) AS VENCIMENTO,   "
    cQueryTit +=" CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS VENCREA,   "
    cQueryTit +=" SE1.E1_VALOR        AS VLRTIT,  "
    cQueryTit +=" SE1.E1_VALLIQ       AS VLRBAIXADO,  "
    cQueryTit +=" (SE1.E1_VALOR - SE1.E1_VALLIQ) AS SALDO,  "
    cQueryTit +=" CASE  "
    cQueryTit +="     WHEN (SE1.E1_VALOR - SE1.E1_VALLIQ) = 0 THEN 'BAIXADO'  "
    cQueryTit +="     ELSE 'ABERTO'  "
    cQueryTit +=" END                 AS SITUACAO  "
    cQueryTit +=" FROM SE1010 SE1  "
    cQueryTit +=" WHERE 1=1    "
    cQueryTit +=" AND SE1.D_E_L_E_T_ = ''  "
    cQueryTit +=" AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-')  "
    cQueryTit +=" AND SE1.E1_CLIENTE = '060395'  "
    cQueryTit +=" AND SE1.E1_LOJA = '01'  "
    cQueryTit +=" ORDER BY SE1.E1_VENCREA DESC "

    //Criar alias temporário
    TCQUERY cQueryTit NEW ALIAS (cAliasTit)
    DbSelectArea(cAliasTit)

    (cAliasTit)->(DbGoTop())

    While ! (cAliasTit)->(EoF())

        RecLock(cAliasTab, .T.)
            (cAliasTab)->FILIAL     := (cAliasTit)->FILIAL
            (cAliasTab)->PREFIXO    := (cAliasTit)->PREFIXO
            (cAliasTab)->TITULO     := (cAliasTit)->TITULO
            (cAliasTab)->PARCELA    := (cAliasTit)->PARCELA
            (cAliasTab)->TIPO       := (cAliasTit)->TIPO
            (cAliasTab)->EMISSAO    := (cAliasTit)->EMISSAO
            (cAliasTab)->VENCIMENTO := (cAliasTit)->VENCIMENTO
            (cAliasTab)->VENCREA    := (cAliasTit)->VENCREA
            (cAliasTab)->VLRTIT     := (cAliasTit)->VLRTIT
            (cAliasTab)->VLRBAIXADO := (cAliasTit)->VLRBAIXADO
            (cAliasTab)->SALDO      := (cAliasTit)->SALDO
            (cAliasTab)->SITUACAO   := (cAliasTit)->SITUACAO
        (cAliasTab)->(MsUnlock())
        (cAliasTit)->(DbSkip())

    EndDo

    (cAliasTit)->(DbCloseArea())
    RestArea(aArea)

Return
