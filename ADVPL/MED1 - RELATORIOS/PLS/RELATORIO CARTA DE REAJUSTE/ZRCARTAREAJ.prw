#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#DEFINE DMPAPER_A4 9 // A4 210 x 297 mm

// consulta padrao: CTRDIG
// 17747438000130

User Function ZRCARTAREAJ()
	
	Local cAtivPerg		 := ""
	Private cEOL 		 := "CHR(13)+CHR(10)"
	Private cPerg   	 := "ZRCREAJ" // Nome do grupo de perguntas

	If !Empty(cAtivPerg)
		Pergunte(cPerg,.F.)
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif

	
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	MsAguarde({||Imprime()},"Aguarde","Montando Carta de Reajuste...") 

Return


//********************************************************************************************//
//                        			MONTA A PAGINA DE IMPRESSAO								  //
//********************************************************************************************//
Static Function Imprime()

	/*	
	TEXTO

	Prezado (a) cliente,

	Gostar�amos de come�ar esta carta expressando nossa sincera gratid�o por sua confian�a e parceria cont�nua com a Medicar. Ao longo dos anos, nos empenhamos diariamente para oferecer servi�os de alta qualidade, visando sempre a seguran�a e o bem-estar de nossos clientes.

	Por isso, a fim de manter o n�vel de excel�ncia que voc� j� conhece e espera de n�s, precisamos realizar um reajuste nos valores dos nossos servi�os. 

	Esse ajuste � necess�rio para repor os aumentos nos custos de materiais e insumos que enfrentamos ao longo do �ltimo ano. 

	Al�m disso, ele � fundamental para garantir a manuten��o da qualidade dos nossos equipamentos, a atualiza��o da nossa frota de ve�culos e o cont�nuo treinamento dos nossos profissionais.

	Sabemos que qualquer mudan�a nos valores pode causar impacto, mas asseguramos que essa medida � imprescind�vel para continuarmos oferecendo servi�os de alta qualidade, com a seguran�a e a efici�ncia que voc� merece.

	O �ndice de reajuste ser� de [XX%] e passar� a vigorar a partir de [data de in�cio do reajuste]. Reiteramos nosso compromisso com a transpar�ncia e a qualidade e estamos � disposi��o para esclarecer qualquer d�vida que possa surgir.
	Agradecemos, mais uma vez, pela confian�a depositada em nossos servi�os. Estamos comprometidos em continuar merecendo essa confian�a e em atender voc� da melhor forma poss�vel.

	Atenciosamente,

	Equipe Medicar Solu��es em Sa�de  
	0800 940 0590


	*/

	//Local _nCont		:= 1
	Local cEmissao 		:= ""
	Local cDtReaj		:= ""
	Local cCliente	
	Private cLogoBmp	:= ""
	Private cRodapeBmp	:= ""
	Private cStartPath	:= GetSrvProfString("Startpath","")
	Private cPosi
	Private nLin
	Private _nPag		:= 1   // Numero da pagina

	cCliente := Posicione('SA1', 1, FWxFilial('SA1') + MV_PAR05 + "01", 'A1_NOME')

	IF SubStr(DTOS(MV_PAR02),5,2) = '01'
	
		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de janeiro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '02'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de fevereiro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '03'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de mar�o de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '04'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de abril de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '05'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de maio de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '06'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de junho de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '07'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de julho de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '08'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de agosto de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '09'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de setembro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '10'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de outubro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '11'

		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de novembro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '12'
		
		cEmissao := "S�o Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de dezembro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	EndIf


	IF SubStr(DTOS(MV_PAR04),5,2) = '01'
	
		cDtReaj := "Janeiro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '02'

		cDtReaj := "Fevereiro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '03'

		cDtReaj := "Mar�o/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '04'

		cDtReaj := "Abril/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '05'

		cDtReaj := "Maio/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '06'

		cDtReaj := "Junho/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '07'

		cDtReaj := "Julho/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '08'

		cDtReaj := "Agosto/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '09'

		cDtReaj := "Setembro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '10'

		cDtReaj := "Outubro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '11'

		cDtReaj := "Novembro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '12'
		
		cDtReaj := "Dezembro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	EndIf




	cTexto1 := "Prezado (a) cliente, " + cEOL + cEOL

	cTexto2 := "Gostar�amos de come�ar esta carta expressando nossa sincera gratid�o por sua confian�a e parceria"
	cTexto3 := "cont�nua com a Medicar. Ao longo dos anos, nos empenhamos diariamente para oferecer servi�os  " 
	cTexto4 := "de alta qualidade, visando sempre a seguran�a e o bem-estar de nossos clientes. "

	cTexto5 := "Por isso, a fim de manter o n�vel de excel�ncia que voc� j� conhece e espera de n�s, precisamos  "
	cTexto6 := "realizar um reajuste nos valores dos nossos servi�os. "
	
	cTexto7 := "Esse ajuste � necess�rio para repor os aumentos nos custos de materiais e insumos que enfrentamos "
	cTexto8 := "ao longo do�ltimo ano. "
	
	cTexto9  := "Al�m disso, ele � fundamental para garantir a manuten��o da qualidade dos nossos equipamentos, "
	cTexto10 := "a atualiza��o da nossa frota de ve�culos e o cont�nuo treinamento dos nossos profissionais. "
	
	cTexto11 := "Sabemos que qualquer mudan�a nos valores pode causar impacto, mas asseguramos que essa medida "
	cTexto12 := " � imprescind�vel para continuarmos oferecendo servi�os de alta qualidade, com a seguran�a  "
	cTexto12_1 := "e a efici�ncia que voc� merece. "
	
	cTexto13 := "O �ndice de reajuste ser� de "+ALLTRIM(MV_PAR03)+"% e passar� a vigorar a partir de "+cDtReaj+".  "
	cTexto14 := "Reiteramos nosso compromisso com a transpar�ncia e a qualidade e estamos � disposi��o para "
	cTexto15 := "esclarecer qualquer d�vida que possa surgir. "
	
	cTexto16 := "Agradecemos, mais uma vez, pela confian�a depositada em nossos servi�os. Estamos comprometidos "
	cTexto17 := "em continuar merecendo essa confian�a e em atender voc� da melhor forma poss�vel. "
	
	cTexto18 :="Atenciosamente, " 
	
	cTexto19 := "Equipe Medicar Solu��es em Sa�de   " 
	cTexto20 := "0800 940 0590 "

	cLogoBmp := "\RELATORIOS\CARTAREAJUSTE\reajuste.bmp"	
	

	//********************************************************************************************
	//									FONTESS DO RELATORIO
	//********************************************************************************************

	//Fontes a serem utilizadas no relat�rio
	Private oFont08  	:= TFont():New( "Arial",,08,,.F.,,,,,.f.)
	Private oFont08N 	:= TFont():New( "Arial",,08,,.T.,,,,,.f.)
	Private oFont08I 	:= TFont():New( "Arial",,08,,.f.,,,,,.f.,.T.)
	Private oFont09  	:= TFont():New( "Arial",,09,,.F.,,,,,.f.)
	Private oFont09N 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
	Private oFontC9  	:= TFont():New( "Courier New",,09,,.F.,,,,,.f.)
	Private oFontC9N 	:= TFont():New( "Courier New",,09,,.T.,,,,,.f.)
	Private oFont10  	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
	Private oFont10N 	:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
	Private oFont10I 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)
	Private oFont11  	:= TFont():New( "Arial",,11,,.f.,,,,,.f.)
	Private oFont11N 	:= TFont():New( "Arial",,11,,.T.,,,,,.f.)
	Private oFont12N 	:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
	Private oFont12  	:= TFont():New( "Arial",,12,,.F.,,,,,.F.)
	Private oFont12NS	:= TFont():New( "Arial",,12,,.T.,,,,,.T.)
	Private oFont13N 	:= TFont():New( "Arial",,13,,.T.,,,,,.f.)
	Private oFont15N 	:= TFont():New( "Arial",,15,,.T.,,,,,.f.)
	Private oFont17 	:= TFont():New( "Arial",,17,,.F.,,,,,.F.)
	Private oFont17N 	:= TFont():New( "Arial",,17,,.T.,,,,,.F.)


	//********************************************************************************************
	//									DADOS E PARAMETRIZA��ES
	//********************************************************************************************

	//Start de impress�o
	Private oPrn:= TMSPrinter():New()

	oPrn:SetPortrait()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
	oPrn:setPaperSize( DMPAPER_A4 )

	nLin := 10

	/*		
	If _nCont >= 1
	
		_nCont		:= 0
		_nPag 		+= 1
		
		oPrn :EndPage() 

	EndIf
	_nCont += 1
	*/

	//logo
	oPrn:SayBitmap(000,0000,cLogoBmp,2480,3508)


	nLin := 500
	oPrn:say(nLin,1400,cEmissao,oFont15N,,)
	
	nLin += 200
	oPrn:say(nLin,0200,cCliente,oFont15N,,)


	// Primeiro paragrafo
	nLin += 250
	oPrn:say(nLin,0200,cTexto1,oFont12N,)
	nLin += 100
	oPrn:say(nLin,0200,cTexto2,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto3,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto4,oFont12N,)

	// Segundo paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto5,oFont12N,)
	nLin += 100
	oPrn:say(nLin,0200,cTexto6,oFont12N,)
	
	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto7,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto8,oFont12N,)


	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto9,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto10,oFont12N,)

	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto11,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto12,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto12_1,oFont12N,)
	

	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto13,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto14,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto15,oFont12N,)

	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto16,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto17,oFont12N,)

	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto18,oFont12N,)

	// Terceiro paragrafo
	nLin += 100
	oPrn:say(nLin,0200,cTexto19,oFont12N,)
	nLin += 50
	oPrn:say(nLin,0200,cTexto20,oFont12N,)


	oPrn:Preview() //Preview DO RELATORIO

Return



