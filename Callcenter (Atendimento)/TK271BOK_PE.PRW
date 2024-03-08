#INCLUDE "Protheus.ch" 
#INCLUDE 'TOPCONN.CH'
/*/ 
-----------------------------------------------------------------------------# 
								  TK271BOK									 #
-----------------------------------------------------------------------------# 
Funcao: TK271BOK 															 #
Autor: Alexandre Lacerda 													 #
Data: 07/12/16 																 #
Descricao: Ponto de entrada antes da gravaçãoo do atendimento no Call    #
            Center forï¿½ando o preenchimento obrigatï¿½rio do campo UB_OPER #
            na finalização do Orï¿½amento Call center                    #
*****************************************************************************#

-----------------------------------------------------------------------------# 
								 ALTERACOES   							     #
-----------------------------------------------------------------------------#
Funcao: TK271BOK 
Autor:Henrique												 				 #
Data: 09/01/2017                                             				 #
Solicitante: Rodrigo Zanotti                                 				 #
Descricao: Retirar obrigatoriedade de Preenchimento dos camp 				 #
		   os do Cabeï¿½alho do Atendimento, possibilitando maior agili 	 #
		   de na consulta de produtos                                   	 #
*****************************************************************************#

-----------------------------------------------------------------------------#
                               Alteracoes							 		 #
-----------------------------------------------------------------------------#
Funcao: TK271BOK 													         #
Autor: Cristina Iabuki												         #
Data: 05/09/2020 													         #
Solicitante: Alexandre Lacerda											     #
Descricao: Fonte analisado para 12.1.27 (Sxs para banco de dados)	         #
		   (SX1/SX2/SX3/Pswret-Tratamento)									 #	
*****************************************************************************#
*/

User Function TK271BOK()

Local i
Local aArea   := GetArea()
Local nTmAcol := LEN( aCols )
Local nCont   := 0
//Local nLimite := SUPERGETMV( "ZZ_LIMRETD", .F., 3)
Local cCodCont:= M->UA_CODCONT
Local cNomeCon:= M->UA_DESCNT
Local cCodCli := M->UA_CLIENTE
Local cCodLoja:= M->UA_LOJA
Local cChave  := Posicione("SA1", 1, xFilial("SA1") + cCodCli + cCodLoja, "A1_GRPTRIB")
Local cUFDest := SA1 -> A1_EST
Local cCliOld := ""
Local cEntOld := ""
Local aMsgErro:= {}
Local lRet    := .T.
Local lValDesc:= .F.   
Local nPosDel := Len( aCols[1] )
Local nPosTes := aScan( aHeader, { |x| ALLTRIM( UPPER( x[2] ) ) == "UB_TES"     } )
Local nPosOper:= aScan( aHeader, { |x| ALLTRIM( UPPER( x[2] ) ) == "UB_OPER"    } )
Local nPosDesc:= aScan( aHeader, { |x| ALLTRIM( UPPER( x[2] ) ) == "UB_ZPERDES" } )
Local nPosProd:= aScan( aHeader, { |x| ALLTRIM( UPPER( x[2] ) ) == "UB_PRODUTO" } )
Local ValProd:=  aScan( aHeader, { |x| ALLTRIM( UPPER( x[2] ) ) == "UB_VLRITEM" } )
Local DescontATM:=  M->UA_ZPDESAT
Local FatorDesc:= 0
Local TotProd:= 0
Local TotATM:= 0
Local cQuery1 := "SELECT ZZ7_FILIAL, ZZ7_NUMATM, ZZ7_IDPIPE, D_E_L_E_T_, R_E_C_N_O_, R_E_C_D_E_L_, ZZ7_VEND FROM ZZ7010 WHERE D_E_L_E_T_ = '' AND ZZ7_IDPIPE = '" + M->UA_ZIDPIP2 +  "'"  



			FOR i := 1 TO Len( aCols)
				IF !( aCols[i][ nPosDel])
					TotProd:= TotProd + aCols[i,ValProd]
				ENDIF
			NEXT i

			FatorDesc:= 1 - (DescontATM/100)
			TotATM:= TotProd * FatorDesc


If Select("ZZ7") > 0
     dbSelectArea("ZZ7")
     dbCloseArea()
EndIf
TcQuery cQuery1 New Alias ZZ7
dbSelectArea("ZZ7")

("SB2") -> ( DbClearFilter() )
("SB3") -> ( DbClearFilter() )
("DA1") -> ( DbClearFilter() )
("SC7") -> ( DbClearFilter() )
//("AliasPVP") -> ( DbClearFilter() )


IF nTmAcol > 0   
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAÇÃO DE POSICIONAMENTO DE CAMPOS	
		FOR i := 1 TO Len( aCols )
			IF aCols[i][ nPosDel ] .AND. !(lValDesc)
				lValDesc := .T. //Garanto que existe pelo menos 1 registro no Acols. Dessa forma valido o desconto pois ele pode estar incorreto.
				EXIT
			ENDIF
		NEXT i
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAÇÃO DE CAMPOS OBRIGATï¿½RIOS DO TELEVENDAS
	IF (Inclui .OR. Altera)	
		IF EMPTY(M->UA_VEND) .OR. M->UA_VEND = "000001"
			aADD( aMsgErro,{"<b> ÓDIGO VENDEDOR </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		IF EMPTY(M->UA_CONDPG)
			AADD( aMsgErro,{"<b> CONDICAO DE PAGAMENTO </b>" ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		IF EMPTY(M->UA_TABELA)
			AADD( aMsgErro,{"<b> TABELA </b>"				 ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		/*
		IF EMPTY(M->UA_MIDIA)
			AADD( aMsgErro,{"<b> MIDIA </b>"                 ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		*/
		/*
		IF EMPTY(M->UA_TMK) .OR. M->UA_TMK = "5"
			AADD( aMsgErro,{"<b> MARKETING </b>"             ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		*/
		IF EMPTY(M->UA_TPFRETE)
			AADD( aMsgErro,{"<b> TIPO DO FRETE </b>"         ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		IF EMPTY(M->UA_OPER)
			AADD( aMsgErro,{"<b> TIPO OPERACAO </b>"         ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		IF EMPTY(M->UA_TIPOCLI) 
			AADD( aMsgErro,{"<b> TIPO DO CLIENTE </b>"       ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF		

		// Incluído em: 04/12/2020 Por: Alexandre Lacerda		
		IF EMPTY(M->UA_ZMONTAG) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "12"                  
			AADD( aMsgErro,{"<b> MONTAGEM/PROD </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		// Incluído em: 18/02/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_ZPLOTAG) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "12"                  
			AADD( aMsgErro,{"<b> PLOTAGEM/PROD </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF
		
		// Incluído em: 04/12/2020 Por: Alexandre Lacerda
		IF EMPTY(M->UA_ZPRDMLT) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "3456"               
			AADD( aMsgErro,{"<b> PROD/MULTIFRIO </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		// Incluído em: 04/12/2020 Por: Alexandre Lacerda
		IF EMPTY(M->UA_ZPRDRIB) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "3456"                  
			AADD( aMsgErro,{"<b> PORTAS/METALRIB </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		// Incluído em: 18/02/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_ZMONTPN) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "3456"                  
			AADD( aMsgErro,{"<b> MONTAGEM PAINEL </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		// Incluído em: 18/02/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_ZCRTPNL) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "3456"                  
			AADD( aMsgErro,{"<b> CORTE PAINEL </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		ENDIF

		// Incluído em: 18/02/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_ZCODFRT) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "123456"                  
			AADD( aMsgErro,{"<b> TRANSPORTE </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )	
		ENDIF
/*
		// Incluído em: 18/02/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_CODCONT) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "123456" .AND. ( M->UA_VEND <> "000011" .AND.;
																							  	  M->UA_VEND <> "000052")              
			AADD( aMsgErro,{"<b> CONTATO </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )	
		ENDIF
*/

/* ---------------------------------------	O QUE ESTÁ VALENDO É ESTE ---------------------------------------*/
		
		// Incluído em: 25/02/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_ZIDPIPE) .AND. M->UA_OPER <> "3" .AND. M->UA_ZTIPVND $ "123456" .AND. (M->UA_VEND <> "000003" .AND.;
				 																			  M->UA_VEND <> "000004" .AND.;
																							  M->UA_VEND <> "000008" .AND.;
																							  M->UA_VEND <> "000010" .AND.;
																							  M->UA_VEND <> "000016" .AND.;
																							  M->UA_VEND <> "000020" .AND.;
																							  M->UA_VEND <> "000011" .AND.;
																							  M->UA_VEND <> "000099")

			AADD( aMsgErro,{"<b> GANHO NO PIPEDRIVE NÃO ENCONTRADO. FAVOR FECHAR O ATENDIMENTO E VERIFICAR OS CAMPOS NO PIPEDRIVE: NUMERO ATENDIMENTO, VALOR E GANHO </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		
		ENDIF

		// Incluído em: 04/08/2021 Por: Eduardo Jorge
		IF EMPTY(M->UA_ZCONTR) .AND. M->UA_OPER = "2" .AND. TotATM > 40000 .AND. (	M->UA_VEND <> "000003" .AND.;
				 																	M->UA_VEND <> "000004" .AND.;
																					M->UA_VEND <> "000008" .AND.;
																					M->UA_VEND <> "000010" .AND.;
																					M->UA_VEND <> "000016" .AND.;
																					M->UA_VEND <> "000020" .AND.;
																					M->UA_VEND <> "000052" .AND.;
																					M->UA_VEND <> "000011" .AND.;
																					M->UA_VEND <> "000096" .AND.;
																					M->UA_VEND <> "000097" .AND.;
																					M->UA_VEND <> "000092" .AND.;
																					M->UA_VEND <> "000099")

			AADD( aMsgErro,{"<b> O FLUXO NO 'PIPEFY CONTRATOS' NÃO ESTÁ CONCLUÍDO PARA ESTE ATENDIMENTO. </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
		
		ENDIF



/* --------------------------------------- Projetistas (Equipamentos e Industria) ---------------------------------------*/

		IF (M->UA_OPERADO = "000095" .OR.;
			M->UA_OPERADO = "000109" .OR.;
			M->UA_OPERADO = "000110" .OR.;
			M->UA_OPERADO = "000113")

			/*PRIMEIRA TRAVA - ID PIPEDRIVE VAZIO*/
			IF EMPTY(M->UA_ZIDPIP2)
			AADD( aMsgErro,{"<b> ID PIPEDRIVE VAZIO! (OBRIGATÓRIO UTILIZAÇÃO DO PIPEFY DE PROJETOS) </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
			
			
				/*SEGUNDA TRAVA - ID PIPEDRIVE NÃO ENCONTRADO NA TABELA ZZ7*/
				ELSEIF EMPTY(ZZ7->ZZ7_IDPIPE)
				AADD( aMsgErro,{"<b> ID PIPEDRIVE NÃO ENCONTRADO! (OBRIGATÓRIO UTILIZAÇÃO DO PIPEFY DE PROJETOS) </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
				
				/*TERCEIRA TRAVA - DEIXA SALVAR O ATENDIMENTO (PRIMEIRA VEZ QUE SALVA) E JOGA O NUMERO DO ATENDIMENTO NA TABELA ZZ7 VINCULADO PIPE COM ATENDIMENTO*/
				ELSEIF ZZ7->ZZ7_IDPIPE <> "" .AND.  EMPTY(ZZ7->ZZ7_NUMATM)
				TCSqlExec("UPDATE ZZ7010 SET ZZ7_NUMATM = '" + M->UA_NUM + "' FROM ZZ2010 WHERE ZZ7_IDPIPE = '" + M->UA_ZIDPIP2 +"'")

				/*QUARTA TRAVA - DEIXAR SALVAR O ATENDIMENTO QUE JÁ ESTÁ COM ALUM PIPE VINCULADO E JOGA NOVAMENTE O NUMERO DO ATENDIMENTO*/
				ELSEIF ZZ7->ZZ7_IDPIPE <> "" .AND. ZZ7->ZZ7_NUMATM = M->UA_NUM
				TCSqlExec("UPDATE ZZ7010 SET ZZ7_NUMATM = '" + M->UA_NUM + "' FROM ZZ2010 WHERE ZZ7_IDPIPE = '" + M->UA_ZIDPIP2 + "'")


				/*QUINTA TRAVA - ID PIPEDRIVE JÁ UTILIZADO EM OUTRO ATENDIMENTO*/
				ELSE 
				AADD( aMsgErro,{"<b> ID PIPEDRIVE JÁ UTILIZADO! </b>"  ," <b> CAMPO OBRIGATÓRIO!</b>"} )
			
			
			ENDIF

		ENDIF


/* --------------------------------------- Vendedores (Projetos - Equipamentos) ---------------------------------------*/


		/*
		TotATM > 40000 - USAR ESSA CONDICCIONAL PARA VERIFICAR SE VALOR DO ATENDIMENTO É MAIOR QUE 40K
		*/

		IF  (M->UA_OPERADO = "000064" .OR.;
			 M->UA_OPERADO = "000086")


		ENDIF


/* --------------------------------------- Vendedores (Varejo - Equipamentos Matriz) ---------------------------------------*/


		/*
		TotATM > 40000 - USAR ESSA CONDICCIONAL PARA VERIFICAR SE VALOR DO ATENDIMENTO É MAIOR QUE 40K
		*/

		IF  (M->UA_OPERADO = "000007" .OR.;
			 M->UA_OPERADO = "000028")


		ENDIF



/* --------------------------------------- Vendedores (Varejo - Equipamentos DP) ---------------------------------------*/


		/*
		TotATM > 40000 - USAR ESSA CONDICCIONAL PARA VERIFICAR SE VALOR DO ATENDIMENTO É MAIOR QUE 40K
		*/

		IF  (M->UA_OPERADO = "000030" .OR.;
			 M->UA_OPERADO = "000041")


		ENDIF

	
////////////////////////////////////////////////////////////////////////////////////////////////////////
	

		ZZ7->(dbCloseArea()) //Fecha a área de trabalho ZZ7


////////////////////////////////////////////////////////////////////////////////////////////////////////


		IF EMPTY(cCodCli) .OR. (cCodCli = "000001" .AND. cCodLoja = "02")
			AADD( aMsgErro,{"<b> CLIENTE </b> favor digitar um código válido ou altere a Loja do Cliente Padrão para 01"," <b> CAMPO OBRIGATÓRIO! </b> "} )
		ELSE


////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAÇÃO DE GRUPO TRIBUTï¿½RIO DO CLIENTE
			IF Posicione("SA1",1,"01  " + cCodCli,"A1_PESSOA" ) <> SUBSTR(cChave, 1, 1)
				AADD( aMsgErro,{"<b> GRUPO TRIBUTï¿½RIO </b> em Desacordo com o Tipo de Pessoa do Cliente, Acesse o Menu 'Outras Aï¿½ï¿½es' > 'Alteração da Entidade' e corrija os campos Relacionados"      ,"CAMPO OBRIGATï¿½RIO!"} )
			ENDIF
			IF Posicione("SA1",1,"01  " + cCodCli,"A1_TIPO"   ) <> SUBSTR(cChave, 2, 1)
				AADD( aMsgErro,{"<b> GRUPO TRIBUTï¿½RIO </b> em Desacordo com o Tipo de Consumidor do Cliente, Acesse o Menu 'Outras Aï¿½ï¿½es' > 'Alteração da Entidade' e corrija os campos Relacionados"  ,"CAMPO OBRIGATï¿½RIO!"} )
			ENDIF
			IF Posicione("SA1",1,"01  " + cCodCli,"A1_CONTRIB") <> SUBSTR(cChave, 3, 1)
				AADD( aMsgErro,{"<b> GRUPO TRIBUTï¿½RIO </b> em Desacordo com o Tipo de Contribuição do Cliente, Acesse o Menu 'Outras Aï¿½ï¿½es' > 'Alteração da Entidade' e corrija os campos Relacionados","CAMPO OBRIGATï¿½RIO!"} )
			ENDIF
		ENDIF
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAï¿½ï¿½ES DE CONTATO, RETORNO E HORA DE RETORNO
/*
		// Tratamento Pswret
		//IF PswRet()[1][10][1] $ ("000008\000009\000010") //SOMENTE LOJA ZANOTTI
		IF  u_FZntGrp(PswId(),"000008\000009\000010","") //SOMENTE LOJA ZANOTTI
		 	IF EMPTY(M->UA_CODCONT)
		 		AADD( aMsgErro,{" <b> CONTATO </b>", "<b> CAMPO OBRIGATï¿½RIO!</b>"} )
			ENDIF
			IF M->UA_OPER $("3\4") //SOMENTE LOJA ZANOTTI - ATENDIMENTOS/PROSPECçÃO
				IF EMPTY(M->UA_HRPEND)
					AADD( aMsgErro,{" <b> HORA </b>", "<b> CAMPO OBRIGATï¿½RIO!</b>"} )
				ENDIF
				IF EMPTY(M->UA_PROXLIG)
					AADD( aMsgErro,{"<b>DATA DE RETORNO</b>", "<b> CAMPO OBRIGATï¿½RIO!</b>"} )
				ELSEIF M->UA_PROXLIG == dDataBase
					IF M->UA_HRPEND < (SUBSTR(TIME(), 1, 2) + SUBSTR(TIME(), 4, 2))
						AADD( aMsgErro,{"<b>HORA DE RETORNO,</b> Hora de Retorno nï¿½o poderï¿½ ser menor do que a Hora Atual","PREENCHIMENTO INCORRETO!"} )
					ENDIF
				ELSEIF M->UA_PROXLIG < dDataBase 
					AADD( aMsgErro,{"<b>DATA DE RETORNO,</b> Data de Retorno nï¿½o poderï¿½ ser menor do que a Data Atual","PREENCHIMENTO INCORRETO!"} )
				ELSEIF M->UA_PROXLIG > MonthSum( dDataBase, nLimite )
					AADD( aMsgErro,{"<b>DATA DE RETORNO,</b> Data de Retorno nï¿½o poderï¿½ ultrapassar o limite de " + cValToChar( nLimite ) + " meses.","PREENCHIMENTO INCORRETO!"} )
				ENDIF
			ENDIF
		ENDIF	
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAÇÃO DE DESCONTO
		IF lValDesc 
			IF aVALORES[2] > 0.99 // VALIDAR DESCONTOS ACIMA DE 1 REAL
				IF ( ( ( aVALORES[1] * M -> UA_ZPDESAT ) / 100 ) != aVALORES[2] )
					AADD( aMsgErro, {"<b>DESCONTO</b>, Favor atualizar o Campo !!","ATENÇÃO!"} )
				ENDIF
			ENDIF
		ENDIF
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAÇÃO FISCAL CLIENTE/PRODUTO
		IF M->UA_OPER != "1"
			FOR nCont := 1 TO nTmAcol
				IF !( aCols[ nCont, nPosDel ] ) 	//Confere se registro foi deletado
					IF EMPTY( aCols[ nCont, nPosOper ] )
						AADD( aMsgErro,{"<b> TIPO DE OPERAçÃO 		</b>", "<b> CAMPO OBRIGATï¿½RIO!</b>"} )
					ENDIF
					IF Empty( aCols[ nCont, nPosTes ] )
						AADD( aMsgErro, {"<b> TIPO DE ENTRADA E SAï¿½DA </b>", "<b> CAMPO OBRIGATï¿½RIO!</b>"} )
					ELSE
						DO CASE
							CASE ( Posicione("SB1",1,xFilial("SB1") + aCols[ nCont, 2 ], "B1_GRTRIB" ) == "000009")
								IF cUFDest <> "SP" //VENDAS FORA DO ESTADO DE Sï¿½O PAULO ------------------------------------------------------------------------------------
									IF aCols[ nCont, nPosOper] == "01"											
										DO CASE
											CASE cChave == "FF2" //PESSOA FISICA/VENDA FORA ESTADO/CONSUMIDOR FINAL/NÃO CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "501"												 
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>FF2 EM DESACORDO</b> para Operação '01' FORA DO ESTADO", "ATENÇÃO!"} )
												ENDIF
											CASE cChave == "FL1"//PESSOA FISICA/VENDA FORA ESTADO/PRODUTOR RURAL/CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "80A"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>FL1 EM DESACORDO</b> para Operação '01' FORA DO ESTADO", "ATENÇÃO!"} )
												ENDIF 
											CASE cChave == "JF1"//PESSOA JURIDICA/VENDA FORA ESTADO/CONSUMIDOR FINAL/CONTRIBUINTE
												IF aCols[ nCont,nPosTes ] <> "80A"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JF1 EM DESACORDO</b> para Operação '01' FORA DO ESTADO", "ATENÇÃO!"} )
												ENDIF
											CASE cChave == "JR1"//PESSOA JURIDICA/VENDA FORA ESTADO/REVENDEDOR/CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "80A"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont,nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JR1 EM DESACORDO</b> para Operação '01' FORA DO ESTADO", "ATENÇÃO!"} )
												ENDIF
										ENDCASE
									ELSEIF aCols[ nCont, nPosOper] == "V"
										DO CASE
											CASE cChave == "JF1" //PESSOA FISICA/VENDA FORA ESTADO/CONSUMIDOR FINAL/NÃO CONTRIBUINTE
												IF aCols[ nCont,nPosTes ] <> "80B"												 
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JF1 EM DESACORDO</b> para Operação 'V' FORA DO ESTADO", "ATENÇÃO!"} )
												ENDIF
										ENDCASE
									ENDIF
								ELSE //VENDAS DENTRO DO ESTADO DE SAO PAULO ----------------------------------------------------------------------------------------------
									IF aCols[ nCont, nPosOper] == "01"	
										DO CASE
											CASE cChave == "FF2" //PESSOA FISICA/VENDA DENTRO ESTADO/CONSUMIDOR FINAL/NÃO CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "505"												 
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>FF2 EM DESACORDO</b> para Operação '01' DENTRO DO ESTADO", "ATENÇÃO!"})
												ENDIF
											CASE cChave == "FL1"//PESSOA FISICA/VENDA DENTRO ESTADO/PRODUTOR RURAL/CONTRIBUINTE
												IF aCols[ nCont, nPosTes] <> "505"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>FL1 EM DESACORDO</b> para Operação '01' DENTRO DO ESTADO", "ATENÇÃO!"})
												ENDIF
											CASE cChave == "JF1"//PESSOA JURIDICA/VENDA DENTRO ESTADO/CONSUMIDOR FINAL/CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "505"
													AADD( aMsgErro,{"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JF1 EM DESACORDO</b> para Operação '01' DENTRO DO ESTADO", "ATENÇÃO!"} )
												ENDIF
											CASE cChave == "JR1"//PESSOA JURIDICA/VENDA DENTRO ESTADO/REVENDEDOR/CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "505"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JR1 EM DESACORDO</b> para Operação '01' DENTRO DO ESTADO", "ATENÇÃO!"} )
												ENDIF
										ENDCASE
									ELSEIF aCols[ nCont, nPosOper] == "V"
										DO CASE
											CASE cChave == "FF2" //PESSOA FISICA/VENDA DENTRO ESTADO/CONSUMIDOR FINAL/NÃO CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "705"												 
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>FF2 EM DESACORDO</b> para Operação 'V' DENTRO DO ESTADO", "ATENÇÃO!"} )
												ENDIF
											CASE cChave == "JF1"//PESSOA JURIDICA/VENDA DENTRO ESTADO/CONSUMIDOR FINAL/CONTRIBUINTE
												IF aCols[ nCont, nPosTes ] <> "705"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont,2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JF1 EM DESACORDO</b> para Operação 'V' DENTRO DO ESTADO", "ATENÇÃO!"} )
												ENDIF
											CASE cChave == "JR1"//PESSOA JURIDICA/VENDA FORA ESTADO/REVENDEDOR/CONTRIBUINTE
												IF aCols[nCont,nPosTes] <> "705"
													AADD( aMsgErro, {"PRODUTO:" + aCols[ nCont, 2 ] + "-" + "<b> TES " + aCols[ nCont, nPosTes ] + " </b> e Grupo Tributario do Cliente <b>JR1 EM DESACORDO</b> para Operação 'V' DENTRO DO ESTADO", "ATENÇÃO!"} )
												ENDIF
										ENDCASE
									ENDIF
								ENDIF
						ENDCASE
					ENDIF
				ENDIF
			NEXT nCont
		ELSEIF M->UA_OPER == "1"
			AADD( aMsgErro, {"Tipo de Operação : 'FATURAMENTO' Boqueado para uso. Altere o Tipo de Operação para : 2 - Orçamento ou 3 - Atendimento ou 4 - Liberado p/Faturamento", "ATENÇÃO!" } )
		ENDIF
////////////////////////////////////////////////////////////////////////////////////////////////////////
//VALIDAÇÃO DE PRODUTOS EM PROMOÇÃO
		FOR i := 1 TO Len( aCols)
			IF !( aCols[i][ nPosDel])
				IF !( EMPTY( aCols[i][ nPosDesc] ) )
					IF U_ConfSaldo( aCols[i][ nPosProd] ) <= 0 .AND. aCols[ i, nPosTes ] != "890"
						AADD( aMsgErro,{"Produto : " + aCols[i][ nPosProd] +" <b>EM PROMOÇÃO</b> porï¿½m <b>SEM SALDO</b> Disponï¿½vel","ATENÇÃO!"})
					ENDIF
				ENDIF
			ENDIF
		NEXT i
		//VALIDAÇÃO DE PRODUTOS DE PROSPECçÃO
		IF !( M -> UA_OPER $ "3\4" )
			FOR i := 1 TO Len( aCols)
				IF !( aCols[i][ nPosDel])
					IF "ZZZZZZ" $ aCols[i][ nPosProd]
						AADD( aMsgErro,{ "PRODUTOS DE PROSPCçÃO ENCONTRADO 'ZZZZZZ'! " + CHR(10) + CHR(13) + "ORÇAMENTO SOMENTE PODERï¿½ SER FINALIZADO COMO 'ATENDIMENTO' - OPCçÃO '3' ", "ATENÇÃO"})
						EXIT
					ENDIF
				ENDIF
			NEXT i
		ENDIF		
////////////////////////////////////////////////////////////////////////////////////////////////////////	
//VALIDAÇÃO DE PRODUTOS LIBERADOS TEMPORARIAMENTE / EM PROMOCAO
		IF Len( aMsgErro ) = 0
			FOR i := 1 TO Len( aCols)
				IF !( aCols[i][ nPosDel])
					IF (Posicione("SB1",1,xFilial("SB1") + aCols[i][2],"B1_ZLIBTMP") == "S")
						IF RecLock("SB1",.F.) 
							B1_ZLIBTMP := "N"
							MSUnlock()
						ENDIF
					ENDIF
				ENDIF
			NEXT i
////////////////////////////////////////////////////////////////////////////////////////////////////////
//LIMPA VARIAVEL GLOBAL QUE ARMAZENA CODIGO DE CONTATO -- SISTEMA APAGAVA COD CONTATO AO MUDAR FOCO DA JANELA
			__cContat := ""	
		ENDIF
	ENDIF		
ELSE
	AADD( aMsgErro,{ "Nenhum Item no Orï¿½amento" } )
ENDIF

IF Len(aMsgErro) != 0
	lRet 	 := .F.
	cMsgErro := ""
	FOR i := 1 TO Len(aMsgErro)
		cMsgErro += aMsgErro[i][1] + CHR(13) + CHR(10)
	NEXT i
	MsgAlert("Favor preencher o(s) campo(s) abaixo:"  + CHR(13) + CHR(10) + CHR(13) + CHR(10) + cMsgErro,"ATENÇÃO! Campos Obrigatórios")
// Tratamento Pswret	
//ELSEIF PswRet()[1][10][1] $ ("000001|000002|000005|000008|000009|000010|000011|000013") .AND. (M->UA_OPER == "2" .OR. M->UA_OPER == "4" .OR. EMPTY(M->UA_ZDTAENT) ) 	
//ELSEIF u_FZntGrp(PswId(),"000001|000002|000005|000008|000009|000010|000011|000013","") .AND. (M->UA_OPER == "2" .OR. M->UA_OPER == "4" .OR. EMPTY(M->UA_ZDTAENT) ) 
ELSEIF u_FZntGrp(PswId(),"000001|000002|000005|000008|000009|000010|000011|000013","") .AND. (M->UA_OPER == "2" .OR. M->UA_OPER == "4") 
	
	
	//Incluído em: 24/01/2020 Por: Alexandre Lacerda ( Validação Ganho PipeDrive )
	//lRet := U_ZNTAPIPIPE(M->UA_FILIAL,M->UA_NUM,M->UA_VEND,M->UA_VLRLIQ)
	
	lRet 	:= U_ZNTPRZENT()
ENDIF         

IF M->UA_OPER = "2" .AND. lRet

	IF lRet .AND. ( M->UA_CLIENTE == "000001" .OR. VAL( M->UA_CLIENTE ) == 0 .OR. "CONSUMIDOR" $ SA1 -> A1_NOME )
		IF MsgYesNo("Deseja converter o Contato para Cliente e utilizï¿½-lo neste Orï¿½amento?")					
			BEGIN TRANSACTION
				IF U_CriaSA1(cCodCont, cNomeCon) != "erro"  //CRIA REGISTRO NA SA1 CONFORME CONTATO PASSADO
					cCliOld := M->UA_CLIENTE
					M->UA_CLIENTE := SA1 -> A1_COD  	//ALTERO CLIENTE DO ORÇAMENTO//
					M->UA_LOJA	  := SA1 -> A1_LOJA		//ALTERO LOJA DO ORÇAMENTO---//
					U_ExecGat() //CASO SUCESSO - ALTERA ENTIDADE NA AC8
					DbSelectArea("AC8")
					DbSetOrder(1)
					DbGoTop()
					IF DbSeek( xFilial("AC8") + cCodCont )
						cEntOld := AC8_CODENT
						IF RecLock("AC8", .F.)
							AC8_CODENT := ALLTRIM( M->UA_CLIENTE ) + ALLTRIM( M->UA_LOJA )
							MsUnlock()
							
							MsgAlert("Orï¿½amento: " + M->UA_NUM           + CHR(10) + CHR(13) +;
								 "	Cliente Alterado de: " + cCliOld       + CHR(10) + CHR(13) +;
								 "	Para			   : " + M->UA_CLIENTE + CHR(10) + CHR(13) +;
								 ""							    		   + CHR(10) + CHR(13) +;
								 "Associação do Contato: "            	   + CHR(10) + CHR(13) +;
								 "  De				   : " + cEntOld 	   + CHR(10) + CHR(13) +;
								 "	Para			   : " + AC8_CODENT				            ;
								 )	
							M->UA_CODCONT:= cCodCont
							M->UA_DESCNT := cNomeCon
							
							DbSelectArea("SU6")
							DbSetOrder(2)
							IF DbSeek( xFilial("SU6") + DTOS( DATE() ) + cEntOld)
								IF RecLock("SU6", .F.)
									SU6 -> U6_CODENT  := AC8 -> AC8_CODENT	
									MsUnlock()
								ENDIF
							ENDIF
							IF ExistTrigger("UA_CODCONT")			//EXECUTO GATILHOS DO CAMPO--//
								RunTrigger(1, NIL, NIL, , "UA_CODCONT")
							ENDIF			
							IF ExistTrigger("UA_DESCNT")			//EXECUTO GATILHOS DO CAMPO--//
								RunTrigger(1, NIL, NIL, , "UA_DESCNT")
							ENDIF 
						ELSE
							DisarmTransaction()
						ENDIF
					ELSE
						DisarmTransaction()
					ENDIF
				ELSE	
					DisarmTransaction()
				ENDIF						
			END TRANSACTION			
		ENDIF
	ENDIF
ENDIF

RestArea( aArea )

Return lRet
