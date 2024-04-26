#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"


/*

- PONTO DE ENTRADA MENUDEF DO BROSER NA ROTINA DE CADASTRO DE CLIENTES.

- Por: Eduardo Amaral

- Em: 14/03/2024

*/

/*/{Protheus.doc} User Function CRM980MDEF
Novo ponto de entrada para adicionar rotinas no novo cadastro de clientes (CRMA980)
@type  Function
@author Atilio
@since 15/10/2022
@see https://tdn.totvs.com/pages/releaseview.action?pageId=604230458

/*/
  

User Function CRM980MDEF()
    Local aArea := FWGetArea()
    Private aRotina := {}
    
    //DbSelectArea("SA1")
    
    aAdd(aRotina,{"Contratos", "U_ZCONTRATCLI(SA1->A1_COD, SA1->A1_LOJA, SA1->A1_PESSOA)", MODEL_OPERATION_VIEW,0})
    aAdd(aRotina,{"Auditoria", "U_ZMEDAUDITORIA()", MODEL_OPERATION_VIEW,0})
  
    FWRestArea(aArea)
Return aRotina







