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

// consulta padrao: CTRDIG
// 17747438000130

User Function ZRCARTEDIGI()
	
	Local oDlg as object
	Private _cAlias		 := GetNextAlias()
	Private cEOL 		 := "CHR(13)+CHR(10)"
	
	
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif


 	DEFINE MSDIALOG oDlg FROM 05,10 TO 165,325 TITLE " Carteirinha Digital Medicar " PIXEL

        @ 010,020 TO 045,140 LABEL " Gerar Carteirinha Por " OF oDlg PIXEL

     	TButton():New( 025, 030 , "Contrato" , oDlg, {|| fFiltroCtr() }, 040,011, ,,,.T.,,,,,,)
        TButton():New( 025, 080 , "Beneficiario" , oDlg, {|| fFiltroBenef(), oDlg:End() }, 040,011, ,,,.T.,,,,,,)

    	DEFINE SBUTTON FROM 055,110 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER


	

Return


//********************************************************************************************//
//                        			MONTA A PAGINA DE IMPRESSAO								  //
//********************************************************************************************//
Static Function Imprime()


	Local _nCont 		:= 1
	//Local aAreaSM0	:= {}	 
	Local cTitular := "Titular: "
	Local cIdContrato := "#ID: "
	Local cCarteira := "Nr. Carteira: "
	Local cCpfBene := "Cpf: "
	Private cBitmap		:= ""
	Private cStartPath:= GetSrvProfString("Startpath","")
	Private cPosi
	Private nLin
	Private _nPag		:= 1   // Numero da pagina
	//Private cNomeAgrup := ''

	Private cTotalValor := 0
	Private cTotalBaixado := 0

	//cBitmap := R110ALogo()
	cBitmap := "\RELATORIOS\CARTEIRINHADIGITAL\carteirinhadigital.bmp"


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

	oPrn:SetLandscape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem
	oPrn:setPaperSize( DMPAPER_A4 )

		nLin := 425

	While (_cAlias)->(!Eof())
		
		If _nCont >= 1
		
			_nCont		:= 0
			_nPag 		+= 1
			
			oPrn :EndPage() 

		EndIf

			oPrn:SayBitmap(0045,0060,cBitmap,1200,800)
			
			//oPrn:say(nLin,1320, SubStr((_cAlias)->TITULAR,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),oFont10N)
			//oPrn:say(nLin,1620, "R$" + Str((_cAlias)->IDCONTRATO,10,2),oFont10N)
			
			nLin := 260
			oPrn:say(nLin,1500,(_cAlias)->NOMEBENEF,oFont12N,,CLR_WHITE,,1)
			
			nLin := 380
			oPrn:say(nLin,0100,cTitular,oFont10N,,CLR_WHITE)
			oPrn:say(nLin,0230,SubStr((_cAlias)->TITULAR,1,40),oFont10N,,CLR_WHITE)
			nLin += 65
			oPrn:say(nLin,0100,cCpfBene,oFont10N,,CLR_WHITE)
			oPrn:say(nLin,0175,(_cAlias)->CPFBENE,oFont10N,,CLR_WHITE)
			nLin += 65
			oPrn:say(nLin,0100,cIdContrato,oFont10N,,CLR_WHITE)
			oPrn:say(nLin,0170,(_cAlias)->IDCONTRATO,oFont10N,,CLR_WHITE)
			nLin += 65
			oPrn:say(nLin,0100,cCarteira,oFont10N,,CLR_WHITE)
			oPrn:say(nLin,0330,(_cAlias)->CARTEIRINHA,oFont10N,,CLR_WHITE)


		_nCont += 1
		//Verifica a quebra de pagina
		(_cAlias)->(dBskip())


	EndDo
	
	(_cAlias)->(DbCloseArea())
	oPrn:Preview() //Preview DO RELATORIO

Return


//********************************************************************************************
// 										  	QUERY
//********************************************************************************************
Static Function QueryBenefi(cFILIAL,cCODINT,cCODEMP,cCONEMP,cVERCON,cSUBCON,cVERSUB,cMATEMP,cMATRIC,cTIPREG)

	Local cQuery  

	cQuery := " SELECT  "
	cQuery += " A.BA1_NOMUSR	AS NOMEBENEF, "
	cQuery += " CONCAT(SUBSTRING(A.BA1_CPFUSR,1,3), '.', SUBSTRING(A.BA1_CPFUSR,4,3), '.', SUBSTRING(A.BA1_CPFUSR,7,3), '-', SUBSTRING(A.BA1_CPFUSR,10,2)) AS CPFBENE, "
	cQuery += " CASE  "
	cQuery += " 	WHEN A.BA1_CODEMP IN ('0003','0006') AND A.BA1_TIPREG = '00' THEN A.BA1_NOMUSR "
	cQuery += " 	WHEN A.BA1_CODEMP IN ('0003','0006') AND A.BA1_TIPREG <> '00' THEN ISNULL(( SELECT BA1.BA1_NOMUSR FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND BA1.BA1_FILIAL = A.BA1_FILIAL AND BA1.BA1_CODINT = A.BA1_CODINT AND BA1.BA1_CODEMP = A.BA1_CODEMP AND BA1.BA1_CONEMP = A.BA1_CONEMP AND BA1.BA1_VERCON = A.BA1_VERCON AND BA1.BA1_SUBCON = A.BA1_SUBCON AND BA1.BA1_VERSUB = A.BA1_VERSUB AND BA1.BA1_MATEMP = A.BA1_MATEMP AND BA1.BA1_MATRIC = A.BA1_MATRIC AND BA1.BA1_TIPREG = '00' ),'') "
	cQuery += " 	ELSE ISNULL(( SELECT BQC.BQC_DESCRI FROM BQC010 BQC WHERE 1=1 AND BQC.D_E_L_E_T_ = '' AND BQC.BQC_CODINT = A.BA1_CODINT AND BQC.BQC_CODEMP = A.BA1_CODEMP AND BQC.BQC_NUMCON = A.BA1_CONEMP AND BQC.BQC_VERCON = A.BA1_VERCON AND BQC.BQC_SUBCON = A.BA1_SUBCON AND BQC.BQC_VERSUB = A.BA1_VERSUB ),'') "
	cQuery += " END 			AS TITULAR, "
	cQuery += " CASE "
	cQuery += " 	WHEN BA1_CODEMP = '0003' THEN B.BA3_ZIRIS "
	cQuery += " 	WHEN BA1_CODEMP = '0004' THEN A.BA1_SUBCON "
	cQuery += " 	WHEN BA1_CODEMP = '0005' THEN A.BA1_MATEMP "
	cQuery += " 	WHEN BA1_CODEMP = '0006' THEN B.BA3_ZIRIS "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS IDCONTRATO, "
	cQuery += " A.BA1_XCARTE  	AS CARTEIRINHA "
	cQuery += " FROM BA1010 A "
	cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_FILIAL = A.BA1_FILIAL AND B.BA3_CODINT = A.BA1_CODINT AND B.BA3_CODEMP = A.BA1_CODEMP AND B.BA3_CONEMP = A.BA1_CONEMP AND B.BA3_VERCON = A.BA1_VERCON AND B.BA3_SUBCON = A.BA1_SUBCON AND B.BA3_VERSUB = A.BA1_VERSUB AND B.BA3_MATEMP = A.BA1_MATEMP AND B.BA3_MATRIC = A.BA1_MATRIC "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.BA1_FILIAL = '"+cFILIAL+"' "
	cQuery += " AND A.BA1_CODINT = '"+cCODINT+"' "
	cQuery += " AND A.BA1_CODEMP = '"+cCODEMP+"' "
	cQuery += " AND A.BA1_CONEMP = '"+cCONEMP+"' "
	cQuery += " AND A.BA1_VERCON = '"+cVERCON+"' "
	cQuery += " AND A.BA1_SUBCON = '"+cSUBCON+"' "
	cQuery += " AND A.BA1_VERSUB = '"+cVERSUB+"' "
	cQuery += " AND A.BA1_MATEMP = '"+cMATEMP+"' "
	cQuery += " AND A.BA1_MATRIC = '"+cMATRIC+"' "
	cQuery += " AND A.BA1_TIPREG = '"+cTIPREG+"' "

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	//Verifica resultado da query
	DbSelectArea(_cAlias)
	DbGoTop()

	If (_cAlias)->(Eof())
		MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
		(_cAlias)->(DbCloseArea())
		(cAliasAgrup)->(DbCloseArea())
	Else

		Processa({|| Imprime() },"Relatorio de Agrupamento","Imprimindo...") 
		
	EndIf

Return


Static Function QueryCtr(cFILIAL,cCODINT,cCODEMP,cCONEMP,cVERCON,cSUBCON,cVERSUB,cIDCONTRATO,cTipoCtr)

	Local cQuery

		cQuery := " SELECT  "
		cQuery += " A.BA1_NOMUSR	AS NOMEBENEF, "
		cQuery += " CONCAT(SUBSTRING(A.BA1_CPFUSR,1,3), '.', SUBSTRING(A.BA1_CPFUSR,4,3), '.', SUBSTRING(A.BA1_CPFUSR,7,3), '-', SUBSTRING(A.BA1_CPFUSR,10,2)) AS CPFBENE, "
		cQuery += " CASE  "
		cQuery += " 	WHEN A.BA1_CODEMP IN ('0003','0006') AND A.BA1_TIPREG = '00' THEN A.BA1_NOMUSR "
		cQuery += " 	WHEN A.BA1_CODEMP IN ('0003','0006') AND A.BA1_TIPREG <> '00' THEN ISNULL(( SELECT BA1.BA1_NOMUSR FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND BA1.BA1_FILIAL = A.BA1_FILIAL AND BA1.BA1_CODINT = A.BA1_CODINT AND BA1.BA1_CODEMP = A.BA1_CODEMP AND BA1.BA1_CONEMP = A.BA1_CONEMP AND BA1.BA1_VERCON = A.BA1_VERCON AND BA1.BA1_SUBCON = A.BA1_SUBCON AND BA1.BA1_VERSUB = A.BA1_VERSUB AND BA1.BA1_MATEMP = A.BA1_MATEMP AND BA1.BA1_MATRIC = A.BA1_MATRIC AND BA1.BA1_TIPREG = '00' ),'') "
		cQuery += " 	ELSE ISNULL(( SELECT BQC.BQC_DESCRI FROM BQC010 BQC WHERE 1=1 AND BQC.D_E_L_E_T_ = '' AND BQC.BQC_CODINT = A.BA1_CODINT AND BQC.BQC_CODEMP = A.BA1_CODEMP AND BQC.BQC_NUMCON = A.BA1_CONEMP AND BQC.BQC_VERCON = A.BA1_VERCON AND BQC.BQC_SUBCON = A.BA1_SUBCON AND BQC.BQC_VERSUB = A.BA1_VERSUB ),'') "
		cQuery += " END 			AS TITULAR, "
		cQuery += " CASE "
		cQuery += " 	WHEN BA1_CODEMP = '0003' THEN B.BA3_ZIRIS "
		cQuery += " 	WHEN BA1_CODEMP = '0004' THEN A.BA1_SUBCON "
		cQuery += " 	WHEN BA1_CODEMP = '0005' THEN A.BA1_MATEMP "
		cQuery += " 	WHEN BA1_CODEMP = '0006' THEN B.BA3_ZIRIS "
		cQuery += " 	ELSE '' "
		cQuery += " END 			AS IDCONTRATO, "
		cQuery += " A.BA1_XCARTE  	AS CARTEIRINHA "
		cQuery += " FROM BA1010 A "
		cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_FILIAL = A.BA1_FILIAL AND B.BA3_CODINT = A.BA1_CODINT AND B.BA3_CODEMP = A.BA1_CODEMP AND B.BA3_CONEMP = A.BA1_CONEMP AND B.BA3_VERCON = A.BA1_VERCON AND B.BA3_SUBCON = A.BA1_SUBCON AND B.BA3_VERSUB = A.BA1_VERSUB AND B.BA3_MATEMP = A.BA1_MATEMP AND B.BA3_MATRIC = A.BA1_MATRIC "
		cQuery += " WHERE 1=1 "
		cQuery += " AND A.D_E_L_E_T_ = '' "
		cQuery += " AND A.BA1_FILIAL = '"+cFILIAL+"' "
		cQuery += " AND A.BA1_CODINT = '"+cCODINT+"' "
		cQuery += " AND A.BA1_CODEMP = '"+cCODEMP+"' "
		cQuery += " AND A.BA1_CONEMP = '"+cCONEMP+"' "
		cQuery += " AND A.BA1_VERCON = '"+cVERCON+"' "
		cQuery += " AND A.BA1_SUBCON = '"+cSUBCON+"' "
		cQuery += " AND A.BA1_VERSUB = '"+cVERSUB+"' "
		if cTipoCtr = 1
			cQuery += " AND A.BA1_MATEMP = '"+alltrim(cIDCONTRATO)+"' "
			cQuery += " AND A.BA1_CODEMP IN ('0003','0006') "
		Else
			cQuery += " AND A.BA1_CODEMP IN ('0004','0005') "
		Endif


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	//Verifica resultado da query
	DbSelectArea(_cAlias)
	DbGoTop()

	If (_cAlias)->(Eof())
		MsgAlert("Relatório vazio! Verifique os parâmetros.","Atenção")  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
		(_cAlias)->(DbCloseArea())
	Else
		
		(_cAlias)->(DbGoTop())
		Processa({|| Imprime() },"Relatorio de Agrupamento","Imprimindo...") 
		
	EndIf

Return


//********************************************************************************************
// 										  	FILTRO CONTRATO
//********************************************************************************************
Static Function fFiltroCtr()

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local cPesq := Space(80)
    Local oRadMenu1
    Local oDlg as object
    Local oBrowse as object
    Local cOpc := 1
	Local cTipoCtr := 1
 

        DEFINE DIALOG oDlg TITLE "Contratos - Contrato Medicar " FROM 0, 0 TO 470, 980 PIXEL
        
            aGrade := {}

            @ 015, 020 SAY oTitParametro PROMPT "Pesquisa: "        SIZE 070, 020 OF oDlg PIXEL
            @ 010, 050 MSGET oGrupo VAR  cPesq                      SIZE 150, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
            
            @ 005, 210 RADIO oRadMenu1 VAR cOpc ITEMS "Nome","Cpf/Cnpj" SIZE 092, 020 OF oDlg COLOR 0, 16777215 PIXEL

			@ 005, 250 RADIO oRadMenu1 VAR cTipoCtr ITEMS "PF","PJ" SIZE 092, 020 OF oDlg COLOR 0, 16777215 PIXEL

			aAdd(aGrade, {.T.,'','','','','','','','','',''}) // DADOS DA GRADE

            oBrowse := TCBrowse():New( 30 , 5, 420, 200,, {'','Cpf/Cnpj','Nome','Filial','Operadora','Grupo Empresa','Perfil','Ver. Perfil','Subcon','Ver Sub.','Id Contrato'},{20,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,"aGrade",.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGrade)
            oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11] }} //EXIBICAO DA GRADE

            TButton():New( 010, 430 , "Pesquisar"         	, oDlg, {|| fPesqCtr(cPesq,cOpc,cTipoCtr) }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 035, 430 , "Gerar"          		, oDlg, {|| QueryCtr(aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],cTipoCtr), oDlg:End() }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 060, 430 , "Voltar"            	, oDlg, {||  oDlg:End() }, 50,018, ,,,.T.,,,,,,)

        ACTIVATE DIALOG oDlg CENTERED




Return 


Static Function fPesqCtr(cPesq,cOpc,cTipoCtr)


    //Local oOK := LoadBitmap(GetResources(),'br_verde')
    //Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local cQueryCtr
	Private AliasCtr := GetNextAlias()

	if alltrim(cPesq) != ""

		IF cTipoCtr = 1

			cQueryCtr := " SELECT "
			cQueryCtr += " A.BA1_CPFUSR	AS CGC, "
			cQueryCtr += " A.BA1_NOMUSR	AS NOME, "
			cQueryCtr += " A.BA1_FILIAL	AS FILIAL, "
			cQueryCtr += " A.BA1_CODINT	AS CODINT, "
			cQueryCtr += " A.BA1_CODEMP	AS CODEMP, "
			cQueryCtr += " A.BA1_CONEMP	AS CONEMP, "
			cQueryCtr += " A.BA1_VERCON	AS VERCON, "
			cQueryCtr += " A.BA1_SUBCON	AS SUBCON, "
			cQueryCtr += " A.BA1_VERSUB	AS VERSUB, "
			cQueryCtr += " A.BA1_MATEMP	AS IDCONTRATO, "
			cQueryCtr += " CASE "
			cQueryCtr += " 	WHEN A.BA1_DATBLO = '' THEN 'ATIVO' "
			cQueryCtr += " 	ELSE 'INATIVO' "
			cQueryCtr += " END 			AS STATCTR "
			cQueryCtr += " FROM BA1010 A "
			cQueryCtr += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_FILIAL = A.BA1_FILIAL AND B.BA3_CODINT = A.BA1_CODINT AND B.BA3_CODEMP = A.BA1_CODEMP AND B.BA3_CONEMP = A.BA1_CONEMP AND B.BA3_VERCON = A.BA1_VERCON AND B.BA3_SUBCON = A.BA1_SUBCON AND B.BA3_VERSUB = A.BA1_VERSUB AND B.BA3_MATEMP = A.BA1_MATEMP AND B.BA3_MATRIC = A.BA1_MATRIC "
			cQueryCtr += " WHERE 1=1 "
			cQueryCtr += " AND A.D_E_L_E_T_ = '' "
			cQueryCtr += " AND A.BA1_TIPREG = '00' "
			cQueryCtr += " AND A.BA1_CODEMP IN ('0003','0006') "
			IF cOpc = 1
				cQueryCtr += " AND A.BA1_NOMUSR LIKE '%"+alltrim(cPesq)+"%' "
			ELSE
				cQueryCtr += " AND A.BA1_CPFUSR LIKE '%"+alltrim(cPesq)+"%' "
			ENDIF
			

		ELSE

			cQueryCtr := " SELECT "
			cQueryCtr += " A.BQC_CNPJ	AS CGC, "
			cQueryCtr += " A.BQC_DESCRI	AS NOME, "
			cQueryCtr += " ISNULL(( SELECT TOP 1 BA1.BA1_FILIAL FROM BA1010 BA1 WHERE 1=1 AND BA1.D_E_L_E_T_ = '' AND A.BQC_CODINT = BA1.BA1_CODINT AND A.BQC_CODEMP = BA1.BA1_CODEMP AND A.BQC_NUMCON = BA1.BA1_CONEMP AND A.BQC_VERCON = BA1.BA1_VERCON AND A.BQC_SUBCON = BA1.BA1_SUBCON AND A.BQC_VERSUB = BA1.BA1_VERSUB ), '') AS FILIAL, "
			cQueryCtr += " A.BQC_CODINT	AS CODINT, "
			cQueryCtr += " A.BQC_CODEMP	AS CODEMP, "
			cQueryCtr += " A.BQC_NUMCON	AS CONEMP, "
			cQueryCtr += " A.BQC_VERCON	AS VERCON, "
			cQueryCtr += " A.BQC_SUBCON	AS SUBCON, "
			cQueryCtr += " A.BQC_VERSUB	AS VERSUB, "
			cQueryCtr += " A.BQC_SUBCON	AS IDCONTRATO, "
			cQueryCtr += " CASE "
			cQueryCtr += " 	WHEN A.BQC_DATBLO = '' THEN 'ATIVO' "
			cQueryCtr += " 	ELSE 'INATIVO' "
			cQueryCtr += " END 			AS STATCTR "
			cQueryCtr += " FROM BQC010 A "
			cQueryCtr += " WHERE 1=1 "
			cQueryCtr += " AND A.D_E_L_E_T_ = '' "
			cQueryCtr += " AND A.BQC_CODEMP IN ('0004','0005') "
			IF cOpc = 1
				cQueryCtr += " AND A.BQC_DESCRI LIKE '%"+alltrim(cPesq)+"%' "
			ELSE
				cQueryCtr += " AND A.BQC_CNPJ LIKE '%"+alltrim(cPesq)+"%' "
			ENDIF

		ENDIF

	else

		aSize(aGrade, 0)
		cQueryCtr := " SELECT TOP 1 "
		cQueryCtr += " ''	AS CGC, "
		cQueryCtr += " ''	AS NOME, "
		cQueryCtr += " ''	AS FILIAL, "
		cQueryCtr += " ''	AS CODINT, "
		cQueryCtr += " ''	AS CODEMP, "
		cQueryCtr += " ''	AS CONEMP, "
		cQueryCtr += " ''	AS VERCON, "
		cQueryCtr += " ''	AS SUBCON, "
		cQueryCtr += " ''	AS VERSUB, "
		cQueryCtr += " ''	AS IDCONTRATO, "
		cQueryCtr += " ''	AS STATCTR "
		cQueryCtr += " FROM BA1010 A "
		cQueryCtr += " WHERE 1=1 "
		cQueryCtr += " AND A.D_E_L_E_T_ = '' "

	EndIf


    TCQUERY cQueryCtr NEW ALIAS (AliasCtr)
        
    //Verifica resultado da query
	DbSelectArea(AliasCtr)
    (AliasCtr)->(DbGoTop())


    If (AliasCtr)->(Eof())

        MsgInfo("Nehum Beneficiario Encontrado", "Beneficiarios Medicar")
		aSize(aGrade, 0)
		aAdd(aGrade, {.T.,'','','','','','','','','',''}) // DADOS DA GRADE

    Else
		
		aSize(aGrade, 0)
		While (AliasCtr)->(!Eof())

			aAdd(aGrade, { IF((AliasCtr)->STATCTR = 'ATIVO',.T.,.F.),(AliasCtr)->CGC,(AliasCtr)->NOME,(AliasCtr)->FILIAL,(AliasCtr)->CODINT,(AliasCtr)->CODEMP,(AliasCtr)->CONEMP,(AliasCtr)->VERCON,(AliasCtr)->SUBCON,(AliasCtr)->VERSUB,(AliasCtr)->IDCONTRATO }) // DADOS DA GRADE

			(AliasCtr)->(dBskip())

		EndDo


	Endif
	
	(AliasCtr)->(DbCloseArea())

Return



//********************************************************************************************
// 										  	FILTRO BENEFICIARIO
//********************************************************************************************
Static Function fFiltroBenef()

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local cPesq := Space(80)
    Local oRadMenu1
    Local oDlg as object
    Local oBrowse as object
    Local cOpc := 1
 
        DEFINE DIALOG oDlg TITLE "Beneficiarios - Contrato Medicar " FROM 0, 0 TO 470, 980 PIXEL
        
            aGrade := {}

            @ 015, 020 SAY oTitParametro PROMPT "Pesquisa: "        SIZE 070, 020 OF oDlg PIXEL
            @ 010, 050 MSGET oGrupo VAR  cPesq                      SIZE 150, 011 PIXEL OF oDlg WHEN .T. Picture "@!"
            
            @ 005, 210 RADIO oRadMenu1 VAR cOpc ITEMS "Nome","Cpf" SIZE 092, 020 OF oDlg COLOR 0, 16777215 PIXEL

			aAdd(aGrade, {.T.,'','','','','','','','','','','','',''}) // DADOS DA GRADE

            oBrowse := TCBrowse():New( 30 , 5, 420, 200,, {'','Cpf','Beneficiario','Carteirinha','Filial','Operadora','Grupo Empresa','Perfil','Ver. Perfil','Subcon','Ver Sub.','Mat.Emp.','Matricula','Tip. Reg.'},{20,50,50,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,"aGrade",.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGrade)
            oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12],aGrade[oBrowse:nAt,13],aGrade[oBrowse:nAt,14] }} //EXIBICAO DA GRADE

            TButton():New( 010, 430 , "Pesquisar"         	, oDlg, {|| fPesqBenef(cPesq,cOpc) }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 035, 430 , "Gerar"          		, oDlg, {|| QueryBenefi(aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06],aGrade[oBrowse:nAt,07],aGrade[oBrowse:nAt,08],aGrade[oBrowse:nAt,09],aGrade[oBrowse:nAt,10],aGrade[oBrowse:nAt,11],aGrade[oBrowse:nAt,12],aGrade[oBrowse:nAt,13],aGrade[oBrowse:nAt,14]), oDlg:End() }, 50,018, ,,,.T.,,,,,,)
            TButton():New( 060, 430 , "Voltar"            	, oDlg, {||  oDlg:End() }, 50,018, ,,,.T.,,,,,,)

        ACTIVATE DIALOG oDlg CENTERED




Return 



Static Function fPesqBenef(cPesq,cOpc)


    //Local oOK := LoadBitmap(GetResources(),'br_verde')
    //Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local cQueryBenefi
	Private AliasBeneCtr := GetNextAlias()

	if alltrim(cPesq) != ""
		
		cQueryBenefi := " SELECT "
		cQueryBenefi += " A.BA1_CPFUSR		AS CPF, "
		cQueryBenefi += " A.BA1_NOMUSR		AS NOME, "
		cQueryBenefi += " A.BA1_XCARTE		AS CARTEIRA, "
		cQueryBenefi += " A.BA1_FILIAL 		AS FILIAL, "
		cQueryBenefi += " A.BA1_CODINT 		AS CODINT, "
		cQueryBenefi += " A.BA1_CODEMP 		AS CODEMP, "
		cQueryBenefi += " A.BA1_CONEMP 		AS CONEMP, "
		cQueryBenefi += " A.BA1_VERCON 		AS VERCON, "
		cQueryBenefi += " A.BA1_SUBCON 		AS SUBCON, "
		cQueryBenefi += " A.BA1_VERSUB 		AS VERSUB, "
		cQueryBenefi += " A.BA1_MATEMP 		AS MATEMP, "
		cQueryBenefi += " A.BA1_MATRIC 		AS MATRIC, "
		cQueryBenefi += " A.BA1_TIPREG 		AS TIPREG, "
		cQueryBenefi += " CASE "
		cQueryBenefi += " 	WHEN A.BA1_DATBLO = '' THEN 'ATIVO' "
		cQueryBenefi += " 	ELSE 'INATIVO' "
		cQueryBenefi += " END 				AS STATBENE "
		cQueryBenefi += " FROM BA1010 A "
		cQueryBenefi += " WHERE 1=1 "
		cQueryBenefi += " AND A.D_E_L_E_T_ = '' "
		IF cOpc = 1
			cQueryBenefi += " AND A.BA1_NOMUSR LIKE '%"+alltrim(cPesq)+"%' "
		Else
			cQueryBenefi += " AND A.BA1_CPFUSR LIKE '%"+alltrim(cPesq)+"%' "
		EndIf

	else

		aSize(aGrade, 0)
		cQueryBenefi := " SELECT TOP 1"
		cQueryBenefi += " ''		AS CPF, "
		cQueryBenefi += " ''		AS NOME, "
		cQueryBenefi += " ''		AS CARTEIRA, "
		cQueryBenefi += " '' 		AS FILIAL, "
		cQueryBenefi += " '' 		AS CODINT, "
		cQueryBenefi += " '' 		AS CODEMP, "
		cQueryBenefi += " '' 		AS CONEMP, "
		cQueryBenefi += " '' 		AS VERCON, "
		cQueryBenefi += " '' 		AS SUBCON, "
		cQueryBenefi += " '' 		AS VERSUB, "
		cQueryBenefi += " '' 		AS MATEMP, "
		cQueryBenefi += " '' 		AS MATRIC, "
		cQueryBenefi += " '' 		AS TIPREG, "
		cQueryBenefi += " ''		AS STATBENE "
		cQueryBenefi += " FROM BA1010 A "
		cQueryBenefi += " WHERE 1=1 "
		cQueryBenefi += " AND A.D_E_L_E_T_ = '' "

	EndIf


    TCQUERY cQueryBenefi NEW ALIAS (AliasBeneCtr)
        
    //Verifica resultado da query
	DbSelectArea(AliasBeneCtr)
    (AliasBeneCtr)->(DbGoTop())


    If (AliasBeneCtr)->(Eof())

        MsgInfo("Nehum Beneficiario Encontrado", "Beneficiarios Medicar")
		aSize(aGrade, 0)
		aAdd(aGrade, {.T.,'','','','','','','','','','','','',''}) // DADOS DA GRADE

    Else
		
		aSize(aGrade, 0)
		While (AliasBeneCtr)->(!Eof())

			
			aAdd(aGrade, { IF((AliasBeneCtr)->STATBENE = 'ATIVO',.T.,.F.),(AliasBeneCtr)->CPF,(AliasBeneCtr)->NOME,(AliasBeneCtr)->CARTEIRA,(AliasBeneCtr)->FILIAL,(AliasBeneCtr)->CODINT,(AliasBeneCtr)->CODEMP,(AliasBeneCtr)->CONEMP,(AliasBeneCtr)->VERCON,(AliasBeneCtr)->SUBCON,(AliasBeneCtr)->VERSUB,(AliasBeneCtr)->MATEMP,(AliasBeneCtr)->MATRIC,(AliasBeneCtr)->TIPREG }) // DADOS DA GRADE

			(AliasBeneCtr)->(dBskip())

		EndDo


	Endif
	
	(AliasBeneCtr)->(DbCloseArea())

Return
