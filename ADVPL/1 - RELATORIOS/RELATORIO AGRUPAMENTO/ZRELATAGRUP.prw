//#############################################################################
//#              ZFINR470 - RELATORIO DE AGRUPAMENTO		            	  #
//#	Por: Edyardo Jorge														  #
//# Em: 25/01/2024															  #
//#############################################################################

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#DEFINE DMPAPER_A4 9 // A4 210 x 297 mm


User Function ZRELATAGRUP(cAgrupamento)
		

	DEFAULT cAgrupamento := ""
	Private cAgencia	 := ""
	Private cConta		 := ""
	Private _cAlias		 := GetNextAlias()
	Private cAliasAgrup	 := GetNextAlias()
	Private cEOL 		 := "CHR(13)+CHR(10)"
	Private cPerg   	 := "ZRELAGRUP" // Nome do grupo de perguntas

	If !Empty(cAgrupamento)
		Pergunte(cPerg,.F.)
		MV_PAR04 := cAgrupamento
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
	DbSelectArea(cAliasAgrup)


	DbGoTop()
	If (_cAlias)->(Eof())
		MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
		(_cAlias)->(DbCloseArea())
		(cAliasAgrup)->(DbCloseArea())
	Else

		IF MV_PAR06 = 1
			Processa({|| Imprime() },"Relatorio de Agrupamento","Imprimindo...") 
		ELSE
			Processa({|| fGeraExcel() },"Relatorio de Agrupamento","Imprimindo...")
		EndIF


		
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

	oPrn:SetPortrait()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
	oPrn:setPaperSize( DMPAPER_A4 )

	//cabecalho da pagina
	Cabec(.t.)

		nLin := 425

	While (_cAlias)->(!Eof())
		
		If _nCont >= 50
		
			_nCont		:= 0
			_nPag 		+= 1
			
			oPrn :EndPage() 
			Cabec(.t.)

		EndIf 
		
		//cSaldoInI := cSaldoInI - (_cAlias)->SAIDAS + (_cAlias)->ENTRADAS

		//SubStr((_cAlias)->E1_VENCREA,1,4)+"/"+SubStr((_cAlias)->E1_VENCREA,5,2)+"/"SubStr((_cAlias)->E1_VENCREA,7,2)

		//oPrn:say (0300,2800,"Saldo Inicial: " + Transform(MV_PAR06,"@E 999,999,999.99"), oFont08) 	//"Saldo Inicial"
		//oPrn:say(nLin,0450,	Transform((_cAlias)->E1_VALOR,"@E 999,999,999.99"),oFont08)		//VALOR
		//oPrn:say(nLin,0165,DTOC((_cAlias)->E1_VENCREA),oFont08)								//VENCIMENTO
		

		IF  (_cAlias)->TIPODOC_SE5 == "JR" .or. (_cAlias)->TIPODOC_SE5 == "RA"
		else
			IF (_cAlias)->MOTBX == "SMV" .or. (_cAlias)->MOTBX =="PER" 
			else

				If (_cAlias)->SALDO = 0 .AND. (_cAlias)->VALORES_BAIXADOS >= (_cAlias)->VALOR
					oPrn:say(nLin,0035,(_cAlias)->CLIENTE,oFont10N)										//EMPRESA
					oPrn:say(nLin,1320, SubStr((_cAlias)->VENCIMENTO,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),oFont10N)										//VENCIMENTO
					oPrn:say(nLin,1620, "R$" + Str((_cAlias)->VALOR,10,2),oFont10N)						//VALOR
					oPrn:say(nLin,1920, "R$" + Str((_cAlias)->VALORES_BAIXADOS,10,2),oFont10N)			//VALOR BAIXADO
					oPrn:say(nLin,2200,"LIQUIDADO",oFont10N)											//SITUACAO
					//oPrn:say(nLin,2400,(_cAlias)->TIPODOC_SE5,oFont10N)											//SITUACAO
					nLin += 60   //pula linha
					cTotalValor := cTotalValor + (_cAlias)->VALOR
					cTotalBaixado := cTotalBaixado + (_cAlias)->VALORES_BAIXADOS
				Else
					oPrn:say(nLin,0035,(_cAlias)->CLIENTE,oFont10)										//EMPRESA
					oPrn:say(nLin,1320, SubStr((_cAlias)->VENCIMENTO,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),oFont10)										//VENCIMENTO
					oPrn:say(nLin,1620, "R$" + Str((_cAlias)->VALOR,10,2),oFont10)						//VALOR
					oPrn:say(nLin,1920, "R$" + Str((_cAlias)->VALORES_BAIXADOS,10,2),oFont10)			//VALOR BAIXADO
					oPrn:say(nLin,2200,"EM ABERTO",oFont10)												//SITUACAO
					//oPrn:say(nLin,2400,(_cAlias)->TIPODOC_SE5,oFont10N)									//SITUACAO			
					nLin += 60   //pula linha
					cTotalValor := cTotalValor + (_cAlias)->VALOR
					cTotalBaixado := cTotalBaixado + (_cAlias)->VALORES_BAIXADOS
				EndIF

			EndIF

		EndIF
		
		
		_nCont += 1
		//Verifica a quebra de pagina
		(_cAlias)->(dBskip())


	EndDo

		//cSaldoFinal := MV_PAR06 + cTotalEntrada - cTotalSaida

	If _nCont <= 50
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

	oPrn:say(0070,0750, "RELATORIO DE AGRUPAMENTO",oFont17N)

	//oPrn:line(210,1200,430,1200) 	//1 Linha Vertical Cabecalho

	oPrn:line(305,0015,305,2520)    //Linha Horizontal Cabecalho Inferior
	oPrn:line(405,0015,405,2520)    //Linha Horizontal Cabecalho Inferior





		//********************************************************************************************
		//										cabecalho											 
		//********************************************************************************************
		// Primeira coluna do cabecalho
		nLin := 225
		oPrn:say (nLin,0035, "AGRUPAMENTO: " + (cAliasAgrup)->AOV_DESSEG ,oFont13N)


	/*

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


	*/



	//********************************************************************************************
	//										Corpo
	//********************************************************************************************
	nLin := 330
	// Subtitulo do Corpo

	oPrn:say (nLin,0035,"EMPRESA",oFont10N) 					//"EMPRESA"
	oPrn:say (nLin,1300,"VENCIMENTO",oFont10N) 					//"VENCIMENTO"
	oPrn:say (nLin,1600,"VALOR LIQUIDO",oFont10N) 				//"VALOR LIQUIDO"
	oPrn:say (nLin,1900,"VALORES BAIXADOS",oFont10N) 			//"VALOR BAIXADO"
	oPrn:say (nLin,2200,"SITUACAO",oFont10N) 					//"SITUACAO"


	nLin := 510
	oPrn:say (0070,2150,"Pag. " + Transform(_nPag,"@R 999"),oFont08I)    //Impressão do numero da página
	//oPrn:say (0070,3200,nHorzRes(),oFont08I)
	//oPrn:say (0070,3200,nLogPixelX(),oFont08I)


	//oPrn:say (0300,3200,"Saldo Inicial: " + "0" ,oFont08I) //"Saldo Inicial"

return


//********************************************************************************************
// 										  	RODAPE
//********************************************************************************************
Static Function Rodap()


	//********************************************************************************************
	//										Rodape
	//********************************************************************************************

	nLin := 3200
									
	oPrn:line(nLin,0015,nLin,2520)    //Linha Horizontal Cabecalho Inferior
	nLin += 30
	oPrn:say(nLin,0050,"VALOR LIQUIDO TOTAL: " +  "R$" + Str(cTotalValor,10,2), oFont10N)		
	nLin += 60
	oPrn:say(nLin,0050,"VALOR BAIXADO TOTAL: " +  "R$" + Str(cTotalBaixado,10,2), oFont10N)
	nLin += 60	

	//oPrn:line(1800,0035,1800,1500)    //Linha Horizontal Superior OBS
	//oPrn:line(2250,0035,2250,1500)    //Linha Horizontal Inferior OBS
	//oPrn:line(1800,0035,2250,0035) 	/Linha Vertical OBS Esquerda
	//oPrn:line(1800,1500,2250,1500)    //Linha Vertical OBS Direita

	oPrn :EndPage()

Return


//********************************************************************************************
// 										  	QUERY
//********************************************************************************************
Static Function MontaQuery

	Local cQuery  
	local cQueryAgrup

		cQuery := " SELECT  "
		cQuery += " SE1.E1_FILIAL   AS FILIAL, "
		cQuery += " SE1.E1_NUM	    AS NUMERO, "
		cQuery += " SE1.E1_PREFIXO  AS PREFIXO, "
		cQuery += " SE1.E1_PARCELA  AS PARCELA, "
		cQuery += " SA1.A1_NREDUZ   AS CLIENTE,	  "
		cQuery += " SE1.E1_VENCREA  AS VENCIMENTO,  "
		cQuery += " SE5.E5_TIPODOC  AS TIPODOC_SE5, "
		cQuery += " SE5.E5_MOTBX    AS MOTBX, "
		cQuery += " CASE "
		cQuery += "     WHEN SUM(SE1.E1_VALLIQ) = 0 THEN SUM(SE1.E1_VALOR) "
		cQuery += "     ELSE SUM(SE1.E1_VALLIQ) "
		cQuery += " END             AS VALOR, "
		cQuery += " SUM(SE5.E5_VALOR)    AS VALORES_BAIXADOS, "
		cQuery += " SUM(SE1.E1_SALDO)    AS SALDO "
		cQuery += " FROM SE1010 SE1 "
		cQuery += " LEFT JOIN SE5010 SE5 ON SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA  "
		cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA   "
		cQuery += " WHERE 1=1   "
		cQuery += " AND SE1.D_E_L_E_T_ = '' "
		cQuery += " AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-', 'PR') "
		cQuery += " AND SE1.E1_FILIAL >= '" +MV_PAR01+ "' "
		cQuery += " AND SE1.E1_FILIAL <= '" +MV_PAR02+ "' "
		cQuery += " AND SA1.A1_CODSEG = '"+MV_PAR05+"' "
		IF MV_PAR07 = 1
			cQuery += " AND SE1.E1_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ElseIf MV_PAR07 = 2
			cQuery += " AND SE1.E1_VENCREA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		ELSE
			cQuery += " AND SE1.E1_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		EndIF
		cQuery += " GROUP BY SE1.E1_FILIAL ,SE1.E1_NUM,SE1.E1_PREFIXO,SE1.E1_PARCELA,SA1.A1_NREDUZ ,SE1.E1_VENCREA,SE5.E5_TIPODOC,SE5.E5_MOTBX  "
		cQuery += "ORDER BY 5,6 "

		cQueryAgrup := "SELECT AOV.AOV_DESSEG FROM AOV010 AOV WHERE 1=1 AND AOV.D_E_L_E_T_ = '' AND AOV.AOV_CODSEG = '"+(MV_PAR05)+"' "

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)
	TCQUERY cQueryAgrup NEW ALIAS (cAliasAgrup)

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

	lRet := oExcel:IsWorkSheet("AGRUPAMENTO")
	oExcel:AddworkSheet("AGRUPAMENTO")

	//lRet := oExcel:IsWorkSheet("PLANILHA1")
	//oExcel:AddTable ("TELEMEDINC","TELEMED")
	oExcel:AddTable ("AGRUPAMENTO","RELAGRUP",.F.)

	oExcel:AddColumn("AGRUPAMENTO","RELAGRUP","FILIAL"			,1,1,.F., "")
	oExcel:AddColumn("AGRUPAMENTO","RELAGRUP","EMPRESA"			,1,1,.F., "")
	oExcel:AddColumn("AGRUPAMENTO","RELAGRUP","VENCIMENTO"		,1,1,.F., "")
	oExcel:AddColumn("AGRUPAMENTO","RELAGRUP","VALORLIQ"		,1,3,.F., "")
	oExcel:AddColumn("AGRUPAMENTO","RELAGRUP","VALOBAIXADO"		,1,3,.F., "")
	oExcel:AddColumn("AGRUPAMENTO","RELAGRUP","SITUACAO"		,1,1,.F., "")
	

	While (_cAlias)->(!Eof())

		If (_cAlias)->SALDO = 0 .AND. (_cAlias)->VALORES_BAIXADOS >= (_cAlias)->VALOR
			oExcel:AddRow("AGRUPAMENTO","RELAGRUP",{(_cAlias)->FILIAL,(_cAlias)->CLIENTE,SubStr((_cAlias)->VENCIMENTO,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),(_cAlias)->SALDO,(_cAlias)->VALORES_BAIXADOS,'LIQUIDADO'})
		ELSE
			oExcel:AddRow("AGRUPAMENTO","RELAGRUP",{(_cAlias)->FILIAL,(_cAlias)->CLIENTE,SubStr((_cAlias)->VENCIMENTO,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),(_cAlias)->SALDO,(_cAlias)->VALORES_BAIXADOS,'EM ABERTO'})
		EndIF

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cPasta := cPasta + '\' + Alltrim((cAliasAgrup)->AOV_DESSEG) + '_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cPasta)

	oExcel:DeActivate()

Return
