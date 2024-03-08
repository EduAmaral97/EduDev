#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
 
/* 1 = Nome do botão | 2 = Mensagem do botão | 3 = Ação do botão */

User Function FC010BTN()

    Local cCli      := ''
    Local cLojacli  := ''

        DbSelectArea("SUA")

        cCli := SA1->A1_COD
        cLojacli := SA1->A1_LOJA

    If Paramixb[1] == 1// Deve retornar o nome a ser exibido no botão
        Return "Contratos"
    ElseIf Paramixb[1] == 3// Deve retornar a ação do contrato
        Return  U_ZCONTRATCLI(cCli, cLojacli)
    Endif

Return


