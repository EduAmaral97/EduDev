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
    aAdd( aBot,    { "Aprovacao"    ,  "U_ZAPRFINPG(SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA)"        , 0 , 7})
   

Return(aBot)
