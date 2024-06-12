//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRCADFORNMED()

	DEFAULT cCustBem := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZFILFXC" // Nome do grupo de perguntas
 

	/* ---------------------------- PERGUNTAS E FILTROS ---------------------------- */
	
	If !Empty(cCustBem)
		Pergunte(cPerg,.F.)
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif


	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */


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

	
	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio de Fornecedores...") 
	
	
Return

Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqBem
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("FORNMED")
	oExcel:AddworkSheet("FORNMED")
	
	oExcel:AddTable ("FORNMED","CADFORN",.F.)
	oExcel:AddColumn("FORNMED","CADFORN", "CODFOR",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "RAZAOSOC",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "NOMEFANT",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "CGC",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "BANCO",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "AGENCIA",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "DIGAGE",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "CONTA",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "DIGCONTA",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "FAVORECIDO",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "CGCFAVORE",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "TIPOCONTA",	1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "DDD",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "TEL",		1,1,.F.,"")
	oExcel:AddColumn("FORNMED","CADFORN", "EMAIL",		1,1,.F.,"")


		cQuery := "SELECT DISTINCT "
		cQuery += "A.A2_COD			AS CODFOR,  "
		cQuery += "A.A2_NOME		AS RAZAOSOC,  "
		cQuery += "A.A2_NREDUZ		AS NOMEFANT,  "
		cQuery += "A.A2_CGC			AS CGC,  "
		cQuery += "A.A2_BANCO		AS BANCO,  "
		cQuery += "A.A2_AGENCIA		AS AGENCIA,  "
		cQuery += "A.A2_DVAGE		AS DIGAGE,  "
		cQuery += "A.A2_NUMCON		AS CONTA,  "
		cQuery += "A.A2_DVCTA		AS DIGCONTA,  "
		cQuery += "A.A2_ZZFAVRE		AS FAVORECIDO,  "
		cQuery += "A.A2_ZZCFGFV		AS CGCFAVORE,  "
		cQuery += "CASE  "
		cQuery += "	WHEN A.A2_TIPCTA = '1' THEN 'Conta Corrente'   "
		cQuery += "	WHEN A.A2_TIPCTA = '2' THEN 'Conta Poupanca'   "
		cQuery += "	ELSE ''  "
		cQuery += "END 				AS TIPOCONTA, "
		cQuery += "A.A2_DDD			AS DDD,  "
		cQuery += "A.A2_TEL			AS TEL, "
		cQuery += "A.A2_EMAIL		AS EMAIL "
		cQuery += "FROM SE2010 SE2  "
		cQuery += "LEFT JOIN SA2010 A ON A.D_E_L_E_T_ = '' AND A.A2_COD = SE2.E2_FORNECE AND A.A2_LOJA = SE2.E2_LOJA "
		cQuery += "WHERE 1=1 "
		cQuery += "AND SE2.D_E_L_E_T_ = '' "
		cQuery += "AND A.A2_COD <> '' "
		cQuery += "AND SE2.E2_SALDO = 0 "		
		cQuery += "AND SE2.E2_BAIXA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
		

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("FORNMED","CADFORN",{ (_cAlias)->CODFOR,(_cAlias)->RAZAOSOC,(_cAlias)->NOMEFANT,(_cAlias)->CGC,(_cAlias)->BANCO,(_cAlias)->AGENCIA,(_cAlias)->DIGAGE,(_cAlias)->CONTA,(_cAlias)->DIGCONTA,(_cAlias)->FAVORECIDO,(_cAlias)->CGCFAVORE,(_cAlias)->TIPOCONTA,(_cAlias)->DDD,(_cAlias)->TEL,(_cAlias)->EMAIL })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'FORNMEDICAR' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
