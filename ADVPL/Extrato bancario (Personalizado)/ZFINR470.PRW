/*

//#############################################################################
//#              ZFINR470 - EXTRATO BANCARIO (Peronsalizado)            	  #
//#	Por: Edyardo Jorge														  #
//# Em: 08/07/2021															  #
//# Solicitado por: Guilherme Zanotti / Geovana 							  #
//#############################################################################
 
*/

#INCLUDE 'TOPCONN.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#DEFINE DMPAPER_A4 9 // A4 210 x 297 mm


User Function ZFINR470(cBanco)
		

DEFAULT cBanco		:= ""
Private cAgencia	:= ""
Private cConta		:= ""
Private _cAlias		:= GetNextAlias()
Private cEOL 		:= "CHR(13)+CHR(10)"
Private cPerg   	:= "ZNTFINR470" // Nome do grupo de perguntas

If !Empty(cBanco)
	Pergunte(cPerg,.F.)
	MV_PAR01 := cBanco
	MV_PAR02 := cAgencia
	MV_PAR03 := cConta
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
DbGoTop()
If (_cAlias)->(Eof())
	MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
	(_cAlias)->(DbCloseArea())
Else
	Processa({|| Imprime() },"Extrato Bancario","Imprimindo...") //"Pedido de Compras "##"Imprimindo..."
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
//Private oFont08
//Private oFont09
//Private oFont10
Private cPosi
Private nLin
Private _nPag  			:= 1   // Numero da pagina
Private cSaldoInI := MV_PAR06
Private cDtIni := MV_PAR04
Private cDtFim := MV_PAR05
Private cTotalEntrada := 0
Private cTotalSaida := 0
Private cSaldoFinal := 0

cBitmap := R110ALogo()

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

//Start de impressão
Private oPrn:= TMSPrinter():New()

oPrn:SetLandscape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
oPrn:setPaperSize( DMPAPER_A4 )

//cabecalho da pagina
Cabec(.t.)


While (_cAlias)->(!Eof())
	
	If _nCont >= 25
	
		_nCont		:= 0
		_nPag 		+= 1
		
		oPrn :EndPage() 
		Cabec(.t.)

	EndIf 
		
	cSaldoInI := cSaldoInI - (_cAlias)->SAIDAS + (_cAlias)->ENTRADAS
	
	cTotalEntrada := cTotalEntrada + (_cAlias)->ENTRADAS

	cTotalSaida := cTotalSaida + (_cAlias)->SAIDAS


	oPrn:say (0300,2800,"Saldo Inicial: " + Transform(MV_PAR06,"@E 999,999,999.99"), oFont08) 	//"Saldo Inicial"

	oPrn:say(nLin,0035,(_cAlias)->E5_FILIAL,oFont08)								//FILIAL
	oPrn:say(nLin,0165,DTOC((_cAlias)->E5_DTDISPO),oFont08)							//DATA
	oPrn:say(nLin,0350,(_cAlias)->E5_HISTOR,oFont08)								//HISTORICO
	oPrn:say(nLin,0880,(_cAlias)->E5_DOCUMEN,oFont08)								//DOCUMENTO
	oPrn:say(nLin,1180,(_cAlias)->E5_CLIFOR,oFont08)								//CLIFOR
	oPrn:say(nLin,1450,Substr((_cAlias)->CLIENTE_FORNECEDOR,1,40),oFont08)			//NOME CLIFOR
	oPrn:say(nLin,2200,(_cAlias)->PREFIXO_TITULO,oFont08)							//TITULO
	oPrn:say(nLin,2580,	Transform((_cAlias)->ENTRADAS,"@E 999,999,999.99"),oFont08)	//ENTRADAS
	oPrn:say(nLin,2880,Transform((_cAlias)->SAIDAS,"@E 999,999,999.99"),oFont08)	//SAIDAS
	oPrn:say(nLin,3170,Transform(cSaldoInI,"@E 999,999,999.99"),oFont08)			//Saldo
	
	_nCont 		+= 1

	nLin += 50   //pula linha



	
	
	//Verifica a quebra de pagina
	(_cAlias)->(dBskip())

EndDo

	cSaldoFinal := MV_PAR06 + cTotalEntrada - cTotalSaida

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

If(mv_par07 == 1)
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

oPrn:say(0070,1365, "EXTRATO BANCÁRIO",oFont17)


oPrn:line(210,1200,430,1200) 	//1 Linha Vertical Cabecalho

oPrn:line(445,0035,445,3425)    //Linha Horizontal Cabecalho Inferior
oPrn:line(505,0035,505,3425)    //Linha Horizontal Cabecalho Inferior

//********************************************************************************************
//										cabecalho											 
//********************************************************************************************

// Primeira coluna do cabecalho
nLin := 225
oPrn:say (nLin,0035, SM0->M0_NOMECOM ,oFont08I)
nLin += 50
oPrn:say (nLin,0035,"CNPJ:"+" "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  -  "+"I.E:"+" "+Alltrim(SM0->M0_INSC) ,oFont08I)  //"CNPJ:"##"I.E:"
nLin += 50
oPrn:say (nLin,0035,Alltrim(SM0->M0_ENDCOB)+" "+ Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" /"+Alltrim(SM0->M0_ESTCOB),oFont08I) //"ENDEREÇO:"
nLin += 50
oPrn:say (nLin,0035,"I.E:"+" "+(SM0->M0_CEPENT)+ " | " + "TEL.:"+" "+Alltrim(SM0->M0_TEL)+"  |  "+"FAX:"+" "+Alltrim(SM0->M0_FAX) ,oFont08I) //"CEP.:"##"TEL.:"##"FAX:"


// Primeira coluna do cabecalho (Banco)

nLin := 225
oPrn:say (nLin,1215,"Banco: " + (_cAlias)->E5_BANCO, oFont08I) //Cod + Nome Fornecedor
nLin += 50
oPrn:say (nLin,1215,"Agência: " + (_cAlias)->E5_AGENCIA, oFont08I) //Cod + Nome Fornecedor
nLin += 50
oPrn:say (nLin,1215,"Conta: " + (_cAlias)->E5_CONTA, oFont08I) //Cod + Nome Fornecedor
nLin += 50
oPrn:say (nLin,1215,"Periodo de: " + DTOC(cDtIni) + " Até: " + DTOC(cDtFim), oFont08I) //Cod + Nome Fornecedor
nLin += 50

//********************************************************************************************
//										Corpo
//********************************************************************************************
nLin := 450
// Subtitulo do Corpo

oPrn:say (nLin,0035,"FILIAL",oFont08I) 					//"EXEMPLO"
oPrn:say (nLin,0185,"DATA",oFont08I) 					//"EXEMPLO"
oPrn:say (nLin,0375,"HISTORICO",oFont08I) 				//"EXEMPLO"
oPrn:say (nLin,0850,"DOCUMENTO",oFont08I) 				//"EXEMPLO"
oPrn:say (nLin,1150,"COD. CLI/FOR",oFont08I) 			//"EXEMPLO"
oPrn:say (nLin,1500,"CLIENTE/FORNECEDOR",oFont08I) 		//"EXEMPLO"
oPrn:say (nLin,2200,"PREFIXO/TÍTULO",oFont08I) 			//"EXEMPLO"
oPrn:say (nLin,2565,"ENTRADAS",oFont08I) 				//"EXEMPLO"
oPrn:say (nLin,2891,"SAÍDAS",oFont08I) 					//"EXEMPLO"
oPrn:say (nLin,3201,"SALDO",oFont08I) 					//"EXEMPLO"


nLin := 510
oPrn:say (0070,3200,"Pag. " + Transform(_nPag,"@R 999"),oFont08I)    //Impressão do numero da página
//oPrn:say (0070,3200,nHorzRes(),oFont08I) 
//oPrn:say (0070,3200,nLogPixelX(),oFont08I) 


//oPrn:say (0300,3200,"Saldo Inicial: " + "0" ,oFont08I) //"Saldo Inicial"

return

Static Function Rodap()


//********************************************************************************************
//										Rodape
//********************************************************************************************

nLin := 1820


oPrn:say(nLin,0050,"Totais - Entradas & Saídas" , oFont13N)
nLin += 100												
oPrn:say(nLin,0050,"Saldo Inicial: " + Transform(MV_PAR06,"@E 999,999,999.99"), oFont08N)		
nLin += 50
oPrn:say(nLin,0050,"Total de Entradas: " + Transform(cTotalEntrada,"@E 999,999,999.99"), oFont08N)
nLin += 50		
oPrn:say(nLin,0050,"Total de Saídas: " + Transform(cTotalSaida,"@E 999,999,999.99"), oFont08N)	
nLin += 50
oPrn:say(nLin,0050,"Saldo Atual: " + Transform(cSaldoFinal,"@E 999,999,999.99"), oFont08N)		


oPrn:line(1800,0035,1800,1500)    //Linha Horizontal Superior OBS
oPrn:line(2250,0035,2250,1500)    //Linha Horizontal Inferior OBS
oPrn:line(1800,0035,2250,0035) 	  //Linha Vertical OBS Esquerda
oPrn:line(1800,1500,2250,1500)    //Linha Vertical OBS Direita

oPrn :EndPage()

Return

//********************************************************************************************
// 										   		QUERY
//********************************************************************************************
Static Function MontaQuery

Local cQuery  

		  cQuery := "SELECT SE5.E5_RECPAG, SE5.E5_CONTA, SE5.E5_AGENCIA, SE5.E5_BANCO, SE5.E5_FILIAL, SE5.E5_DTDISPO, SE5.E5_HISTOR,SE5. E5_DOCUMEN, SE5.E5_CLIFOR, "
		  cQuery += "CASE WHEN SE5.E5_CLIENTE <> '' THEN ISNULL((SELECT A1_NOME FROM SA1010 WHERE D_E_L_E_T_ = '' AND A1_COD = SE5.E5_CLIFOR AND A1_LOJA = SE5.E5_LOJA),'') WHEN SE5.E5_FORNECE <> '' THEN ISNULL((SELECT A2_NOME FROM SA2010 WHERE D_E_L_E_T_ = '' AND A2_COD = SE5.E5_CLIFOR AND A2_LOJA = SE5.E5_LOJA),'') ELSE '' END AS CLIENTE_FORNECEDOR, "
		  cQuery += "CONCAT(SE5.E5_PREFIXO, '-', SE5.E5_NUMERO, '-',SE5.E5_PARCELA) AS PREFIXO_TITULO, "
		  cQuery += "CASE WHEN SE5.E5_RECPAG = 'P' THEN SE5.E5_VALOR ELSE 0 END AS SAIDAS,"
		  cQuery += "CASE WHEN SE5.E5_RECPAG = 'R' THEN SE5.E5_VALOR ELSE 0 END AS ENTRADAS, E5_RECONC "
		  cQuery += "FROM "+RetSqlName('SE5')+" SE5 "
		  cQuery += "WHERE 1=1"
		  cQuery += "AND SE5.D_E_L_E_T_ = '' "
		  cQuery += "AND SE5.E5_RECONC = 'x' "
		  cQuery += "AND SE5.E5_BANCO = '"+(MV_PAR01)+"'
		  cQuery += "AND SE5.E5_AGENCIA ='"+(MV_PAR02)+"'
		  cQuery += "AND SE5.E5_CONTA = '"+(MV_PAR03)+"'
		  cQuery += "AND SE5.E5_DTDISPO  BETWEEN '"+Dtos(MV_PAR04)+"' AND '"+Dtos(MV_PAR05)+"' "
		  

If Upper(TcGetDb()) $ "ORACLE.INFORMIX"
	cQuery += "   ORDER BY 6,12,10"
Else
	cQuery += "   ORDER BY 6,12,10"
Endif

//Criar alias temporário
TCQUERY cQuery NEW ALIAS (_cAlias)

tCSetField((_cAlias), "E5_DTDISPO", "D")


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
