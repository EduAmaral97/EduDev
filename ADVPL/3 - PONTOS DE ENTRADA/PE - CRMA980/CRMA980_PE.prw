#INCLUDE "PROTHEUS.CH"


User Function MA030BUT()

    Local aBotao := {} as array
    aAdd(aBotao,{"BOTA TESTE",{|| U_ZTESTEPECLI() }, "*XXX"})

Return( aBotao ) 
