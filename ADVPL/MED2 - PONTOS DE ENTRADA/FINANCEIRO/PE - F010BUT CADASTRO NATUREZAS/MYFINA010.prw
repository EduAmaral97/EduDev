#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"



User Function FINA010()

    Local xRet       := .T.
    Local cIdPonto   := PARAMIXB[2]

    IF cIdPonto == 'BUTTONBAR'
        //ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
        xRet := { {'Auditoria', 'AUDITORIA', { || U_ZMEDAUDITORIA() }, 'Este botao Auditda o cadastro' } }    
    EndIf
    

Return xRet
