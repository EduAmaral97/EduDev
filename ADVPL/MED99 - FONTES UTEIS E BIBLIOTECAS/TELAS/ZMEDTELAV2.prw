#Include "Protheus.ch"

User Function ZMEDTELA()

    Local cAlias := "BSQ"
    Local aCores := {}
    //Local cFiltra := "BSQ_SUBCON == '001025642' "
   
    Private cCadastro := "Debito e Credito Medicar"
    Private aRotina := {}
    Private aIndexSA2 := {}
    Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }


    /*
    -- CORES DISPONIVEIS PARA LEGENDA --
    BR_AMARELO
    BR_AZUL
    BR_BRANCO
    BR_CINZA
    BR_LARANJA
    BR_MARRON
    BR_VERDE
    BR_VERMELHO
    BR_PINK
    BR_PRETO
    */

    aAdd(aRotina,{"Legenda",    "fLegenda()", 0, 6})

    AADD(aCores,{"BSQ_NUMTIT == '         '" ,"BR_VERDE" })
    AADD(aCores,{"BSQ_NUMTIT != ' '"         ,"BR_VERMELHO" })
    AADD(aCores,{"BSQ_TABORI == '1'"         ,"BR_PRETO" })
    dbSelectArea(cAlias)
    SET DELETED OFF
    dbSetOrder(1)
//+------------------------------------------------------------
//| Cria o filtro na MBrowse utilizando a função FilBrowse
//+------------------------------------------------------------
    //Eval(bFiltraBrw)
    //dbSelectArea(cAlias)
    //SET DELETED OFF
    dbGoTop()
    //SetBlkBackColor({|| IIf(BSQ->BSQ_TABORI == "1" , CLR_HMAGENTA , Nil )})
    mBrowse(6,1,22,75,cAlias,,,,,,aCores)

    MsgInfo("Ponto de parada", "Teste")
    
//+------------------------------------------------
//| Deleta o filtro utilizado na função FilBrowse
//+------------------------------------------------
    EndFilBrw(cAlias,aIndexSA2)
Return Nil
//+---------------------------------------
//|Função: BInclui - Rotina de Inclusão
//+---------------------------------------
User Function BInclui(cAlias,nReg,nOpc)
    Local nOpcao := 0
    nOpcao := AxInclui(cAlias,nReg,nOpc)
    If nOpcao == 1
        MsgInfo("Inclusão efetuada com sucesso!")
    Else
        MsgInfo("Inclusão cancelada!")
    Endif
Return Nil


Static Function fLegenda()

    MsgInfo("Teste", "Debito e Credito Medicar")

Return







