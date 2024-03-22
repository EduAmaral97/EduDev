#include 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*/ 
-----------------------------------------------------------------------------# 
								  ZNTENDENT271							     #
-----------------------------------------------------------------------------# 
Funcao: ZNTENDENT271 														 #
Autor: Eduardo Jorge 	     					     #
Data: ? 								     #
Descricao: ?                                                                 #
*****************************************************************************#

*/


User Function ZNTENDENT()

Local aArea   	:= GetArea()
Local aAreaSUA	:= ("SUA") -> ( GetArea() )
Local cNumATM	    := SUA->UA_NUM
Local tCodOpe	    := SUA->UA_OPER
Local tCli          := SUA->UA_CLIENTE
Local tLoja         := SUA->UA_LOJA
Local tCepEnt	    := SUA->UA_CEPE
Local tEndEnt	    := SUA->UA_ENDENT
Local tBairroEnt    := SUA->UA_BAIRROE
Local tEstEnt	    := SUA->UA_ESTE
Local tMunEnt	    := SUA->UA_MUNE
Local cQueryCli



Local cCep := Space(9)
Local cEstado := Space(2)
Local cMunicipio := Space(80)
Local cEndereço := Space(80)
Local cBairro := Space(40)
Local cTransp := Space(12)
Local cValorFrete := 0
Private cCombo 		:= " "
Private aItems 		:= {"Endereço do Cadastro do Cliente","Endereço Alternativo do Cliente"}   

    
DbSelectArea("SUA")



cQueryCli := "SELECT A1_FILIAL,A1_COD,A1_NOME,A1_CEP,A1_EST,A1_MUN,A1_END,A1_BAIRRO FROM SA1010 WHERE 1=1 AND D_E_L_E_T_ = '' AND A1_COD = '"+ SUA->UA_CLIENTE +"' AND A1_LOJA = '" + SUA->UA_LOJA +"'"
If Select("AliasCli") > 0
     dbSelectArea("AliasCli")
     dbCloseArea()
EndIf
TcQuery cQueryCli New Alias AliasCli
dbSelectArea("AliasCli")



	DEFINE MSDIALOG oDlg FROM 05,10 TO 320,650 TITLE "Endereço de Entrega - Cliente (ATM: " + cNumATM + ")" PIXEL
		

        @ 010, 020 SAY oDiaEnt PROMPT "Selecione o Tipo de Endereço de Entrega" SIZE 150, 020 OF oDlg PIXEL
        oCombo := TComboBox():New(020,20,,aItems,120,020,oDlg,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cCombo,cCombo:=u)}
        
        @ 040,010 TO 152,160 LABEL " Insira abaixo os dados da Entrega " OF oDlg PIXEL

        @ 050, 020 SAY oTitCep PROMPT "Cep" SIZE 050, 020 OF oDlg PIXEL
        @ 057, 020 MSGET oCep VAR cCep SIZE 035, 011 PIXEL OF oDlg VALID NAOVAZIO(cCep) When If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. ) Picture "@!"
        @ 075, 020 SAY oTitEst PROMPT "Estado" SIZE 060, 020 OF oDlg PIXEL
        @ 082, 020 MSGET oEst VAR cEstado SIZE 020, 011 PIXEL OF oDlg F3 "SX512" VALID NAOVAZIO(cEstado) When If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. ) Picture "@!"
        @ 075, 045 SAY oTitMun PROMPT "Município" SIZE 095, 020 OF oDlg PIXEL
        @ 082, 045 MSGET oMun VAR cMunicipio SIZE 095, 011 PIXEL OF oDlg F3 "Z_MUNI" VALID NAOVAZIO(cMunicipio) When If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. ) Picture "@!"
        @ 100, 020 SAY oTitEnd PROMPT "Endereço" SIZE 120, 020 OF oDlg PIXEL
        @ 107, 020 MSGET oEnd VAR cEndereço SIZE 120, 011 PIXEL OF oDlg VALID NAOVAZIO(cEndereço)  When If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. ) Picture "@!"
        @ 125, 020 SAY oTitBairro PROMPT "Bairro" SIZE 120, 020 OF oDlg PIXEL
        @ 132, 020 MSGET oBairro VAR cBairro SIZE 120, 011 PIXEL OF oDlg VALID NAOVAZIO(cBairro)  When If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. ) Picture "@!"

        @ 040,165 TO 152,310 LABEL " Insira abaixo os dados do Frete " OF oDlg PIXEL

        @ 050, 175 SAY oTitTransp PROMPT "Transportadora" SIZE 0100, 020 OF oDlg PIXEL        
        @ 057, 175 MSGET oTransp VAR cTransp SIZE 060, 011 PIXEL OF oDlg F3 "SA4" VALID NAOVAZIO(cTransp)  When .T. Picture "@!"

        @ 075, 175 SAY oTitVal PROMPT "Valor Frete" SIZE 0100, 020 OF oDlg PIXEL
        @ 082, 175 MSGET oValFrete VAR cValorFrete SIZE 050, 011 PIXEL OF oDlg VALID POSITIVO() When .T. Picture "@R 999999.99"
      
        /*1 - Endeteço no Cadastro do Cliente*/

       IF cCombo = "Endereço do Cadastro do Cliente"
        ELSEIF  cCombo = "Endereço Alternativo do Cliente"
       ENDIF

        DEFINE SBUTTON FROM 137,275 TYPE 1 ACTION ( oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 137,245 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

        ACTIVATE MSDIALOG oDlg CENTER

RestArea( aAreaSUA )
RestArea( aArea    )


Return()


/*
        @ 050, 020 SAY oDiaEnt PROMPT "Cep" SIZE 050, 020 OF oDlg PIXEL
        oCepEnt :=    TGet():New( 057, 020,, oDlg, 035, 011, "@!",,,,,,, .T.,,,{||If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. )}    ,,,,,,,,,,,,,,,,,,,.T.,.T.)
        oCepEnt:bSetGet:= {||Space(9)}

        @ 075, 020 SAY oDiaEnt PROMPT "Estado" SIZE 060, 020 OF oDlg PIXEL
        oEstEnt :=    TGet():New( 082, 020,, oDlg, 020, 011, "@!",,,,,,, .T.,,,{||If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. )}     ,,,,,,,,,,,,,,,,,,,.T.,.T.)
        oEstEnt:bSetGet:= {||Space(2)}

        @ 075, 045 SAY oDiaEnt PROMPT "Município" SIZE 095, 020 OF oDlg PIXEL
        oMunEnt :=    TGet():New( 082, 045,, oDlg, 095, 011, "@!",,,,,,, .T.,,,{||If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. )}     ,,,,,,,,,,,,,,,,,,,.T.,.T.)
        oMunEnt:bSetGet:= {||Space(80)}

        @ 100, 020 SAY oDiaEnt PROMPT "Endereço" SIZE 120, 020 OF oDlg PIXEL
        oEndEnt :=    TGet():New( 107, 020,, oDlg, 120, 011, "@!",,,,,,, .T.,,,{||If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. )}     ,,,,,,,,,,,,,,,,,,,.T.,.T.)
        oEndEnt:bSetGet:= {||Space(80)}

        @ 125, 020 SAY oDiaEnt PROMPT "Bairro" SIZE 120, 020 OF oDlg PIXEL
        oBairroEnt := TGet():New( 132, 020,, oDlg, 120, 011, "@!",,,,,,, .T.,,,{||If( cCombo = "Endereço Alternativo do Cliente", .T. , .F. )}  ,,,,,,,,,,,,,,,,,,,.T.,.T.)
        oBairroEnt:bSetGet:= {||Space(40)}
*/



