#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"


User Function MA020BUT()

    Local aButtons := {} // bot�es a adicionar

    AAdd(aButtons,{ 'Auditoria'      ,{| |  U_ZMEDAUDITORIA() }, 'Auditoria','Auditoria' } )

Return (aButtons)
