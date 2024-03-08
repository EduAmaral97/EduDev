#INCLUDE "Protheus.ch" 
#INCLUDE 'TOPCONN.CH'

/* 
-----------------------------------------------------------------------------# 
								  PL660OPE									 #
-----------------------------------------------------------------------------# 
Funcao: PL660OPE 															 #
Autor: EDUARDO AMARAL   													 #
Data: 18/01/2024    														 #
Descricao: Ponto de entrada cadastro subcontrato.          					 #
PE: VERIFICAÇÃO ATES DE SALVAR UM SUBCONTRATO				                 #
*****************************************************************************#

*****************************************************************************#
*/

User Function PL660OPE()

Local i
Local lRet    := .T.
Local aArea   := GetArea()
Local aMsgErro:= {}


	IF M->BQC_COBNIV = "1"

		IF EMPTY(M->BQC_CODCLI) 
			aADD( aMsgErro,{"<b> CODIGO CLIENTE </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		IF EMPTY(M->BQC_NATURE) 
			aADD( aMsgErro,{"<b> NATUREZA </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		IF EMPTY(M->BQC_CC) 
			aADD( aMsgErro,{"<b> CENTRO DE CUSTO </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		IF EMPTY(M->BQC_CLVL) 
			aADD( aMsgErro,{"<b> CLASSE VALOR </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

	ENDIF

	IF Len(aMsgErro) != 0
		lRet 	 := .F.
		cMsgErro := ""

		FOR i := 1 TO Len(aMsgErro)
			cMsgErro += aMsgErro[i][1] + CHR(13) + CHR(10)
		NEXT i
		MsgAlert("Favor preencher o(s) campo(s) abaixo:"  + CHR(13) + CHR(10) + CHR(13) + CHR(10) + cMsgErro,"ATENÇÃO! Campos Obrigatórios")

	ENDIF  

	RestArea( aArea )

Return lRet
