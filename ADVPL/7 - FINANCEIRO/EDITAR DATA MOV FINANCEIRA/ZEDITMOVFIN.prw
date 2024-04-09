#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*

-----------------------------------------------------------------------------# 
                            U_RESUMOCONTATO							         #
-----------------------------------------------------------------------------# 
Funcao: U_ZEDITMOVFIN														 #
Autor: Eduardo Jorge 													     #
Data: 09/04/2024														     #
Descricao: EDITAR DATA DE MOVIMENTAÇÃO FINANCEIRA                            #
*****************************************************************************#

*/


User function ZEDITMOVFIN()
    
    Local aArea   	:= GetArea()

    //cChama a funcao que monta os dados
    MsAguarde({||fMontatela()},"Aguarde","Aguarde...")

     RestArea(aArea)

return()

Static Function fMontatela()


    Local cQuery
    Local dDtFin := STOD("")
    Local cDtAtu
    Private AliasParam := GetNextAlias()

    cQuery := "SELECT  "
    cQuery += "A.X6_VAR         AS PARAMETRO, "
    cQuery += "A.X6_DESCRIC     AS DESCRICAO, "
    cQuery += "A.X6_CONTEUD     AS CONTPT, "
    cQuery += "A.X6_CONTSPA     AS CONTSPA, "
    cQuery += "A.X6_CONTENG     AS CONTENG "
    cQuery += "FROM SX6010 A  "
    cQuery += "WHERE 1=1  "
    cQuery += "AND A.X6_VAR = 'MV_DATAFIN' "

    TCQUERY cQuery NEW ALIAS (AliasParam)


    DbSelectArea(AliasParam)

    cDtAtu := SubStr(((AliasParam)->CONTPT),7,2) + '/' + SubStr(((AliasParam)->CONTPT),5,2) + '/' + SubStr(((AliasParam)->CONTPT),1,4)

    DEFINE MSDIALOG oDlg FROM 05,10 TO 220,520 TITLE "ALTERAR DATA MOV. FINANCEIRA " PIXEL

        @ 010,020 TO 100,250 LABEL " Parametro " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Parametro: "               SIZE 070, 020 OF oDlg PIXEL
        @ 020, 060 MSGET oGrupo VAR (AliasParam)->PARAMETRO             SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 045, 025 SAY oTitDesc PROMPT "Descricao: "                    SIZE 070, 020 OF oDlg PIXEL
        @ 040, 060 MSGET oGrupo VAR (AliasParam)->DESCRICAO             SIZE 170, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 065, 025 SAY oTitDtAtual PROMPT "Data atual: "                SIZE 070, 020 OF oDlg PIXEL
        @ 060, 060 MSGET oGrupo VAR cDtAtu                              SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"        


        @ 085, 025 SAY oTitNovaData PROMPT "Nova Data: "                SIZE 070, 020 OF oDlg PIXEL
        @ 080, 060 MSGET oGrupo VAR dDtFin                              SIZE 050, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
       
        @ 080,175  BUTTON oBtn1 PROMPT "Salvar"                         SIZE 030,011   ACTION (UpdateDt(cDtAtu,dDtFin)) OF oDlg PIXEL 

    DEFINE SBUTTON FROM 080,215 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

    (AliasParam)->(DbCloseArea())
    
Return

Static Function UpdateDt(cDtAtu,dDtFin)

    If MsgYesNo("Confirma alteracao da data?" +  CHR(13)+CHR(10) + " - De: " + cDtAtu + CHR(13)+CHR(10) + " - Para: " + SubStr(DTOS(dDtFin),7,2) + '/' + SubStr(DTOS(dDtFin),5,2) + '/' + SubStr(DTOS(dDtFin),1,4))
    
        Begin Transaction

        //Monta o Update
        cQryUpd := " UPDATE SX6010 "
        cQryUpd += "    SET SX6010.X6_CONTEUD = '"+DTOS(dDtFin)+"', "
        cQryUpd += "    SX6010.X6_CONTSPA =  '"+DTOS(dDtFin)+"', "
        cQryUpd += "    SX6010.X6_CONTENG = '"+DTOS(dDtFin)+"' "
        cQryUpd += " FROM SX6010 "
        cQryUpd += " WHERE 1=1 "
        cQryUpd += "    AND SX6010.D_E_L_E_T_ = ' ' "
        cQryUpd += "     AND SX6010.X6_VAR = 'MV_DATAFIN' "

        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf       

        End Transaction
        oDlg:End()

    Else
            Alert("Alteracao Cancelada!")
            oDlg:End()
    EndIf
      
Return
