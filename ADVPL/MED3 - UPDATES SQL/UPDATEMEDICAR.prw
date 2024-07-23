#include 'protheus.ch'


/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para executar de forma rapida e simples updates em SQL direto do protheus.

------------------------------------------------------------------------------- */


user function UPDATEMEDICAR()

    Local cQuery := ""

    DEFINE MSDIALOG oDlg FROM 05,10 TO 400,650 TITLE "SQL EXEC - MEDICAR " PIXEL

        @ 010,020 TO 180,300 LABEL " Sql Exec " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Query: "                    SIZE 070, 020 OF oDlg PIXEL
        @ 020,050 GET OMEMO VAR cQuery MEMO                              SIZE 200,150 PIXEL OF oDlg

        @ 025,260  BUTTON oBtn1 PROMPT "Executar"                        SIZE 030,011   ACTION (execupdatesqlmedicar(cQuery)) OF oDlg PIXEL
        @ 040,260  BUTTON oBtn1 PROMPT "Sair"                            SIZE 030,011   ACTION (oDlg:End()) OF oDlg PIXEL

    ACTIVATE MSDIALOG oDlg CENTER

return


Static function execupdatesqlmedicar(cQuery)

    //MsgAlert(cQuery)

    Begin Transaction

        //Tenta executar o update
        nErro := TcSqlExec(cQuery)

        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            //ABORTA O UPDATE
            DisarmTransaction()
        Else
            MsgInfo("Query executado com sucesso", "SQL Exec Medicar")            
        EndIf

    End Transaction

return


