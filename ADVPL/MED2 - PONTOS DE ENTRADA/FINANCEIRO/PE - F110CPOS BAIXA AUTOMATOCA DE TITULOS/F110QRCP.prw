#Include "Protheus.ch"
 
/*---------------------------------------------------------------------*
 | P.E.:  F110QRCP                                                     |
 | Desc:  Filtro na seleção de títulos do baixas a receber auto        |
 *---------------------------------------------------------------------*/
 
 
User Function F110QRCP()
    Local aArea    := GetArea()
    Local cQuery   := PARAMIXB[1]
    Local cOrderBy := ""
    Local cAux     := ""
    Local cFilRet  := ""
    Local cTipo    := Space(3)
    //Local cFilNm   := Space(3)
    Private cCombo 		:= " "
    Private aItems 		:= {"Sim","Nao"}   


    If MsgYesNo ("Deseja utilizar filtro personalizado?")
         
        DEFINE MSDIALOG oDlg FROM 05,10 TO 220,520 TITLE "FILTROS PERSONALIZADOS " PIXEL

            @ 010,020 TO 100,250 LABEL " Filtro " OF oDlg PIXEL

            @ 025, 025 SAY oTitParametro PROMPT "Tipo: "                    SIZE 070, 020 OF oDlg PIXEL
            @ 020, 075 MSGET oGrupo VAR cTipo                               SIZE 050, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
            
            @ 045, 025 SAY oTitDesc PROMPT "Ordenar por nome?: "            SIZE 070, 020 OF oDlg PIXEL
            //@ 040, 060 MSGET oGrupo VAR cFilNm                              SIZE 170, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
            oCombo := TComboBox():New(040,075,,aItems,050,015,oDlg,,,,,,.T.,,,,,,,,,)
            oCombo:bSetGet:= {|u|if(PCount()==0,cCombo,cCombo:=u)}

            @ 080,175  BUTTON oBtn1 PROMPT "Confirmar"                      SIZE 030,011   ACTION (oDlg:End()) OF oDlg PIXEL 

        DEFINE SBUTTON FROM 080,215 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

        ACTIVATE MSDIALOG oDlg CENTER
        
       
        //Montando o filtro de retorno para exibição dos titulos que serão baixados
        cFilRet := " AND E1_ZZFORPG = '"+cTipo+"' "
        
        //Pega o order by e até o order by
        cOrderBy := SubStr(cQuery, RAt("ORDER BY", cQuery), Len(cQuery))
        cAux := SubStr(cQuery, 1, RAt("ORDER BY", cQuery)-1)
        
        //Monta o retorno da query
        IF cCombo = "Sim"
            cQuery := cAux + cFilRet + "ORDER BY E1_NOMCLI"
        ELSE
            cQuery := cAux + cFilRet + cOrderBy
        EndIf
        
    EndIf
      
    RestArea(aArea)
Return cQuery




/*

#Include "Protheus.ch"

 
 
User Function F110QRCP()
    
    //Local aArea    := GetArea()
    Local cQuery   := PARAMIXB[1]
    Local cOrderBy := ""
    Local cAux     := ""
    Local cFilRet  := ""
    Local cFilpg  := ""
    Private cPerg  := "ZFILBXAUT" // Nome do grupo de perguntas


    If MsgYesNo ("Deseja utilizar filtro personalizado?")

        If !Empty(cFilpg)
            Pergunte(cPerg,.F.)
        ElseIf !Pergunte(cPerg,.T.)
            Return
        Endif

        If !Empty(MV_PAR01)

            //Montando o filtro de retorno para exibição dos titulos que serão baixados
            cFilRet := " AND E1_ZZFORPG = '"+MV_PAR01+"' "
            
            //Pega o order by e até o order by
            cOrderBy := SubStr(cQuery, RAt("ORDER BY", cQuery), Len(cQuery))
            cAux := SubStr(cQuery, 1, RAt("ORDER BY", cQuery)-1)
            
            //Monta o retorno da query
            //cQuery := cAux + cFilRet + cOrderBy
            
            IF MV_PAR02 = 1
                cQuery := cAux + cFilRet + "ORDER BY E1_NOMCLI"
            ELSE
                cQuery := cAux + cFilRet + cOrderBy
            EndIf

        EndIf

    EndiF
     

    //RestArea(aArea)
Return cQuery

*/










