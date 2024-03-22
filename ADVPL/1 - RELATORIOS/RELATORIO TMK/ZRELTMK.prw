//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function ZRELTMK()

	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
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
	
	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio TMK...") 

Return

Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO"			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK",""			,1,1,.F., "")	


	cQuery := " SELECT TOP 100 "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDAE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP,					 "
	cQuery += " B.A1_TEL						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " B.A1_TEL						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " A.E1_VENCREA					AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " ''								AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '001001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_VENCREA  <= DATEADD(day, -30, getdate()) "
	cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "
	cQuery += " AND B.A1_PESSOA = 'J' "
	/* REMOVER PUBLICO */


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO, })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TELEMEDINC_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return

