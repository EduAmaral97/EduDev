#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
 
/* 1 = Nome do bot�o | 2 = Mensagem do bot�o | 3 = A��o do bot�o */

User Function FC010BTN()

    Local cCli      := ''
    Local cLojacli  := ''

        DbSelectArea("SUA")

        cCli := SA1->A1_COD
        cLojacli := SA1->A1_LOJA

    If Paramixb[1] == 1// Deve retornar o nome a ser exibido no bot�o
        Return "Contratos"
    ElseIf Paramixb[1] == 3// Deve retornar a a��o do contrato
        Return  U_ZCONTRATCLI(cCli, cLojacli)
    Endif

Return


