#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"


User function M261BCHOI()
    Local aArea    := GetArea()
    Local aButtons := {}
     
    aAdd(aButtons, {'BITMAP', { || U_ZIMPTRANSF() }  ,OemtoAnsi('Importador CSV')})
     
    RestArea(aArea)
Return aButtons
