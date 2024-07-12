//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRTITPARC()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Sele��o de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRTITABE" // Nome do grupo de perguntas
 

	/* ---------------------------- PERGUNTAS E FILTROS ---------------------------- */
	
	If !Empty(cCustBem)
		Pergunte(cPerg,.F.)
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif


	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */


    //Se n�o estiver sendo executado via job
    If ! IsBlind()
 
        //Chama a fun��o para buscar arquivos
        cPasta := tFileDialog(;
            cTipArq,;                  // Filtragem de tipos de arquivos que ser�o selecionados
            cTitulo,;                  // T�tulo da Janela para sele��o dos arquivos
            ,;                         // Compatibilidade
            cDirIni,;                  // Diret�rio inicial da busca de arquivos
            lSalvar,;                  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
            GETF_RETDIRECTORY;         // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
        )
 
    EndIf 

	
	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	
	
Return

Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqBem
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("BXPARC")
	oExcel:AddworkSheet("BXPARC")
	
	oExcel:AddTable ("BXPARC","TITULOS",.F.)
	oExcel:AddColumn("BXPARC","TITULOS", "FILIAL",		1,1,.F., "")
	oExcel:AddColumn("BXPARC","TITULOS", "PREFIXO",		1,1,.F., "")
    oExcel:AddColumn("BXPARC","TITULOS", "NUMTIT",		1,1,.F., "")
    oExcel:AddColumn("BXPARC","TITULOS", "CLIENTE",		1,1,.F., "")
	oExcel:AddColumn("BXPARC","TITULOS", "CGC",			1,1,.F., "")
	oExcel:AddColumn("BXPARC","TITULOS", "EMISSAO",		1,1,.F., "")
    oExcel:AddColumn("BXPARC","TITULOS", "VENCIMENTO",	1,1,.F., "")
    oExcel:AddColumn("BXPARC","TITULOS", "DTBAIXA",		1,1,.F., "")
    oExcel:AddColumn("BXPARC","TITULOS", "VALORLIQ",		1,3,.F., "")
	oExcel:AddColumn("BXPARC","TITULOS", "VLRBAIXA",	    1,3,.F., "")
	oExcel:AddColumn("BXPARC","TITULOS", "SALDO",		1,3,.F., "")


		cQuery := "	SELECT "
		cQuery += "	SE1.E1_FILIAL   	AS FILIAL,  "
	    cQuery += "	SE1.E1_PREFIXO  	AS PREFIXO,  "
        cQuery += "	SE1.E1_NUM	    	AS NUMTIT,  "
		cQuery += "	SA1.A1_NREDUZ   	AS CLIENTE,  "
		cQuery += "	CASE  "
		cQuery += "		WHEN SA1.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(SA1.A1_CGC,1,3),'.',SUBSTRING(SA1.A1_CGC,4,3),'.',SUBSTRING(SA1.A1_CGC,7,3),'-',SUBSTRING(SA1.A1_CGC,10,2))  "
		cQuery += "		ELSE CONCAT(SUBSTRING(SA1.A1_CGC,1,2),'.',SUBSTRING(SA1.A1_CGC,3,3),'.',SUBSTRING(SA1.A1_CGC,6,3),'/',SUBSTRING(SA1.A1_CGC,9,4),'-',SUBSTRING(SA1.A1_CGC,13,2))  "
		cQuery += "	END             	AS CGC,  "
        cQuery += "	CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS EMISSAO,   "
		cQuery += "	CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS VENCIMENTO,   "
        cQuery += "	CONCAT(SUBSTRING(SE1.E1_BAIXA,7,2),'/',SUBSTRING(SE1.E1_BAIXA,5,2),'/',SUBSTRING(SE1.E1_BAIXA,1,4)) AS DTBAIXA,   "
	    cQuery += "	SE1.E1_VALOR    AS VLRTIT,  "
		cQuery += "	SE1.E1_VALLIQ   AS VLRBAIXA, "
        cQuery += "	SE1.E1_SALDO    AS SALDO "
		cQuery += "	FROM SE1010 SE1  "
		cQuery += "	LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA    "
		cQuery += "	WHERE 1=1    "
		cQuery += "	AND SE1.D_E_L_E_T_ = ''  "
		cQuery += "	AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
		cQuery += " AND SE1.E1_FILIAL >= '"+MV_PAR01+"' "
		cQuery += " AND SE1.E1_FILIAL <= '"+MV_PAR02+"' "
		cQuery += " AND SE1.E1_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
		cQuery += " AND SE1.E1_SALDO > 0 "
        //cQuery += " AND ((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) > 1 "
		cQuery += " ORDER BY SE1.E1_VENCREA "


	//Criar alias tempor�rio
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("BXPARC","TITULOS",{ (_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->NUMTIT,(_cAlias)->CLIENTE,(_cAlias)->CGC,(_cAlias)->EMISSAO,(_cAlias)->VENCIMENTO,(_cAlias)->DTBAIXA,(_cAlias)->VLRTIT,(_cAlias)->VLRBAIXA,(_cAlias)->SALDO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'BXPARC' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
