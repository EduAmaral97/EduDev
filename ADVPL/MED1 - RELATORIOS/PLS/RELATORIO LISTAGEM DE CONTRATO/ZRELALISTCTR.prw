//#############################################################################
//#              ZFINR470 - RELATORIO LISTAGEM DE CONTRATO	            	  #
//#	Por: Edyardo Jorge														  #
//# Em: 12/03/2024															  #
//#############################################################################

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#DEFINE DMPAPER_A4 9 // A4 210 x 297 mm


//********************************************************************************************//
//                        			FILTROS E CHAMADAS DO FONTE								  //
//********************************************************************************************//
User Function ZRELALISTCTR(cListaContrato)
		

	DEFAULT cListaContrato  := ""
	Private cAgencia	    := ""
	Private cConta		  	:= ""
	Private _cAlias		  	:= GetNextAlias()
	Private cAliasCapaCtr 	:= GetNextAlias()
	Private cEOL 		  	:= "CHR(13)+CHR(10)"
	Private cPerg   	  	:= "ZRLISTCTR" // Nome do grupo de perguntas

	If !Empty(cListaContrato)
		Pergunte(cPerg,.F.)
		//MV_PAR04 := cListaContrato
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
	MsAguarde({||MontaQuery()},"Aguarde","Criando arquivos para impressão...") //"Aguarde"##"Criando arquivos para impressão..."

	//Verifica resultado da query

	DbSelectArea(_cAlias)
	DbSelectArea(cAliasCapaCtr)

	DbGoTop()
	If (_cAlias)->(Eof())
		MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
		(_cAlias)->(DbCloseArea())
		(cAliasCapaCtr)->(DbCloseArea())
	Else

		If MV_PAR02 = 1
			Processa({|| Imprime() },"Listagem de Contrato","Gerando PDF...") //"Pedido de Compras "##"Imprimindo..."
		Else
			Processa({|| fGeraExcel() },"Listagem de Contrato","Gerando Excel...") //"Pedido de Compras "##"Imprimindo..."
		Endif

	EndIf


Return


//********************************************************************************************//
//                        			MONTA A PAGINA DE IMPRESSAO								  //
//********************************************************************************************//
Static Function Imprime()


	Local _nCont 		:= 1
	//Local aAreaSM0	:= {}	 
	Private cBitmap	:= ""
	Private cStartPath:= GetSrvProfString("Startpath","")
	Private cPosi
	Private nLin
	Private _nPag  			:= 1   // Numero da pagina
	//Private cNomeAgrup := ''

	Private cTotalValor := 0
	Private cTotalBaixado := 0

	cBitmap := R110ALogo()


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
	Private oFont17 	:= TFont():New( "Arial",,17,,.F.,,,,,.F.)
	Private oFont17N 	:= TFont():New( "Arial",,17,,.T.,,,,,.F.)

	
	//********************************************************************************************
	//									VARIAVEIS DE TOTAIS
	//********************************************************************************************

	//QUANTIDADES
	Private nQtdAtivos    := 0
	Private nQtdInativos  := 0 
	Private nQtdComAtm    := 0
	Private nQtdSemAtm    := 0
	Private nQtdMenor60   := 0 
	Private nQtdMaior60   := 0 
	Private nQtdTitular   := 0 
	Private nQtdDepedente := 0
	Private nQtdTotalReg  := 0  

	//VALORES
	Private nTotalTit	  := 0
	Private nTotalDep	  := 0
	Private nTotalComAtm  := 0
	Private nTotalValor	  := 0




	//********************************************************************************************
	//									DADOS E PARAMETRIZAÇÕES
	//********************************************************************************************

	//Start de impressão
	Private oPrn:= TMSPrinter():New()

	oPrn:SetLandscape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
	oPrn:setPaperSize( DMPAPER_A4 )

	//cabecalho da pagina
	Cabec(.t.)

		nLin := 620


	// IMPRIME DADOS DA CONSULTA
	While (_cAlias)->(!Eof())
		
		If _nCont >= 28
		
			_nCont		:= 0
			_nPag 		+= 1

			oPrn :EndPage() 
			Cabec(.t.)
			nLin := 620

		EndIf 
		
		oPrn:say(nLin,0115,(_cAlias)->CODIGO,oFont10)
		oPrn:say(nLin,0420,(_cAlias)->TIPO,oFont10)
		oPrn:say(nLin,0550,(_cAlias)->NOME,oFont10)
		//oPrn:say(nLin,1550,(_cAlias)->DTNASCIMENTO,oFont10)
		oPrn:say(nLin,1550, SubStr((_cAlias)->DTNASCIMENTO,7,2) + "/" + SubStr((_cAlias)->DTNASCIMENTO,5,2) + "/" + SubStr((_cAlias)->DTNASCIMENTO,1,4),oFont10)
		oPrn:say(nLin,1850,(_cAlias)->STATUSBEN,oFont10)
		//oPrn:say(nLin,2150,(_cAlias)->DTVIGOR,oFont10)
		oPrn:say(nLin,2150, SubStr((_cAlias)->DTVIGOR,7,2) + "/" + SubStr((_cAlias)->DTVIGOR,5,2) + "/" + SubStr((_cAlias)->DTVIGOR,1,4),oFont10)
		oPrn:say(nLin,2450,(_cAlias)->ATEND,oFont10)
		oPrn:say(nLin,2750,	"R$" + Str((_cAlias)->VALOR,10,2),oFont10)
		//oPrn:say(nLin,3050,(_cAlias)->VALORTOT,oFont10)
		//oPrn:say(nLin,3200,(_cAlias)->NRDEP,oFont10)
		
		//oPrn:say(nLin,1620, "R$" + Str((_cAlias)->VALOR,10,2),oFont10N)						//VALOR
		//oPrn:say(nLin,1320, SubStr((_cAlias)->DTNASCIMENTO,7,2) + "/" + SubStr((_cAlias)->DTNASCIMENTO,5,2) + "/" + SubStr((_cAlias)->DTNASCIMENTO,1,4),oFont10N)										//VENCIMENTO

		nLin += 60   //pula linha
		
		/*VALORES TOTALIZADOS*/
		//cTotalValor := cTotalValor + (_cAlias)->VALOR
		//cTotalBaixado := cTotalBaixado + (_cAlias)->VALORES_BAIXADOS

		_nCont += 1
		//Verifica a quebra de pagina


		If (_cAlias)->STATUSBEN = 'ATIVO'
			nQtdAtivos := nQtdAtivos + 1
		Else
			nQtdInativos := nQtdInativos + 1
		Endif

		If (_cAlias)->ATEND = 'SIM'
			nQtdComAtm := nQtdComAtm + 1
			nTotalComAtm := nTotalComAtm + (_cAlias)->VALOR
		Else
			nQtdSemAtm := nQtdSemAtm + 1
		Endif

		If (_cAlias)->DIFANOS <= 60
			nQtdMenor60 := nQtdMenor60 + 1
		Else
			nQtdMaior60 := nQtdMaior60 + 1
		Endif

		If (_cAlias)->TIPO = 'T'
			nQtdTitular := nQtdTitular + 1
			nTotalTit := nTotalTit + (_cAlias)->VALOR
		Else
			nQtdDepedente := nQtdDepedente + 1
			nTotalDep := nTotalDep + (_cAlias)->VALOR
		Endif

		nQtdTotalReg := nQtdTotalReg + 1
		nTotalValor := nTotalValor + (_cAlias)->VALOR

		(_cAlias)->(dBskip())


	EndDo

	//cSaldoFinal := MV_PAR06 + cTotalEntrada - cTotalSaida

	If _nCont <= 28
		(_cAlias)->(DbGoTop())
		//		Infoger()
		Rodap()
		//		WordImp()
	//Else
		//(_cAlias)->(DbGoTop())
		//Rodap()
		//oPrn :EndPage()
		//Cabec(.f.)
		//   		Infoger()
		//Rodap()
		//   		WordImp()
	EndIF


	oPrn:Preview() //Preview DO RELATORIO

	/*
	If(mv_par07 == 1)
	oPrn:Print()
	Else
	oPrn:Preview() //Preview DO RELATORIO
	EndIf

	*/


Return


//********************************************************************************************
//										Impressão do Relatório
//********************************************************************************************
Static Function  Cabec(_lCabec)

	oPrn:StartPage()	//Inicia uma nova pagina

	_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

	oPrn:SayBitmap(0045,0060,_cFileLogo,0400,0125)

	oPrn:say(0070,0550, "MEDICAR EMERGENCIAS MEDICAS LTDA",oFont17N)
	oPrn:say(0150,0550, "Listagem de Contrato",oFont13N)

	//oPrn:line(210,1200,430,1200) 	//1 Linha Vertical Cabecalho

	oPrn:line(0205,0100,0205,3300)    //Linha Horizontal Cabecalho Superor
	oPrn:line(0505,0100,0505,3300)    //Linha Horizontal Cabecalho Inferior
	oPrn:line(0205,0100,0505,0100) 	  //Linha Vertical Cabecalho Esquerda
	oPrn:line(0205,3300,0505,3300) 	  //Linha Vertical Cabecalho Direita


	oPrn:line(0305,0100,0305,3300)    //Linha Horizontal Cabecalho MEIO
	oPrn:line(0405,0100,0405,3300)    //Linha Horizontal Cabecalho MEIO

	

	//********************************************************************************************
	//										cabecalho											 
	//********************************************************************************************

	// Primeira coluna do cabecalho
	nLin := 250

	//oPrn:line(nLin,0015,nLin,2520)    //Linha Horizontal Cabecalho Inferior
	//oPrn:line(nLin,0035,2250,0035) 	 //Linha Vertical OBS Esquerda

	//oPrn:say (nLin,0035, "MEDICAR EMERGENCIAS MEDICAS LTDA",oFont13N)

	// Primeira coluna do cabecalho

	oPrn:say (nLin,0115, "Numero: " ,oFont10N)
	oPrn:say (nLin,0705, "Nome: " ,oFont10N)
	oPrn:say (nLin,1750, "Tipo Contrato:" ,oFont10N)
	oPrn:say (nLin,2600, "Cadastro: " ,oFont10N)
	oPrn:say (nLin,3000, "Ficha: " ,oFont10N)
	nLin += 100
	oPrn:say (nLin,0115, "Nro Vidas: " ,oFont10N)
	oPrn:say (nLin,0705, "Valor: " ,oFont10N)
	oPrn:say (nLin,1150, "Forma Pgto: " ,oFont10N)
	oPrn:say (nLin,2220, "Fone: " ,oFont10N)
	oPrn:say (nLin,2600, "Bairro:" ,oFont10N)
	nLin += 100
	oPrn:say (nLin,0115, "Tp parcela: " ,oFont10N)
	oPrn:say (nLin,0705, "Vencimento: " ,oFont10N)
	oPrn:say (nLin,1150, "Portador: " ,oFont10N)
	oPrn:say (nLin,1450, "Agencia: " ,oFont10N)
	oPrn:say (nLin,1850, "C/C:" ,oFont10N)
	oPrn:say (nLin,2200, "Endereco:" ,oFont10N)


	/* ------------------------- DADOS CABECARIO ------------------------- */

	nLin := 250

	oPrn:say(nLin,0300,(cAliasCapaCtr)->NUMERO,oFont10)
	oPrn:say(nLin,0850,(cAliasCapaCtr)->NOMECLI,oFont10)
	oPrn:say(nLin,2050,(cAliasCapaCtr)->TIPOCTR,oFont10)
	//oPrn:say(nLin,2800,(cAliasCapaCtr)->DTCAD,oFont10)
	oPrn:say(nLin,2800, SubStr((cAliasCapaCtr)->DTCAD,7,2) + "/" + SubStr((cAliasCapaCtr)->DTCAD,5,2) + "/" + SubStr((cAliasCapaCtr)->DTCAD,1,4),oFont10)
	oPrn:say(nLin,3150,(cAliasCapaCtr)->FICHA,oFont10)
	nLin += 100
	oPrn:say(nLin,0250,	Str((cAliasCapaCtr)->QTDVIDAS,10),oFont10)
	oPrn:say(nLin,0850,"R$" + Str((cAliasCapaCtr)->VALORCTR,10,2),oFont10)
	oPrn:say(nLin,1400,SubStr((cAliasCapaCtr)->CONDPAG,1,38),oFont10)
	oPrn:say(nLin,2350,(cAliasCapaCtr)->FONE,oFont10)
	oPrn:say(nLin,2750,(cAliasCapaCtr)->BAIRRO,oFont10)
	nLin += 100
	oPrn:say(nLin,0350,(cAliasCapaCtr)->TPPARC,oFont10)
	oPrn:say(nLin,0950,Str((cAliasCapaCtr)->VENCTO,2),oFont10)
	oPrn:say(nLin,1250,(cAliasCapaCtr)->PORTADOR,oFont10)
	oPrn:say(nLin,1600,(cAliasCapaCtr)->AGENCIA,oFont10)
	oPrn:say(nLin,1900,(cAliasCapaCtr)->CC,oFont10)
	oPrn:say(nLin,2400,(cAliasCapaCtr)->ENDERECO,oFont10)


	//********************************************************************************************
	//										Corpo
	//********************************************************************************************
	nLin := 550
	// Subtitulo do Corpo

	oPrn:say (nLin,0115,"Codigo",oFont10N) 					
	oPrn:say (nLin,0400,"Tipo",oFont10N) 					
	oPrn:say (nLin,0550,"Nome Assossiado",oFont10N) 		
	oPrn:say (nLin,1550,"Nasc.",oFont10N) 					
	oPrn:say (nLin,1850,"Status",oFont10N) 					
	oPrn:say (nLin,2150,"Dt. Vigor",oFont10N) 				
	oPrn:say (nLin,2450,"Atend.",oFont10N) 					
	oPrn:say (nLin,2750,"Valor Ind.",oFont10N) 					
	//oPrn:say (nLin,3050,"Valor.",oFont10N) 					
	//oPrn:say (nLin,3200,"Nr Dep.",oFont10N)

	nLin := 510
	oPrn:say (0070,3000,"Emitido em: " + DTOC(Date()),oFont08I)    //Impressão do numero da página
	oPrn:say (0120,3000,"Pag. " + Transform(_nPag,"@R 999"),oFont08I)    //Impressão do numero da página
	//oPrn:say (0070,3200,nHorzRes(),oFont08I)
	//oPrn:say (0070,3200,nLogPixelX(),oFont08I)


	//oPrn:say (0300,3200,"Saldo Inicial: " + "0" ,oFont08I) //"Saldo Inicial"

return


//********************************************************************************************
//										Rodape
//********************************************************************************************
Static Function Rodap()



	//nLin := 3200
									
		oPrn:line(2300,0100,2300,3300)    //Linha Horizontal Rodape Superor
		oPrn:line(2500,0100,2500,3300)    //Linha Horizontal Rodape Inferior
		
		oPrn:line(2300,0100,2500,0100) 	  //Linha Vertical Rodape Esquerda
		oPrn:line(2300,3300,2500,3300) 	  //Linha Vertical Rodape Direita


		oPrn:say (2370,0150, "Ativos: " ,oFont10N)
		oPrn:say (2410,0150, "Inativos: " ,oFont10N)

		oPrn:say (2370,0550, "C/ Atendimento: " ,oFont10N)
		oPrn:say (2410,0550, "S/ Atendimento: " ,oFont10N)

		oPrn:say (2370,1200, "Ate 60 anos: " ,oFont10N)
		oPrn:say (2410,1200, "Acima de 60 anos: " ,oFont10N)

		oPrn:say (2370,1750, "Titulares: " ,oFont10N)
		oPrn:say (2410,1750, "Depedentes: " ,oFont10N)

		oPrn:say (2370,2500, "Total c/ Atendimento: " ,oFont10N)
		oPrn:say (2410,2500, "Reg. Listados: " ,oFont10N)


		/* ----------------------- VALORES DAS VARIAVEIS ----------------------- */


		oPrn:say(2370,0270,Str(nQtdAtivos),oFont10)
		oPrn:say(2410,0270,Str(nQtdInativos),oFont10)
		
		oPrn:say(2370,0850,Str(nQtdComAtm),oFont10)
		oPrn:say(2410,0850,Str(nQtdSemAtm),oFont10)
		
		oPrn:say(2370,1450,Str(nQtdMenor60),oFont10)
		oPrn:say(2410,1450,Str(nQtdMaior60),oFont10)
		
		oPrn:say(2370,1900,Str(nQtdTitular),oFont10)
		oPrn:say(2410,1900,Str(nQtdDepedente),oFont10)
		oPrn:say(2370,2100,	"|  R$" + Str(nTotalTit,10,2),oFont10)
		oPrn:say(2410,2100,	"|  R$" + Str(nTotalDep,10,2),oFont10)


		oPrn:say(2370,2900,	"R$" + Str(nTotalComAtm,10,2),oFont10)
		oPrn:say(2410,2900,Str(nQtdTotalReg),oFont10)
		
		//nTotalValor

	oPrn :EndPage()	

Return


//********************************************************************************************
// 										  	QUERY
//********************************************************************************************
Static Function MontaQuery

	Local cQuery  
	local cQueryCapaCtr

	cQuery := " SELECT "
	cQuery += " BA1.BA1_XCARTE 	AS CODIGO, "
	cQuery += " BA1.BA1_MATEMP   AS MATEMP, "
	cQuery += " BA1.BA1_TIPUSU	AS TIPO, "
	cQuery += " BA1.BA1_NOMUSR	AS NOME, "
	cQuery += " BA1.BA1_DATNAS	AS DTNASCIMENTO, "
	cQuery += " CASE "
	cQuery += "	WHEN BA1.BA1_MOTBLO <> '' AND BA1.BA1_DATBLO <> '' THEN 'INATIVO' "
	cQuery += "	ELSE 'ATIVO' "
	cQuery += " END 				AS STATUSBEN, "
	cQuery += " BA1.BA1_DATINC	AS DTVIGOR, "
	cQuery += " CASE "
	cQuery += "	WHEN BA1.BA1_ZATEND = '1' THEN 'SIM' "
	cQuery += "	ELSE 'NAO' "
	cQuery += " END 				AS ATEND, "
	cQuery += " DATEDIFF(year, BA1.BA1_DATNAS, GETDATE()) AS DIFANOS, "
	cQuery += " BDK.BDK_VALOR	AS VALOR, "
	cQuery += " ISNULL((SELECT TOP 1 A.BA1_NOMUSR FROM BA1010 A WHERE 1=1	AND A.D_E_L_E_T_ = '' AND A.BA1_FILIAL = BA1.BA1_FILIAL AND A.BA1_MATRIC = BA1.BA1_MATRIC AND A.BA1_CODINT = BA1.BA1_CODINT AND A.BA1_CODEMP = BA1.BA1_CODEMP AND A.BA1_CONEMP = BA1.BA1_CONEMP AND A.BA1_VERCON = BA1.BA1_VERCON AND A.BA1_SUBCON = BA1.BA1_SUBCON AND A.BA1_VERSUB = BA1.BA1_VERSUB AND A.BA1_TIPREG = '00'),'') AS TITULAR, "
	cQuery += " CASE WHEN BA1.BA1_TIPUSU = 'T' THEN 'A' ELSE 'B' END "
	cQuery += " FROM BA1010 BA1  "
	cQuery += " LEFT JOIN BDK010 BDK ON BDK.BDK_FILIAL = BA1.BA1_FILIAL AND BDK.BDK_CODINT = BA1.BA1_CODINT AND BDK.BDK_CODEMP = BA1.BA1_CODEMP AND BDK.BDK_MATRIC = BA1.BA1_MATRIC AND BDK.BDK_TIPREG = BA1.BA1_TIPREG AND BDK.D_E_L_E_T_ = ''  "
	cQuery += " WHERE 1=1  "
	cQuery += " AND BA1.D_E_L_E_T_ = ''  "
	cQuery += " AND BA1.BA1_SUBCON = '"+MV_PAR01+"'  "
	If MV_PAR03 = 2       
		cQuery += " AND BA1.BA1_MOTBLO = '' "
		cQuery += " AND BA1.BA1_DATBLO = '' "
	Endif
	cQuery += " ORDER BY 11,12,4 "


	cQueryCapaCtr := " SELECT  "
	cQueryCapaCtr += " A.BQC_ANTCON								AS NUMERO, "
	cQueryCapaCtr += " B.A1_NOME								AS NOMECLI, "
	cQueryCapaCtr += " C.BT5_NOME								AS TIPOCTR, "
	cQueryCapaCtr += " A.BQC_DATCON								AS DTCAD, "
	cQueryCapaCtr += " 'S/F'									AS FICHA, "
	cQueryCapaCtr += " ISNULL(( SELECT COUNT(*) FROM BA1010 BA1 WHERE 1=1 AND BA1.BA1_MOTBLO = '' AND BA1.BA1_DATBLO = '' AND BA1.BA1_SUBCON = A.BQC_SUBCON),0) AS QTDVIDAS, "
	cQueryCapaCtr += " ISNULL((SELECT SUM(BDK.BDK_VALOR) FROM BA1010 BA1 LEFT JOIN BDK010 BDK ON BDK.BDK_FILIAL = BA1.BA1_FILIAL AND BDK.BDK_CODINT = BA1.BA1_CODINT AND BDK.BDK_CODEMP = BA1.BA1_CODEMP AND BDK.BDK_MATRIC = BA1.BA1_MATRIC AND BDK.BDK_TIPREG = BA1.BA1_TIPREG AND BDK.D_E_L_E_T_ = '' WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND BA1.BA1_MOTBLO = '' AND BA1.BA1_DATBLO = '' AND BDK.BDK_VALOR > 0.01 AND BA1.BA1_SUBCON = A.BQC_SUBCON ),0) AS VALORCTR,	 "
	cQueryCapaCtr += " D.ZI0_DESCRI 							AS CONDPAG, "
	cQueryCapaCtr += " CONCAT(B.A1_DDD, ' ', B.A1_TEL) 			AS FONE, "
	cQueryCapaCtr += " B.A1_BAIRRO 								AS BAIRRO, "
	cQueryCapaCtr += " 'MENSAL'									AS TPPARC, "
	cQueryCapaCtr += " D.ZI0_VENCTO 							AS VENCTO, "
	cQueryCapaCtr += " B.A1_CODBANC								AS PORTADOR, "
	cQueryCapaCtr += " CONCAT(B.A1_ZZAGENC, '-',B.A1_ZZDVAGG) 	AS AGENCIA, "
	cQueryCapaCtr += " CONCAT(B.A1_ZZNRCON, '-',B.A1_ZZDVCTA)	AS CC, "
	cQueryCapaCtr += " B.A1_END									AS ENDERECO "
	cQueryCapaCtr += " FROM BQC010 A "
	cQueryCapaCtr += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.BQC_CODCLI AND B.A1_LOJA = A.BQC_LOJA "
	cQueryCapaCtr += " LEFT JOIN BT5010 C ON C.D_E_L_E_T_ = '' AND C.BT5_CODINT = A.BQC_CODINT AND C.BT5_CODIGO = A.BQC_CODEMP AND C.BT5_NUMCON = A.BQC_NUMCON "
	cQueryCapaCtr += " LEFT JOIN ZI0010 D ON D.D_E_L_E_T_ = '' AND D.ZI0_CODIGO = A.BQC_XCONDI "
	cQueryCapaCtr += " WHERE 1=1 "
	cQueryCapaCtr += " AND A.D_E_L_E_T_ = '' "
	cQueryCapaCtr += " AND A.BQC_CODEMP IN ('0004','0005') "
	cQueryCapaCtr += " AND A.BQC_SUBCON = '"+MV_PAR01+"' "
	

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)
	TCQUERY cQueryCapaCtr NEW ALIAS (cAliasCapaCtr)

Return

//********************************************************************************************
//									LOGO DA EMPRESA
//********************************************************************************************
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


//********************************************************************************************
//									GERA EM EXCEL
//********************************************************************************************
Static Function fGeraExcel()

	
	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Selecione a pasta onde sera salvo o arquivo"
    Local lSalvar := .F.
    //Local cPasta  := ""
 
    //Se não estiver sendo executado via job
    If ! IsBlind()
 
        //Chama a função para buscar arquivos
        cPasta := tFileDialog(;
            cTipArq,;                  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;                  // Título da Janela para seleção dos arquivos
            ,;                         // Compatibilidade
            cDirIni,;                  // Diretório inicial da busca de arquivos
            lSalvar,;                  // Se for .T., será uma Save Dialog, senão será Open Dialog
            GETF_RETDIRECTORY;         // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
        )
 
    EndIf 

	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Gerando Arquivo em Excel...")

	//MsgAlert("Excel Em desenvolvimento!")


Return


//********************************************************************************************
//									MONTA ARQUIVO EM EXCEL
//********************************************************************************************
Static Function fMontaExcel(cPasta)

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("LISTACTR")
	oExcel:AddworkSheet("LISTACTR")

	//lRet := oExcel:IsWorkSheet("PLANILHA1")
	//oExcel:AddTable ("TELEMEDINC","TELEMED")
	oExcel:AddTable ("LISTACTR","BENEFCTR",.F.)

	oExcel:AddColumn("LISTACTR","BENEFCTR","CODIGO"			,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","TIPO"			,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","NOME"			,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","DTNASCIMENTO"	,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","STATUSBEN"		,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","DTVIGOR"		,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","ATEND"			,1,1,.F., "")
	oExcel:AddColumn("LISTACTR","BENEFCTR","VALOR"			,1,3,.F., "")


	While (_cAlias)->(!Eof())

		oExcel:AddRow("LISTACTR","BENEFCTR",{(_cAlias)->CODIGO,(_cAlias)->TIPO,(_cAlias)->NOME,SubStr((_cAlias)->DTNASCIMENTO,7,2) + "/" + SubStr((_cAlias)->DTNASCIMENTO,5,2) + "/" + SubStr((_cAlias)->DTNASCIMENTO,1,4),(_cAlias)->STATUSBEN,SubStr((_cAlias)->DTVIGOR,7,2) + "/" + SubStr((_cAlias)->DTVIGOR,5,2) + "/" + SubStr((_cAlias)->DTVIGOR,1,4),(_cAlias)->ATEND,(_cAlias)->VALOR})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cPasta := cPasta + '\' + MV_PAR01 + '_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cPasta)

	oExcel:DeActivate()

Return
