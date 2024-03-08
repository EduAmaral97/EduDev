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
PE: VERIFICAÇÃO ATES DE SALVAR UM SUBCONTRATO				                 #
*****************************************************************************#

*****************************************************************************#
*/

/*

A260MOV:2556 Fonte: PLSA260.PRW 28/06/2023 15:05:18
PLSA260MOV:1252 Fonte: PLSA260.PRW 28/06/2023 15:05:18
PLSA260FAM:391 Fonte: PLSA260.PRW 28/06/2023 15:05:18
PLSA260:275 Fonte: PLSA260.PRW 28/06/2023 15:05:18

*/



/*

Local i
Local lRet    := .T.
Local aArea   := GetArea()
Local aMsgErro:= {}


	IF M->BQC_COBNIV = "1"

		IF EMPTY(M->BQC_CODCLI) 
			aADD( aMsgErro,{"<b> CODIGO CLIENTE </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
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

*/



User Function A260MOV()
Local lRet:= .T.


Return(lRet)




