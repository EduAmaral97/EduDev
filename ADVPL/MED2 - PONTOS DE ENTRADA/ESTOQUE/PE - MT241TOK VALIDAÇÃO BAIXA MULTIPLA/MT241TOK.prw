#include "protheus.ch"

User Function MT241TOK()

    Local lRet := .T.
    Local aItens := aCols
    Local nPos
    Local cMsg := ""

    For nPos := 1 to Len(aItens)
      

        IF aItens[nPos][27] = "         "

            cMsg += " - Produto: " + aItens[nPos][1] + " - " + aItens[nPos][18] + CHR(13)+CHR(10)

        EndIf

    Next


    If cMsg <> ""
      
        MsgInfo("Itens sem Classe valor, Verifique os itens abaixo: " +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + cMsg, "Medicar - Mov. Interna")

        //NAO DEIXA SALVAR
        lRet := .F.

    Else

        //DEIXA SALVAR
        lRet := .T.
   


    EndIf


Return lRet
