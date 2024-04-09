#INCLUDE "TOTVS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} PL660SBUT
Ponto de entrada do subcontrato para importar as vidas
@author  Kaio Novelli
@since   27/11/2023
@version v1.00
/*/
//-------------------------------------------------------------------
User Function PL660SBUT()

    Local aRet := {} 

    aadd(aRet,{"IMPBENEF"  ,{|| U_MEDADP() },"Importador Medicar","Importador Medicar"})

Return(aRet)
