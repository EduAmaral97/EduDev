#include "TOTVS.CH"
#include "PROTHEUS.CH"

User Function MTA140MNU()

    Local aArea := GetArea()

    //.. Customizacao do cliente  
    aAdd(aRotina,{ "Cond. Pagamento", "U_ZCONDPGPNF()", 0 , 2, 0, .F.})  

    RestArea(aArea)
    
Return
