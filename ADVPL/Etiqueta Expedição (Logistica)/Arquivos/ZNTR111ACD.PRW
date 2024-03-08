
#include "PROTHEUS.CH"
#include "RWMAKE.CH"

User Function ZNTR110ACD( cNota, cSerie, cCliente, cLoja )

Local cArea    		:= GetArea()
Local lImpEtq		:= .F.

Private cPerg  		:= ""
Private nTotEtqItm	:= 0
Private aPerg  		:= {"ZNTR110P01","ZNTR103P02"}
Private lAbortPrint	:=.F.
Private nRadio 		:= 1
Private aItems 		:= {"Imprimir Etiquetas por Documento de Saida (NF-e / RP)","Imprimir Etiquetas Avulsas conforme cadastro do produto"}  
  
Default cNota    	:= Space(09)
Default cSerie   	:= Space(03)
Default cCliente 	:= Space(06)
Default cLoja    	:= Space(02)
Default cPort		:= Space(04)
Default cEoL 		:= CHR(13)+CHR(10)
	
AjustaSX1( cPerg := aPerg[nRadio] )
lImpEtq := U_ZNTR110OPC()

If lImpEtq
	Processa( {|| ZNTR110IMP() }, "Aguarde...", "Imprimindo Etiquetas!..",.T.)
EndIf

RestArea( cArea )
Return

//Imprime etiquetas com dados da nota.
Static Function ZNTR110IMP()

	Local i        	:= 0
	Local nItmAtual	:= 0
	Local nTotItmDoc:= 0		
	
	Local cQuery 	:= ""
	Local cQuery1 	:= ""
	Local lPortaOk	:= .T.
	Local cPorta	:= "LPT4"

	Local cMsgErr	:= ""
	Local lErrImp	:= .F.
	Local lImpEtq	:= .F.
	Local lPrdBlq 	:= .F.
	//Local lMovEstq 	:= .F.
	Local nLenPrd	:=  0
	Local nLimMax	:= 50
	Local cTipImp	:= "H"      // H = Impressão Horizontal da Etiqueta (150x100mm)     V = Impressão Vertical da Etiqueta (100x150mm)  
	Local lTstImp	:= .F.
	Local _cFileLogo := ""
	Local cBitmap	:= ""
	Local cTotal	:= ""
	
	cBitmap := R110ALogo()	//Chama a função com o caminho do bitmap

	
	_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap // pegar arquivo bitmap

		
		cQuery1 := " SELECT SF2V.F2_VOLUME1 AS VOLUMESF2 "
		cQuery1 += " FROM " + RetSqlName("SF2") + " AS SF2V "
		cQuery1 += " WHERE 1=1" 
		cQuery1 += " AND SF2V.D_E_L_E_T_ = ''" 
		cQuery1 += " AND SF2V.F2_SERIE = '"+ MV_PAR02 +"' 
		cQuery1 += " AND SF2V.F2_DOC = '"+ MV_PAR01 +"'"
		cQuery1 += " AND SF2V.F2_CLIENTE = '"+ MV_PAR03 +"'"
		cQuery1 += " AND SF2v.F2_LOJA = '"+ MV_PAR04 +"'"

				cQuery1 := ChangeQuery( cQuery1 )
				DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery1 ), "TMPSF2" , .T., .T. )
	               		
    			dbSelectArea("TMPSF2")

				cTotal := TMPSF2->VOLUMESF2
	
				

	If nRadio = 1
	
		cQuery +=	" SELECT SF2.F2_FILIAL AS FILIAL, SF2.F2_SERIE AS SERIE, SF2.F2_DOC AS DOC, SB1.B1_COD AS CODPROD, SB1.B1_MSBLQL AS PROD_BLQ, SB1.B1_ZIMPETQ AS IMP_ETQ, SB1.B1_ZDESRDZ AS PRODUTO, SB1.B1_CODBAR AS CODBAR, SD2.D2_ITEM AS ITEM, SB1.B1_ZAPRES1 AS COD_APRES, "
		cQuery +=	" CONCAT(SUBSTRING(SF2.F2_EMISSAO,7,2), '/', SUBSTRING(SF2.F2_EMISSAO,5,2), '/', SUBSTRING(SF2.F2_EMISSAO,1,4)) AS EMISSAO, "
		cQuery +=	" SA1.A1_COD AS COD_CLI, SA1.A1_NOME AS CLIENTE, CONCAT(TRIM(SA1.A1_MUN),' / ',SA1.A1_EST) AS CIDADE, "
		cQuery +=	" SA4.A4_NOME AS EXPEDICAO, "
		cQuery +=	" SD2.D2_QUANT AS QTD "
		cQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
		cQuery += 	" LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA "
		cQuery +=	" LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_DOC = SF2.F2_DOC "
		cQuery +=	" LEFT JOIN " + RetSqlName("SC9") + " SC9 ON SC9.D_E_L_E_T_ = '' AND SC9.C9_FILIAL = SF2.F2_FILIAL AND SC9.C9_SERIENF = SF2.F2_SERIE AND SC9.C9_NFISCAL = SF2.F2_DOC "
		cQuery +=	" LEFT JOIN " + RetSqlName("SL1") + " SL1 ON SL1.D_E_L_E_T_ = '' AND SL1.L1_FILIAL = SC9.C9_FILIAL AND SL1.L1_PEDRES = SC9.C9_PEDIDO "
		cQuery +=	" LEFT JOIN " + RetSqlName("SUA") + " SUA ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = SL1.L1_FILIAL AND SUA.UA_NUM = SL1.L1_NUMATEN "
		cQuery +=	" LEFT JOIN " + RetSqlName("SL1") + " SL1501 ON SL1501.D_E_L_E_T_ = '' AND SL1501.L1_FILIAL = SF2.F2_FILIAL AND SL1501.L1_SERIE = SF2.F2_SERIE AND SL1501.L1_DOC = SF2.F2_DOC "
		cQuery +=	" LEFT JOIN " + RetSqlName("SUA") + " SUA501 ON SUA501.D_E_L_E_T_ = '' AND SUA501.UA_FILIAL = SL1501.L1_FILIAL AND SUA501.UA_NUM = SL1501.L1_NUMATEN "
		cQuery +=	" LEFT JOIN " + RetSqlName("SA4") + " SA4 ON SA4.D_E_L_E_T_ = '' AND SA4.A4_COD = SF2.F2_TRANSP "
		cQuery +=	" LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SD2.D2_COD "
		cQuery +=	" WHERE 1=1 "
		cQuery +=	" AND SF2.D_E_L_E_T_ = ''"
		cQuery +=	" AND SF2.F2_DOC = '" + MV_PAR01 + "' "
		cQuery +=	" AND SF2.F2_SERIE = '" + MV_PAR02 + "' "
		cQuery +=	" AND SF2.F2_CLIENTE = '" + MV_PAR03 + "' "
		cQuery +=	" AND SF2.F2_LOJA = '" + MV_PAR04 + "' "
		//cQuery +=	" GROUP BY SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_EMISSAO, SA1.A1_COD, SA1.A1_NOME,	 SA1.A1_MUN, SA1.A1_EST, SA4.A4_COD, SA4.A4_NOME, SA4501.A4_COD, SA4501.A4_NOME, SB1.B1_MSBLQL, SB1.B1_COD, SB1.B1_ZIMPETQ, SB1.B1_ZDESRDZ, SB1.B1_CODBAR, SD2.D2_ITEM "

	Else

		cQuery := " SELECT A.B1_COD,A.B1_DESC,A.B1_ZDESRDZ,A.B1_ZAPRES1,A.B1_CODBAR,A.B1_ZIMPETQ,A.B1_MSBLQL,A.B1_PROC,A.B1_LOJPROC,B.A2_NREDUZ,A.B1_CODBAR,A.B1_UM "
    	cQuery += " FROM "      + RetSqlName("SB1") + " AS A "
		cQuery += " LEFT JOIN " + RetSqlName("SA2") + " AS B ON B.D_E_L_E_T_ = '' AND B.A2_COD = A.B1_PROC AND B.A2_LOJA = A.B1_LOJPROC "
    	cQuery += " WHERE A.D_E_L_E_T_ 	= '' "    	    	    	    	
		cQuery += " AND A.B1_COD		= '" + MV_PAR01 + "' "
		
	EndIf

      
    MemoWrite("\Sql\ZNTR110ACD.sql",cQuery)
	
    cQuery := ChangeQuery( cQuery )
	DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "TMP" , .T., .T. )
	               		
    dbSelectArea("TMP")


	


    dbGoTop()

    Count TO nTotItmDoc

    dbGoTop()
    		
	If nTotItmDoc > 0
		nTotItmDoc  := IIF(nRadio=1,nTotItmDoc,nTotEtqItm)
	Else
	   	
		TMP->(dbCloseArea())  
		TMPSF2->(dbCloseArea())
	
		MsgStop(   "NENHUM REGISTRO ENCONTRADO!" + CHR(13) + CHR(13) + ;
	       		   "Por favor, verifique os parâmetros digitados.","ATENÇÃO!")
	
		Return

	EndIf
		
	If !IsPrinter(4) 
		lPortaOk := .F.
		MsgSTOP("<b>Porta de Impressão LPT4 não Encotrada</b>. Por favor verifique com o Setor de TI para realizar/conferir mapeamento da Porta da Impressora Térmica.","IMPRESSÃO CANCELADA!")
	else
		lPortaOk := .T.
	Endif
	
	IF lPortaOk
				
		If nTotItmDoc > 0
	
	    	IF 	MsgYesNo("Confirma a Impressão das Etiquetas de Identificação dos Produtos ?","ATENÇÃO!")
		    
            	nItmAtual := 0		
/*
		 		// Calibra a Impressora antes de Imprimir
		    	mscbprinter("GC420t", cPorImp,,,)
		    	mscbchkstatus( .F. )
		    	mscbbegin( 1, 2 )
		    	mscbwrite( "^XA" + chr(13) )
		    	mscbwrite( "^MFC,L" + chr(13) )
		    	mscbwrite( "^XZ" + chr(13) )
		    	mscbend()
		    	MSCBCLOSEPRINTER()
*/		
		    	While !EOF() 
			
					nItmAtual++
					lImpEtq 	:= .T.
					lPrdBlq 	:= .F.
					//nTotEtqItm 	:= 1
			    	nTotEtqItm := IIF(nRadio=1,cTotal,nTotEtqItm)
			
					IncProc("Imprimindo Etiqueta: " + cValToChar(nItmAtual) + " de " + cValToChar(nTotItmDoc) + "...")
				
				
			    	If nTotEtqItm > nLimMax

						If MsgNoYes("Confirma a Impressão dessa quantidade de Etiquetas ?","ATENÇÃO!")
								lImpEtq := .T.
						ELSE	
								lImpEtq := .F.
						EndIf
					
					EndIf
					
								
			    	If TMP->PROD_BLQ <> "2" 

						/*
						MsgAlert(	"O item:<b> "+TMP->D1_ITEM+"</b> Produto:<b> "+TRIM(TMP->D1_COD)+"-"+TRIM(TMP->B1_ZDESRDZ)+"</b>"+cEoL+ ;
									"Com a quantidade de:<b> "+TRANSFORM(TMP->D1_QUANT,"@E 999.99")+"</b> etiquetas para impressão. "+cEoL+ ;
									"Este produto está com <b> BLOQUEIO DE TELA </b>, portanto, etiquetas não serão impressas." +cEoL+cEoL+ ;
									"Favor entrar em contato com setor de Compras para alinhamento do processo.","PRODUTO BLOQUEADO!")
						*/									
						lPrdBlq := .T.
						lImpEtq := .F.
											
					EndIf

					If TMP->IMP_ETQ = "S" .AND. lImpEtq
					
						For i=1 TO nTotEtqItm
									

											
				    		nLenPrd     	:= LEN(TRIM(IIF(nRadio=1,TMP->CODPROD,TMP->B1_COD)))
							cCodPrd     	:= TRIM(IIF(nRadio=1,TMP->CODPROD,TMP->B1_COD))
				    		cDc1Prd     	:= SUBSTR(TRIM(TMP->PRODUTO),01,20)
				    		cDc2Prd     	:= SUBSTR(TRIM(TMP->PRODUTO),21,40)
				    		cCidade     	:= TMP->CIDADE				                    
				    		cEndPad     	:= ""   //TRIM(TRANSFORM(TMP->D1_ENDER,"@r 99.99.999"))
				    		cDatEmi		   	:= IIF(nRadio=1, TMP->EMISSAO,"")  
                    		cNumDoc     	:= IIF(nRadio=1,TMP->SERIE+"/"+TMP->DOC,"")         
                    		cCodBar     	:= TRIM(TMP->CODBAR)
							cCliente		:= IIF(nRadio=1,TRIM(TMP->CLIENTE),TMP->A2_NREDUZ) 
							cDocSaida		:= IIF(nRadio=1,TMP->SERIE + " - " + TMP->DOC,"")
							cEndPad			:= ""
                    		cQtdEtqItm		:= STRZERO(I,3,0)+"/"+STRZERO(cQtdEtqItm,3,0)
                    		cTipoExp		:= IIF(nRadio=1,TMP->EXPEDICAO,"")

							IF cTipImp = "V"
								cTamanho    := IIF( nLenPrd <= 6, "200, 200", "200, 250" )
							ELSE
								cTamanho	:= IIF( nLenPrd <= 6,"350,370",IIF(nLenPrd = 7,"350,310",IIF(nLenPrd = 8,"350,290","350,255" )))
							ENDIF	

				    		If lTstImp 
								
								MsgAlert("Imprimindo Item: "+IIF(nRadio=1,TMP->ITEM,STRZERO(i,4))+"  "+cQtdEtqItm+"  "+IIF(nRadio=1,TMP->UM,TMP->B1_UM),"Teste de Impressão")
							
							Else
								
								mscbprinter("GC420t",cPorta,,,)
				    			mscbchkstatus( .F. )
				    			mscbbegin( 1, 2 )
								MSCBLOADGRF("LogoZano.grf")	
										//MSCBBEGIN(1,2)        
				    
                    			mscbwrite( "^XA" + chr(13) )								     

                        		If nRadio = 1
								
									IF cTipImp = "H"
										
																				
										MSCBGRAFIC(110,10,"LogoZano")   
										
										MSCBSAY(81,05,cDocSaida	,"R","0","140,160",.T.,,,,.T.)	

										MSCBSAY(76,05,"Cliente"	,"R","0","025,035",.T.,,,,.T.)
										MSCBSAY(56,05,cCliente ,"R","0","100,080",.T.,,,,.T.)
				        		
										MSCBSAY(50,05,"Cidade"	,"R","0","025,035",.T.,,,,.T.)
										//MSCBSAY(55,70,"VOLUME","R","0","025,035",.T.,,,,.T.)
										MSCBSAY(50,135,"VOLUME /  TOTAL","R","0","025,035",.T.,,,,.T.)
										MSCBSAY(40,05,cCidade					,"R","0","045,056",.T.,,,,.T.)
										//MSCBSAY(45,125,cVolume,"R","0","045,056",.T.,,,,.T.)
										MSCBSAY(40,140,cQtdEtqItm,"R","0","045,056",.T.,,,,.T.)

										MSCBSAY(35,05,"Emissão Doc.","R","0","025,035",.T.,,,,.T.)
										MSCBSAY(25,05,cDatEmi					,"R","0","045,056",.T.,,,,.T.)
										
										MSCBSAY(35,120,"Tipo Expedição","R","0","025,035",.T.,,,,.T.)
										MSCBSAY(25,100,cTipoExp				,"R","0","045,056",.T.,,,,.T.)
                        		
										//MSCBSAYBAR(018,121,cCodBar,"R","MB02",18, .F., .T., .F., , 4, 2, .F., .F., , .T.)									
										
									ELSE

                        				MSCBSAY(05,05,cCodPrd					,"I","0",cTamanho,.T.)				        
				        
										MSCBSAY(05,40,"Descricao do Produto"	,"I","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,45,cDc1Prd					,"I","0","060,075",.T.,,,,.T.)
				        				MSCBSAY(05,55,cDc2Prd					,"I","0","060,075",.T.,,,,.T.)
				        
										MSCBSAY(05,70,"Apresentacao do Produto"	,"N","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,75,cAprPrd					,"N","0","060,075",.T.,,,,.T.)

										MSCBSAY(05,105,"Fornecedor"	,"N","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,110,cCliente		,"N","0","060,075",.T.,,,,.T.)

										////MSCBSAY(05,105,"Endereco do Produto   " + cQtdEtqItm ,"N","0","025,035",.T.,,,,.T.)
										////MSCBSAY(05,110,"01.02.01.07.01","N","0","060,075",.T.,,,,.T.)
										////MSCBSAY(05,110,cEndPad					,"N","0","060,075",.T.,,,,.T.)

										MSCBSAY(05,140,"Documento de Saida /"+" Item: "+TMP->D1_ITEM+"  Qtd/Etiq: "+cQtdEtqItm,"N","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,145,cDocSaida				,"N","0","035,045",.T.,,,,.T.)

                        				//MSCBSAYBAR(006,152,cCodBar,"N","MB02",33, .F., .T., .F., , 6, 3, .F., .F., , .T.)
								
									ENDIF

								Else

									IF cTipImp = "H"
									
										MSCBSAY(65,04,cCodPrd					,"R","0",cTamanho,.T.)				        

										MSCBSAY(70,05,"Descricao do Produto"	,"R","0","025,035",.T.,,,,.T.)
										MSCBSAY(60,05,cDc1Prd+cDc2Prd			,"R","0","045,056",.T.,,,,.T.)
				        		
										MSCBSAY(50,05,"Apresentacao do Produto"	,"R","0","025,035",.T.,,,,.T.)
										MSCBSAY(50,120,"UM","R","0","025,035",.T.,,,,.T.)
										MSCBSAY(40,05,cAprPrd					,"R","0","045,056",.T.,,,,.T.)
										MSCBSAY(40,120,TMP->B1_UM,"R","0","045,056",.T.,,,,.T.)

										MSCBSAY(30,05,"Fornecedor"	,"R","0","025,035",.T.,,,,.T.)
										MSCBSAY(20,05,cCliente		,"R","0","045,056",.T.,,,,.T.)

										//MSCBSAY(10,05,"Documento de Entrada" 	,"R","0","025,035",.T.,,,,.T.)
										//MSCBSAY(04,05,""				,"R","0","035,045",.T.,,,,.T.)
                        		
										//MSCBSAYBAR(018,121,cCodBar,"R","MB02",18, .F., .T., .F., , 4, 2, .F., .F., , .T.)									

									ELSE

                        				MSCBSAY(05,05,cCodPrd					,"I","0",cTamanho,.T.)				        
				        
										MSCBSAY(05,40,"Descricao do Produto"	,"I","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,45,cDc1Prd					,"I","0","060,075",.T.,,,,.T.)
				        				MSCBSAY(05,55,cDc2Prd					,"I","0","060,075",.T.,,,,.T.)
				        
										MSCBSAY(05,70,"Apresentacao do Produto"	,"N","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,75,cAprPrd					,"N","0","060,075",.T.,,,,.T.)

										MSCBSAY(05,105,"Fornecedor"	,"N","0","025,035",.T.,,,,.T.)
										MSCBSAY(05,110,cCliente		,"N","0","060,075",.T.,,,,.T.)

										////MSCBSAY(05,105,"Endereco do Produto   " + cQtdEtqItm ,"N","0","025,035",.T.,,,,.T.)
										////MSCBSAY(05,110,"01.02.01.07.01","N","0","060,075",.T.,,,,.T.)
										////MSCBSAY(05,110,cEndPad					,"N","0","060,075",.T.,,,,.T.)

										//MSCBSAY(05,140,"Documento de Entrada /"+" Item: "+TMP->D1_ITEM+"  Qtd/Etiq: "+cQtdEtqItm,"N","0","025,035",.T.,,,,.T.)
										//MSCBSAY(05,145,""				,"N","0","035,045",.T.,,,,.T.)

                        				//MSCBSAYBAR(006,152,cCodBar,"N","MB02",33, .F., .T., .F., , 6, 3, .F., .F., , .T.)
								
									ENDIF

								EndIf

				    			mscbwrite( "^XZ" + chr(13) )
				    			mscbend()

								If nTotItmDoc > 0 
			    					MSCBCLOSEPRINTER()
		    					EndIf
							
							EndIf
		
			    		Next i
			    
					Else
					
						lErrImp	:= .T.
						cMsgErr	+= "Produto: <b>" + TRIM(IIF(nradio=1,TMP->CODPROD,TMP->B1_COD))+"-"+TRIM(TMP->PRODUTO)+" / "+TRIM(TMP->COD_APRES)+" </b> "+IIF("Limite max","[LIMITE EXCEDIDO DE IMPRESSÃO DE ETIQUETA]",IIF(lPrdBlq,"[PRODUTO COM BLOQUEIO DE TELA]","[CADASTRO BLOQUEADO P/IMPRESSÃO ETIQUETA]"))+cEoL+cEoL  
								
					EndIF			    			    
                
					TMP->( dbSkip() )
					//lMovEstq :=  IIF(nRadio=1,IIF(TMP->F4_ESTOQUE = "S",.T.,.F.),.T.)
			
		    	EndDo
				    	
				IF lErrImp
					MsgAlert("Produto(s) não autorizado(s) para impressão de Etiquetas de identificação. Favor verificar cadastro:" +cEoL+cEoL+cMsgErr,"ATENÇÃO! Produto(s) Não Impresso(s)")		
				ENDIF
		
			EndIF
		
		ELSE
	
	    	MsgStop(   "NENHUM REGISTRO ENCONTRADO!" + CHR(13) + CHR(13) + ;
	        		   "Por favor, verifique os parâmetros digitados.","ATENÇÃO!")
	
    	ENDIF

	ELSE
	
		If lPortaOk
			MsgStop("Documento de entrada <b>NÃO GERA MOVIMENTAÇÃO DE ESTOQUE</b>."+cEoL+"Favor verificar os parâmetros digitados.","IMPRESSÃO CANCELADA!")	
		EndIf
	
	ENDIF
    
    TMP->(dbCloseArea())
	TMPSF2->(dbCloseArea()) 
    
Return()	

Static Function AjustaSX1( _Perg )

    cPerg    := _Perg 
    cValid   := ""             // FG_StrZero("MV_PAR01",9)                                    
    cF3      := ""
    cPicture := ""
    cDef01   := ""
    cDef02   := ""
    cDef03   := ""
    cDef04   := ""
    cDef05   := ""
    
	If nRadio = 1
		u_zPutSX1(cPerg, "01", "Num.Documento de Saida ?" , "MV_PAR01", "MV_CH0", "C", TamSX3('F2_DOC')[01]  , 0, "G", cValid, "SF2", cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, "Informe o numero documento de Saida.")
		u_zPutSX1(cPerg, "02", "Num.da Serie Doc.Saida ?" , "MV_PAR02", "MV_CH1", "C", TamSX3('F2_SERIE')[01], 0, "G", cValid, ""   , cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, "Informe a serie do documento de Saida.")
		u_zPutSX1(cPerg, "03", "Codigo Cliente ?"        , "MV_PAR03", "MV_CH2", "C", TamSX3('A1_COD')[01]  , 0, "G", cValid, "SA1", cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, "Informe o codigo do Cliente.")
		u_zPutSX1(cPerg, "04", "Codigo Loja do Cliente ?", "MV_PAR04", "MV_CH3", "C", TamSX3('A1_LOJA')[01] , 0, "G", cValid, "SA1", cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, "Informe a loja do Cliente.")
	
	Else
		u_zPutSX1(cPerg, "01", "Codigo do Produto ?"     	 , "MV_PAR01", "MV_CH0", "C", TamSX3('B1_COD')[01]  , 0, "G", cValid      , "SB1", cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, "Informe o codigo do produto à ser impresso.")		
		u_zPutSX1(cPerg, "02", "Imprimir Quantas Etiquetas ?", "MV_PAR02", "MV_CH1", "N", 03                    , 0, "G", "Positivo()",  cF3 , "@e 999", cDef01, cDef02, cDef03, cDef04, cDef05, "Informe a quantidade de etiquetas que deseja imprimir para o produto escolhido.")
	EndIf

Return

User Function ZNTR110MENU()

  DEFINE DIALOG oDlg TITLE "Impressão Etiqueta Térmica" FROM 150,150 TO 300,250 PIXEL
   
  oRadio := ZNTR110MENU():New (10,02,aItems,,oDlg,,,,,,,,150,220,,,,.T.)
  oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}
   
  ACTIVATE DIALOG oDlg CENTERED

Return

User Function ZNTR110OPC()

	Local lRet	   	:= .F.
	Local aSays 	:= {}
	Local cTitoDlg 	:= "Impressão de Etiquetas Térmicas de Identificação / Produtos"
	Local oFont, oDlg, oSay, oPanel1
	
	//Monta tela / texto
	Aadd( aSays, "Impressao de Etiqueta Termica por Doc. De Saida" ) 

	// Cria Fonte para visualização
	oFont := TFont():New('Courier new',,-11,.T.)

	DEFINE MSDIALOG oDlg FROM 0,0 TO 300,687 PIXEL TITLE cTitoDlg

	@ 10,05 MSPANEL oPanel1 COLORS CLR_BLACK,CLR_HGRAY SIZE 335,060 OF oDlg
	@ 20,10 SAY oSay PROMPT aSays[01] SIZE 500,20 COLORS CLR_BLACK,CLR_WHITE FONT oFont OF oDlg PIXEL

	oRadio := TRadMenu():New (80,10,aItems,,oDlg,,,,,,,,200,40,,,,.T.)
  	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}		
	
	@ 125, 169 BUTTON "&Parâmetros" SIZE 060,012 PIXEL OF oDlg ACTION Eval( {|| lRet := .T., U_cPergSX1_110() } )
	@ 125, 237 BUTTON "&Imprimir" 	SIZE 046,012 PIXEL OF oDlg ACTION Eval( {|| lRet := .T., Close( oDlg ) } )
	@ 125, 291 BUTTON "&Cancelar" 	SIZE 046,012 PIXEL OF oDlg ACTION Eval( {|| lRet := .F., Close( oDlg ) } )
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return lRet

User Function U_cPergSX1_110()
	
	cPerg := aPerg[nRadio]
	
	//MsgAlert("Você Escolheu <b>"+aItems[nRadio]+"</b>","ATENÇÃO!")	
	Pergunte( cPerg, .T. )
	
	nTotEtqItm := IIF(nRadio=2,MV_PAR02,0)

Return


Static Function R110ALogo()

Local cRet := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo com o codigo do grupo de empresas ³
//³ completo, retira os espacos em branco do codigo da empresa   ³
//³ para nova tentativa.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cRet )
	cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo com o codigo da filial completo,  ³
//³ retira os espacos em branco do codigo da filial para nova    ³
//³ tentativa.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cRet )
	cRet := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se ainda nao encontrar, retira os espacos em branco do codigo³
//³ da empresa e da filial simultaneamente para nova tentativa.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cRet )
	cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo por filial, usa o logo padrao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cRet )
	cRet := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

Return cRet
