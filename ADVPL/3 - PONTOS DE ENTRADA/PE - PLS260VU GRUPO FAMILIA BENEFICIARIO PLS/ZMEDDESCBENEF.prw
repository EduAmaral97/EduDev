#INCLUDE "Protheus.ch" 
#INCLUDE 'TOPCONN.CH'


User Function ZMEDDESCBENEF()

	Local aArea   := GetArea()
	Local cFiltro 
	Local cFiltroBDK 
	Local cFiltroBDQ 
	Local cBenefi
	Local cValor
	Local cMsgFinal := ""

	DbSelectArea("BA1")
	cFiltro := "BA1->BA1_FILIAL == '"+BA3->BA3_FILIAL+"' .AND. "
	cFiltro += "BA1->BA1_CODINT == '"+BA3->BA3_CODINT+"' .AND. "
	cFiltro += "BA1->BA1_CODEMP == '"+BA3->BA3_CODEMP+"' .AND. "
	cFiltro += "BA1->BA1_CONEMP == '"+BA3->BA3_CONEMP+"' .AND. "
	cFiltro += "BA1->BA1_VERCON == '"+BA3->BA3_VERCON+"' .AND. "
	cFiltro += "BA1->BA1_SUBCON == '"+BA3->BA3_SUBCON+"' .AND. "
	cFiltro += "BA1->BA1_VERSUB == '"+BA3->BA3_VERSUB+"' .AND. "
	cFiltro += "BA1->BA1_MATEMP == '"+BA3->BA3_MATEMP+"' .AND. "
	cFiltro += "BA1->BA1_MATRIC == '"+BA3->BA3_MATRIC+"' "
    BA1->( dbSetFilter( { || &cFiltro }, cFiltro ) )

	BA1->(dbGoTOP())

    While BA1->(!EOF())

		DbSelectArea("BDK")
		cFiltroBDK := "BDK->BDK_FILIAL == '"+BA1->BA1_FILIAL+"' .AND. "
		cFiltroBDK += "BDK->BDK_CODINT == '"+BA1->BA1_CODINT+"' .AND. "
		cFiltroBDK += "BDK->BDK_CODEMP == '"+BA1->BA1_CODEMP+"' .AND. "
		cFiltroBDK += "BDK->BDK_MATRIC == '"+BA1->BA1_MATRIC+"' .AND. "
		cFiltroBDK += "BDK->BDK_TIPREG == '"+BA1->BA1_TIPREG+"' "
		BDK->( dbSetFilter( { || &cFiltroBDK }, cFiltroBDK ) )
		BDK->(dbGoTOP())

		DbSelectArea("BDQ")
		cFiltroBDQ := "BDQ->BDQ_FILIAL == '"+BA1->BA1_FILIAL+"' .AND. "
		cFiltroBDQ += "BDQ->BDQ_CODINT == '"+BA1->BA1_CODINT+"' .AND. "
		cFiltroBDQ += "BDQ->BDQ_CODEMP == '"+BA1->BA1_CODEMP+"' .AND. "
		cFiltroBDQ += "BDQ->BDQ_MATRIC == '"+BA1->BA1_MATRIC+"' .AND. "
		cFiltroBDQ += "BDQ->BDQ_TIPREG == '"+BA1->BA1_TIPREG+"' "		
		BDQ->( dbSetFilter( { || &cFiltroBDQ }, cFiltroBDQ ) )
		BDQ->(dbGoTOP())

		If BDQ->(EOF())

			IF BDK->BDK_VALOR <= 0.01

				cBenefi := BA1->BA1_NOMUSR
				cValor	:= BDK->BDK_VALOR

				cMsgFinal += " - " + cBenefi + " VALOR : R$ " + STR(cValor) + CHR(13)+CHR(10)

			EndIF
			
		Endif
	        
		BA1->(dbSkip())
		BDK->(DbCloseArea())
		BDQ->(DbCloseArea())

    End


	If MsgYesNo("Deseja aplicar o desconto automatico nos beneficiarios abaixo?" + CHR(13)+CHR(10) + cMsgFinal, "Desconto Automatico Medicar")
		
		BA1->(dbGoTOP())

		While BA1->(!EOF())

			RecLock("BDQ", .T.)
					BDQ->BDQ_FILIAL := BA1->BA1_FILIAL
					BDQ->BDQ_CODINT := BA1->BA1_CODINT
					BDQ->BDQ_CODEMP := BA1->BA1_CODEMP
					BDQ->BDQ_MATRIC := BA1->BA1_MATRIC
					BDQ->BDQ_TIPREG := BA1->BA1_TIPREG
					BDQ->BDQ_CODFAI := "001"
					BDQ->BDQ_PERCEN := 0
					BDQ->BDQ_VALOR  := 0.01
					BDQ->BDQ_QTDMIN := 0
					BDQ->BDQ_QTDMAX := 999
					BDQ->BDQ_TIPO   := "1"
					BDQ->BDQ_DATDE  := CToD("01/01/2000")
					BDQ->BDQ_DATATE := CToD("31/12/2900")
			BDQ->(MsUnlock())
			//ConfirmSX8()

			BA1->(dbSkip())

		End		

		MsgInfo("Desconto aplicado.","Desconto automatico Medicar")

	Else
		
		MsgInfo("Desconto nao aplicado." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "Operacao cancelada.","Desconto automatico Medicar")

	EndIf


	RestArea( aArea )

Return




