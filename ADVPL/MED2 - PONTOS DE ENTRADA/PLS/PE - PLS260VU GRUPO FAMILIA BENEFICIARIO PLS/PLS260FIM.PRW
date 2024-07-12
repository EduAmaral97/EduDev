#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} PLS260FIM
Executa no final do processamento do cadastro de beneficiarios
@version P12
/*/
//-------------------------------------------------------------------
User Function PLS260FIM()

    //APLICA DESCONTO EM BENEFICIARIO QUANDO O VALOR FOR "0.01"
    ZMEDDESCBENEF()

    GravaCartei()
    If ALLTRIM(BA1->BA1_FILIAL) != "016"
        IntegIRIS()
    endif

    GravaRotina()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} IntegIRIS
Realiza a integracao com o sistema IRIS.
@version P12
/*/
//-------------------------------------------------------------------
Static Function IntegIRIS()

    If Inclui .OR. Altera
        BA1->(DbSetOrder(2)) //BA1_FILIAL+BA1_CODINT+BA1_CODEMP+BA1_MATRIC+BA1_TIPREG+BA1_DIGITO
	    If BA1->( MsSeek( xFilial("BA1") + BA3->(BA3_CODINT + BA3_CODEMP + BA3_MATRIC + "00")))
            if Inclui
                FWMsgRun(, {|| U_IZGrvFila(BA1->(Recno()),BA3->(Recno()),BQC->(Recno()),BG9->(Recno()),"1") },"Aguarde", "Integração com o sistema IRIS colocada na fila de execução...")
            elseif Altera
                FWMsgRun(, {|| U_IZGrvFila(BA1->(Recno()),BA3->(Recno()),BQC->(Recno()),BG9->(Recno()),"2") },"Aguarde", "Atualização do contrato colocada na fila de execução...")
                FWMsgRun(, {|| U_IZGrvFila(BA1->(Recno()),BA3->(Recno()),BQC->(Recno()),BG9->(Recno()),"3") },"Aguarde", "Atualização da vida colocada na fila de execução...")
            Endif
        EndIf
    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GravaCartei
Grava a numeração da carteirinha do beneficiário
@version P12
/*/
//-------------------------------------------------------------------
Static Function GravaCartei()

    Local oGravaCartei := NumCarteirinha():New()

    If Inclui .OR. Altera
       FWMsgRun(, {||  oGravaCartei:GeraCartei() },"Aguarde", "Gerando a numeração da carteirinha...")
    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GravaRotina
Grava o campo BA3_ROTINA
@version P12
/*/
//-------------------------------------------------------------------
Static Function GravaRotina()

    Local aAreaBA3 := GetArea()
    Local aAreaBA1 := GetArea()

    If (Inclui .OR. Altera) .AND. Empty(BA3->BA3_ROTINA)

        BA3->(RecLock("BA3",.F.))
            BA3->BA3_ROTINA := "PLSPORFAI"
        BA3->(MsUnLock())
    EndIf

    If (Inclui .OR. Altera)
        //Atualiza os campos obrigatórios do Cliente
        BA1->(DbSetOrder(1))
		If BA1->( MsSeek( xFilial("BA1") + BA3->(BA3_CODINT + BA3_CODEMP + BA3_MATRIC)))
            If BA1->BA1_TIPUSU == "T" .AND. !Empty(BTS->BTS_CPFUSR) .AND. AllTrim(BTS->BTS_CPFUSR) == AllTrim(BA1->BA1_CPFUSR)
                If Empty(BA1->BA1_EMAIL)
                    BA1->(RecLock("BA1", .F.))
                        BA1->BA1_EMAIL	:= BTS->BTS_EMAIL
                    BA1->(MsUnlock())
                endIf

                SA1->(DbSetOrder(3))
                If SA1->(DbSeek(xFilial("SA1")+AllTrim(BTS->BTS_CPFUSR)))
                    SA1->(RecLock("SA1", .F.))
                    //SA1->A1_RECISS	:= "1" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_INCISS 	:= "N" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_RECINSS	:= "S" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_RECIRRF	:= "1" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_SIMPNAC   := "2" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_RECPIS 	:= "S" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_RECCOFI   := "S" //Solicitado pelo Eduardo em 17/04/2024
                    //SA1->A1_RECCSLL   := "S" //Solicitado pelo Eduardo em 17/04/2024
                    SA1->A1_PAIS	:= "105"
                    SA1->A1_CODPAIS	:= "01058"
                    SA1->A1_TPESSOA := "PF"
                    SA1->(MsUnlock())
                Endif
            EndIf
        EndIf
    EndIf

    RestArea(aAreaBA1)
    RestArea(aAreaBA3)

Return 

//-------------------------------------------------------------------
/*/{Protheus.doc} ZMEDDESCBENEF
Disponibiliza a possibilidade do desconto automatico (Se o Usuario aceitar).
@version P12
/*/
//-------------------------------------------------------------------
Static Function ZMEDDESCBENEF()

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

	IF cMsgFinal <> ""

		If MsgYesNo("Deseja aplicar o desconto automatico nos beneficiarios abaixo?" + CHR(13)+CHR(10) + cMsgFinal, "Desconto Automatico Medicar")
		

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
						
					EndIF

				Endif
				
				BDK->(DbCloseArea())
				BQD->(DbCloseArea())
				BA1->(dbSkip())
				
			End		
	

			MsgInfo("Desconto aplicado.","Desconto automatico Medicar")

		Else
			
			MsgInfo("Desconto nao aplicado." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "Operacao cancelada.","Desconto automatico Medicar")

		EndIf


	EndIF



	RestArea( aArea )

Return

