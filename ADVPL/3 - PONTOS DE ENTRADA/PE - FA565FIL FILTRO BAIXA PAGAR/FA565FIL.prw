#include 'Protheus.ch'
 
User Function FA565FIL()
    Local cQuery := ""
    Local cFilpg := ''
    Private cPerg  := "ZFILLIQ" // Nome do grupo de perguntas


    If MsgYesNo ("Deseja utilizar filtro personalizado?")

        If !Empty(cFilpg)
            Pergunte(cPerg,.F.)
        ElseIf !Pergunte(cPerg,.T.)
            Return
        Endif
        
        cQuery := " "

        IF !Empty(MV_PAR01)
            cQuery += " AND E2_NATUREZ IN ("+MV_PAR01+") "
        ENDIF

        IF !Empty(MV_PAR02)
            cQuery += " AND E2_TIPO IN ("+MV_PAR02+") "
        ENDIF
      
    EndiF
RETURN cQuery


