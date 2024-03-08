//#############################################################################
//#                           ZNTALTENT()                                     #
//#############################################################################
//# Módulo:         Telemarketing/Faturamento                                 #
//# Categoria:      Função Interna                                            #
//# Solicitante:                                                              #
//# Data:           24/06/2020                                                #
//# Autor:          Alexandre Lacerda                                         #
//# Observações:    Solicitação Rodrigo Zanotti  							  #
//#############################################################################
//# Relacionamento:                                                           #
//# Variáveis Ent:  		                                                  #
//# Descrição:      Rotina para o colaborador autorizado alterar a data de    #
//# 				entrega do atendimento já faturado 						  #
//#############################################################################
/*
------------------------------------------------------------------------------#
                               Alterações									  #
------------------------------------------------------------------------------#
Data:           12/09/2020 													  #
Solicitante:    Alexandre Lacerda											  #
Autor:          Cristina Iabuki												  #
Descrição:		Fonte analisado para 12.1.27 (Sxs para banco de dados)		  #
			    (SX1/SX2/SX3/Pswret-Tratamento)								  #	
******************************************************************************#
*/
#include 'protheus.ch'

User Function ZNTALTENT()

Local aArea   	:= GetArea()
Local aAreaSUA	:= ("SUA") -> ( GetArea() )
//Local cCodFil	:= SUA->UA_FILIAL
Local cNumATM	:= SUA->UA_NUM
Local nPrzEnt	:= SUA->UA_ZPRZENT
Local dDatAtu	:= IIF(EMPTY(SUA->UA_ZDTAENT),Ctod("  /  /  "),DTOC(SUA->UA_ZDTAENT))
Local cCodOpe	:= SUA->UA_OPER
Local oDlg, oObs               

Local nDiaEnt   := IIF(EMPTY(M->UA_ZDTAENT),0,DateDiffDay(M->UA_EMISSAO,dDatEnt))
Local dDatEnt   := IIF(EMPTY(M->UA_ZDTAENT),Ctod("  /  /  "),DTOC(SUA->UA_ZDTAENT))
//Local dPrvEnt 	:= IIF(EMPTY(M->UA_ZDTAENT),Ctod("  /  /  "),DTOC(STOD(M->UA_ZDTAENT)))     
//Local nQtdDia 	:= IIF(EMPTY(M->UA_ZDTAENT),0,DateDiffDay(dDATABASE,M->UA_ZDTAENT))
//Local lVndFin	:= IIF( M -> UA_OPER == "3",.T.,.F.)
//Local lRet	    := .F.
//Local lCheck    := .F.
Local lHasButton:= .T.                              

Local bSetGet1  := { | u | If( PCount() == 0, nDiaEnt, nDiaEnt := u ) }
Local bChange1  := { |   | dDatEnt := DaySum( dDATABASE, nDiaEnt ), oDatEnt:Refresh() }
Local bSetGet2  := { | u | If( PCount() == 0, dDatEnt, dDatEnt := u ) }
Local bChange2  := { |   | nDiaEnt := DateDiffDay(dDATABASE, dDatEnt), oDiaEnt:Refresh() }
Local bSetGet3  := { | u | If( PCount() == 0, nPrzEnt, nPrzEnt := u ) }

// Tratamento Pswret
//IF PswRet(1)[1][10][1] $ ("000004|000005")
 If	u_FZntGrp(PswId(),"000004|000005","")
	
	IF cCodOpe $ "12"
		
		DbSelectArea("SUA")
		DEFINE MSDIALOG oDlg FROM 05,10 TO 274,484 TITLE "Justificativa - Alteração Data Entrega / Cliente (ATM: " + cNumATM + ")" PIXEL
		
		cObs := MSMM( SUA -> UA_ZMOTIVO, TamSx3( "UA_ZMOTIVO" )[1] )
		
		@ 003,004 TO 108,236 LABEL "Justificativa" OF oDlg PIXEL
		
		@ 012, 008 TO 047, 118 LABEL "Alteração do Prazo de Entrega/Cliente" PIXEL OF oDlg
		oDiaEnt := TGet():New( 021, 010, bSetGet1, oDlg, 015, 011, "@E 999", { || IIF( SUA->UA_OPER $ "12", ( nDiaEnt > 0 ), .T. ) .AND. U_VLDALTENT( nDiaEnt, dDatEnt )         },,,,,, .T.,,, { || .T. },,, bChange1,,,, "nDiaEnt",,,, lHasButton,)
		@ 022, 030 SAY oDiaEnt PROMPT "Dias" SIZE 030, 009 OF oDlg PIXEL
		oDatEnt := TGet():New( 021, 050, bSetGet2, oDlg, 065, 011, "@D"    , { || IIF( SUA->UA_OPER $ "12", ( dDatEnt > dDataBase .AND. !EMPTY(dDatEnt) ), .T. ) .AND. U_VLDALTENT( nDiaEnt, dDatEnt ) },,,,,, .T.,,, { || .T. },,, bChange2,,,, "dDatEnt",,,, lHasButton,)
		//			oCheck  := TCheckBox():New( 037, 010, "Entrega Finalizada", {| u | IF( PCount() > 0, lCheck := u, lCheck ) }, oDlg, 080, 007, , { || oDatEnt:lReadOnly := oDiaEnt:lReadOnly := !( lCheck ), oDiaEnt:CtrlRefresh(), oDatEnt:CtrlRefresh() },,,,,, .T.,,,)
		
		@ 012, 121 TO 047, 230 LABEL "Prazo de Entrega Atual Combinado/Cliente" PIXEL OF oDlg
		oPrzEnt := TGet():New( 021, 123,bSetGet3,oDlg, 015, 011, "@E 999",,,,,,, .T.,,, { || .F. },,,,,,, "nPrzEnt",,,,lHasButton,)
		@ 022, 143 SAY oDiaEnt PROMPT "Dias" SIZE 030, 009 OF oDlg PIXEL
		oDatAtu := TGet():New( 021, 163,{ | u | If( PCount() == 0, dDatAtu, dDatAtu := u ) }, oDlg,065,011,"@D",,,,,,, .T.,,, { || .F. },,,,,,, "dDatAtu",,,,lHasButton  )
		
		@ 050,008 GET oObs VAR cObs OF oDlg MEMO SIZE 223,55 PIXEL Valid !Empty(cObs)
		
		DEFINE SBUTTON FROM 115,210 TYPE 1 ACTION ( ALTENTSUA(cObs,nDiaEnt,dDatEnt), oDlg:End() ) ENABLE OF oDlg
		DEFINE SBUTTON FROM 115,180 TYPE 2 ACTION ( oDlg:End()                  ) ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTER
		
		/*
		IF lRet
		IF lCheck
		M -> UA_ZPRZENT := 0
		M -> UA_ZDTAENT := Ctod("  /  /  ")
		M -> UA_ZSEMPRZ := "S"
		ELSE
		M -> UA_ZPRZENT := nDiaEnt
		M -> UA_ZDTAENT := dDatEnt
		M -> UA_ZSEMPRZ := "N"
		ENDIF
		EndIf
		*/
		
	ELSE
		MsgAlert("Atendimento em <b>ABERTO</b>, Favor usar a opção <b>ALTERAR</b>.","Acesso Negado!")
	ENDIF
ELSE	
	MsgStop("Usuário sem Permissão para Alterar a Data de Entrega/Cliente. Favor usar a opção <b>ALTERAR</b>, caso o atendimento esteja em aberto, caso contrário, entre em contato com o setor de Faturamento e/ou Compras.","Acesso Negado!")		
ENDIF

RestArea( aAreaSUA )
RestArea( aArea    )

Return()

//#############################################################################
//#                           ALTENTSUA()                                     #
//#############################################################################
//# Módulo:         Telemarketing/Faturamento                                 #
//# Categoria:      Função Interna                                            #
//# Solicitante:                                                              #
//# Data:           24/06/2020                                                #
//# Autor:          Alexandre Lacerda                                         #
//# Observações:    Solicitação Rodrigo Zanotti  							  #
//#############################################################################
//# Relacionamento:                                                           #
//# Variáveis Ent:  		                                                  #
//# Descrição:      Rotina para o colaborador autorizado alterar a data de    #
//# 				entrega do atendimento já faturado 						  #
//#############################################################################

Static Function ALTENTSUA( cObs,nDiaEnt,dDatEnt )

Private	nZPRZANT := 0
Private dZDTAANT := CTOD("  /  /  ")

IF  RecLock( "SUA", .F.)

	IF !EMPTY( ALLTRIM ( SUA->UA_ZMOTIVO ) )
		SUA->UA_ZMOTIVO += CHR(13) + CHR(10)
		SUA->UA_ZMOTIVO += DToS( Date() ) + " - " +  cObs
	ELSE
		SUA->UA_ZMOTIVO := DToS( Date() ) + " - " + cObs
	ENDIF
	                  
	nZPRZANT := SUA->UA_ZPRZENT
	dZDTAANT := SUA->UA_ZDTAENT

	SUA->UA_ZPRZENT := nDiaEnt
	SUA->UA_ZDTAENT := dDatEnt

	IF  EMPTY(SUA->UA_ZDTENT2)
		SUA->UA_ZDTENT2 := dZDTAANT
	ENDIF


	MsUnlock()
	MsgRun("Prazo de entrega atualizada com Sucesso, enviando E-Mail...","Por favor, Aguarde!",{|| U_MAILATU(7) })
ELSE
	MsgAlert("Não foi possível a Abertura do Atendimento! Favor contate o Setor de TI!", "Erro")
ENDIF

Return()

//#############################################################################
//#                           VLDALTENT()                                     #
//#############################################################################
//# Módulo:         Telemarketing/Faturamento                                 #
//# Categoria:      Função Interna                                            #
//# Solicitante:                                                              #
//# Data:           24/06/2020                                                #
//# Autor:          Alexandre Lacerda                                         #
//# Observações:    														  #
//# Descrição:      Rotina para o colaborador autorizado alterar a data de    #
//# 				entrega do atendimento já faturado 						  #
//#############################################################################

User Function VLDALTENT( _nDias, _dPrzEnt )

//Local i
Local aArea    := GetArea()
//Local aMsgErro := {}
//Local cMsgErro := ""
Local lRet     := .T.
          
/*
MSGALERT("Alteração Solicitada!","Atenção!")

IF Len( aMsgErro ) != 0
	lRet 	 := .F.
	cMsgErro := ""
	FOR i := 1 TO Len( aMsgErro )
		cMsgErro += aMsgErro[i][1] + CHR(13) + CHR(10)
	NEXT i
	MsgAlert( "Usuário Não Autorizado para realizar a alteração da data de entrega!"  + CHR(13) + CHR(10) + CHR(13) + CHR(10) + cMsgErro, "ATENÇÃO!")
ENDIF 
*/


RestArea( aArea    )
Return( lRet )

