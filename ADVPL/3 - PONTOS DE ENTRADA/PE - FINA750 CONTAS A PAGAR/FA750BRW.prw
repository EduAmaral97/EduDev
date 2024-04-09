#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} FA750BRW
Criar botões no aRotina contas a pagar
@type     function
@author      Eurai Rapelli
@since       2023.01.01
/*/


User Function FA750BRW()

    Local aBot    := {} as array

    aAdd( aBot,    { "Auditoria"    ,  "U_ZMEDAUDITORIA()"    , 0 , 6})
  
Return(aBot)
