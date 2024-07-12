#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
 
/* 1 = Nome do bot�o | 2 = Mensagem do bot�o | 3 = A��o do bot�o */

User Function FC010BTN()

     Local cCli      := ''
    Local cLojacli  := ''
    Local cTipCli   := ''
    
        cCli := SA1->A1_COD
        cLojacli := SA1->A1_LOJA
        cTipCli := SA1->A1_PESSOA

    If Paramixb[1] == 1// Deve retornar o nome a ser exibido no bot�o
        Return "Rotinas Medicar"
    ElseIf Paramixb[1] == 3// Deve retornar a a��o do contrato
        Return  U_ZROTMEDCC(cCli, cLojacli, cTipCli)
    Endif


Return

