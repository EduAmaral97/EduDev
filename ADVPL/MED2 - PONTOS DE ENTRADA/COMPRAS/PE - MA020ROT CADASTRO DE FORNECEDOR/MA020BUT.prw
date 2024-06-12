#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"


User Function MA020BUT()

    Local aButtons := {} // botões a adicionar

    AAdd(aButtons,{ 'Auditoria'      ,{| |  U_ZMEDAUDITORIA() }, 'Auditoria','Auditoria' } )

Return (aButtons)
