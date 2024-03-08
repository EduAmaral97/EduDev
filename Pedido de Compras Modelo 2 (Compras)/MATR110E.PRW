#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"
#INCLUDE "MATR110A.CH"

/*/ 
-----------------------------------------------------------------------------# 
								  	MATR110E							     #
-----------------------------------------------------------------------------# 
Funcao: MATR110E 															 #
Autor: Eduardo Jorge 													     #
Data: ? 																     #
Descricao: ?                                                                 #
*****************************************************************************#

*/


User Function MATR110E(cNumPed)
		

DEFAULT cNumPed		:= ""
Private _cAlias		:= GetNextAlias()
Private _cAlias1	:= GetNextAlias()
Private cEOL 		:= "CHR(13)+CHR(10)"
Private cPerg   	:= "MTR110A" // Nome do grupo de perguntas

If !Empty(cNumPed)
	Pergunte(cPerg,.F.)
	MV_PAR01 := Replicate(" ", Len(SA2->A2_COD)) 
	MV_PAR02 := Replicate("Z", Len(SA2->A2_COD))
	MV_PAR03 := Replicate(" ", Len(SA2->A2_LOJA)) 
	MV_PAR04 := Replicate("Z", Len(SA2->A2_LOJA))
	MV_PAR05 := cNumPed
	MV_PAR06 := cNumPed
	MV_PAR07 := CTOD("01/01/1900")
	MV_PAR08 := CTOD("31/12/2049")
ElseIf !Pergunte(cPerg,.T.)
	
	Return
Endif

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Monta arquivo de trabalho temporário
MsAguarde({||MontaQuery()},STR0001,STR0002) //"Aguarde"##"Criando arquivos para impressão..."

//Verifica resultado da query

DbSelectArea(_cAlias)
DbGoTop()
If (_cAlias)->(Eof())
	MsgAlert(STR0003,STR0004)  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
	(_cAlias)->(DbCloseArea())
Else
	Processa({|| Imprime() },STR0005,STR0006) //"Pedido de Compras "##"Imprimindo..."
EndIf

Return

//********************************************************************************************//
//                        			MONTA A PAGINA DE IMPRESSAO								  //
//********************************************************************************************//

Static Function Imprime()


Local _nCont 		:= 1
Local cPedidoAtu	:= ""
Local cPedidoAnt	:= ""
Local aAreaSM0	:= {}	 

Private cBitmap	:= ""
Private cStartPath:= GetSrvProfString("Startpath","")
Private oFont08
Private oFont09
Private oFont10
Private cPosi
Private nLin
Private nLinOBS			:= 1470
Private iOBS			:= 1
Private CountOBS		:= 0
Private _nValIcm		:= 0   // Valor do Icms
Private _nValIcmR		:= 0	// Valore do Icms retido
Private _nValIpi		:= 0   // Valor do Ipi
Private _nPag  			:= 1   // Numero da
Private _nTot    		:= 0   // Valor Total
Private _nFrete			:= 0   // Valor do frete
Private _nDescPed		:= 0
Private _nDesc1	 		:= 0
Private _nDesc2	 		:= 0
Private _nDesc3	 		:= 0
Private _nDespesa		:= 0
Private _nSeguro		:= 0
Private _dDtEnt
Private _cEndEnt		:= ""
Private _cBairEnt		:= ""
Private _cCidEnt		:= ""
Private _cEstEnt		:= ""		
Private _cTel			:= ""

cBitmap := R110ALogo()

//Fontes a serem utilizadas no relatório
//Private oFont08  	:= TFont():New( "Arial",,08,,.F.,,,,,.f.)
Private oFont08N 	:= TFont():New( "Arial",,08,,.T.,,,,,.f.)
Private oFont08I 	:= TFont():New( "Arial",,08,,.f.,,,,,.f.,.T.)
//Private oFont09  	:= TFont():New( "Arial",,09,,.F.,,,,,.f.)
Private oFont09N 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
Private oFontC9  	:= TFont():New( "Courier New",,09,,.F.,,,,,.f.)
Private oFontC9N 	:= TFont():New( "Courier New",,09,,.T.,,,,,.f.)
//Private oFont10  	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFont10N 	:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFont10I 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)
Private oFont11  	:= TFont():New( "Arial",,11,,.f.,,,,,.f.)
Private oFont11N 	:= TFont():New( "Arial",,11,,.T.,,,,,.f.)
Private oFont12N 	:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
Private oFont12  	:= TFont():New( "Arial",,12,,.F.,,,,,.F.)
Private oFont12NS	:= TFont():New( "Arial",,12,,.T.,,,,,.T.)
Private oFont13N 	:= TFont():New( "Arial",,13,,.T.,,,,,.f.)
Private oFont17 	:= TFont():New( "Arial",,17,,.F.,,,,,.F.)
Private oFont17N 	:= TFont():New( "Arial",,17,,.T.,,,,,.F.)

//Start de impressão
Private oPrn:= TMSPrinter():New()

oPrn:SetLandScape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem

//cabecalho da pagina
Cabec(.t.)

cPedidoAnt := (_cAlias)->C7_NUM

// Carrega dados da filial de Entrega
If((_cAlias)->C7_FILENT != NIL)
 	aAreaSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	dbGoTop()
	While !Eof()
		If Trim(M0_CODFIL) == Trim((_cAlias)->C7_FILENT)
 			_cEndEnt	:= M0_ENDENT
 			_cBairEnt	:= M0_BAIRENT
			_cCidEnt	:= M0_CIDENT
			_cEstEnt	:= M0_ESTENT
			_cTel		:= M0_TEL
		EndIf
		dbSkip()
	EndDo
	RestArea(aAreaSM0)
EndIf

While (_cAlias)->(!Eof())

	
	cPedidoAtu := (_cAlias)->C7_NUM
	
	If _nCont >= 20 .Or. cPedidoAtu <> cPedidoAnt
		
		If cPedidoAtu <> cPedidoAnt
					
			Rodap()
			
			// Carrega dados da filial de Entrega
			If((_cAlias)->C7_FILENT != NIL)
				aAreaSM0 := SM0->(GetArea())
				dbSelectArea("SM0")
				dbGoTop()
				While !Eof()
					If Trim(M0_CODFIL) == Trim((_cAlias)->C7_FILENT)
 						_cEndEnt	:= M0_ENDENT
 						_cBairEnt	:= M0_BAIRENT
						_cCidEnt	:= M0_CIDENT
						_cEstEnt	:= M0_ESTENT
						_cTel		:= M0_TEL
					EndIf
					dbSkip()
				EndDo
				RestArea(aAreaSM0)
			EndIf
			
			
			_nDescPed 	:= 0
			_nDesc1 	:= 0
			_nDesc2 	:= 0
			_nDesc3 	:= 0
			_nValIpi	:= 0
			_nValIcm	:= 0
			_nValIcmR	:= 0
			_nTot		:= 0
			_nFrete	:= 0
			_dDtEnt 	:= NIL
			
			oPrn :EndPage() 
			
		Else
			oPrn:line(1960,0075,1960,3425)    //Linha Horizontal Rodape Inferior
		EndIf
		
		_nCont		:= 0
		_nPag 		+= 1
		
		oPrn :EndPage() 
		Cabec(.t.)
	EndIf
		
	//oPrn:say(nLin,0035,(_cAlias)->C7_ITEM, oFont08)		  							//item
	oPrn:say(nLin,0035,Substr((_cAlias)->C7_PRODUTO,1,25),oFont08)						//codigo
	oPrn:say(nLin,0235,Substr((_cAlias)->B1_ZAPRES1,1,25),oFont08)						//Codigo Apres
	oPrn:say(nLin,0590,Substr((_cAlias)->A5_CODPRF,1,18),oFont08)						//codigo do fornecedor
	oPrn:say(nLin,1000,Substr((_cAlias)->B1_ZDESRDZ,1,40),oFont08)						//descricao
	oPrn:say(nLin,1830,Substr((_cAlias)->C7_NUMSC,1,6),oFont08)							//SC
	oPrn:say(nLin,2060,Transform((_cAlias)->C7_QUANT,"@R 999999.99"), oFont08)			//Quantidade
	oPrn:say(nLin,2220,Transform((_cAlias)->C7_QUJE,"@R 999999"), oFont08)				//Quantidade Já Entregue
	oPrn:say(nLin,2370,Transform((_cAlias)->QTD_ABERTO,"@R 999999"), oFont08)			//Quantidade em Aberto
	oPrn:say(nLin,2530,(_cAlias)->C7_UM,oFont08)										//unidade de medida
	oPrn:say(nLin,2620,Transform((_cAlias)->C7_PRECO,"@R 999,999,999.99"),oFont08)		//VLR UNIT
	oPrn:say(nLin,2820,Transform((_cAlias)->C7_TOTAL,"@R 999,999,999.99"),oFont08)		//VLR TOT
	oPrn:say(nLin,3020,Transform((_cAlias)->C7_IPI,"@R 999.99"),oFont08)				//IPI
	oPrn:say(nLin,3220,Transform((_cAlias)->C7_ICMSRET,"@R 999.99"),oFont08)			//ICMS RET
	
	
	//oPrn:say(nLinOBS,0050, Substr((_cAlias)->C7_PRODUTO,1,25) + " - " + (_cAlias)->C7_OBS,oFont08N) //OBS

	
	_nFrete	+= (_cAlias)->C7_VALFRE
	
	If (_cAlias)->C7_DESC1 != 0 .or. (_cAlias)->C7_DESC2 != 0 .or. (_cAlias)->C7_DESC3 != 0
		_nDescPed  += CalcDesc((_cAlias)->C7_TOTAL,(_cAlias)->C7_DESC1,(_cAlias)->C7_DESC2,(_cAlias)->C7_DESC3)
	    _nDesc1	:= (_cAlias)->C7_DESC1
		_nDesc2	:= (_cAlias)->C7_DESC2
		_nDesc3	:= (_cAlias)->C7_DESC3
	Else
		_nDescPed += (_cAlias)->C7_VLDESC
	Endif
	
	If _dDtEnt == NIL
		_dDtEnt := (_cAlias)->C7_DATPRF 
	ElseIf (_cAlias)->C7_DATPRF > _dDtEnt
		_dDtEnt := (_cAlias)->C7_DATPRF 
	Endif
	
	_nCont 		+= 1
	_nValIcm 	+= (_cAlias)->C7_VALICM
	_nValIcmR	+= (_cAlias)->C7_ICMSRET
	_nValIpi 	+= (_cAlias)->C7_VALIPI
	_nTot 	 	+= (_cAlias)->C7_TOTAL
	_nDespesa 	+= (_cAlias)->C7_DESPESA
	_nSeguro	+= (_cAlias)->C7_SEGURO
	

	
	nLin += 50   //pula linha
	//nLinOBS += 50   //pula linha Obs


	
	cPedidoAnt := (_cAlias)->C7_NUM
	
	//Verifica a quebra de pagina
	
	(_cAlias)->(dBskip())
EndDo

If _nCont <= 32
	(_cAlias)->(DbGoTop())
	//		Infoger()
	Rodap()
	//		WordImp()
Else
	(_cAlias)->(DbGoTop())
	Rodap()
	oPrn :EndPage()
	Cabec(.f.)
	//   		Infoger()
	Rodap()
	//   		WordImp()
EndIF

If(mv_par09 == 1)
  oPrn:Print()
Else
  oPrn:Preview() //Preview DO RELATORIO
EndIf

Return

//********************************************************************************************
//										Impressão do Relatório
//********************************************************************************************
Static Function  Cabec(_lCabec)

oPrn:StartPage()	//Inicia uma nova pagina

_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

oPrn:SayBitmap(0045,0060,_cFileLogo,0400,0125)

oPrn:say(0070,1300, STR0007+ " " +Alltrim((_cAlias)->C7_NUM),oFont17) //"PEDIDO DE COMPRA:"
oPrn:say(0070,1300,Iif(!Empty(Alltrim((_cAlias)->C7_OP))," |   OP: " +Alltrim((_cAlias)->C7_OP),""),oFont12)

oPrn:say(0150,1300, "Obrigatório informar este número na emissão NF",oFont10N) //"Texto informativo abaixo do Pedido de compras"

oPrn:line(210,1200,430,1200) 	//1 Linha Vertical Cabecalho
oPrn:line(210,2550,430,2550) 	//2 Linha Vertical Cabecalho
oPrn:line(445,0035,445,3425)    //Linha Horizontal Cabecalho Inferior
oPrn:line(505,0035,505,3425)    //Linha Horizontal Cabecalho Inferior

//********************************************************************************************
//										cabecalho
//********************************************************************************************

// Primeira coluna do cabecalho
nLin := 225
oPrn:say (nLin,0035, SM0->M0_NOMECOM ,oFont08I)
nLin += 50
oPrn:say (nLin,0035,STR0009+" "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  -  "+STR0010+" "+Alltrim(SM0->M0_INSC) ,oFont08I)  //"CNPJ:"##"I.E:"
nLin += 50
oPrn:say (nLin,0035,Alltrim(SM0->M0_ENDCOB)+" "+ Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" /"+Alltrim(SM0->M0_ESTCOB),oFont08I) //"ENDEREÇO:"
nLin += 50
oPrn:say (nLin,0035,STR0011+" "+(SM0->M0_CEPENT)+ " | " + STR0012+" "+Alltrim(SM0->M0_TEL)+"  |  "+STR0013+" "+Alltrim(SM0->M0_FAX) ,oFont08I) //"CEP.:"##"TEL.:"##"FAX:"

//............................................................................................
// Segunda coluna do cabecalho (FORNECEDOR)
nLin := 225
oPrn:say (nLin,1215,"Fornecedor: " + (_cAlias)->A2_COD +" - " + (_cAlias)->A2_NOME, oFont08I) //Cod + Nome Fornecedor
nLin += 50
oPrn:say (nLin,1215,STR0009+" "+ Transform((_cAlias)->A2_CGC,"@R 99.999.999/9999-99") + " - " + STR0010 + " " + Transform((_cAlias)->A2_INSCR,"@R 999.999.999.999"), oFont08I) //"CNPJ: + IE:"
nLin += 50
oPrn:say (nLin,1215,STR0015+ " " + Alltrim((_cAlias)->A2_END) + ", "+ Alltrim((_cAlias)->A2_BAIRRO) + " - " + Alltrim((_cAlias)->A2_MUN)+" / "+(_cAlias)->A2_EST, oFont08I)  //"Endereço:"
nLin += 50
oPrn:say (nLin,1215,STR0011 + Transform((_cAlias)->A2_CEP,"@R 99.999-999") + " | " +STR0012+" " + "("+Alltrim((_cAlias)->A2_DDD)+") "+Alltrim((_cAlias)->A2_TEL) + " | " + STR0013 +  "("+Alltrim((_cAlias)->A2_DDD)+") "+Alltrim((_cAlias)->A2_FAX) , oFont08I) //"CEP: ## TEL.:"


//............................................................................................
// Terceira coluna do cabecalho (Info PC)
nLin := 225
oPrn:say(nLin,2565, STR0008+ " " + dtoc((_cAlias)->C7_EMISSAO) ,oFont11N) //"EMISSÃO:"
nLin += 50
oPrn:say(nLin,2565,"Cond. Pagamento: "+ (_cAlias)->E4_CODIGO + " - " + (_cAlias)->E4_COND, oFont08I) //"Cond. Pagamento:"
nLin += 50
oPrn:say(nLin,2565,"Tipo Frete: " + (_cAlias)->TIPO_FRETE,oFont08I) //"Tipo Frete:"
nLin += 50
oPrn:say(nLin,2565,"Transportadora: " + (_cAlias)->TRANSPORTADORA,oFont08I) //"Transportadora:"

//********************************************************************************************
//										Corpo
//********************************************************************************************
nLin := 450
// Subtitulo do Corpo
//oPrn:say (nLin,0035,STR0018,oFont08I) 	//"Item"
oPrn:say (nLin,0035,STR0020,oFont08I) 		//"Código"
oPrn:say (nLin,0235,"Cod. Apres.",oFont08I) //"Código Apres"
oPrn:say (nLin,0590,STR0021,oFont08I) 		//"Cód. Prod. Fornec."
oPrn:say (nLin,1235,STR0022,oFont08I) 		//"Descrição"
oPrn:say (nLin,1850,"SC",oFont08I) 			//"SC"
oPrn:say (nLin,2060,STR0019,oFont08I) 		//"Qtde"
oPrn:say (nLin,2220,"Entregue",oFont08I) 	//"Qtde Ent."
oPrn:say (nLin,2380,"Saldo",oFont08I) 		//"Qtde Abrt."
oPrn:say (nLin,2530,"Und",oFont08I) 		//Unidade Medida
oPrn:say (nLin,2650,STR0024,oFont08I) 		//"Vl. Unit."
oPrn:say (nLin,2850,STR0025,oFont08I) 		//"Vl. Total"
oPrn:say (nLin,3040,STR0026,oFont08I) 		//"IPI"
oPrn:say (nLin,3200,"ICMS Ret.",oFont08I) 	//"ICMS RET:"

nLin := 510
oPrn:say (2340,3330,Transform(_nPag,"@R 999"),oFont08I)    //Impressão do numero da página

return

Static Function Rodap()

//********************************************************************************************
//										Assinaturas
//********************************************************************************************

//nLin := 1700
//oPrn:line(1700,0150,1700,0800)	//Linha Assinatura Comprador
//oPrn:line(1700,0950,1700,1600)	//Linha Assinatura Gerencia
//oPrn:line(1700,1750,1700,2400)	//Linha Assinatura Diretoria
//nLin += 50
//oPrn:say (nLin,0390,"Comprador",oFont11N) //"Comprador"
//oPrn:say (nLin,1200,"Gerencia",oFont11N) //"Gerencia"
//oPrn:say (nLin,2000,"Diretoria",oFont11N) //"Diretoria"


//********************************************************************************************
//										Rodape
//********************************************************************************************

nLin := 1420

oPrn:say(nLin,0050,"Observações: ", oFont08N)		//"OBS:"

CountOBS := AliasCOUNTOBS->QTD_OBS

WHILE iOBS <= 8
oPrn:say(nLinOBS,0050, Substr(AliasOBS->PRODUTO,1,25) + " - " + AliasOBS->OBS,oFont08N) //OBS
nLinOBS += 50   //pula linha Obs
iOBS++
AliasOBS->(dBskip())
EndDo

nLinOBS := 1470

WHILE iOBS <= 16
oPrn:say(nLinOBS,0900, Substr(AliasOBS->PRODUTO,1,25) + " - " + AliasOBS->OBS,oFont08N) //OBS
nLinOBS += 50   //pula linha Obs
iOBS++
AliasOBS->(dBskip())
EndDo

nLinOBS := 1470

WHILE iOBS <= CountOBS
oPrn:say(nLinOBS,1750, Substr(AliasOBS->PRODUTO,1,25) + " - " + AliasOBS->OBS,oFont08N) //OBS
nLinOBS += 50   //pula linha Obs
iOBS++
AliasOBS->(dBskip())
EndDo



oPrn:line(1400,0035,1400,2500)    //Linha Horizontal Superior OBS
oPrn:line(1850,0035,1850,2500)    //Linha Horizontal Inferior OBS
oPrn:line(1400,0035,1850,0035) 	  //Linha Vertical OBS Esquerda
oPrn:line(1400,2500,1850,2500)    //Linha Vertical OBS Direita

oPrn:line(1900,0035,1900,3425)    //Linha Horizontal Rodape Inferior
oPrn:line(1960,0035,1960,3425)    //Linha Horizontal Rodape Inferior
oPrn:line(2085,0035,2085,3425)    //Linha Horizontal Rodape Inferior  Alterado em 22.08.2012 por André Luiz de Sousa

nLin := 1905

_nTot := (_nTot + _nValIcmR + _nValIpi + _nDespesa + _nSeguro + _nFrete - _nDescPed)

oPrn:say(nLin,0035,STR0027+" "+Transform(_nDescPed, "@E 999,999,999.99") ,oFont08I) //"Desc:"
//oPrn:say(nLin,0350,"ICMS RET: "+Transform((_cAlias)->C7_ICMSRET,"@E 999,999,999.99"),oFont08I) 		//"ICMSRET:"
oPrn:say(nLin,0450,STR0028+" "+Transform(_nValIcm,"@E 999,999,999.99"),oFont08I) 		//"ICMS:"
oPrn:say(nLin,1100,STR0029+" "+Transform(_nValIpi,"@E 999,999,999.99"),oFont08I) 		//"IPI:"
oPrn:say(nLin,1500,STR0044+" "+Transform(_nDespesa,"@E 99,999,999.99"),oFont08I)		//"Despesas: "
oPrn:say(nLin,1900,STR0045+" "+Transform(_nSeguro,"@E 99,999,999.99"),oFont08I)	   		//"Seguro: "
oPrn:say(nLin,2300,STR0043+" "+Transform(_nFrete,"@E 999,999,999.99"),oFont08I) 		//"Vlr Frete:"
oPrn:say(nLin,2700,STR0030+" "+Transform(_nTot,"@E 999,999,999.99"),oFont08N) 			//"Valor Total:"
nLin += 110
oPrn:say(nLin,0035,STR0032+" "+Alltrim(_cEndEnt) +" "+Alltrim(_cBairEnt) +  " - " + Alltrim(_cCidEnt)+ "/" +Alltrim(_cEstEnt),oFont08) 	//"Endereço de Entrega:"
oPrn:say(nLin,1250,STR0031+"  "+DTOC(_dDtEnt),oFont08) 									//"Prazo Programado p/ Entrega:"

nLin += 80
oPrn:say (nLin,625,"É OBRIGATORIO O AGENDAMENTO DO PEDIDO COM ANTENCENDENCIA DE 24HRS PARA A ENTREGA.",oFont13N) //"Msg"
nLin += 50
oPrn:say (nLin,1125,"PARA AGENDAR ACESSE: https://bit.ly/zanottientregas",oFont13N) //"Msg"

oPrn :EndPage()

Return

//********************************************************************************************
// 										   		QUERY
//********************************************************************************************
Static Function MontaQuery

Local cQuery  
Local cQuery1 
Local cQuery2

cQuery := "SELECT DISTINCT SC7.C7_NUM, SC7.C7_NUMSC,SC7.C7_ITEM,SC7.C7_FILENT, SC7.C7_VALFRE, SC7.C7_UM, SC7.C7_OP, SC7.C7_OBS, SA2T.A2_NOME AS TRANSPORTADORA,"
cQuery += " SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_QUANT - SC7.C7_QUJE AS QTD_ABERTO, SC7.C7_PRODUTO, SB1.B1_ZDESRDZ, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_DESCRI, SC7.C7_PRECO,"
cQuery += " SC7.C7_TOTAL, SC7.C7_EMISSAO, SC7.C7_DATPRF, SC7.C7_IPI, SC7.C7_DESC1,"
cQuery += " SC7.C7_DESC2, SC7.C7_DESC3, SC7.C7_VLDESC, SC7.C7_BASEICM, SC7.C7_BASEIPI, SC7.C7_VALIPI,"
cQuery += " SC7.C7_VALICM, SC7.C7_DT_EMB, SC7.C7_TOTAL, SC7.C7_CODTAB, SC7.C7_SEGURO, SC7.C7_DESPESA, SC7.C7_ICMSRET,"
cQuery += " SA2.A2_COD, SA2.A2_NOME, SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_EST, SA2.A2_MUN, SA2.A2_CEP,"
cQuery += " SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_DDD, SA5.A5_CODPRF, SB1.B1_DESC, SB1.B1_ZAPRES1, SE4.E4_CODIGO, SE4.E4_COND, CASE WHEN C7_TPFRETE = 'C' THEN 'CIF' WHEN C7_TPFRETE = 'F' THEN 'FOB' ELSE '' END AS TIPO_FRETE "
cQuery += " FROM "+RetSqlName('SC7')+" SC7 "
cQuery += " INNER JOIN "+RetSqlName('SA2')+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SC7.C7_FORNECE =  SA2.A2_COD     AND SC7.C7_LOJA = SA2.A2_LOJA        AND SA2.D_E_L_E_T_ <> '*' "
cQuery += " LEFT JOIN "+RetSqlName('SA5')+" SA5 ON SA5.A5_FILIAL = '"+xFilial("SA5")+"'  AND SC7.C7_PRODUTO =  SA5.A5_PRODUTO AND SC7.C7_FORNECE =  SA5.A5_FORNECE AND SC7.C7_LOJA = SA5.A5_LOJA  AND SA5.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN "+RetSqlName('SB1')+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SC7.C7_PRODUTO =  SB1.B1_COD     AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " LEFT JOIN "+RetSqlName('SE4')+" SE4 ON SE4.D_E_L_E_T_ = '' AND SE4.E4_CODIGO = SC7.C7_COND"
cQuery += " LEFT JOIN "+RetSqlName('SA2')+" SA2T ON  SA2T.D_E_L_E_T_ = '' AND SA2T.A2_COD = SC7.C7_TRANSP"
cQuery += " WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += " AND SC7.C7_FORNECE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' "
cQuery += " AND SC7.C7_LOJA    BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQuery += " AND SC7.C7_NUM     BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cQuery += " AND SC7.C7_EMISSAO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"' "
cQuery += " AND SC7.D_E_L_E_T_ <> '*' "

If Upper(TcGetDb()) $ "ORACLE.INFORMIX"
	cQuery += "   ORDER BY 1,2"
Else
	cQuery += "   ORDER BY SC7.C7_NUM,SC7.C7_ITEM"
Endif

//Criar alias temporário
TCQUERY cQuery NEW ALIAS (_cAlias)

tCSetField((_cAlias), "C7_EMISSAO", "D")
tCSetField((_cAlias), "C7_DATPRF",  "D")
tCSetField((_cAlias), "C7_DT_EMB",  "D")


cQuery1 := "SELECT C7_PRODUTO AS PRODUTO, C7_OBS AS OBS FROM SC7010 WHERE D_E_L_E_T_ = '' AND C7_OBS <> '' AND C7_FORNECE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' AND C7_LOJA    BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"'  AND C7_NUM     BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"'  AND C7_EMISSAO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"'"
If Select("AliasOBS") > 0
     dbSelectArea("AliasOBS")
     dbCloseArea()
EndIf
TcQuery cQuery1 New Alias AliasOBS
dbSelectArea("AliasOBS")

cQuery2 := "SELECT COUNT(C7_OBS) AS QTD_OBS FROM SC7010 WHERE D_E_L_E_T_ = '' AND C7_OBS <> '' AND C7_FORNECE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' AND C7_LOJA    BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"'  AND C7_NUM     BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"'  AND C7_EMISSAO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"'"
If Select("AliasCOUNTOBS") > 0
     dbSelectArea("AliasCOUNTOBS")
     dbCloseArea()
EndIf
TcQuery cQuery2 New Alias AliasCOUNTOBS
dbSelectArea("AliasCOUNTOBS")


//AliasCOUNTOBS->(dbCloseArea()) 
//AliasCOUNTOBS->(AliasOBS()) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110ALogo ³ Autor ³ Materiais             ³ Data ³08/01/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna string com o nome do arquivo bitmap de logotipo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110A                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

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
