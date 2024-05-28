#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "FWMVCDEF.CH"


//Posições do Array para planilha de importacao
Static nPosPlaca        := 1
Static nPosVlrUni       := 2 
Static nPosQuantidade   := 3
Static nPosValor        := 4 
Static nPosCC           := 5 
Static nPosCLVL         := 6 
Static nPosInsumo       := 7
Static nPosCondutor     := 8
Static nPosPosto        := 9


/* ----------------------------------------------------------------------------

------------- TABELAS -------------
ZMCF1 - CABECARIO IMP. COMBUSTIVEL
ZMCF2 - ITENS/PLACA IMP. COMBUSTIVEL
SC7010 - PEDIDO DE COMPRAS
SCH010 - RATEIO POR CC/CLVL

------------- PASSOS ------------- 
1 - PREENCHER O CABECARIO (MANUALMENTE)
2 - IMPORTAR ITENS/PLACAS COM LAYOUT EM PLANILHA
3 - GERAR PEDIDO DE COMPRAS COM RATEIO VIA ROTINA PERSONALIZADA
4 - VERIFICAR PEDIDO DE COMPRAS GERADO E SALVA-LO PARA GERAR OS APROVADORES

---------------------------------------------------------------------------- */

/* -------------------------- BROWSER DA ROTINA -------------------------- */

User Function ZMEDDESPFRT()

 Local aIndex := {}
 Local aSeek := {}

  Private cCadastro := "Despesas Frota Medicar"
  Private oBrow
  
  //Private aRotina := {;
  //{ "Pesquisar"     ,'PesqBrw'        ,0,1 },;
  //{ "Visualizar"    ,'AxVisual'       ,0,2 },;
  //{ "Incluir"       ,'AxInclui'       ,0,3 },;
  //{ "AlTerar"       ,'AxAltera'       ,0,4 },;  
  //{ "Excluir"       ,'AxDeleta'       ,0,5 };
  // }

   aAdd(aIndex, {"ZC1_DOC"})
   aAdd(aIndex, {"ZC1_FORNEC"})
   aAdd(aSeek, {"ZC1_DOC"    , {{"LookUp", "C", 18, 0, "Numero NF",,}} , 1, .T. }) // TIPO | TAMANHO | 0
   aAdd(aSeek, {"ZC1_FORNEC" , {{"LookUp", "C", 6, 0, "Numero NF",,}} , 1, .T. }) // TIPO | TAMANHO | 0

  // Monta o mBrowse para exibição dos registros
  oBrowse := FWMBrowse():New() // Inicializa o objeto
  //Adiciona a coluna de Status
  //oBrowse:AddStatusColumns( { || BrwStatus() }, { || BrwLegend() } )
  oBrowse:SetAlias("ZC1") // Indica a tabela utilizada
  oBrowse:SetDescription(cCadastro) // Titulo
  oBrowse:DisableDetails() // Desabilita os detalhes
  oBrowse:SetSeek(.T.,aSeek)
  //oBrowse:SetSeeAll(.T.) // Permite visualizar registros todas filiais
  //oBrowse:SetChgAll(.T.) // Permite alterar reg. de outras filiais
  oBrowse:AddButton( "Visualizar"       , {|| ZVIS() } ,, 2 ) 
  oBrowse:AddButton( "Incluir"          , {|| ZINC() } ,, 3 ) 
  oBrowse:AddButton( "Alterar"          , {|| ZALT() } ,, 4 ) 
  oBrowse:AddButton( "Excluir"          , {|| ZEXC() } ,, 5 ) 
  //oBrowse:AddButton( "Importar Placas"  , {|| MINHAFUNCAO() } ,, 6 ) 

  oBrowse:AddLegend( " ZC1_PEDIDO == '      ' "  , "GREEN"      ,  "Sem Pedido Gerado" )
  oBrowse:AddLegend( " ZC1_PEDIDO <> ' ' "       , "BLUE"       ,  "Pedido Gerado" )        
     
  oBrowse:Activate() //Ativa

Return Nil


/* -------------------------- TELAS PRINCIPAIS DA ROTINA -------------------------- */

Static Function ZINC()
    

    Local cFunc := "ZINC"
    Local aCoors as array
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oBtn1 as object

    Local cFilialFtr    := ALLTRIM(SM0->M0_CODFIL)
    Local cSerie        := Space(3)    
    Local cDoc          := Space(9)
    Local cFornecedor   := Space(6)
    Local cLoja         := Space(2)
    Local cProduto      := Space(6)
    Local cDescProd     := Space(40)
    Local cCondpg       := Space(3)
    Local cPedido       := Space(6)
    

    Local cTotalPlaca   := 0
    Local cTotalQtd     := 0
    Local cTotalValor   := 0
        
    Private aItems 		:= {"Combustivel","Rastreador","Guincho","Outros"}   
    Private cTipoDesp   := aItems[1]

    aCoors := FWGetDialogSize()
    
    DEFINE DIALOG oDlg TITLE "Combustivel Frota Medicar - Incluir " FROM aCoors[1], aCoors[1] TO aCoors[3], aCoors[4] PIXEL
        
        aGrade := {}
        //ExistCpo("SC2")

        @ 010,010 TO 070,500 LABEL " Dados Cadastrais " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Filial: "              SIZE 070, 020 OF oDlg PIXEL
        @ 022, 040 MSGET oGrupo VAR  cFilialFtr                     SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 100 SAY oTitParametro PROMPT "Serie: "               SIZE 070, 020 OF oDlg PIXEL
        @ 022, 117 MSGET oGrupo VAR  cSerie                         SIZE 030, 011 PIXEL OF oDlg WHEN .T. Picture "@!"

        @ 025, 177 SAY oTitParametro PROMPT " Numero NF: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 210 MSGET oGrupo VAR  cDoc                           SIZE 060, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
        
        @ 025, 300 SAY oTitParametro PROMPT "Fornecedor: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 333 MSGET oGrupo VAR  cFornecedor                    SIZE 050, 011 PIXEL OF oDlg F3 "SA2" WHEN .T. Picture "@!"
                
        @ 025, 415 SAY oTitParametro PROMPT "Loja: "                SIZE 070, 020 OF oDlg PIXEL
        @ 022, 430 MSGET oGrupo VAR  cLoja                          SIZE 020, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 050, 017 SAY oTitParametro PROMPT "Produto: "             SIZE 070, 020 OF oDlg PIXEL
        @ 047, 040 MSGET oGrupo VAR  cProduto                       SIZE 040, 011 PIXEL OF oDlg F3 "SB1MED" WHEN .T. Picture "@!"
        
        @ 050, 090 SAY oTitParametro PROMPT "Descricao: "           SIZE 070, 020 OF oDlg PIXEL
        @ 047, 117 MSGET oGrupo VAR  cDescProd                      SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 050, 230 SAY oTitParametro PROMPT "Tipo Despesa: "        SIZE 070, 020 OF oDlg PIXEL
        oCombo := TComboBox():New(047,270,,aItems,060,015,oDlg,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cTipoDesp,cTipoDesp:=u)}

        @ 050, 340 SAY oTitParametro PROMPT "Cond. Pg.: "            SIZE 070, 020 OF oDlg PIXEL
        @ 047, 370 MSGET oGrupo VAR  cCondpg                         SIZE 020, 011 PIXEL OF oDlg F3 "SE4" WHEN .T. Picture "@!"

        @ 050, 410 SAY oTitParametro PROMPT "Pedido: "              SIZE 070, 020 OF oDlg PIXEL
        @ 047, 430 MSGET oGrupo VAR  cPedido                        SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        aAdd(aGrade, { .T.,'','','','',0,0,0,'','','','','' }) // DADOS DA GRADE

        oBrowse := TCBrowse():New( aCoors[1] + (aCoors[3]/6.5), aCoors[1], (aCoors[4] - (aCoors[4]/2)), (aCoors[3]/2.9),, {'','Filial','Serie','Documento','Placa','Valor Unitario','Quantidade','Valor','Centro Custo','Classe Valor','Insumo','Condutor','Posto'},{20,50,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGrade)
        oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12],aGrade[oBrowse:nAt,13] }} //EXIBICAO DA GRADE


        @ 075,010 TO 135,150 LABEL " Totais " OF oDlg PIXEL

        @ 090, 025 SAY oTitParametro PROMPT "Total Placas: "        SIZE 070, 020 OF oDlg PIXEL
        @ 087, 060 MSGET oGrupo VAR  cTotalPlaca                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 105, 025 SAY oTitParametro PROMPT "Qtd Total: "           SIZE 070, 020 OF oDlg PIXEL
        @ 102, 060 MSGET oGrupo VAR  Str(cTotalQtd,10,2)            SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 120, 025 SAY oTitParametro PROMPT "Valor Total: "         SIZE 070, 020 OF oDlg PIXEL
        @ 117, 060 MSGET oGrupo VAR  Str(cTotalValor,10,2)          SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        cCssBtn := "QPushButton { font-family: Arial, Helvetica, sans-serif;"+;
                        " font-size: 10px;" +;
                        " font-weight: bold;" +;
                         "color: white;"+;
                        " background-color: #42568E; }" 

        TButton():New(aCoors[1]+15,(aCoors[3]/1.03) , "Salvar"              , oDlg, {|| fBtnSalvar(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cProduto,cTipoDesp,cCondpg)}, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+40,(aCoors[3]/1.03) , "Importar Placas"     , oDlg, {|| fBtnImpArq(cFunc)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:=TButton():New(aCoors[1]+65,(aCoors[3]/1.03) , "Gerar Pedido"        , oDlg, {|| fBtnPed(cFunc)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:SetCSS( cCssBtn )
        TButton():New(aCoors[1]+90,(aCoors[3]/1.03) , "Cancelar"            , oDlg, {|| oDlg:End()}, 50,018, ,,,.T.,,,,,,)

    ACTIVATE DIALOG oDlg CENTERED
    

Return


Static Function ZALT()

    
    Local cFunc := "ZALT"
    Local aCoors as array
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oBtn1 as object
    Local cFiltro

    Local cFilialFtr    :=  ZC1->ZC1_FILIAL
    Local cSerie        :=  ZC1->ZC1_SERIE
    Local cDoc          :=  ZC1->ZC1_DOC
    Local cFornecedor   :=  ZC1->ZC1_FORNEC
    Local cLoja         :=  ZC1->ZC1_LOJA
    Local cProduto      :=  ZC1->ZC1_CODPRD
    Local cDescProd     :=  Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_DESC')
    Local cCondpg       :=  ZC1->ZC1_COND
    Local cPedido       :=  ZC1->ZC1_PEDIDO

    Local cTotalPlaca   := 0
    Local cTotalQtd     := 0
    Local cTotalValor   := 0

    Private aItems 		:= {"Combustivel","Rastreador","Guincho","Outros"}   
    Private cTipoDesp   := aItems[1]


    If ZC1->ZC1_TIPODP = "Combustivel"
        cTipoDesp := aItems[1]
    Elseif ZC1->ZC1_TIPODP = "Rastreador"
        cTipoDesp := aItems[2]
    Elseif ZC1->ZC1_TIPODP = "Guincho"
        cTipoDesp := aItems[3]
    Else
        cTipoDesp := aItems[4]
    EndIF
    
    aCoors := FWGetDialogSize()

    DbSelectArea('SC7')
    SC7->(DbSetOrder(3))

    If !SC7->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA+ZC1->ZC1_PEDIDO))

        cPedido := ""

    EndIF

    SC7->(DbCloseArea())


    DEFINE DIALOG oDlg TITLE "Combustivel Frota Medicar - Alterar " FROM aCoors[1], aCoors[1] TO aCoors[3], aCoors[4] PIXEL
        
        aGrade := {}
        //ExistCpo("SC2")

        @ 010,010 TO 070,500 LABEL " Dados Cadastrais " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Filial: "              SIZE 070, 020 OF oDlg PIXEL
        @ 022, 040 MSGET oGrupo VAR  cFilialFtr                     SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 100 SAY oTitParametro PROMPT "Serie: "               SIZE 070, 020 OF oDlg PIXEL
        @ 022, 117 MSGET oGrupo VAR  cSerie                         SIZE 030, 011 PIXEL OF oDlg WHEN .T. Picture "@!"

        @ 025, 177 SAY oTitParametro PROMPT " Numero NF: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 210 MSGET oGrupo VAR  cDoc                           SIZE 060, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
        
        @ 025, 300 SAY oTitParametro PROMPT "Fornecedor: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 333 MSGET oGrupo VAR  cFornecedor                    SIZE 050, 011 PIXEL OF oDlg F3 "SA2" WHEN .T. Picture "@!"
                
        @ 025, 415 SAY oTitParametro PROMPT "Loja: "                SIZE 070, 020 OF oDlg PIXEL
        @ 022, 430 MSGET oGrupo VAR  cLoja                          SIZE 020, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 050, 017 SAY oTitParametro PROMPT "Produto: "             SIZE 070, 020 OF oDlg PIXEL
        @ 047, 040 MSGET oGrupo VAR  cProduto                       SIZE 040, 011 PIXEL OF oDlg F3 "SB1MED" WHEN .T. Picture "@!"
        
        @ 050, 090 SAY oTitParametro PROMPT "Descricao: "           SIZE 070, 020 OF oDlg PIXEL
        @ 047, 117 MSGET oGrupo VAR  cDescProd                      SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 050, 230 SAY oTitParametro PROMPT "Tipo Despesa: "        SIZE 070, 020 OF oDlg PIXEL
        oCombo := TComboBox():New(047,270,,aItems,060,015,oDlg,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cTipoDesp,cTipoDesp:=u)}

        @ 050, 340 SAY oTitParametro PROMPT "Cond. Pg.: "            SIZE 070, 020 OF oDlg PIXEL
        @ 047, 370 MSGET oGrupo VAR  cCondpg                         SIZE 020, 011 PIXEL OF oDlg F3 "SE4" WHEN .T. Picture "@!"

        @ 050, 410 SAY oTitParametro PROMPT "Pedido: "              SIZE 070, 020 OF oDlg PIXEL
        @ 047, 430 MSGET oGrupo VAR  cPedido                        SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        DbSelectArea("ZC2")
        ZC2->(DbSetOrder(1))

        //Monta o filtro que será usado, aplica e conta quantos registros ficaram
        cFiltro := "ZC2->ZC2_FILIAL = '"+cFilialFtr+"' .And. ZC2->ZC2_SERIE = '"+cSerie+"' .And. ZC2->ZC2_DOC = '"+cDoc+"' .And. ZC2->ZC2_FORNEC = '"+cFornecedor+"' .And. ZC2->ZC2_LOJA = '"+cLoja+"' " 
        ZC2->(DbSetFilter({|| &(cFiltro)}, cFiltro))

        ZC2->(DbGoTop())

        IF  ZC2->(Eof())
            aAdd(aGrade, { .T.,'','','','',0,0,0,'','','','','' }) // DADOS DA GRADE
        EndIF

        While ZC2->(!Eof())

            aAdd(aGrade, { .T.,ZC2->ZC2_FILIAL,ZC2->ZC2_SERIE,ZC2->ZC2_DOC,ZC2->ZC2_PLACA,ZC2->ZC2_VLRUNI,ZC2->ZC2_QUANT,ZC2->ZC2_VALOR,ZC2->ZC2_CC,ZC2->ZC2_CLVL,ZC2->ZC2_INSUMO,ZC2->ZC2_CONDUT,ZC2->ZC2_POSTO }) // DADOS DA GRADE
            
            cTotalPlaca := cTotalPlaca + 1
            cTotalQtd   := cTotalQtd + ZC2->ZC2_QUANT
            cTotalValor := cTotalValor + ZC2->ZC2_VALOR

            ZC2->(dBskip())

        EndDo
        

        oBrowse := TCBrowse():New( aCoors[1] + (aCoors[3]/6.5), aCoors[1], (aCoors[4] - (aCoors[4]/2)), (aCoors[3]/2.9),, {'','Filial','Serie','Documento','Placa','Valor Unitario','Quantidade','Valor','Centro Custo','Classe Valor','Insumo','Condutor','Posto'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGrade)
        oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12],aGrade[oBrowse:nAt,13] }} //EXIBICAO DA GRADE


        @ 075,010 TO 135,150 LABEL " Totais " OF oDlg PIXEL

        @ 090, 025 SAY oTitParametro PROMPT "Total Placas: "        SIZE 070, 020 OF oDlg PIXEL
        @ 087, 060 MSGET oGrupo VAR  cTotalPlaca                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 105, 025 SAY oTitParametro PROMPT "Qtd Total: "           SIZE 070, 020 OF oDlg PIXEL
        @ 102, 060 MSGET oGrupo VAR  cTotalQtd                      SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        
        @ 120, 025 SAY oTitParametro PROMPT "Valor Total: "         SIZE 070, 020 OF oDlg PIXEL
        @ 117, 060 MSGET oGrupo VAR  cTotalValor                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"


        cCssBtn := "QPushButton { font-family: Arial, Helvetica, sans-serif;"+;
                        " font-size: 10px;" +;
                        " font-weight: bold;" +;
                         "color: white;"+;
                        " background-color: #42568E; }" 

        TButton():New(aCoors[1]+15,(aCoors[3]/1.03) , "Salvar"              , oDlg, {|| fBtnSalvar(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cProduto,cTipoDesp,cCondpg)}, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+40,(aCoors[3]/1.03) , "Importar Placas"     , oDlg, {|| fBtnImpArq(cFunc)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:=TButton():New(aCoors[1]+65,(aCoors[3]/1.03) , "Gerar Pedido"        , oDlg, {|| fBtnPed(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cTotalPlaca,cTotalQtd,cTotalValor,cProduto,cCondpg)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:SetCSS( cCssBtn )
        TButton():New(aCoors[1]+90,(aCoors[3]/1.03) , "Cancelar"            , oDlg, {|| oDlg:End()}, 50,018, ,,,.T.,,,,,,)

    ACTIVATE DIALOG oDlg CENTERED
    
    ZC2->(DbCloseArea())

Return


Static Function ZVIS()
    
    Local aArea := GetArea()
    Local cFunc := "ZVIS"
    Local aCoors as array
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oBtn1 as object

    Local cFilialFtr    :=  ZC1->ZC1_FILIAL
    Local cSerie        :=  ZC1->ZC1_SERIE
    Local cDoc          :=  ZC1->ZC1_DOC
    Local cFornecedor   :=  ZC1->ZC1_FORNEC
    Local cLoja         :=  ZC1->ZC1_LOJA
    Local cProduto      :=  ZC1->ZC1_CODPRD
    Local cDescProd     :=  Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_DESC')
    Local cCondpg       :=  ZC1->ZC1_COND
    Local cPedido       :=  ZC1->ZC1_PEDIDO

    Local cTotalPlaca   := 0
    Local cTotalQtd     := 0
    Local cTotalValor   := 0

    Private aItems 		:= {"Combustivel","Rastreador","Guincho","Outros"}   
    Private cTipoDesp   := aItems[1]
    

    aCoors := FWGetDialogSize()

    If ZC1->ZC1_TIPODP = "Combustivel"
        cTipoDesp := aItems[1]
    Elseif ZC1->ZC1_TIPODP = "Rastreador"
        cTipoDesp := aItems[2]
    Elseif ZC1->ZC1_TIPODP = "Guincho"
        cTipoDesp := aItems[3]
    Else
        cTipoDesp := aItems[4]
    EndIF
    
    DbSelectArea('SC7')
    SC7->(DbSetOrder(3))

    If !SC7->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA+ZC1->ZC1_PEDIDO))

        cPedido := ""
        
    EndIF

    SC7->(DbCloseArea())

    DEFINE DIALOG oDlg TITLE "Combustivel Frota Medicar - Visualizar " FROM aCoors[1], aCoors[1] TO aCoors[3], aCoors[4] PIXEL
        
        aGrade := {}
        //ExistCpo("SC2")

        @ 010,010 TO 070,500 LABEL " Dados Cadastrais " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Filial: "              SIZE 070, 020 OF oDlg PIXEL
        @ 022, 040 MSGET oGrupo VAR  cFilialFtr                     SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 100 SAY oTitParametro PROMPT "Serie: "               SIZE 070, 020 OF oDlg PIXEL
        @ 022, 117 MSGET oGrupo VAR  cSerie                         SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 177 SAY oTitParametro PROMPT " Numero NF: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 210 MSGET oGrupo VAR  cDoc                           SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 025, 300 SAY oTitParametro PROMPT "Fornecedor: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 333 MSGET oGrupo VAR  cFornecedor                    SIZE 050, 011 PIXEL OF oDlg F3 "SA2" WHEN .F. Picture "@!"
                
        @ 025, 415 SAY oTitParametro PROMPT "Loja: "                SIZE 070, 020 OF oDlg PIXEL
        @ 022, 430 MSGET oGrupo VAR  cLoja                          SIZE 020, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 050, 017 SAY oTitParametro PROMPT "Produto: "             SIZE 070, 020 OF oDlg PIXEL
        @ 047, 040 MSGET oGrupo VAR  cProduto                       SIZE 040, 011 PIXEL OF oDlg F3 "SB1MED" WHEN .F. Picture "@!"

        @ 050, 090 SAY oTitParametro PROMPT "Descricao: "           SIZE 070, 020 OF oDlg PIXEL
        @ 047, 117 MSGET oGrupo VAR  cDescProd                      SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 050, 230 SAY oTitParametro PROMPT "Tipo Despesa: "        SIZE 070, 020 OF oDlg PIXEL
        oCombo := TComboBox():New(047,270,,aItems,060,015,oDlg,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cTipoDesp,cTipoDesp:=u)}

        @ 050, 340 SAY oTitParametro PROMPT "Cond. Pg.: "            SIZE 070, 020 OF oDlg PIXEL
        @ 047, 370 MSGET oGrupo VAR  cCondpg                         SIZE 020, 011 PIXEL OF oDlg F3 "SE4" WHEN .F. Picture "@!"

        @ 050, 410 SAY oTitParametro PROMPT "Pedido: "              SIZE 070, 020 OF oDlg PIXEL
        @ 047, 430 MSGET oGrupo VAR  cPedido                        SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        
        DbSelectArea("ZC2")
        ZC2->(DbSetOrder(1))

        //Monta o filtro que será usado, aplica e conta quantos registros ficaram
        cFiltro := "ZC2->ZC2_FILIAL = '"+cFilialFtr+"' .And. ZC2->ZC2_SERIE = '"+cSerie+"' .And. ZC2->ZC2_DOC = '"+cDoc+"' .And. ZC2->ZC2_FORNEC = '"+cFornecedor+"' .And. ZC2->ZC2_LOJA = '"+cLoja+"' " 
        ZC2->(DbSetFilter({|| &(cFiltro)}, cFiltro))

        ZC2->(DbGoTop())

        IF  ZC2->(Eof())
            aAdd(aGrade, { .T.,'','','','',0,0,0,'','','','','' }) // DADOS DA GRADE
        EndIF

        While ZC2->(!Eof())

            aAdd(aGrade, { .T.,ZC2->ZC2_FILIAL,ZC2->ZC2_SERIE,ZC2->ZC2_DOC,ZC2->ZC2_PLACA,ZC2->ZC2_VLRUNI,ZC2->ZC2_QUANT,ZC2->ZC2_VALOR,ZC2->ZC2_CC,ZC2->ZC2_CLVL,ZC2->ZC2_INSUMO,ZC2->ZC2_CONDUT,ZC2->ZC2_POSTO }) // DADOS DA GRADE
            
            cTotalPlaca := cTotalPlaca + 1
            cTotalQtd   := cTotalQtd + ZC2->ZC2_QUANT
            cTotalValor := cTotalValor + ZC2->ZC2_VALOR

            ZC2->(dBskip())

        EndDo

        oBrowse := TCBrowse():New( aCoors[1] + (aCoors[3]/6.5), aCoors[1], (aCoors[4] - (aCoors[4]/2)), (aCoors[3]/2.9),, {'','Filial','Serie','Documento','Placa','Valor Unitario','Quantidade','Valor','Centro Custo','Classe Valor','Insumo','Condutor','Posto'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGrade)
        oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12],aGrade[oBrowse:nAt,13] }} //EXIBICAO DA GRADE


        @ 075,010 TO 135,150 LABEL " Totais " OF oDlg PIXEL

        @ 090, 025 SAY oTitParametro PROMPT "Total Placas: "        SIZE 070, 020 OF oDlg PIXEL
        @ 087, 060 MSGET oGrupo VAR  cTotalPlaca                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 105, 025 SAY oTitParametro PROMPT "Qtd Total: "           SIZE 070, 020 OF oDlg PIXEL
        @ 102, 060 MSGET oGrupo VAR  cTotalQtd                      SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        
        @ 120, 025 SAY oTitParametro PROMPT "Valor Total: "         SIZE 070, 020 OF oDlg PIXEL
        @ 117, 060 MSGET oGrupo VAR  cTotalValor                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"


        cCssBtn := "QPushButton { font-family: Arial, Helvetica, sans-serif;"+;
                        " font-size: 10px;" +;
                        " font-weight: bold;" +;
                         "color: white;"+;
                        " background-color: #42568E; }" 


        TButton():New(aCoors[1]+15,(aCoors[3]/1.03) , "Salvar"              , oDlg, {|| fBtnSalvar(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cProduto,cTipoDesp,cCondpg)}, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+40,(aCoors[3]/1.03) , "Importar Placas"     , oDlg, {|| fBtnImpArq(cFunc)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:=TButton():New(aCoors[1]+65,(aCoors[3]/1.03) , "Gerar Pedido"        , oDlg, {|| fBtnPed(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cTotalPlaca,cTotalQtd,cTotalValor,cProduto,cCondpg)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:SetCSS( cCssBtn )
        TButton():New(aCoors[1]+90,(aCoors[3]/1.03) , "Cancelar"            , oDlg, {|| oDlg:End()}, 50,018, ,,,.T.,,,,,,)

    ACTIVATE DIALOG oDlg CENTERED
    

    ZC2->(DbCloseArea())
    RestArea(aArea)


Return


Static Function ZEXC()
    
    Local cFunc := "ZEXC"
    Local aCoors as array
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oBtn1 as object

    Local cFilialFtr    :=  ZC1->ZC1_FILIAL
    Local cSerie        :=  ZC1->ZC1_SERIE
    Local cDoc          :=  ZC1->ZC1_DOC
    Local cFornecedor   :=  ZC1->ZC1_FORNEC
    Local cLoja         :=  ZC1->ZC1_LOJA
    Local cProduto      :=  ZC1->ZC1_CODPRD
    Local cDescProd     :=  Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_DESC')
    Local cCondpg       :=  ZC1->ZC1_COND
    Local cPedido       :=  ZC1->ZC1_PEDIDO

    Local cTotalPlaca   := 0
    Local cTotalQtd     := 0
    Local cTotalValor   := 0

    Private aItems 		:= {"Combustivel","Rastreador","Guincho","Outros"}   
    Private cTipoDesp   := aItems[1]

    aCoors := FWGetDialogSize()

    If ZC1->ZC1_TIPODP = "Combustivel"
        cTipoDesp := aItems[1]
    Elseif ZC1->ZC1_TIPODP = "Rastreador"
        cTipoDesp := aItems[2]
    Elseif ZC1->ZC1_TIPODP = "Guincho"
        cTipoDesp := aItems[3]
    Else
        cTipoDesp := aItems[4]
    EndIF
    
    DbSelectArea('SC7')
    SC7->(DbSetOrder(3))

    If !SC7->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA+ZC1->ZC1_PEDIDO))

        cPedido := ""
        
    EndIF

    SC7->(DbCloseArea())

    DEFINE DIALOG oDlg TITLE "Combustivel Frota Medicar - Excluir " FROM aCoors[1], aCoors[1] TO aCoors[3], aCoors[4] PIXEL
        
        aGrade := {}
        //ExistCpo("SC2")

        @ 010,010 TO 070,500 LABEL " Dados Cadastrais " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Filial: "              SIZE 070, 020 OF oDlg PIXEL
        @ 022, 040 MSGET oGrupo VAR  cFilialFtr                     SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 100 SAY oTitParametro PROMPT "Serie: "               SIZE 070, 020 OF oDlg PIXEL
        @ 022, 117 MSGET oGrupo VAR  cSerie                         SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 177 SAY oTitParametro PROMPT " Numero NF: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 210 MSGET oGrupo VAR  cDoc                           SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 025, 300 SAY oTitParametro PROMPT "Fornecedor: "          SIZE 070, 020 OF oDlg PIXEL
        @ 022, 333 MSGET oGrupo VAR  cFornecedor                    SIZE 050, 011 PIXEL OF oDlg F3 "SA2" WHEN .F. Picture "@!"
                
        @ 025, 415 SAY oTitParametro PROMPT "Loja: "                SIZE 070, 020 OF oDlg PIXEL
        @ 022, 430 MSGET oGrupo VAR  cLoja                          SIZE 020, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 050, 017 SAY oTitParametro PROMPT "Produto: "             SIZE 070, 020 OF oDlg PIXEL
        @ 047, 040 MSGET oGrupo VAR  cProduto                       SIZE 040, 011 PIXEL OF oDlg F3 "SB1MED" WHEN .F. Picture "@!"

        @ 050, 090 SAY oTitParametro PROMPT "Descricao: "           SIZE 070, 020 OF oDlg PIXEL
        @ 047, 117 MSGET oGrupo VAR  cDescProd                      SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 050, 230 SAY oTitParametro PROMPT "Tipo Despesa: "        SIZE 070, 020 OF oDlg PIXEL
        oCombo := TComboBox():New(047,270,,aItems,060,015,oDlg,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cTipoDesp,cTipoDesp:=u)}
     
       @ 050, 340 SAY oTitParametro PROMPT "Cond. Pg.: "            SIZE 070, 020 OF oDlg PIXEL
        @ 047, 370 MSGET oGrupo VAR  cCondpg                         SIZE 020, 011 PIXEL OF oDlg F3 "SE4" WHEN .F. Picture "@!"

        @ 050, 410 SAY oTitParametro PROMPT "Pedido: "              SIZE 070, 020 OF oDlg PIXEL
        @ 047, 430 MSGET oGrupo VAR  cPedido                        SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        DbSelectArea("ZC2")
        ZC2->(DbSetOrder(1))

        //Monta o filtro que será usado, aplica e conta quantos registros ficaram
        cFiltro := "ZC2->ZC2_FILIAL = '"+cFilialFtr+"' .And. ZC2->ZC2_SERIE = '"+cSerie+"' .And. ZC2->ZC2_DOC = '"+cDoc+"' .And. ZC2->ZC2_FORNEC = '"+cFornecedor+"' .And. ZC2->ZC2_LOJA = '"+cLoja+"' " 
        ZC2->(DbSetFilter({|| &(cFiltro)}, cFiltro))

        ZC2->(DbGoTop())

        IF  ZC2->(Eof())
            aAdd(aGrade, { .T.,'','','','',0,0,0,'','','','','' }) // DADOS DA GRADE
        EndIF

        While ZC2->(!Eof())

            aAdd(aGrade, { .T.,ZC2->ZC2_FILIAL,ZC2->ZC2_SERIE,ZC2->ZC2_DOC,ZC2->ZC2_PLACA,ZC2->ZC2_VLRUNI,ZC2->ZC2_QUANT,ZC2->ZC2_VALOR,ZC2->ZC2_CC,ZC2->ZC2_CLVL,ZC2->ZC2_INSUMO,ZC2->ZC2_CONDUT,ZC2->ZC2_POSTO }) // DADOS DA GRADE
            
            cTotalPlaca := cTotalPlaca + 1
            cTotalQtd   := cTotalQtd + ZC2->ZC2_QUANT
            cTotalValor := cTotalValor + ZC2->ZC2_VALOR

            ZC2->(dBskip())

        EndDo


        oBrowse := TCBrowse():New( aCoors[1] + (aCoors[3]/6.5), aCoors[1], (aCoors[4] - (aCoors[4]/2)), (aCoors[3]/2.9),, {'','Filial','Serie','Documento','Placa','Valor Unitario','Quantidade','Valor','Centro Custo','Classe Valor','Insumo','Condutor','Posto'},{20,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGrade)
        oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12],aGrade[oBrowse:nAt,13] }} //EXIBICAO DA GRADE


        @ 075,010 TO 135,150 LABEL " Totais " OF oDlg PIXEL

        @ 090, 025 SAY oTitParametro PROMPT "Total Placas: "        SIZE 070, 020 OF oDlg PIXEL
        @ 087, 060 MSGET oGrupo VAR  cTotalPlaca                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 105, 025 SAY oTitParametro PROMPT "Qtd Total: "           SIZE 070, 020 OF oDlg PIXEL
        @ 102, 060 MSGET oGrupo VAR  cTotalQtd                      SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        
        @ 120, 025 SAY oTitParametro PROMPT "Valor Total: "         SIZE 070, 020 OF oDlg PIXEL
        @ 117, 060 MSGET oGrupo VAR  cTotalValor                    SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"


        cCssBtn := "QPushButton { font-family: Arial, Helvetica, sans-serif;"+;
                        " font-size: 10px;" +;
                        " font-weight: bold;" +;
                         "color: white;"+;
                        " background-color: #42568E; }" 


        TButton():New(aCoors[1]+15,(aCoors[3]/1.03) , "Salvar"              , oDlg, {|| fBtnSalvar(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cProduto,cTipoDesp,cCondpg)}, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+40,(aCoors[3]/1.03) , "Importar Placas"     , oDlg, {|| fBtnImpArq(cFunc)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:=TButton():New(aCoors[1]+65,(aCoors[3]/1.03) , "Gerar Pedido"        , oDlg, {|| fBtnPed(cFunc)}, 50,018, ,,,.T.,,,,,,)
        oBtn1:SetCSS( cCssBtn )
        TButton():New(aCoors[1]+90,(aCoors[3]/1.03) , "Cancelar"            , oDlg, {|| oDlg:End()}, 50,018, ,,,.T.,,,,,,)

    ACTIVATE DIALOG oDlg CENTERED
    

    ZC2->(DbCloseArea())

Return


/* -------------------------- FUNCOES DOS BOTOES DA ROTINA -------------------------- */

Static Function fBtnSalvar(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cProduto,cTipoDesp,cCondpg)

    Local cQueryZC1
    Local cQueryZC2


    IF cFunc = "ZINC"

        If ALLTRIM(cDoc) = ""

            MsgInfo("Campo em branco: Numero NF.", "Despesas Frota Medicar")

        Elseif ALLTRIM(cFornecedor) = ""
            
            MsgInfo("Campo em branco: Fornecedor.", "Despesas Frota Medicar")

        Else

            If MsgYesNo("Confirma Inclusao do cadastro?")

                RecLock("ZC1", .T.)
                    ZC1->ZC1_FILIAL  := ALLTRIM(cFilialFtr)
                    ZC1->ZC1_SERIE   := ALLTRIM(cSerie)
                    ZC1->ZC1_DOC     := ALLTRIM(cDoc)
                    ZC1->ZC1_FORNEC  := ALLTRIM(cFornecedor)
                    ZC1->ZC1_LOJA    := ALLTRIM(cLoja)
                    ZC1->ZC1_CODPRD  := ALLTRIM(cProduto)
                    ZC1->ZC1_TIPODP  := ALLTRIM(cTipoDesp)
                    ZC1->ZC1_COND    := ALLTRIM(cCondpg)
    

                ZC1->(MsUnlock())
                //ConfirmSX8()      

                MsgInfo("Cadastro realizado com Suceddo.", "Despesas Frota Medicar")
                oDlg:End()

            Else
                MsgAlert("Cancelado pelo usuario.")  
                oDlg:End()
            EndIF

        EndIF


    ELSEIF cFunc = "ZALT"
 
        DbSelectArea('SC7')
        SC7->(DbSetOrder(3))

        If !SC7->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA+ZC1->ZC1_PEDIDO))

            RecLock("ZC1", .F.)
                ZC1->ZC1_PEDIDO := ""
            ZC1->(MsUnlock())

        EndIF

        SC7->(DbCloseArea())


        IF !Empty(ZC1->ZC1_PEDIDO)

            MsgInfo("Cadastro com Pedido gerado, Nao e permitido Alterar." +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Pedido:" + ZC1->ZC1_PEDIDO)  
            oDlg:End()

        ELSE

            If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))

                MsgInfo("Nao é possivel alterar pois existe placa vinculada.", "Despesas Frota Medicar")

            Else

                If ALLTRIM(cDoc) = ""

                    MsgInfo("Campo em branco: Numero NF.", "Despesas Frota Medicar")

                Elseif ALLTRIM(cFornecedor) = ""
                    
                    MsgInfo("Campo em branco: Fornecedor.", "Despesas Frota Medicar")

                Else

                    If MsgYesNo("Confirma Alteracao do cadastro?")

                        RecLock("ZC1", .F.)
                            ZC1->ZC1_FILIAL := ALLTRIM(cFilialFtr)
                            ZC1->ZC1_SERIE  := ALLTRIM(cSerie)
                            ZC1->ZC1_DOC    := ALLTRIM(cDoc)
                            ZC1->ZC1_FORNEC := ALLTRIM(cFornecedor)
                            ZC1->ZC1_LOJA   := ALLTRIM(cLoja)
                            ZC1->ZC1_CODPRD := ALLTRIM(cProduto)
                            ZC1->ZC1_TIPODP := ALLTRIM(cTipoDesp)
                            ZC1->ZC1_COND   := ALLTRIM(cCondPg)

                        ZC1->(MsUnlock())
                        //ConfirmSX8()      

                        MsgInfo("Cadastro alterado com Suceddo.", "Despesas Frota Medicar")
                        oDlg:End()

                    Else
                        MsgAlert("Cancelado pelo usuario.")  
                        oDlg:End()
                    EndIF

                EndIF

            EndIF

        EndIF
        
    ELSEIF cFunc = 'ZVIS'

        DbSelectArea('SC7')
        SC7->(DbSetOrder(3))

        If !SC7->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA+ZC1->ZC1_PEDIDO))

            RecLock("ZC1", .F.)
                ZC1->ZC1_PEDIDO := ""
            ZC1->(MsUnlock())

        EndIF

        SC7->(DbCloseArea())
    
        oDlg:End()
    
    ELSEIF cFunc = 'ZEXC'

        DbSelectArea('SC7')
        SC7->(DbSetOrder(3))

        If !SC7->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA+ZC1->ZC1_PEDIDO))

            RecLock("ZC1", .F.)
                ZC1->ZC1_PEDIDO := ""
            ZC1->(MsUnlock())

        EndIF

        SC7->(DbCloseArea())


        IF !Empty(ZC1->ZC1_PEDIDO)

            MsgInfo("Cadastro com Pedido gerado, Nao e permitido excluir." +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Pedido:" + ZC1->ZC1_PEDIDO)  
            oDlg:End()

        ELSE

            If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))

                If MsgYesNo("Cadastro com placas Vinculadas confirma a exclusao?")
                    
                    Begin Transaction

                        cQueryZC1 := " UPDATE ZC1010 SET ZC1010.D_E_L_E_T_ = '*' "
                        cQueryZC1 += " FROM ZC1010 "
                        cQueryZC1 += " WHERE 1=1 "
                        cQueryZC1 += " AND ZC1010.D_E_L_E_T_ = '' "
                        cQueryZC1 += " AND ZC1010.ZC1_FILIAL = '"+ZC1->ZC1_FILIAL+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_SERIE  = '"+ZC1->ZC1_SERIE+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_DOC    = '"+ZC1->ZC1_DOC+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_FORNEC = '"+ZC1->ZC1_FORNEC+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_LOJA   = '"+ZC1->ZC1_LOJA+"' "

                        //Tenta executar o update
                        nErro := TcSqlExec(cQueryZC1)

                        //Se houve erro, mostra a mensagem e cancela a transacao
                        If nErro != 0
                            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                            //ABORTA O UPDATE
                            DisarmTransaction()
                        EndIf

                    End Transaction

                    Begin Transaction

                        cQueryZC2 := " UPDATE ZC2010 SET ZC2010.D_E_L_E_T_ = '*' "
                        cQueryZC2 += " FROM ZC2010 "
                        cQueryZC2 += " WHERE 1=1 "
                        cQueryZC2 += " AND ZC2010.D_E_L_E_T_ = '' "
                        cQueryZC2 += " AND ZC2010.ZC2_FILIAL = '"+ZC1->ZC1_FILIAL+"' "
                        cQueryZC2 += " AND ZC2010.ZC2_SERIE  = '"+ZC1->ZC1_SERIE+"' "
                        cQueryZC2 += " AND ZC2010.ZC2_DOC    = '"+ZC1->ZC1_DOC+"' "
                        cQueryZC2 += " AND ZC2010.ZC2_FORNEC = '"+ZC1->ZC1_FORNEC+"' "
                        cQueryZC2 += " AND ZC2010.ZC2_LOJA   = '"+ZC1->ZC1_LOJA+"' "

                        //Tenta executar o update
                        nErro := TcSqlExec(cQueryZC2)

                        //Se houve erro, mostra a mensagem e cancela a transacao
                        If nErro != 0
                            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                            //ABORTA O UPDATE
                            DisarmTransaction()
                        EndIf

                    End Transaction

                    MsgInfo("Cadastro Deletado com Sucesso.", "Despesas Frota Medicar")
                    oDlg:End()
                Else

                    MsgAlert("Cancelado pelo usuario.")  
                    oDlg:End()

                EndIF

            Else

                If MsgYesNo("Confirma a exclusao do cadastro?")
                    
                    Begin Transaction

                        cQueryZC1 := " UPDATE ZC1010 SET ZC1010.D_E_L_E_T_ = '*' "
                        cQueryZC1 += " FROM ZC1010 "
                        cQueryZC1 += " WHERE 1=1 "
                        cQueryZC1 += " AND ZC1010.D_E_L_E_T_ = '' "
                        cQueryZC1 += " AND ZC1010.ZC1_FILIAL = '"+ZC1->ZC1_FILIAL+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_SERIE  = '"+ZC1->ZC1_SERIE+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_DOC    = '"+ZC1->ZC1_DOC+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_FORNEC = '"+ZC1->ZC1_FORNEC+"' "
                        cQueryZC1 += " AND ZC1010.ZC1_LOJA   = '"+ZC1->ZC1_LOJA+"' "

                        //Tenta executar o update
                        nErro := TcSqlExec(cQueryZC1)

                        //Se houve erro, mostra a mensagem e cancela a transacao
                        If nErro != 0
                            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                            //ABORTA O UPDATE
                            DisarmTransaction()
                        EndIf

                    End Transaction

                    MsgInfo("Cadastro Deletado com Sucesso.", "Despesas Frota Medicar")
                    oDlg:End()
                Else

                    MsgAlert("Cancelado pelo usuario.")  
                    oDlg:End()

                EndIF


            EndIF
        
        EndIF

    
    EndIF

Return


Static Function fBtnImpArq(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja)
    
    Private cArqOri := ""

    IF cFunc = "ZINC"

        MsgInfo("Liberado apenas nas funcoes 'Alterar' e 'Visualizar'.", "Despesas Frota Medicar")    

    ELSEIF cFunc = "ZALT"

        IF !Empty(ZC1->ZC1_PEDIDO)

            MsgInfo("Pedido de Comrpas já gerado nao e possivel importar placas."  +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Pedido: " + ZC1->ZC1_PEDIDO, "Despesas Frota Medicar")

        Else

            If MsgYesNo("Deseja realizar importacao das placas?")
            
                //Mostra o Prompt para selecionar arquivos
                cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )
                
                //Se tiver o arquivo de origem
                If ! Empty(cArqOri)
                    
                    //Somente se existir o arquivo e for com a extensão CSV
                    If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
                        Processa({|| fImportaPlaca(cFilialFtr,cSerie,cDoc,cFornecedor,cLoja) }, "Importando...")
                        //msginfo("Teste Importador Contrato")
                    Else
                        MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
                    EndIf
                EndIf

                MsgInfo("Placas importadas com Sucesso.", "Despesas Frota Medicar")    
                oDlg:End()

            Else

                MsgAlert("Cancelado pelo usuario.")  
                oDlg:End()

            EndIf


        EndIf        


    ELSEIF cFunc = 'ZVIS'

        IF !Empty(ZC1->ZC1_PEDIDO)

            MsgInfo("Pedido de Comrpas já gerado nao e possivel importar placas."  +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Pedido: " + ZC1->ZC1_PEDIDO, "Despesas Frota Medicar")

        Else

            If MsgYesNo("Deseja realizar importacao das placas?")


                //Mostra o Prompt para selecionar arquivos
                cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )
                
                //Se tiver o arquivo de origem
                If ! Empty(cArqOri)
                    
                    //Somente se existir o arquivo e for com a extensão CSV
                    If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
                        Processa({|| fImportaPlaca(cFilialFtr,cSerie,cDoc,cFornecedor,cLoja) }, "Importando...")
                        //msginfo("Teste Importador Contrato")
                    Else
                        MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
                    EndIf
                EndIf

                MsgInfo("Placas importadas com Sucesso.", "Despesas Frota Medicar")  
                oDlg:End()  

            Else

                MsgAlert("Cancelado pelo usuario.")  
                oDlg:End()

            EndIf


        EndIF

        

    ELSEIF cFunc = 'ZEXC'
        
        MsgInfo("Liberado apenas nas funcoes 'Alterar' e 'Visualizar'.", "Despesas Frota Medicar")    

    EndIF
       
Return


Static Function fBtnPed(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cTotalPlaca,cTotalQtd,cTotalValor,cProduto,cCondpg)

    IF cFunc = "ZINC"

        MsgInfo("Liberado apenas nas funcoes 'Alterar' e 'Visualizar'.", "Despesas Frota Medicar")    

    ELSEIF cFunc = "ZALT"

        IF !Empty(ZC1->ZC1_PEDIDO)

            MsgInfo("Pedido de Comrpas já gerado."  +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Pedido: " + ZC1->ZC1_PEDIDO, "Despesas Frota Medicar")

        Else

            if MsgYesNo("Gerar pedido de compra" +  CHR(13)+CHR(10) + "Confirma os valores abaixo?" +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Filial: " + cFilialFtr +  CHR(13)+CHR(10) +  "Total placas: " + Str(cTotalPlaca) +  CHR(13)+CHR(10) + "Total Quantidade: " + Str(cTotalQtd) +  CHR(13)+CHR(10) + "Total Valor: " + Str(cTotalValor) )
                    
                    MsAguarde({||fGeraPedido(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cTotalPlaca,cTotalQtd,cTotalValor,cProduto,cCondpg)},"Aguarde","Gerando Pedido de Compras...")
                    oDlg:End()

            Else

                    MsgAlert("Cancelado pelo usuario.")  
                    oDlg:End()

            EndIf


        EndIF


    ELSEIF cFunc = 'ZVIS'


        IF !Empty(ZC1->ZC1_PEDIDO)

            MsgInfo("Pedido de Comrpas já gerado."  +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Pedido: " + ZC1->ZC1_PEDIDO, "Despesas Frota Medicar")

        Else

            if MsgYesNo("Gerar pedido de compra" +  CHR(13)+CHR(10) + "Confirma os valores abaixo?" +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Filial: " + cFilialFtr +  CHR(13)+CHR(10) +  "Total placas: " + Str(cTotalPlaca) +  CHR(13)+CHR(10) + "Total Quantidade: " + Str(cTotalQtd) +  CHR(13)+CHR(10) + "Total Valor: " + Str(cTotalValor) )
                    
                    MsAguarde({||fGeraPedido(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cTotalPlaca,cTotalQtd,cTotalValor,cProduto,cCondpg)},"Aguarde","Gerando Pedido de Compras...")
                    oDlg:End()

            Else

                    MsgAlert("Cancelado pelo usuario.")  
                    oDlg:End()

            EndIf


        EndIF

    ELSEIF cFunc = 'ZEXC'
    
        MsgInfo("Liberado apenas nas funcoes 'Alterar' e 'Visualizar'.", "Despesas Frota Medicar")    

    EndIF
    
Return


/* -------------------------- IMPORTADOR DE PLACAS -------------------------- */
  
Static Function fImportaPlaca(cFilialFtr,cSerie,cDoc,cFornecedor,cLoja)

    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cPlaca        := ""
    Local cVlrUni       := ""
    Local cQuantidade   := ""
    Local cValor        := ""
    Local cCC           := ""
    Local cCLVL         := ""
    Local cInsumo       := ""
    Local cCondutor     := ""
    Local cPosto        := ""
    
    Private cDirLog    := GetTempPath() + "x_impcombfrt\"
    Private cLog       := ""
      
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
      
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
  
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
  
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
              
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")

                if nLinhaAtu >= 2

                    if cLinAtu = ""

                        msginfo("Linha em branco.")

                    else 

                        cPlaca      := aLinha[nPosPlaca]
                        cVlrUni     := aLinha[nPosVlrUni]
                        cQuantidade := aLinha[nPosQuantidade]
                        cValor      := aLinha[nPosValor]
                        cCC         := aLinha[nPosCC]
                        cCLVL       := aLinha[nPosCLVL]
                        cInsumo     := aLinha[nPosInsumo]
                        cCondutor   := aLinha[nPosCondutor]
                        cPosto      := aLinha[nPosPosto]

                        RecLock("ZC2", .T.)
                                ZC2->ZC2_FILIAL  := ZC1->ZC1_FILIAL
                                ZC2->ZC2_SERIE   := ZC1->ZC1_SERIE
                                ZC2->ZC2_DOC     := ZC1->ZC1_DOC
                                ZC2->ZC2_FORNEC  := ZC1->ZC1_FORNEC
                                ZC2->ZC2_LOJA    := ZC1->ZC1_LOJA
                                ZC2->ZC2_PLACA   := cPlaca
                                ZC2->ZC2_VLRUNI  := Val(cVlrUni)
                                ZC2->ZC2_QUANT   := Val(cQuantidade)
                                ZC2->ZC2_VALOR   := Val(cValor)
                                ZC2->ZC2_CC      := StrZero(val(cCC) ,5)
                                ZC2->ZC2_CLVL    := StrZero(val(cCLVL) ,6)
                                ZC2->ZC2_INSUMO  := cInsumo
                                ZC2->ZC2_CONDUT  := cCondutor
                                ZC2->ZC2_POSTO   := cPosto
                        ZC2->(MsUnlock())
                        //ConfirmSX8()
     
                    EndIf

                EndIf

            EndDo

  
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
  
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf

        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
  
    RestArea(aArea)

Return


/* -------------------------- GERAR PEDIDO DE COMPRAS -------------------------- */

Static Function fGeraPedido(cFunc,cFilialFtr,cSerie,cDoc,cFornecedor,cLoja,cTotalPlaca,cTotalQtd,cTotalValor,cProduto,cCondpg)

    Local cQueryRateio
    Local cItem := 1
    Local cNumPed := GetSXENum('SC7', 'C7_NUM')
    Private cAliasRat := GetNextAlias()

    If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))

        RecLock("SC7", .T.)
            
            SC7->C7_FILIAL  := cFilialFtr
            SC7->C7_TIPO    := 1
            SC7->C7_ITEM    := '0001'
            SC7->C7_PRODUTO := cProduto
            SC7->C7_DESCRI  := Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_DESC')
            SC7->C7_UM      := Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_UM')
            SC7->C7_QUANT   := 1
            SC7->C7_PRECO   := cTotalValor
            SC7->C7_TOTAL   := cTotalValor
            SC7->C7_COND    := cCondpg
            SC7->C7_LOCAL   := '01'
            SC7->C7_FORNECE := cFornecedor
            SC7->C7_DATPRF  := DATE()
            SC7->C7_EMISSAO := DATE()
            SC7->C7_NUM     := cNumPed
            SC7->C7_LOJA    := cLoja
            SC7->C7_FILENT  := cFilialFtr
            SC7->C7_FLUXO   := 'S'
            SC7->C7_USER    := RetCodUsr()

        SC7->(MsUnlock())
        ConfirmSX8() 


        cQueryRateio := " SELECT  "
        cQueryRateio += " A.ZC2_CC   AS CC, "
        cQueryRateio += " A.ZC2_CLVL AS CLVL, "
        cQueryRateio += " CAST( ( CAST( COUNT(*) AS NUMERIC(10,2)) * 100 ) /  ISNULL((SELECT COUNT(*) AS QTD1 FROM ZC2010 A1 WHERE 1=1 AND A1.D_E_L_E_T_ = '' AND A1.ZC2_FILIAL = A.ZC2_FILIAL AND A1.ZC2_SERIE = A.ZC2_SERIE AND A1.ZC2_DOC = A.ZC2_DOC AND A1.ZC2_FORNEC = A.ZC2_FORNEC AND A1.ZC2_LOJA = A.ZC2_LOJA ),0) AS NUMERIC(10,2)) AS PERC, "
        cQueryRateio += " SUM(A.ZC2_VALOR) AS VALOR "
        cQueryRateio += " FROM ZC2010 A "
        cQueryRateio += " WHERE 1=1 "
        cQueryRateio += " AND A.D_E_L_E_T_ = '' "
        cQueryRateio += " AND A.ZC2_FILIAL = '"+cFilialFtr+"' "
        cQueryRateio += " AND A.ZC2_SERIE = '"+cSerie+"' "
        cQueryRateio += " AND A.ZC2_DOC = '"+cDoc+"' "
        cQueryRateio += " AND A.ZC2_FORNEC = '"+cFornecedor+"' "
        cQueryRateio += " AND A.ZC2_LOJA = '"+cLoja+"' "
        cQueryRateio += " GROUP BY A.ZC2_CC, A.ZC2_CLVL, A.ZC2_FILIAL, A.ZC2_SERIE, A.ZC2_DOC,A.ZC2_FORNEC, A.ZC2_LOJA "
        
        //Criar alias temporário
        TCQUERY cQueryRateio NEW ALIAS (cAliasRat)
        DbSelectArea(cAliasRat)

        (cAliasRat)->(DbGoTop())

        While ! (cAliasRat)->(EoF())

            RecLock("SCH", .T.)
                
                SCH->CH_FILIAL  := cFilialFtr
                SCH->CH_PEDIDO  := cNumPed
                SCH->CH_FORNECE := cFornecedor
                SCH->CH_LOJA    := cLoja
                SCH->CH_ITEMPD  := '0001'
                SCH->CH_ITEM    := alltrim(Strzero(cItem,2))
                SCH->CH_PERC    := (cAliasRat)->PERC
                SCH->CH_CC      := (cAliasRat)->CC
                SCH->CH_CONTA   := Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_CONTA')
                SCH->CH_ITEMCTA := ''
                SCH->CH_CLVL    := (cAliasRat)->CLVL
                SCH->CH_CUSTO1  := (cAliasRat)->VALOR
                SCH->CH_CUSTO2  := 0
                SCH->CH_CUSTO3  := 0
                SCH->CH_CUSTO4  := 0
                SCH->CH_CUSTO5  := 0
                
            SCH->(MsUnlock())
            ConfirmSX8()

            cItem := cItem + 1

            (cAliasRat)->(dBskip())

        EndDo

        (cAliasRat)->(DbCloseArea())

        RecLock("ZC1", .F.)
            ZC1->ZC1_PEDIDO := cNumPed
        ZC1->(MsUnlock())

        MsgInfo("Pedido gerado com Sucesso.", "Despesas Frota Medicar")
        oDlg:End()

    Else

        MsgInfo("Nenhuma Placa vinculada nao foi possivel gerar o pedido","Despesas Frota Medicar")
    
    EndIF


Return
