#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para alterar a condição de pagamento do pedido de compras

------------------------------------------------------------------------------- */


User Function ZMEDCPPC()

    Local aArea := GetArea()
    Local cCond := Space(3)
    Local cDescCond := Space(30)
    Local cSE4Cond 
    Local cSE4Desc 
    

    // NAO PODE MUDAR QUANDO
    IF SC7->C7_QUJE > 0 .AND. SC7->C7_ENCER = 'E'

        MsgInfo("Pedido ja finalizado nao é permitido alterar.", "Condição Pagamento Medicar.")

    ELSE

        DbSelectArea('SE4')
        SE4->(DbSetOrder(1))

        If SE4->(DbSeek("      "+SC7->C7_COND))

            cSE4Cond := SE4->E4_CODIGO
            cSE4Desc := SE4->E4_DESCRI

            DEFINE MSDIALOG oDlg FROM 05,10 TO 300,400 TITLE " Alterar Condicao Pagamento - Pedido Compras " PIXEL

                @ 010,020 TO 060,170 LABEL " Cond.Pg. Cadastrada " OF oDlg PIXEL

                @ 025, 025 SAY oTit01 PROMPT "Cond.Pg.: "         SIZE 070, 020 OF oDlg PIXEL
                @ 020, 060 MSGET oVa01 VAR cSE4Cond               SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
                @ 043, 025 SAY oTit02 PROMPT "Descricao: "        SIZE 070, 020 OF oDlg PIXEL
                @ 040, 060 MSGET oVa02 VAR cSE4Desc               SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


                @ 070,020 TO 120,170 LABEL " Nova Cond. Pg. " OF oDlg PIXEL

                @ 085, 025 SAY oTit03 PROMPT "Cond.Pg.: "           SIZE 070, 020 OF oDlg PIXEL
                @ 080, 060 MSGET oVa03 VAR cCond                    SIZE 030, 011 PIXEL OF oDlg F3 "SE4MED" WHEN .T. Picture "@!"
                @ 100, 025 SAY oTit04 PROMPT "Descricao: "          SIZE 070, 020 OF oDlg PIXEL
                @ 095, 060 MSGET oVa04 VAR cDescCond                SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

                TButton():New(130, 110,  "Alterar"              , oDlg, {|| fAlteraCond(SC7->C7_FILIAL,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_NUM,cCond) }, 030,011, ,,,.T.,,,,,,)
                TButton():New(130, 150,  "Sair"                 , oDlg, {|| oDlg:End() }, 030,011, ,,,.T.,,,,,,)
            
            //DEFINE SBUTTON FROM 065,150 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

            ACTIVATE MSDIALOG oDlg CENTER

        ELSE

            MsgInfo("Condição de pagamento não encontrada.", "Condição Pagamento Medicar.")

        ENDIF

    ENDIF

    RestArea(aArea)

Return


Static Function fAlteraCond(cFilialPC,cFornecedor,cLoja,cPedido,cCond)

    Local cFiltro

    cFiltro := " SC7->C7_FILIAL == '"+cFilialPC+"' .AND. "
    cFiltro += " SC7->C7_FORNECE == '"+cFornecedor+"' .AND. "
    cFiltro += " SC7->C7_LOJA == '"+cLoja+"' .AND. "
    cFiltro += " SC7->C7_NUM == '"+cPedido+"' "

    DbSelectArea('SC7')
    //SC7->(DbSetOrder(3))
    //SC7->(DbSeek(cFilialPC+cFornecedor+cLoja+cPedido))
    SC7->(DbSetFilter({|| &(cFiltro)}, cFiltro))
    SC7->(dbGoTOP())

    IF SC7->(!Eof())

        While SC7->(!Eof())

            RecLock("SC7", .F.)
                SC7->C7_COND := cCond
            SC7->(MsUnlock())

            SC7->(dBskip())

        EndDo

        MsgInfo("Condição de pagamento alterado com Sucesso!.", "Condição Pagamento Medicar.")

    Else

        MsgInfo("Condição de pagamento não encontrada.", "Condição Pagamento Medicar.")

    Endif


    SC7->(DbCloseArea())
    oDlg:End()

Return

