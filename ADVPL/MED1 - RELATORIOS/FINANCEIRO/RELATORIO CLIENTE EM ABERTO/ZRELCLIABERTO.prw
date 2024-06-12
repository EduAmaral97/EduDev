//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function ZRELCLIABERTO()

	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Relatorio Clientes em Aberto"
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
	
	MsAguarde({||fMontaRel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	
Return

Static Function fMontaRel(cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("ZRELCLIABERTO")
	oExcel:AddworkSheet("ZRELCLIABERTO")

	lRet := oExcel:IsWorkSheet("ZRELCLIABERTO")
	//oExcel:AddTable ("TELEMEDINC","TELEMED")
	oExcel:AddTable ("ZRELCLIABERTO","CLIABERT",.F.)
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","FILIAL"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","PREFIXO"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","TITULO"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","PARCELA"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","TIPO"			,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","CLIENTE"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","DTVENCIMENTO"	,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","SALDO"			,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","DIASVENC"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","VENDEDOR"		,1,1,.F., "")
	oExcel:AddColumn("ZRELCLIABERTO","CLIABERT","STATUS"		,1,1,.F., "")


	cQuery := " SELECT  "
	cQuery += " B.E1_FILIAL		AS FILIAL,  "
	cQuery += " B.E1_PREFIXO	AS PREFIXO,  "
	cQuery += " B.E1_NUM		AS TITULO,  "
	cQuery += " B.E1_PARCELA	AS PARCELA,  "
	cQuery += " B.E1_TIPO		AS TIPO,  "
    cQuery += " A.A1_COD  		AS CODCLI, "
	cQuery += " A.A1_NOME	 	AS CLIENTE,  "
	cQuery += " CONCAT(SUBSTRING(CAST(B.E1_VENCREA AS VARCHAR),7,2), '/', SUBSTRING(CAST(B.E1_VENCREA AS VARCHAR),5,2), '/', SUBSTRING(CAST(B.E1_VENCREA AS VARCHAR),1,4)) AS VENCIMENTO,  "
	cQuery += " B.E1_SALDO		AS SALDO,  "
	cQuery += " DATEDIFF(DAY, B.E1_VENCREA, GETDATE()) AS DIASVENC, "
	cQuery += " CASE "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 VEND1.A3_NOME FROM BQC010 CTR1 LEFT JOIN SA3010 VEND1 ON VEND1.D_E_L_E_T_ = '' AND VEND1.A3_COD = CTR1.BQC_CODVEN WHERE 1=1 AND CTR1.D_E_L_E_T_ = '' AND CTR1.BQC_CODCLI = A.A1_COD AND CTR1.BQC_LOJA = A.A1_LOJA AND CTR1.BQC_COBNIV = '1' ),'') <> '' THEN ISNULL((SELECT TOP 1 VEND1.A3_NOME FROM BQC010 CTR1 LEFT JOIN SA3010 VEND1 ON VEND1.D_E_L_E_T_ = '' AND VEND1.A3_COD = CTR1.BQC_CODVEN WHERE 1=1 AND CTR1.D_E_L_E_T_ = '' AND CTR1.BQC_CODCLI = A.A1_COD AND CTR1.BQC_LOJA = A.A1_LOJA AND CTR1.BQC_COBNIV = '1' ),'') "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 VEND2.A3_NOME FROM BA3010 CTR2 LEFT JOIN SA3010 VEND2 ON VEND2.D_E_L_E_T_ = '' AND VEND2.A3_COD = CTR2.BA3_CODVEN WHERE 1=1 AND CTR2.D_E_L_E_T_ = '' AND CTR2.BA3_CODCLI = A.A1_COD AND CTR2.BA3_LOJA = A.A1_LOJA AND CTR2.BA3_COBNIV = '1' ),'') <> '' THEN ISNULL((SELECT TOP 1 VEND2.A3_NOME FROM BA3010 CTR2 LEFT JOIN SA3010 VEND2 ON VEND2.D_E_L_E_T_ = '' AND VEND2.A3_COD = CTR2.BA3_CODVEN WHERE 1=1 AND CTR2.D_E_L_E_T_ = '' AND CTR2.BA3_CODCLI = A.A1_COD AND CTR2.BA3_LOJA = A.A1_LOJA AND CTR2.BA3_COBNIV = '1' ),'') "
	cQuery += " 	ELSE '' "
	cQuery += " END AS VENDEDOR,	 "
	cQuery += " CASE "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 'INATIVO' FROM BQC010 CTR1	WHERE 1=1 AND CTR1.D_E_L_E_T_ = '' AND CTR1.BQC_CODCLI = A.A1_COD AND CTR1.BQC_LOJA = A.A1_LOJA AND CTR1.BQC_COBNIV = '1'  AND CTR1.BQC_CODBLO <> '' AND CTR1.BQC_DATBLO <> '' ),'') <> '' THEN ISNULL((SELECT TOP 1 'INATIVO' FROM BQC010 CTR1	WHERE 1=1 AND CTR1.D_E_L_E_T_ = '' AND CTR1.BQC_CODCLI = A.A1_COD AND CTR1.BQC_LOJA = A.A1_LOJA AND CTR1.BQC_COBNIV = '1'  AND CTR1.BQC_CODBLO <> '' AND CTR1.BQC_DATBLO <> '' ),'') "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 'ATIVO' FROM BQC010 CTR1 WHERE 1=1 AND CTR1.D_E_L_E_T_ = '' AND CTR1.BQC_CODCLI = A.A1_COD AND CTR1.BQC_LOJA = A.A1_LOJA AND CTR1.BQC_COBNIV = '1'  AND CTR1.BQC_CODBLO = '' AND CTR1.BQC_DATBLO = '' ),'') <> '' THEN ISNULL((SELECT TOP 1 'ATIVO' FROM BQC010 CTR1 WHERE 1=1 AND CTR1.D_E_L_E_T_ = '' AND CTR1.BQC_CODCLI = A.A1_COD AND CTR1.BQC_LOJA = A.A1_LOJA AND CTR1.BQC_COBNIV = '1'  AND CTR1.BQC_CODBLO = '' AND CTR1.BQC_DATBLO = '' ),'') "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 'INATIVO' FROM BA3010 CTR2 WHERE 1=1 AND CTR2.D_E_L_E_T_ = '' AND CTR2.BA3_CODCLI = A.A1_COD AND CTR2.BA3_LOJA = A.A1_LOJA AND CTR2.BA3_COBNIV = '1' AND CTR2.BA3_MOTBLO <> '' AND CTR2.BA3_DATBLO <> '' ),'')  <> '' THEN ISNULL((SELECT TOP 1 'INATIVO' FROM BA3010 CTR2 WHERE 1=1 AND CTR2.D_E_L_E_T_ = '' AND CTR2.BA3_CODCLI = A.A1_COD AND CTR2.BA3_LOJA = A.A1_LOJA AND CTR2.BA3_COBNIV = '1' AND CTR2.BA3_MOTBLO <> '' AND CTR2.BA3_DATBLO <> '' ),'')  "
	cQuery += " 	WHEN ISNULL((SELECT TOP 1 'ATIVO' FROM BA3010 CTR2 WHERE 1=1 AND CTR2.D_E_L_E_T_ = '' AND CTR2.BA3_CODCLI = A.A1_COD AND CTR2.BA3_LOJA = A.A1_LOJA AND CTR2.BA3_COBNIV = '1' AND CTR2.BA3_MOTBLO = '' AND CTR2.BA3_DATBLO = '' ),'') <> '' THEN ISNULL((SELECT TOP 1 'ATIVO' FROM BA3010 CTR2 WHERE 1=1 AND CTR2.D_E_L_E_T_ = '' AND CTR2.BA3_CODCLI = A.A1_COD AND CTR2.BA3_LOJA = A.A1_LOJA AND CTR2.BA3_COBNIV = '1' AND CTR2.BA3_MOTBLO = '' AND CTR2.BA3_DATBLO = '' ),'')  "
	cQuery += " 	ELSE '' "
	cQuery += " END AS STATUSCTR "
	cQuery += " FROM SA1010 A  "
	cQuery += " LEFT JOIN SE1010 B ON B.D_E_L_E_T_ = '' AND B.E1_CLIENTE = A.A1_COD AND B.E1_LOJA = A.A1_LOJA "
	cQuery += " WHERE 1=1  "
	cQuery += " AND A.D_E_L_E_T_ = ''  "
    cQuery += " AND B.E1_SALDO > 0 "
	cQuery += " AND B.E1_VENCREA <= GETDATE()  "
	cQuery += " AND B.E1_TIPO NOT IN ('RA','CF-','PI-','CS-', 'PR')  "
	cQuery += " AND ISNULL(( SELECT COUNT(*) FROM SE1010 E1	WHERE 1=1 AND E1.D_E_L_E_T_ = '' AND E1.E1_SALDO > 0 AND E1.E1_VENCREA <= GETDATE()	AND B.E1_TIPO NOT IN ('CF-','PI-','CS-') AND E1.E1_CLIENTE = A.A1_COD AND E1.E1_LOJA = A.A1_LOJA ),0) > 1 "
	cQuery += " ORDER BY 3 "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("ZRELCLIABERTO","CLIABERT",{(_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->TITULO,(_cAlias)->PARCELA,(_cAlias)->TIPO,(_cAlias)->CLIENTE,(_cAlias)->VENCIMENTO,(_cAlias)->SALDO,(_cAlias)->DIASVENC,(_cAlias)->VENDEDOR,(_cAlias)->STATUSCTR})
		
		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'CLIENTESABERTO_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return
