//#############################################################################
//#              ZFINR470 - CARTEIRA DOS VENDEDORES			            	  #
//#	Por: Edyardo Jorge														  #
//# Em: 03/04/2024															  #
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
User Function ZCARTEIRAVEND(cListaContrato)
		

	DEFAULT cListaContrato  		:= ""
	Private cAgencia	    		:= ""
	Private cConta		  			:= ""
	Private cEOL 		  			:= "CHR(13)+CHR(10)"
	Private cPerg   	  			:= "ZCARTEVEND" // Nome do grupo de perguntas
	Private _cAlias 				:= GetNextAlias()
	Private _cAliasVend				:= GetNextAlias()
	Private _cPerfil				:= GetNextAlias()
	Private _cEquipe				:= GetNextAlias()
	Private _cParcela				:= GetNextAlias()



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
	DbSelectArea(_cAliasVend)
	DbSelectArea(_cPerfil)
	DbSelectArea(_cEquipe)
	DbSelectArea(_cParcela)

	DbGoTop()
	If (_cAlias)->(Eof())

		MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
		(_cAlias)->(DbCloseArea())
		(_cAliasVend)->(DbCloseArea())
		(_cPerfil)->(DbCloseArea())
		(_cEquipe)->(DbCloseArea())
		(_cParcela)->(DbCloseArea())

	Else

		Processa({|| Imprime() },"Listagem de Contrato","Gerando Carteira de Vendas...") //"Pedido de Compras "##"Imprimindo..."

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
	//									DADOS E PARAMETRIZAÇÕES
	//********************************************************************************************

	//Start de impressão
	Private oPrn:= TMSPrinter():New()

	oPrn:SetLandscape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
	oPrn:setPaperSize( DMPAPER_A4 )

	//cabecalho da pagina
	Cabec(.t.)

		nLin := 550

	// IMPRIME DADOS DA CONSULTA
	While (_cAlias)->(!Eof())
		
		If _nCont >= 32
		
			_nCont		:= 0
			_nPag 		+= 1

			oPrn :EndPage() 
			Cabec(.t.)
			nLin := 550

		EndIf 

		oPrn:say(nLin,0115,(_cAlias)->CONTRATO,oFont10)
		oPrn:say(nLin,0500,(_cAlias)->NOME,oFont10)
		oPrn:say(nLin,1300,SubStr((_cAlias)->DTBASE,7,2) + "/" + SubStr((_cAlias)->DTBASE,5,2) + "/" + SubStr((_cAlias)->DTBASE,1,4),oFont10)
		oPrn:say(nLin,1600,(_cAlias)->PERFIL,oFont10)
		oPrn:say(nLin,2150,(_cAlias)->PARCELA,oFont10)
		oPrn:say(nLin,2350,SubStr((_cAlias)->DTINC,7,2) + "/" + SubStr((_cAlias)->DTINC,5,2) + "/" + SubStr((_cAlias)->DTINC,1,4),oFont10)
		oPrn:say(nLin,2600, Str((_cAlias)->VALOR,10,2),oFont10)
		oPrn:say(nLin,2800, Str((_cAlias)->PERCETUAL,10,2),oFont10)
		oPrn:say(nLin,3000, Str((_cAlias)->VLRCOMISSAO,10,2),oFont10)	

		nLin += 60   //pula linha

		_nCont += 1

		(_cAlias)->(dBskip())


	EndDo

	oPrn :EndPage() 
	Rodap()

	/*
		If _nCont <= 1
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
	*/

	oPrn:Preview() //Preview DO RELATORIO


Return


//********************************************************************************************//
//										Impressão do Relatório								  //
//********************************************************************************************//
Static Function  Cabec(_lCabec)

	

	//********************************************************************************************//
	//										cabecalho											  //
	//********************************************************************************************//

	oPrn:StartPage()	//Inicia uma nova pagina

	_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

	oPrn:SayBitmap(0045,0060,_cFileLogo,0400,0125)

	oPrn:say(0070,0550, "MEDICAR EMERGENCIAS MEDICAS LTDA",oFont17N)
	oPrn:say(0150,0550, "Comissao de Vendedores",oFont13N)

	oPrn:say(0230,0115, "Periodo de: ",oFont13N)
	oPrn:say(0230,0715, "Ate: ",oFont13N)
	oPrn:say(0230,1350, "Filial: ",oFont13N)
	
	
	//oPrn:line(210,1200,430,1200) 	//1 Linha Vertical Cabecalho

	//oPrn:line(0205,0100,0205,3300)    //Linha Horizontal Cabecalho Superor
	//oPrn:line(0505,0100,0505,3300)    //Linha Horizontal Cabecalho Inferior
	//oPrn:line(0205,0100,0505,0100) 	  //Linha Vertical Cabecalho Esquerda
	//oPrn:line(0205,3300,0505,3300) 	  //Linha Vertical Cabecalho Direita

	//oPrn:line(0305,0100,0305,3300)    //Linha Horizontal Cabecalho MEIO
	//oPrn:line(0405,0100,0405,3300)    //Linha Horizontal Cabecalho MEIO


	/* ------------------------- DADOS CABECARIO ------------------------- */

	oPrn:say(0230,0370, SubStr(Dtos(MV_PAR03),7,2) + "/" + SubStr(Dtos(MV_PAR03),5,2) + "/" + SubStr(Dtos(MV_PAR03),1,4),oFont13N)
	oPrn:say(0230,0820, SubStr(Dtos(MV_PAR04),7,2) + "/" + SubStr(Dtos(MV_PAR04),5,2) + "/" + SubStr(Dtos(MV_PAR04),1,4),oFont13N)
	oPrn:say(0330,0115, (_cAliasVend)->CODVEND + " - " + (_cAliasVend)->NOMEVEND,oFont13N)
	
	if MV_PAR01 = '001001'

		oPrn:say(0230,1500, "MEDICAR RP",oFont13N)	

	elseif MV_PAR01 = '002001'

		oPrn:say(0230,1500, "MEDICAR CAMP",oFont13N)	

	elseif MV_PAR01 = '003001'

		oPrn:say(0230,1500, "MEDICAR SP",oFont13N)	

	elseif MV_PAR01 = '006001'

		oPrn:say(0230,1500, "MEDICAR TECH",oFont13N)	

	elseif MV_PAR01 = '008001'

		oPrn:say(0230,1500, "MEDICAR LITORAL",oFont13N)	

	elseif MV_PAR01 = '016001'

		oPrn:say(0230,1500, "N1 CARD",oFont13N)		

	elseif MV_PAR01 = '021001'

		oPrn:say(0230,1500, "MEDICAR RJ",oFont13N)	

	endif
	
	//oPrn:say(nLin,0300,(cAliasCapaCtr)->NUMERO,oFont10)
	//oPrn:say(nLin,2800, SubStr((cAliasCapaCtr)->DTCAD,7,2) + "/" + SubStr((cAliasCapaCtr)->DTCAD,5,2) + "/" + SubStr((cAliasCapaCtr)->DTCAD,1,4),oFont10)
	//oPrn:say(nLin,0250,	Str((cAliasCapaCtr)->QTDVIDAS,10),oFont10)
	//oPrn:say(nLin,0850,"R$" + Str((cAliasCapaCtr)->VALORCTR,10,2),oFont10)



	//********************************************************************************************//
	//										Corpo												  //
	//********************************************************************************************//
	nLin := 450
	// Subtitulo do Corpo
	
	oPrn:line(0505,0100,0505,3300)    //Linha Horizontal Cabecalho Inferior


	oPrn:say (nLin,0115,"Contrato",oFont10N)
	oPrn:say (nLin,0500,"Nome",oFont10N)
	oPrn:say (nLin,1300,"Data Base",oFont10N)
	oPrn:say (nLin,1600,"Perfil",oFont10N) 
	oPrn:say (nLin,2150,"Parcela",oFont10N)
	oPrn:say (nLin,2350,"Data Inclusao",oFont10N)
	oPrn:say (nLin,2600,"Vlr. Base",oFont10N)
	oPrn:say (nLin,2800,"Percentual",oFont10N)
	oPrn:say (nLin,3000,"Vlr. Comissao",oFont10N)

	nLin := 510
	oPrn:say (0070,3000,"Emitido em: " + DTOC(Date()),oFont08I)    		//Impressão do numero da página
	oPrn:say (0120,3000,"Pag. " + Transform(_nPag,"@R 999"),oFont08I)   //Impressão do numero da página


	

return


//********************************************************************************************//
//										Rodape												  //	
//********************************************************************************************//
Static Function Rodap()


	_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

	oPrn:SayBitmap(0045,0060,_cFileLogo,0400,0125)

	oPrn:say(0070,0550, "MEDICAR EMERGENCIAS MEDICAS LTDA",oFont17N)
	oPrn:say(0150,0550, "Comissao de Vendedores",oFont13N)

	oPrn:say(0230,0115, "Periodo de: ",oFont13N)
	oPrn:say(0230,0715, "Ate: ",oFont13N)
	oPrn:say(0230,1350, "Filial: ",oFont13N)
	
	/* ------------------------- DADOS CABECARIO ------------------------- */

	oPrn:say(0230,0370, SubStr(Dtos(MV_PAR03),7,2) + "/" + SubStr(Dtos(MV_PAR03),5,2) + "/" + SubStr(Dtos(MV_PAR03),1,4),oFont13N)
	oPrn:say(0230,0820, SubStr(Dtos(MV_PAR04),7,2) + "/" + SubStr(Dtos(MV_PAR04),5,2) + "/" + SubStr(Dtos(MV_PAR04),1,4),oFont13N)
	oPrn:say(0330,0115, (_cAliasVend)->CODVEND + " - " + (_cAliasVend)->NOMEVEND,oFont13N)
	
	if MV_PAR01 = '001001'

		oPrn:say(0230,1500, "MEDICAR RP",oFont13N)	

	elseif MV_PAR01 = '002001'

		oPrn:say(0230,1500, "MEDICAR CAMP",oFont13N)	

	elseif MV_PAR01 = '003001'

		oPrn:say(0230,1500, "MEDICAR SP",oFont13N)	

	elseif MV_PAR01 = '006001'

		oPrn:say(0230,1500, "MEDICAR TECH",oFont13N)	

	elseif MV_PAR01 = '008001'

		oPrn:say(0230,1500, "MEDICAR LITORAL",oFont13N)	

	elseif MV_PAR01 = '016001'

		oPrn:say(0230,1500, "N1 CARD",oFont13N)		

	elseif MV_PAR01 = '021001'

		oPrn:say(0230,1500, "MEDICAR RJ",oFont13N)	

	endif


	/* --------------------------------- RESUMO ---------------------------------- */

	oPrn:say (0480,0380,"Resumo por Perfil",oFont13N)
	oPrn:say (0480,1380,"Resumo por Equipe",oFont13N)
	oPrn:say (0480,2540,"Resumo por Parcela",oFont13N)

	oPrn:say (0550,0150,"Perfil",oFont10N)
	oPrn:say (0550,0670,"Qtd.",oFont10N)
	oPrn:say (0550,0870,"Valor",oFont10N)
	oPrn:line(0605,0100,0605,1000)    //Linha Horizontal Cabecalho Inferior
	
	oPrn:say (0550,1150,"Equipe",oFont10N)
	oPrn:say (0550,1770,"Qtd.",oFont10N)
	oPrn:say (0550,1970,"Valor",oFont10N)		
	oPrn:line(0605,1100,0605,2100)    //Linha Horizontal Cabecalho Inferior
	
	oPrn:say (0550,2250,"Parcela",oFont10N)
	oPrn:say (0550,2870,"Qtd.",oFont10N)
	oPrn:say (0550,3070,"Valor",oFont10N)
	oPrn:line(0605,2200,0605,3200)    //Linha Horizontal Cabecalho Inferior

	nLin := 650

	While (_cPerfil)->(!Eof())

		oPrn:say (nLin,0150,(_cPerfil)->PERFIL,oFont10)
		oPrn:say (nLin,0650,Str((_cPerfil)->QTDLIN,10,2),oFont10)
		oPrn:say (nLin,0850, Str((_cPerfil)->VALOR,10,2),oFont10)
		//oPrn:say (nLin,0650,(_cPerfil)->VLRCOMISSAO,oFont10)
		
		nLin += 60   //pula linha
		(_cPerfil)->(dBskip())

	EndDo

	nLin := 650

	While (_cEquipe)->(!Eof())

		oPrn:say (nLin,1150, (_cEquipe)->EQUIPE,oFont10)
		oPrn:say (nLin,1750, Str((_cEquipe)->QTDLIN,10,2),oFont10)
		oPrn:say (nLin,1950, Str((_cEquipe)->VALOR,10,2),oFont10)
		//oPrn:say (nLin,0650,(_cEquipe)->VLRCOMISSAO,oFont10)
		
		nLin += 60   //pula linha
		(_cEquipe)->(dBskip())

	EndDo

	nLin := 650

	While (_cParcela)->(!Eof())

		oPrn:say (nLin,2250,(_cParcela)->PARCELA,oFont10)
		oPrn:say (nLin,2850,Str((_cParcela)->QTDLIN,10,2),oFont10)
		oPrn:say (nLin,3050, Str((_cParcela)->VALOR,10,2),oFont10)
		//oPrn:say (nLin,0650,(_cParcela)->VLRCOMISSAO,oFont10)
		
		nLin += 60   //pula linha
		(_cParcela)->(dBskip())

	EndDo

	oPrn :EndPage()	

Return


//********************************************************************************************//
// 										  	QUERY											  //	
//********************************************************************************************//
Static Function MontaQuery

	Local cQuery  
	Local cQueryVend  
	Local cQueryPerfil 
	Local cQueryEquip
	Local cQueryParcela

	cQuery := " SELECT  "
	cQuery += " C.BA3_XCARTE	AS CONTRATO, "
	cQuery += " B.BA1_NOMUSR	AS NOME, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.BXQ_SUBCON = '000000001' THEN C.BA3_DATBAS "
	cQuery += " 	ELSE D.BQC_DATCON "
	cQuery += " END AS DTBASE, "
	cQuery += " E.BT5_NOME		AS PERFIL, "
	cQuery += " A.BXQ_NUMPAR	AS PARCELA, "
	cQuery += " B.BA1_DATINC	AS DTINC, "
	cQuery += " A.BXQ_BASCOM	AS VALOR, "
	cQuery += " A.BXQ_PERCOM	AS PERCETUAL, "
	cQuery += " A.BXQ_VLRCOM	AS VLRCOMISSAO "
	cQuery += " FROM BXQ010 A "
	cQuery += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND A.BXQ_FILIAL = B.BA1_FILIAL AND	A.BXQ_CODINT = B.BA1_CODINT AND	A.BXQ_CODEMP = B.BA1_CODEMP AND	A.BXQ_NUMCON = B.BA1_CONEMP AND	A.BXQ_VERCON = B.BA1_VERCON AND	A.BXQ_SUBCON = B.BA1_SUBCON AND	A.BXQ_VERSUB = B.BA1_VERSUB AND	A.BXQ_MATRIC = B.BA1_MATRIC AND	A.BXQ_TIPREG = B.BA1_TIPREG	 "
    cQuery += " LEFT JOIN BA3010 C ON C.D_E_L_E_T_ = '' AND C.BA3_FILIAL = B.BA1_FILIAL AND	C.BA3_CODINT = B.BA1_CODINT AND	C.BA3_CODEMP = B.BA1_CODEMP AND	C.BA3_CONEMP = B.BA1_CONEMP AND	C.BA3_VERCON = B.BA1_VERCON AND	C.BA3_SUBCON = B.BA1_SUBCON AND	C.BA3_VERSUB = B.BA1_VERSUB AND	C.BA3_MATRIC = B.BA1_MATRIC  "
	cQuery += " LEFT JOIN BQC010 D ON D.D_E_L_E_T_ = '' AND	D.BQC_CODINT = C.BA3_CODINT AND	D.BQC_CODEMP = C.BA3_CODEMP	AND	D.BQC_NUMCON = C.BA3_CONEMP	AND	D.BQC_VERCON = C.BA3_VERCON	AND	D.BQC_SUBCON = C.BA3_SUBCON	AND	D.BQC_VERSUB = C.BA3_VERSUB "
	cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = D.BQC_FILIAL AND E.BT5_CODINT = D.BQC_CODINT AND E.BT5_CODIGO = D.BQC_CODEMP AND E.BT5_NUMCON = D.BQC_NUMCON AND E.BT5_VERSAO = D.BQC_VERCON "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.BXQ_E2PREF = '' "
	cQuery += " AND A.BXQ_FILIAL >= '"+ SubStr(MV_PAR01,1,3) +"' "
	cQuery += " AND A.BXQ_FILIAL <= '"+ SubStr(MV_PAR02,1,3) +"' "
	cQuery += " AND A.BXQ_DATA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
	cQuery += " AND A.BXQ_CODVEN = '"+MV_PAR05+"' "
	
	cQueryVend := " SELECT  "
	cQueryVend += " A.A3_COD AS CODVEND, "
	cQueryVend += " A.A3_NOME AS NOMEVEND "
	cQueryVend += " FROM SA3010 A "
	cQueryVend += " WHERE 1=1 "
	cQueryVend += " AND A.D_E_L_E_T_ = '' "
	cQueryVend += " AND A.A3_COD = '"+MV_PAR05+"' "

	cQueryPerfil := " SELECT   "
	cQueryPerfil += " E.BT5_NOME		AS PERFIL, "
	cQueryPerfil += " SUM(A.BXQ_BASCOM)	AS VALOR,  "
	cQueryPerfil += " SUM(A.BXQ_VLRCOM)	AS VLRCOMISSAO, "
	cQueryPerfil += " COUNT(*)			AS QTDLIN "
	cQueryPerfil += " FROM BXQ010 A  "
	cQueryPerfil += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND A.BXQ_FILIAL = B.BA1_FILIAL AND	A.BXQ_CODINT = B.BA1_CODINT AND	A.BXQ_CODEMP = B.BA1_CODEMP AND	A.BXQ_NUMCON = B.BA1_CONEMP AND	A.BXQ_VERCON = B.BA1_VERCON AND	A.BXQ_SUBCON = B.BA1_SUBCON AND	A.BXQ_VERSUB = B.BA1_VERSUB AND	A.BXQ_MATRIC = B.BA1_MATRIC AND	A.BXQ_TIPREG = B.BA1_TIPREG	  "
    cQueryPerfil += " LEFT JOIN BA3010 C ON C.D_E_L_E_T_ = '' AND C.BA3_FILIAL = B.BA1_FILIAL AND	C.BA3_CODINT = B.BA1_CODINT AND	C.BA3_CODEMP = B.BA1_CODEMP AND	C.BA3_CONEMP = B.BA1_CONEMP AND	C.BA3_VERCON = B.BA1_VERCON AND	C.BA3_SUBCON = B.BA1_SUBCON AND	C.BA3_VERSUB = B.BA1_VERSUB AND	C.BA3_MATRIC = B.BA1_MATRIC   "
	cQueryPerfil += " LEFT JOIN BQC010 D ON D.D_E_L_E_T_ = '' AND	D.BQC_CODINT = C.BA3_CODINT AND	D.BQC_CODEMP = C.BA3_CODEMP	AND	D.BQC_NUMCON = C.BA3_CONEMP	AND	D.BQC_VERCON = C.BA3_VERCON	AND	D.BQC_SUBCON = C.BA3_SUBCON	AND	D.BQC_VERSUB = C.BA3_VERSUB  "
	cQueryPerfil += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = D.BQC_FILIAL AND E.BT5_CODINT = D.BQC_CODINT AND E.BT5_CODIGO = D.BQC_CODEMP AND E.BT5_NUMCON = D.BQC_NUMCON AND E.BT5_VERSAO = D.BQC_VERCON  "
	cQueryPerfil += " LEFT JOIN BXL010 F ON F.D_E_L_E_T_ = '' AND F.BXL_CODEQU = A.BXQ_CODEQU "
	cQueryPerfil += " WHERE 1=1  "
	cQueryPerfil += " AND A.D_E_L_E_T_ = '' "
	cQueryPerfil += " AND A.BXQ_E2PREF = '' "
	cQueryPerfil += " AND A.BXQ_FILIAL >= '"+ SubStr(MV_PAR01,1,3) +"' "
	cQueryPerfil += " AND A.BXQ_FILIAL <= '"+ SubStr(MV_PAR02,1,3) +"' "
	cQueryPerfil += " AND A.BXQ_DATA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
	cQueryPerfil += " AND A.BXQ_CODVEN = '"+MV_PAR05+"' "
	cQueryPerfil += " GROUP BY 	 "
	cQueryPerfil += " E.BT5_NOME "


	cQueryEquip := " SELECT   "
	cQueryEquip += " F.BXL_DESEQU		AS EQUIPE, "
	cQueryEquip += " SUM(A.BXQ_BASCOM)	AS VALOR,  "
	cQueryEquip += " SUM(A.BXQ_VLRCOM)	AS VLRCOMISSAO, "
	cQueryEquip += " COUNT(*)			AS QTDLIN "
	cQueryEquip += " FROM BXQ010 A  "
	cQueryEquip += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND A.BXQ_FILIAL = B.BA1_FILIAL AND	A.BXQ_CODINT = B.BA1_CODINT AND	A.BXQ_CODEMP = B.BA1_CODEMP AND	A.BXQ_NUMCON = B.BA1_CONEMP AND	A.BXQ_VERCON = B.BA1_VERCON AND	A.BXQ_SUBCON = B.BA1_SUBCON AND	A.BXQ_VERSUB = B.BA1_VERSUB AND	A.BXQ_MATRIC = B.BA1_MATRIC AND	A.BXQ_TIPREG = B.BA1_TIPREG	  "
    cQueryEquip += " LEFT JOIN BA3010 C ON C.D_E_L_E_T_ = '' AND C.BA3_FILIAL = B.BA1_FILIAL AND	C.BA3_CODINT = B.BA1_CODINT AND	C.BA3_CODEMP = B.BA1_CODEMP AND	C.BA3_CONEMP = B.BA1_CONEMP AND	C.BA3_VERCON = B.BA1_VERCON AND	C.BA3_SUBCON = B.BA1_SUBCON AND	C.BA3_VERSUB = B.BA1_VERSUB AND	C.BA3_MATRIC = B.BA1_MATRIC   "
	cQueryEquip += " LEFT JOIN BQC010 D ON D.D_E_L_E_T_ = '' AND	D.BQC_CODINT = C.BA3_CODINT AND	D.BQC_CODEMP = C.BA3_CODEMP	AND	D.BQC_NUMCON = C.BA3_CONEMP	AND	D.BQC_VERCON = C.BA3_VERCON	AND	D.BQC_SUBCON = C.BA3_SUBCON	AND	D.BQC_VERSUB = C.BA3_VERSUB  "
	cQueryEquip += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = D.BQC_FILIAL AND E.BT5_CODINT = D.BQC_CODINT AND E.BT5_CODIGO = D.BQC_CODEMP AND E.BT5_NUMCON = D.BQC_NUMCON AND E.BT5_VERSAO = D.BQC_VERCON  "
	cQueryEquip += " LEFT JOIN BXL010 F ON F.D_E_L_E_T_ = '' AND F.BXL_CODEQU = A.BXQ_CODEQU "
	cQueryEquip += " WHERE 1=1  "
	cQueryEquip += " AND A.D_E_L_E_T_ = '' "
	cQueryEquip += " AND A.BXQ_E2PREF = '' "
	cQueryEquip += " AND A.BXQ_FILIAL >= '"+ SubStr(MV_PAR01,1,3) +"' "
	cQueryEquip += " AND A.BXQ_FILIAL <= '"+ SubStr(MV_PAR02,1,3) +"' "
	cQueryEquip += " AND A.BXQ_DATA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
	cQueryEquip += " AND A.BXQ_CODVEN = '"+MV_PAR05+"' "
	cQueryEquip += " GROUP BY 	 "
	cQueryEquip += " F.BXL_DESEQU "


	cQueryParcela := " SELECT   "
	cQueryParcela += " A.BXQ_NUMPAR		AS PARCELA,  "
	cQueryParcela += " SUM(A.BXQ_BASCOM)	AS VALOR,  "
	cQueryParcela += " SUM(A.BXQ_VLRCOM)	AS VLRCOMISSAO, "
	cQueryParcela += " COUNT(*)			AS QTDLIN "
	cQueryParcela += " FROM BXQ010 A  "
	cQueryParcela += " LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND A.BXQ_FILIAL = B.BA1_FILIAL AND	A.BXQ_CODINT = B.BA1_CODINT AND	A.BXQ_CODEMP = B.BA1_CODEMP AND	A.BXQ_NUMCON = B.BA1_CONEMP AND	A.BXQ_VERCON = B.BA1_VERCON AND	A.BXQ_SUBCON = B.BA1_SUBCON AND	A.BXQ_VERSUB = B.BA1_VERSUB AND	A.BXQ_MATRIC = B.BA1_MATRIC AND	A.BXQ_TIPREG = B.BA1_TIPREG	  "
    cQueryParcela += " LEFT JOIN BA3010 C ON C.D_E_L_E_T_ = '' AND C.BA3_FILIAL = B.BA1_FILIAL AND	C.BA3_CODINT = B.BA1_CODINT AND	C.BA3_CODEMP = B.BA1_CODEMP AND	C.BA3_CONEMP = B.BA1_CONEMP AND	C.BA3_VERCON = B.BA1_VERCON AND	C.BA3_SUBCON = B.BA1_SUBCON AND	C.BA3_VERSUB = B.BA1_VERSUB AND	C.BA3_MATRIC = B.BA1_MATRIC   "
	cQueryParcela += " LEFT JOIN BQC010 D ON D.D_E_L_E_T_ = '' AND	D.BQC_CODINT = C.BA3_CODINT AND	D.BQC_CODEMP = C.BA3_CODEMP	AND	D.BQC_NUMCON = C.BA3_CONEMP	AND	D.BQC_VERCON = C.BA3_VERCON	AND	D.BQC_SUBCON = C.BA3_SUBCON	AND	D.BQC_VERSUB = C.BA3_VERSUB  "
	cQueryParcela += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = D.BQC_FILIAL AND E.BT5_CODINT = D.BQC_CODINT AND E.BT5_CODIGO = D.BQC_CODEMP AND E.BT5_NUMCON = D.BQC_NUMCON AND E.BT5_VERSAO = D.BQC_VERCON  "
	cQueryParcela += " LEFT JOIN BXL010 F ON F.D_E_L_E_T_ = '' AND F.BXL_CODEQU = A.BXQ_CODEQU "
	cQueryParcela += " WHERE 1=1  "
	cQueryParcela += " AND A.D_E_L_E_T_ = '' "
	cQueryParcela += " AND A.BXQ_E2PREF = '' "
	cQueryParcela += " AND A.BXQ_FILIAL >= '"+ SubStr(MV_PAR01,1,3) +"' "
	cQueryParcela += " AND A.BXQ_FILIAL <= '"+ SubStr(MV_PAR02,1,3) +"' "
	cQueryParcela += " AND A.BXQ_DATA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
	cQueryParcela += " AND A.BXQ_CODVEN = '"+MV_PAR05+"' "
	cQueryParcela += " GROUP BY 	 "
	cQueryParcela += " A.BXQ_NUMPAR "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)
	TCQUERY cQueryVend NEW ALIAS (_cAliasVend)
	TCQUERY cQueryPerfil NEW ALIAS (_cPerfil)
	TCQUERY cQueryEquip NEW ALIAS (_cEquipe)
	TCQUERY cQueryParcela NEW ALIAS (_cParcela)
	

Return

//********************************************************************************************//
//									LOGO DA EMPRESA											  //
//********************************************************************************************//
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
