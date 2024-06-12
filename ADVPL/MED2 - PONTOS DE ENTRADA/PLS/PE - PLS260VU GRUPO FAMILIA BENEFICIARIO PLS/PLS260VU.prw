#INCLUDE "Protheus.ch" 
#INCLUDE 'TOPCONN.CH'

/* 
-----------------------------------------------------------------------------# 
								  PLS260VU									 #
-----------------------------------------------------------------------------# 
Funcao: PLS260VU 															 #
Autor: EDUARDO AMARAL   													 #
Data: 18/01/2024    														 #
Descricao: Ponto de entrada cadastro Familia PLS.          					 #
PE: VERIFICA��O ATES DE SALVAR UM GRUPO FAMILIA/BENEFICIARIO                 #
*****************************************************************************#

*****************************************************************************#
*/




User Function PLS260VU()

	Local i
	Local lRet    := .T.
	Local aArea   := GetArea()
	Local aMsgErro:= {}

	RegToMemory("BA1")
	RegToMemory("BDK")
	RegToMemory("BDQ")


	IF M->BA3_COBNIV = "1"

		IF EMPTY(M->BA3_CODTES) 
			aADD( aMsgErro,{"<b> TIPO SAIDA </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_TIPPAG) 
			aADD( aMsgErro,{"<b> FORMA PAGAMENTO </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_XCONDI) 
			aADD( aMsgErro,{"<b> CONDICAO DE PAGAMENTO </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_VENCTO) 
			aADD( aMsgErro,{"<b> DIA DE VENCIMENTO </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_NATURE) 
			aADD( aMsgErro,{"<b> NATUREZA </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_MESREA) 
			aADD( aMsgErro,{"<b> MES REAJUSTE </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_CC) 
			aADD( aMsgErro,{"<b> CENTRO DE CUSTO </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_CLVL) 
			aADD( aMsgErro,{"<b> CLASSE VALOR </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF

		IF EMPTY(M->BA3_ZZVEND) 
			aADD( aMsgErro,{"<b> VENDEDOR DO CONTRATO </b>"       ," <b> CAMPO OBRIGAT�RIO!</b>"} )
		ENDIF


	ENDIF

	IF Len(aMsgErro) != 0
		lRet 	 := .F.
		cMsgErro := ""

		FOR i := 1 TO Len(aMsgErro)
			cMsgErro += aMsgErro[i][1] + CHR(13) + CHR(10)
		NEXT i
		MsgAlert("Favor preencher o(s) campo(s) abaixo:"  + CHR(13) + CHR(10) + CHR(13) + CHR(10) + cMsgErro,"ATEN��O! Campos Obrigat�rios")

	ENDIF  

	//MsgAlert("Deseja aplicar desconto permanete nos beneficiarios abaixo?")


	RestArea( aArea )


Return(lRet)




