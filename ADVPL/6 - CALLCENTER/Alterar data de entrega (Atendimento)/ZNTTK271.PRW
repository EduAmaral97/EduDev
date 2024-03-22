//#############################################################################
//#                           ZNTTK271()                                      #
//#############################################################################
//# Módulo:         Telemarketing/Faturamento                                #
//# Categoria:      Função Interna                                          #
//# Solicitante:                                                              #
//# Data:           24/06/2020                                                #
//# Autor:          Alexandre Lacerda                                         #
//# Observações:    														  #
//# Descrição:      Rotina para o colaborador autorizado alterar a data de  #
//# 				  entrega do atendimento já faturado 					  #
//#############################################################################
/*
------------------------------------------------------------------------------#
                               Altera��es									  #
------------------------------------------------------------------------------#
Data:           12/09/2020 													  #
Solicitante:    Alexandre Lacerda											  #
Autor:          Cristina Iabuki												  #
Descri��o:		Fonte analisado para 12.1.27 (Sxs para banco de dados)		  #
			    (SX1/SX2/SX3/Pswret-Tratamento )							  #	
******************************************************************************#
*/

#include 'protheus.ch'

User Function ZNTTK271()

Local aArea   := GetArea()
Local aAreaSC6:= ("SUA") -> ( GetArea() )
local cFilt   := "SUA -> UA_FILIAL == '" + xFilial("SUA") + "' .AND. SC5 -> C5_FILIAL == '" + xFilial("SC5") + "' .AND. SC6 -> C6_NUM == SC5 -> C5_NUM"
Local lNota   := .F.
Local oDlg, oObs 

IF !EMPTY( ALLTRIM( SC5 -> C5_ORCRES ) )

	DbSelectArea("SC6")
	dbSetFilter( {|| & ( cFilt ) }, cFilt )
	DbGoTop()
	
	WHILE !EOF()
		IF !EMPTY( ALLTRIM( C6_NOTA ) )
			lNota := .T.
		ENDIF
		DbSkip()
	ENDDO
	
	IF !lNota
		DbSelectArea("SC5")
		DEFINE MSDIALOG oDlg FROM 05,10 TO 270,484 TITLE "Abertura de Pedido de Venda" PIXEL
		
			cObs := MSMM( SC5 -> C5_ZMOTIVO, TamSx3( "C5_ZMOTIVO" )[1] )
		
			@ 003,004 TO 108,236 LABEL "Justificativa" OF oDlg PIXEL
			@ 012,008 GET oObs VAR cObs OF oDlg MEMO SIZE 223,90 PIXEL Valid !Empty(cObs)
		
			DEFINE SBUTTON FROM 115,210 TYPE 1 ACTION ( PPA008A( cObs ), oDlg:End() ) ENABLE OF oDlg
			DEFINE SBUTTON FROM 115,180 TYPE 2 ACTION ( oDlg:End()                  ) ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTER
	ELSE
		MsgStop("Pedidos de Venda JÀ FATURADO.","Acesso Negado!")
	ENDIF
ELSE
	MsgAlert("Este Pedido não necessita de Abertura!", "Aviso!")
ENDIF

RestArea( aAreaSC6 )
RestArea( aArea    )

Return()

//###########################################################################################
//#                           PPA008A()                                       				#
//###########################################################################################
//# MÃƒÆ’Ã‚Â³dulo:         Faturamento				                            #
//# Categoria:      FunÃƒÆ’Ã‚Â§ÃƒÆ’Ã‚Â£o Interna                        #
//# Solicitante:                                                              				#
//# Data:           17/04/2017                                                				#
//# Autor:          Henrique Velloso                                                      	#
//# ObservaÃƒÆ’Ã‚Â§ÃƒÆ’Ã‚Âµes:										  	#
//###########################################################################################
//# Relacionamento:                                                                       	#
//# VariÃƒÆ’Ã‚Â¡veis Ent:           					    					  	#
//# DescriÃƒÆ’Ã‚Â§ÃƒÆ’Ã‚Â£o: Rotina para Abertura de Pedido de Venda	#	
//###########################################################################################

Static Function PPA008A( cObs )

IF  RecLock( "SC5", .F.)
	IF !EMPTY( ALLTRIM ( SC5 -> C5_ZMOTIVO ) )
		SC5 -> C5_ZMOTIVO += CHR(13) + CHR(10)
		SC5 -> C5_ZMOTIVO += DToS( Date() ) + " - " +  cObs
	ELSE
		SC5 -> C5_ZMOTIVO := DToS( Date() ) + " - " + cObs
	ENDIF
	SC5 -> C5_ZORCRES := SC5 -> C5_ORCRES
	SC5 -> C5_ZDTABER := Date()
	SC5 -> C5_ZUSUABE := cUserName 	//PswRet(1)[1][2] Tratamento Pswret
	SC5 -> C5_ORCRES  := ""
	MsUnlock()
	MsgAlert("Abertura de Pedido de Venda OK!", "Aviso")	
	U_MAILATU(5)
ELSE
	MsgAlert("N�o foi possivel a Abertura do Pedido! Contate o Setor de T.I!", "Erro")
ENDIF

Return()
