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

	Gostaríamos de começar esta carta expressando nossa sincera gratidão por sua confiança e parceria contínua com a Medicar. Ao longo dos anos, nos empenhamos diariamente para oferecer serviços de alta qualidade, visando sempre a segurança e o bem-estar de nossos clientes.

	Por isso, a fim de manter o nível de excelência que você já conhece e espera de nós, precisamos realizar um reajuste nos valores dos nossos serviços. 

	Esse ajuste é necessário para repor os aumentos nos custos de materiais e insumos que enfrentamos ao longo do último ano. 

	Além disso, ele é fundamental para garantir a manutenção da qualidade dos nossos equipamentos, a atualização da nossa frota de veículos e o contínuo treinamento dos nossos profissionais.

	Sabemos que qualquer mudança nos valores pode causar impacto, mas asseguramos que essa medida é imprescindível para continuarmos oferecendo serviços de alta qualidade, com a segurança e a eficiência que você merece.

	O índice de reajuste será de [XX%] e passará a vigorar a partir de [data de início do reajuste]. Reiteramos nosso compromisso com a transparência e a qualidade e estamos à disposição para esclarecer qualquer dúvida que possa surgir.
	Agradecemos, mais uma vez, pela confiança depositada em nossos serviços. Estamos comprometidos em continuar merecendo essa confiança e em atender você da melhor forma possível.

	Atenciosamente,

	Equipe Medicar Soluções em Saúde  
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
	
		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de janeiro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '02'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de fevereiro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '03'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de março de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '04'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de abril de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '05'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de maio de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '06'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de junho de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '07'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de julho de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '08'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de agosto de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '09'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de setembro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '10'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de outubro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '11'

		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de novembro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	Elseif SubStr(DTOS(MV_PAR02),5,2) = '12'
		
		cEmissao := "São Paulo, " + SubStr(DTOS(MV_PAR02),7,2) + " de dezembro de " + SubStr(DTOS(MV_PAR02),1,4) + '.'
	
	EndIf


	IF SubStr(DTOS(MV_PAR04),5,2) = '01'
	
		cDtReaj := "Janeiro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '02'

		cDtReaj := "Fevereiro/" + SubStr(DTOS(MV_PAR02),1,4)
	
	Elseif SubStr(DTOS(MV_PAR04),5,2) = '03'

		cDtReaj := "Março/" + SubStr(DTOS(MV_PAR02),1,4)
	
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

	cTexto2 := "Gostaríamos de começar esta carta expressando nossa sincera gratidão por sua confiança e parceria"
	cTexto3 := "contínua com a Medicar. Ao longo dos anos, nos empenhamos diariamente para oferecer serviços  " 
	cTexto4 := "de alta qualidade, visando sempre a segurança e o bem-estar de nossos clientes. "

	cTexto5 := "Por isso, a fim de manter o nível de excelência que você já conhece e espera de nós, precisamos  "
	cTexto6 := "realizar um reajuste nos valores dos nossos serviços. "
	
	cTexto7 := "Esse ajuste é necessário para repor os aumentos nos custos de materiais e insumos que enfrentamos "
	cTexto8 := "ao longo doúltimo ano. "
	
	cTexto9  := "Além disso, ele é fundamental para garantir a manutenção da qualidade dos nossos equipamentos, "
	cTexto10 := "a atualização da nossa frota de veículos e o contínuo treinamento dos nossos profissionais. "
	
	cTexto11 := "Sabemos que qualquer mudança nos valores pode causar impacto, mas asseguramos que essa medida "
	cTexto12 := " é imprescindível para continuarmos oferecendo serviços de alta qualidade, com a segurança  "
	cTexto12_1 := "e a eficiência que você merece. "
	
	cTexto13 := "O índice de reajuste será de "+ALLTRIM(MV_PAR03)+"% e passará a vigorar a partir de "+cDtReaj+".  "
	cTexto14 := "Reiteramos nosso compromisso com a transparência e a qualidade e estamos à disposição para "
	cTexto15 := "esclarecer qualquer dúvida que possa surgir. "
	
	cTexto16 := "Agradecemos, mais uma vez, pela confiança depositada em nossos serviços. Estamos comprometidos "
	cTexto17 := "em continuar merecendo essa confiança e em atender você da melhor forma possível. "
	
	cTexto18 :="Atenciosamente, " 
	
	cTexto19 := "Equipe Medicar Soluções em Saúde   " 
	cTexto20 := "0800 940 0590 "

	cLogoBmp := "\RELATORIOS\CARTAREAJUSTE\reajuste.bmp"	
	

	//********************************************************************************************
	//									FONTESS DO RELATORIO
	//********************************************************************************************

	//Fontes a serem utilizadas no relatório
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
	//									DADOS E PARAMETRIZAÇÕES
	//********************************************************************************************

	//Start de impressão
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



